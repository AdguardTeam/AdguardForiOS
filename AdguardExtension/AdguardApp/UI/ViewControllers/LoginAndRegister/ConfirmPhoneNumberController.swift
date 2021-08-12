//
//  ConfirmPhoneNumberController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/30/21.
//

import UIKit

class ConfirmPhoneNumberController:UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var btn_confirm_phoneNumber: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
        btn_confirm_phoneNumber.layer.cornerRadius = 8
        btn_confirm_phoneNumber.backgroundColor = UIColor.systemYellow
        btn_cancel.layer.borderColor = UIColor.systemYellow.cgColor
        btn_cancel.layer.borderWidth = 1
        btn_cancel.layer.cornerRadius = 8
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        phoneNumber.layer.borderWidth = 2
        phoneNumber.layer.cornerRadius = 5
        phoneNumber.layer.borderColor = UIColor.systemYellow.cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        phoneNumber.layer.borderWidth = 1
        phoneNumber.layer.cornerRadius = 5
        phoneNumber.layer.borderColor = UIColor.lightGray.cgColor
    }
    @IBAction func btn_send_tp_to_confirm(_ sender: Any) {
        if phoneNumber.text != ""
        {
            StoreData.username = RegisterController.convertToViePhoneNumber(phoneNumber: phoneNumber.text!)
            self.ReSendOTPResetPassword(username: RegisterController.convertToViePhoneNumber(phoneNumber: phoneNumber.text!))
        }
        else
        {
            let alert = UIAlertController(title: "Thông báo", message: "Nhập chính xác số điện thoại được đăng ký" , preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Xác nhận", style:
            UIAlertAction.Style.default) {
               UIAlertAction in
                }
               alert.addAction(okAction)
               // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func btn_cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func ReSendOTPResetPassword(username:String) {
        struct RequestData: Codable {
            var username:String
        }
        let url = URL(string: DOMAIN_RESET_PASSWORD+username)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                DispatchQueue.main.async {
                    if let response = response as? HTTPURLResponse {
                           if response.statusCode == 200
                           {
                                StoreData.forgot_password = true
                                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "otp_controller")
                                self.definesPresentationContext = true
                                secondVC?.modalPresentationStyle = .overCurrentContext
                                self.present(secondVC!, animated: true, completion: nil)
                           }
                           else
                           {
                            let alert = UIAlertController(title: "Thông báo", message: "Email hoặc Số điện thoại chưa được đăng ký trên hệ thống" , preferredStyle: UIAlertController.Style.alert)
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
            }
            catch _{
            }
        }
        task.resume()
    }
}
