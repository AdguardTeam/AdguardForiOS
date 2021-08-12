//
//  OTPController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/29/21.
//

import UIKit

class OTPController:UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var otp1: UITextField!
    @IBOutlet weak var otp2: UITextField!
    @IBOutlet weak var otp3: UITextField!
    @IBOutlet weak var otp4: UITextField!
    @IBOutlet weak var otp5: UITextField!
    @IBOutlet weak var otp6: UITextField!
    @IBOutlet weak var text_inform: UILabel!
    var otpCode:String = ""
    override func viewDidLoad() {
        super .viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //set time
        if StoreData.username.contains("@") == true
        {
            text_inform.text = "Visafe đã gửi mã xác thực OTP đến email " + StoreData.username
        }
        else
        {
            text_inform.text = "Visafe đã gửi mã xác thực OTP đến số điện thoại " + StoreData.username
        }
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        otp1.backgroundColor = UIColor.clear
        otp2.backgroundColor = UIColor.clear
        otp3.backgroundColor = UIColor.clear
        otp4.backgroundColor = UIColor.clear
        otp5.backgroundColor = UIColor.clear
        otp6.backgroundColor = UIColor.clear
        
        addBottomBorderTo(textField: otp1)
        addBottomBorderTo(textField: otp2)
        addBottomBorderTo(textField: otp3)
        addBottomBorderTo(textField: otp4)
        addBottomBorderTo(textField: otp5)
        addBottomBorderTo(textField: otp6)
        
        otp1.delegate = self
        otp2.delegate = self
        otp3.delegate = self
        otp4.delegate = self
        otp5.delegate = self
        otp6.delegate = self
        
        otp1.becomeFirstResponder()
        otp1.isUserInteractionEnabled = true
    }
   
    func addBottomBorderTo(textField:UITextField)
    {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height-2.0, width: textField.frame.size.width - 5.0, height: 2.0)
     
        textField.layer.addSublayer(layer)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if ((textField.text?.count)! < 1) && (string.count > 0)
        {
            if textField == otp1
            {
                otp2.becomeFirstResponder()
            }
            if textField == otp2
            {
                otp3.becomeFirstResponder()
            }
            if textField == otp3
            {
                otp4.becomeFirstResponder()
            }
            if textField == otp4
            {
                otp5.becomeFirstResponder()
            }
            if textField == otp5
            {
                otp6.becomeFirstResponder()
            }
            if textField == otp6
            {
                otp6.resignFirstResponder()
            }
            textField.text = string
            otpCode += string
            if otpCode.count == 6
            {
                if StoreData.forgot_password == false
                {
                    if StoreData.username != ""
                    {
                        AuthorizeByOTP(username: StoreData.username, otp: otpCode)
                        StoreData.username = ""
                        otpCode = ""
                    }
                    else
                    {
                        AuthorizeByOTP(username: StoreData.phoneNumber, otp: otpCode)
                        StoreData.phoneNumber = ""
                        otpCode = ""
                    }
                }
                else
                {
                    StoreData.forgot_password = false
                    StoreData.OTP = otpCode
                    let secondVC1 = self.storyboard?.instantiateViewController(withIdentifier: "reset_password_controller")
                    self.definesPresentationContext = true
                    secondVC1?.modalPresentationStyle = .overCurrentContext
                    self.present(secondVC1!, animated: true,completion: nil)
                }
            }
            return false
        }
        else if ((textField.text?.count)! >= 1) && (string.count == 0)
        {
            if textField == otp2
            {
                otp1.becomeFirstResponder()
            }
            if textField == otp3
            {
                otp2.becomeFirstResponder()
            }
            if textField == otp4
            {
                otp3.becomeFirstResponder()
            }
            if textField == otp5
            {
                otp4.becomeFirstResponder()
            }
            if textField == otp6
            {
                otp5.becomeFirstResponder()
            }
            if textField == otp1
            {
                otp1.resignFirstResponder()
            }
            textField.text = ""
            return false
        }
        else if (textField.text?.count)! >= 1
        {
            textField.text = string
            return false
        }
        return true
    }

    func AuthorizeByOTP(username:String,otp:String) {
        struct RequestData: Codable {
            var username:String
            var OTP:String
        }
        let url = URL(string: DOMAIN_TO_OTP)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(username: username, OTP: otp)
        print(request_json)
        let jsonData = try? JSONEncoder().encode(request_json)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse{
                        print(httpResponse.statusCode)
                        if httpResponse.statusCode == 200{
                            let alert = UIAlertController(title: "Thông báo", message: "Đăng ký tài khoản thành công! Mời bạn đăng nhập lại" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_controller")
                                        self.definesPresentationContext = true
                                        secondVC?.modalPresentationStyle = .overCurrentContext
                                    self.present(secondVC!, animated: true)
                                }
                               alert.addAction(okAction)
                               // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else
                        {
                            StoreData.saveMyPlist(key: "token_login", value: "")
                            let alert = UIAlertController(title: "Thông báo", message: "Đăng ký tài khoản không thành công! Mời bạn đăng ký lại" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
                                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "register_controller") as! RegisterController
                                        self.definesPresentationContext = true
                                        secondVC.modalPresentationStyle = .overCurrentContext
                                    self.present(secondVC, animated: true)
                                }
                               alert.addAction(okAction)
                               // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }catch let jsonErr{
                DispatchQueue.main.async {
                }
           }
        }
        task.resume()
    }

    @IBOutlet weak var btn_resend_otp_outlet: UIButton!
    
    var count = 60
    var resendTimer = Timer()
    
    @IBAction func btn_resend_otp(_ sender: UIButton) {
        count = 60
        resendTimer = Timer()
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        LoginController.ReSendOTP(username: StoreData.username)
    }
    @objc func update() {
        if(count > 0) {
            count = count - 1
            UIView.transition(with: btn_resend_otp_outlet, duration: 0.8, options: .transitionCrossDissolve, animations: {
                self.btn_resend_otp_outlet.setTitle("Gửi lại mã OTP trong \(self.count)", for: .normal)
                self.btn_resend_otp_outlet.isEnabled = false
            }, completion: nil)
            
        }
        else {
            resendTimer.invalidate()
            self.btn_resend_otp_outlet.setTitle("Gửi lại mã OTP", for: .normal)
            self.btn_resend_otp_outlet.isEnabled = true
            // if you want to reset the time make count = 60 and resendTime.fire()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
