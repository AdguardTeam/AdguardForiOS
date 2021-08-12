//
//  RegisterController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/22/21.
//

import UIKit

class RegisterController:UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var full_name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirm_password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var btn_register: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        full_name.delegate = self
        username.delegate = self
        password.delegate = self
        confirm_password.delegate = self
        btn_register.imageView?.contentMode = .scaleAspectFit
        btn_register.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    

    @IBAction func btn_register(_ sender: UIButton) {
        if full_name.text!.isEmpty == true || username.text!.isEmpty == true || password.text!.isEmpty == true || confirm_password.text!.isEmpty == true
        {
            if full_name.text!.isEmpty == true
            {
                let alert = UIAlertController(title: "Thông báo", message: "Họ và tên không được để trống" , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                    }
                   alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
               
            else if username.text!.isEmpty == true
            {
                let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại hoặc email không được để trống" , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                    }
                   alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            else if password.text!.isEmpty == true || confirm_password.text!.isEmpty == true
            {
                let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu không được để trống" , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                    }
                   alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            sendInfoToRegister(full_name: full_name.text!, username: RegisterController.convertToViePhoneNumber(phoneNumber: username.text!), password: password.text!, confirm_password: confirm_password.text!)
        }
    }
    @IBAction func btnback(_ sender: Any) {
        if Core.shared.isNewUser() == true
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_controller")
            self.definesPresentationContext = true
            secondVC?.modalTransitionStyle = .crossDissolve
            secondVC?.modalPresentationStyle = .overCurrentContext
            present(secondVC!, animated: true)
        }
        else{
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
            self.definesPresentationContext = true
            secondVC?.modalTransitionStyle = .crossDissolve
            secondVC?.modalPresentationStyle = .overCurrentContext
            present(secondVC!, animated: true)
        }
       
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func sendInfoToRegister(full_name:String,username:String,password:String,confirm_password:String)
    {
        struct RequestData: Codable {
            var full_name:String
            var phone_number:String
            var email:String
            var password:String
            var repeat_password:String
        }

        let url = URL(string: DOMAIN_TO_REGISTER)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        var request_json:RequestData
        if isValidEmail(username) == true
        {
            request_json = RequestData(full_name: full_name, phone_number: "", email: username, password: password, repeat_password: confirm_password)
        }
        else
        {
            request_json = RequestData(full_name: full_name, phone_number: username, email: "", password: password, repeat_password: confirm_password)
        }
        
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
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse{
                        print(httpResponse.statusCode)
                        print(json)
                        if httpResponse.statusCode == 200{
                            StoreData.username = username
                            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "otp_controller") as! OTPController
                            _ = self.navigationController?.popViewController(animated: true)
                            self.definesPresentationContext = true
                            secondVC.modalPresentationStyle = .overCurrentContext
                            self.present(secondVC, animated: true)
                        }
                        else if httpResponse.statusCode == 400
                        {
                            if json["status_code"] as! Int == 0
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đã tồn tại trong hệ thống!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 1
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Thông tin đăng ký không hợp lệ!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 2
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Email hoặc số điện thoại không hợp lệ!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 3
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Email hoặc số điện thoại không được để trống!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 4
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Số điện thoại đã được đăng ký trên hệ thống" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                        StoreData.username = username
                                        LoginController.ReSendOTP(username: StoreData.username)
                                        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "otp_controller") as! OTPController
                                        self.definesPresentationContext = true
                                        secondVC.modalPresentationStyle = .overCurrentContext
                                        self.present(secondVC, animated: true)
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 5
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu không an toàn, hãy thử mật khẩu khác!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 6
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu không trùng khớp!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 7
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Họ và tên không vượt quá 50 ký tự!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else if json["status_code"] as! Int == 8
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Email đã tồn tại trong hệ thống!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                            else
                            {
                                let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đã tồn tại trong hệ thống!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Xác nhận", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
                                    }
                                   alert.addAction(okAction)
                                   // show the alert
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else if httpResponse.statusCode == 401
                        {
                            let alert = UIAlertController(title: "Thông báo", message: "Email hoặc mật khẩu không hợp lệ!" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
                                }
                               alert.addAction(okAction)
                               // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if httpResponse.statusCode == 403
                        {
                            let alert = UIAlertController(title: "Thông báo", message: "Tất cả các thông tin không được để trống!" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
                                }
                               alert.addAction(okAction)
                               // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if httpResponse.statusCode == 409
                        {
                            let alert = UIAlertController(title: "Thông báo", message: "Email đã tồn tại trong hệ thống!" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
                                }
                               alert.addAction(okAction)
                               // show the alert
                            self.present(alert, animated: true, completion: nil)
                        }
                        else if httpResponse.statusCode == 500
                        {
                            let alert = UIAlertController(title: "Thông báo", message: "Đăng ký không thành công!" , preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "Xác nhận", style:
                            UIAlertAction.Style.default) {
                               UIAlertAction in
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
    static func convertToViePhoneNumber(phoneNumber: String) -> String {
        var temp_phone = phoneNumber
        var result = ""
        if phoneNumber[0] == "+"
        {
            temp_phone.removeFirst()
            result = temp_phone
        }
        else if phoneNumber[0] == "0"
        {
            temp_phone.removeFirst()
            result = "84"+temp_phone
        }
        else
        {
            result = phoneNumber
        }
        return result
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemYellow.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
    }
}

