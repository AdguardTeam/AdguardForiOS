//
//  DashboardController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/4/21.
//

import UIKit
import WebKit
import Network

@available(iOS 12.0, *)
class DashboardController: UIViewController, UIScrollViewDelegate,WKNavigationDelegate{
    @IBOutlet var webView: WKWebView!
    @IBOutlet var image_no_connection: UIImageView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var btn_start_outlet: UIButton!
    let view_under = UIView();
    @IBOutlet weak var indicator_loading_webview: UIActivityIndicatorView!
    override func viewDidLoad() {

        if Core_Dashboard.shared.isNewUser() == false{
            Core_Dashboard.shared.setIsNotNewUser()
            image.isHidden = true
            btn_start_outlet.isHidden = true
        }
        
        webView.addSubview(indicator_loading_webview)
        indicator_loading_webview.startAnimating()
        webView.navigationDelegate = self
        indicator_loading_webview.hidesWhenStopped = true
        
        if StoreData.getMyPlist(key: "uuid") == nil
        {
            StoreData.saveMyPlist(key: "uuid", value: UUID().uuidString)
        }
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right

        webView.addGestureRecognizer(swipeLeftRecognizer)
        webView.addGestureRecognizer(swipeRightRecognizer)

        super.viewDidLoad()
        var jsonData:String = ""
        let monitor = NWPathMonitor()
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    if StoreData.getMyPlist(key: "groupId") != nil
                    { 
                        if StoreData.getMyPlist(key: "groupId") as! String == ""
                        {
                            struct RequestData: Codable {
                                var deviceId:String
                                var deviceName:String
                                var macAddress:String
                                var ipAddress:String
                                var deviceType:String
                                var deviceOwner:String
                                var deviceDetail:String
                            }
                            let request_json = RequestData(
                                deviceId: StoreData.getMyPlist(key: "userid") as! String,
                                deviceName: UIDevice.current.name,
                                macAddress: StoreData.getMyPlist(key: "uuid") as! String,
                                ipAddress: "127.0.0.1",
                                deviceType: UIDevice.current.model,
                                deviceOwner: UIDevice.current.name,
                                deviceDetail: StoreData.getMyPlist(key: "uuid") as! String)
                            let jsonParam = try? JSONEncoder().encode(request_json)
                            jsonData = String(data: (jsonParam)!, encoding: .utf8)!
                        }
                        else
                        {
                            struct RequestData: Codable {
                                var deviceId:String
                                var groupName:String
                                var groupId:String
                                var deviceName:String
                                var macAddress:String
                                var ipAddress:String
                                var deviceType:String
                                var deviceOwner:String
                                var deviceDetail:String
                            }
                            let request_json = RequestData(
                                deviceId: StoreData.getMyPlist(key: "userid") as! String,
                                groupName: "",
                                groupId: StoreData.getMyPlist(key: "groupId") as! String,
                                deviceName: UIDevice.current.name,
                                macAddress: StoreData.getMyPlist(key: "uuid") as! String,
                                ipAddress: "127.0.0.1",
                                deviceType: UIDevice.current.model,
                                deviceOwner: UIDevice.current.name,
                                deviceDetail: StoreData.getMyPlist(key: "uuid") as! String)
                            let jsonParam = try? JSONEncoder().encode(request_json)
                            jsonData = String(data: (jsonParam)!, encoding: .utf8)!
                        }
                    }
                    else
                    {
                        struct RequestData: Codable {
                            var deviceId:String
                            var deviceName:String
                            var macAddress:String
                            var ipAddress:String
                            var deviceType:String
                            var deviceOwner:String
                            var deviceDetail:String
                        }
                        let request_json = RequestData(
                            deviceId: StoreData.getMyPlist(key: "userid") as! String,
                            deviceName: UIDevice.current.name,
                            macAddress: StoreData.getMyPlist(key: "uuid") as! String,
                            ipAddress: "127.0.0.1",
                            deviceType: UIDevice.current.model,
                            deviceOwner: UIDevice.current.name,
                            deviceDetail: StoreData.getMyPlist(key: "uuid") as! String)
                        let jsonParam = try? JSONEncoder().encode(request_json)
                        jsonData = String(data: (jsonParam)!, encoding: .utf8)!
                    }
                   
                    var source: String = ""
                    if jsonData == ""
                    {
                       source = "var meta = document.createElement('meta');" +
                          "meta.name = 'viewport';" +
                          "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                          "var head =  document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
                    }
                    else
                    {
                       source = "var meta = document.createElement('meta');" +
                           "meta.name = 'viewport';" +
                           "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                           "var head =  document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"+"window.localStorage.setItem('deviceNative','" + jsonData + "');"
                        
                    }
                    if StoreData.getMyPlist(key: "token_login") != nil
                    {
                        let token:String = StoreData.getMyPlist(key: "token_login") as! String
                        source = source + "window.localStorage.setItem('token','" + token + "');"
                    }
                    let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                    self.webView.configuration.userContentController.addUserScript(script)
                    self.webView.scrollView.showsHorizontalScrollIndicator = false;
                    self.webView.scrollView.showsVerticalScrollIndicator = false;
                    self.webView.load(URLRequest(url: URL(string:DOMAIN_WEBVIEW )!))
                    let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: nil, action: nil)
                    longPress.minimumPressDuration = 0.2
                    self.webView.addGestureRecognizer(longPress)
                    if self.view_under.tag == 100
                    {
                        self.view_under.removeFromSuperview()
                        self.webView.reload()
                    }
                    //self.webView.reload()
                }
            } else {
                DispatchQueue.main.async {
                    
                    let screenSize: CGRect = UIScreen.main.bounds
                    let screenWidth = screenSize.width
                    let screenHeight = screenSize.height
                    self.view_under.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self.view_under.backgroundColor = .white
                    let imageNoConnection = UIImageView(image: UIImage(named: "intro_launch.jpg"))
                    imageNoConnection.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    imageNoConnection.contentMode = .scaleAspectFit
                    self.view_under.addSubview(imageNoConnection)
                    self.view.addSubview(self.view_under)
                    self.view_under.tag = 100
                }
            }
            
        }
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func btn_start(_ sender: Any) {
        webView.reload()
        image.isHidden = true
        btn_start_outlet.isHidden = true
        Core_Dashboard.shared.setIsNotNewUser()
    }

    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
            if webView.canGoForward {
                webView.goForward()
            }
        }

        if (recognizer.direction == .right) {
            if webView.canGoBack {
                webView.goBack()
            }
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator_loading_webview.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator_loading_webview.stopAnimating()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator_loading_webview.startAnimating()
    }
}
class Core_Dashboard {
    static let shared = Core_Dashboard()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNew")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNew")
    }
}
