//
//  MainController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/11/21.
//

import UIKit
import Network
import NetworkExtension
import CoreData
import SafariServices
import WebKit
import AudioToolbox
import UserNotifications

class Main:UIViewController{
    
    @IBOutlet var view_main: UIView!
    @IBOutlet weak var active_background: UIImageView!
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    var status_network:Bool = false
    var count:Int = 0
    var first_use:Int = 0
    var updateTimer: Timer?
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let nativeProviders: NativeProvidersServiceProtocol = ServiceLocator.shared.getService()!
    @IBOutlet weak var btn_active_main: UIButton!
    @IBOutlet weak var image_status_mode: UIImageView!
    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    @IBOutlet weak var container_view: UIView!
    var status_btn:Int = 1, appear_time:Int = 0
    func animated_round() {
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
            self.container_view.transform = CGAffineTransform.identity
            self.container_view.transform = CGAffineTransform(rotationAngle:  -CGFloat.pi * 0.999)
        })
        {(true) in
            UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear, animations: {
                self.container_view.transform = CGAffineTransform(rotationAngle:  -CGFloat.pi * 0.999*2)
            })
            { (true)
                in self.animated_round()}
            
        }
    }
    @IBAction func btn_active(_ sender: UIButton) {
        if StoreData.getMyPlist(key: "userid") == nil{
            AppDelegate.GetUserID()
        }
        container_view.isHidden = true
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let vpnManager: VpnManagerProtocol = ServiceLocator.shared.getService()!
        let userid = StoreData.getMyPlist(key: "userid") as! String
        let upstream = DOMAIN_NORMAL + userid.lowercased()
        let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
        dnsProvidersService.addVisafeVPN(name: "Visafe", upstream: upstream) { [weak self] in
            vpnManager.updateSettings(completion: nil)
        }
        if status_btn == 0{
            
            let alertController = UIAlertController (title: "", message: "Bạn chắc chắn muốn ngắt \n tính năng bảo vệ của Visafe?", preferredStyle: .deviceAlertStyle)
            let until_turn_on = UIAlertAction(title: "Đồng ý", style: .default) { (_) -> Void in
                if StoreData.getMyPlist(key: "passcode") != nil
                {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "confirm_passcode") as! TurnOffVisafeController
                    _ = self.navigationController?.popViewController(animated: true)
                    self.navigationController?.pushViewController(secondVC, animated: false)
                }
                else
                {
                    self.status_btn = 1
                    self.complexProtection.switchSystemProtection(state: false, for: self) { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.updateVpnInfo()
                        }
                    }
                }
            }
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .default) { (_) -> Void in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(until_turn_on)
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(cancel)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            status_btn = 0
            self.complexProtection.switchSystemProtection(state: true, for: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.container_view.isHidden = false
                self?.active_background.image=UIImage(named: "Group 6043.png")
                let seconds = 2.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        self?.updateVpnInfo()
                    }
                }
            }
        }
    }
    private func updateVpnInfo() {
        
        let enabled = complexProtection.systemProtectionEnabled
        print("abc")
        print(complexProtection.systemProtectionEnabled)
        print(complexProtection.complexProtectionEnabled)
        if enabled == true && complexProtection.complexProtectionEnabled == true{
            self.active_background.image=UIImage(named: "Group 6041.png")
            self.status_btn = 0
            StoreData.saveMyPlist(key: "status", value: "1")
            container_view.isHidden = true
            // notification
            let content = UNMutableNotificationContent()
            content.title = "Đã kích hoạt chế độ bảo vệ!"
            content.body = "Chế độ chống lừa đảo, mã độc, tấn công mạng đã được kích hoạt!"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }
        else
        {
            container_view.isHidden = true
            self.active_background.image = UIImage(named: "Group 6042.png")
            StoreData.saveMyPlist(key: "status", value: "0")
            self.status_btn = 1
            //notification
            let content = UNMutableNotificationContent()
            content.title = "Bạn đã tắt chế độ bảo vệ!"
            content.body = "Thiết bị của bạn có thể bị ảnh hưởng bởi tấn công mạng "
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    @IBOutlet weak var background_dot: UIImageView!
    @IBOutlet weak var advertise: UIImageView!
    deinit {
      NotificationCenter.default.removeObserver(self)
    }
   
    override func viewDidLoad() {
       
        if StoreData.getMyPlist(key: "uuid") == nil
        {
            StoreData.saveMyPlist(key: "uuid", value: UUID().uuidString)
        }
        animated_round()
        container_view.isHidden = true
        //đoạn set gradient background
        let layer0 = CAGradientLayer()

        layer0.colors = [

          UIColor(red: 0.059, green: 0.09, blue: 0.2, alpha: 1).cgColor,

          UIColor(red: 0.062, green: 0.136, blue: 0.4, alpha: 1).cgColor

        ]
        layer0.locations = [0, 1]

        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)

        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)

        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.42, c: -0.42, d: 0, tx: 0.71, ty: 0.2))

        layer0.bounds = view_main.bounds.insetBy(dx: -0.5*view_main.bounds.size.width, dy: -0.5*view_main.bounds.size.height)

        layer0.position = view_main.center

        view_main.layer.addSublayer(layer0)
        layer0.frame = view_main.bounds
        view_main.bringSubviewToFront(background_dot)
        view_main.bringSubviewToFront(active_background)
        view_main.bringSubviewToFront(advertise)
        view_main.bringSubviewToFront(container_view)
        super.viewDidLoad()
        
        if (StoreData.getMyPlist(key: "status") as? String == nil)
        {
            status_btn = 1
            StoreData.saveMyPlist(key: "status", value: "1")
        }
        else{

            if StoreData.getMyPlist(key: "status") as? String == "0"{
                status_btn = 1
                StoreData.saveMyPlist(key: "status", value: "0")
                active_background.image=UIImage(named: "Group 6042.png")
            }
            else
            {
                status_btn = 0
                StoreData.saveMyPlist(key: "status", value: "1")
                active_background.image=UIImage(named: "Group 6041.png")
            }
        }
        first_use = 1
        if StoreData.getMyPlist(key: "status_code") == nil
        {
            StoreData.saveMyPlist(key: "status_code",value: 0)
        }
        StoreData.saveMyPlist(key: "check_passcode", value: false)
        // ImageButton
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image_status_mode.isUserInteractionEnabled = true
        image_status_mode.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "detail_mode") as! DetailModeViewController
        secondVC.modalPresentationStyle = .overFullScreen
        secondVC.modalTransitionStyle = .crossDissolve
        present(secondVC, animated: true)
    }
    func didDismiss() {
        print("dismiss called in view controller")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if Core.shared.isNewUser() {
            StoreData.saveMyPlist(key: "status", value: "0")
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "intro_screen")
            secondVC?.modalTransitionStyle = .crossDissolve
            secondVC?.modalPresentationStyle = .fullScreen
            self.present(secondVC!, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if StoreData.getMyPlist(key: "status_code") != nil
        {
            if StoreData.getMyPlist(key: "status_code") as! Int == 1
            {
                image_status_mode.image = UIImage(named: "basic+")
            }
            else
            {
                image_status_mode.image = UIImage(named: "basic")
            }
        }
        if StoreData.getMyPlist(key: "switch_vip") != nil
        {
            if StoreData.getMyPlist(key: "switch_vip") as! Bool == true
            {
                image_status_mode.image = UIImage(named: "vip-1")
            }
        }
        
        if StoreData.getMyPlist(key: "check_passcode") == nil
        {
            StoreData.saveMyPlist(key: "check_passcode", value: false)
            self.navigationController?.popViewController(animated: true)
        }
        else if StoreData.getMyPlist(key: "check_passcode") as! Bool == true
        {
            self.complexProtection.switchSystemProtection(state: false, for: self) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateVpnInfo()
                }
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

class Core {
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}

extension UIImage {
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
extension UIAlertController{
    func addImage(image:UIImage)
    {
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        var ratio:CGFloat!
        if (imgSize.width > imgSize.height)
        {
            ratio = maxSize.width / imgSize.width
        }
        else{
            ratio = maxSize.height / imgSize.height
        }
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        if imgSize.height > imgSize.width{
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
        }
        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(_:.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}
