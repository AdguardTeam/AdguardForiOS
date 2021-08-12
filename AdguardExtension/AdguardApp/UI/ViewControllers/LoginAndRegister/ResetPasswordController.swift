//
//  ResetPasswordController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 7/3/21.
//

import UIKit

class ResetPasswordController:UIViewController,UITextFieldDelegate
{
    @IBOutlet weak var repeat_password: UITextField!
    @IBOutlet weak var new_password: UITextField!
    @IBOutlet weak var btn_forgot_pwd_outlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_forgot_pwd_outlet.layer.cornerRadius = 10
        btn_forgot_pwd_outlet.imageView?.contentMode = .scaleAspectFit
        new_password.delegate = self
        repeat_password.delegate = self
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
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
    @IBAction func btn_confirm(_ sender: Any) {
        ResetPassword(new_password: new_password.text!, repeat_password: repeat_password.text!, otp: StoreData.OTP, username: StoreData.username)
    }
    func ResetPassword(new_password:String, repeat_password:String,otp:String,username:String)
    {
        struct RequestData:Codable{
            var username:String
            var otp:String
            var password:String
            var repeat_password:String
        }
        let url = URL(string: DOMAIN_RESET_PASSWORD_WITH_OTP)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(username: username, otp: otp, password: new_password, repeat_password: repeat_password)
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
                            let alert = UIAlertController(title: "Thông báo", message: "Đổi mật khẩu thành công" , preferredStyle: UIAlertController.Style.alert)
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
                            let alert = UIAlertController(title: "Thông báo", message: "Đổi mật khẩu không thành công" , preferredStyle: UIAlertController.Style.alert)
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
                    }
                }
            }catch let jsonErr{
                DispatchQueue.main.async {
                }
           }
        }
        task.resume()
    }
}
