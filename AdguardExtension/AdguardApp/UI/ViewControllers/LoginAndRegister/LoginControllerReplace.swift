//
//  LoginControllerReplace.swift
//  visafe_ios
//
//  Created by NCSC P5 on 7/6/21.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class LoginControllerReplace:UIViewController,UITextFieldDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("We have error sign in user == \(error.localizedDescription)")
        } else {               // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            self.LoginSocial(url:DOMAIN_LOGIN_WITH_GMAIL,token: idToken!)
        }
    }
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btn_login_outlet: UIButton!
    @IBOutlet weak var btn_register_outlet: UIButton!
    @IBOutlet weak var btn_login_facebook: UIImageView!
    @IBOutlet weak var btn_login_google: UIImageView!
    @IBOutlet weak var btn_login_apple: UIImageView!
    @IBOutlet weak var btn_forgot_password: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        email.delegate = self
        password.delegate = self
        btn_login_outlet.imageView?.contentMode = .scaleAspectFit
        btn_login_outlet.layer.cornerRadius = 5
        btn_register_outlet.imageView?.contentMode = .scaleAspectFit
        self.hideKeyboardWhenTappedAround()
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginControllerReplace.tapFunction))
                btn_forgot_password.isUserInteractionEnabled = true
                btn_forgot_password.addGestureRecognizer(tap)
        let tapFb = UITapGestureRecognizer(target: self, action: #selector(LoginController.tapFacebookFunction))
                btn_login_facebook.isUserInteractionEnabled = true
                btn_login_facebook.addGestureRecognizer(tapFb)
        let tapGg = UITapGestureRecognizer(target: self, action: #selector(LoginController.tapGmailFunction))
                btn_login_google.isUserInteractionEnabled = true
                btn_login_google.addGestureRecognizer(tapGg)
        let tapAp = UITapGestureRecognizer(target: self, action: #selector(LoginController.tapAppleFunction))
                btn_login_apple.isUserInteractionEnabled = true
                btn_login_apple.addGestureRecognizer(tapAp)
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            if AccessToken.current?.tokenString != nil
            {
                print("FB Access Token: " + (AccessToken.current?.tokenString)!)
                self.LoginSocial(url:DOMAIN_LOGIN_WITH_FACEBOOK,token: (AccessToken.current?.tokenString)!)
            }
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
    }
    @IBAction func btn_register(_ sender: UIButton) {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "register_controller")
        self.definesPresentationContext = true
        secondVC?.modalTransitionStyle = .crossDissolve
        secondVC?.modalPresentationStyle = .overCurrentContext
        self.present(secondVC!, animated: true,completion: nil)
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "confirm_phoneNumber")
        self.definesPresentationContext = true
        newVC?.modalTransitionStyle = .crossDissolve
        newVC?.modalPresentationStyle = .overCurrentContext
        self.present(newVC!, animated: true, completion: nil)

    }
    @objc func tapFacebookFunction (sender:UITapGestureRecognizer) {
        let loginManager = LoginManager()
        
        if let _ = AccessToken.current {
            // Access token available -- user already logged in
            // Perform log out
            
            loginManager.logOut()
            
            
        } else {
           
            let loginManager = LoginManager()
            
            if let _ = AccessToken.current {
                loginManager.logOut()
                print("Đăng xuất")
            } else {
                loginManager.logIn(permissions: [], from: self) { (result, error) in
                    
                    // Check for error
                    guard error == nil else {
                        // Error occurred
                        print(error!.localizedDescription)
                        return
                    }
                    
                    // Check for cancel
                    guard let result = result, !result.isCancelled else {
                        print("User cancelled login")
                        return
                    }
                    
                    
                }
            }
        }
    }
    
    @objc func tapGmailFunction (sender:UITapGestureRecognizer) {
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance()?.signIn()
        let signInConfig = GIDConfiguration.init(clientID: "364533202921-h0510keg49fuo2okdgopo48mato4905d.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: self
        ) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let idToken = user.authentication.idToken // Safe to send to the server
            self.LoginSocial(url:DOMAIN_LOGIN_WITH_GMAIL,token: idToken!)
        }
    }
    @objc private func userDidSignInGoogle(_ notification: Notification) {
           // Update screen after user successfully signed in
           print("Login gmail successfully")
       }
    @objc func tapAppleFunction (sender:UITapGestureRecognizer) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            
        }
        
    }
    
    @IBAction func btn_login(_ sender: UIButton) {
        sendInfoToLoginAccount(email: RegisterController.convertToViePhoneNumber(phoneNumber: email.text!),password: password.text!)
    }
    func sendInfoToLoginAccount(email:String,password:String)
    {
        struct RequestData: Codable {
            var username:String
            var password:String
        }

        let url = URL(string: DOMAIN_TO_LOGIN)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(
            username: email, password: password)
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
                        if httpResponse.statusCode == 200{
                            print(json["token"] as! String)
                            Core.shared.setIsNotNewUser()
                            StoreData.saveMyPlist(key: "token_login", value: json["token"] as! String)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "tabbar_main") as! TabBarController
                            vc.modalPresentationStyle = .fullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            self.present(vc, animated: true, completion: nil)
                        }
                        else if httpResponse.statusCode == 404
                        {
                            StoreData.saveMyPlist(key: "token_login", value: "")
                            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản chưa được đăng ký trên hệ thống!" , preferredStyle: UIAlertController.Style.alert)
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
                            if json["status_code"] as! Int == 0
                            {
                                StoreData.saveMyPlist(key: "token_login", value: "")
                                let alert = UIAlertController(title: "Thông báo", message: "Email hoặc mật khẩu nhập không đúng.\nMời đăng nhập lại!" , preferredStyle: UIAlertController.Style.alert)
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
                                StoreData.username = email
                                StoreData.saveMyPlist(key: "token_login", value: "")
                                let alert = UIAlertController(title: "Thông báo", message: "Tài khoản chưa được kích hoạt!" , preferredStyle: UIAlertController.Style.alert)
                                let okAction = UIAlertAction(title: "Kích hoạt", style:
                                UIAlertAction.Style.default) {
                                   UIAlertAction in
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
