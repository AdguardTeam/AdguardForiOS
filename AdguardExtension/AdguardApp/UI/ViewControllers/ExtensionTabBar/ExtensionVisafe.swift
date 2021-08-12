//
//  ExtensionVisafe.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/11/21.
//


import UIKit
import Network
import WebKit
@available(iOS 12.0, *)
class ExtensionVisafeController:UIViewController, WKNavigationDelegate
{
    @IBOutlet var webView: WKWebView!
    @IBOutlet var image_no_connection_extension: UIImageView!
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    let view_under = UIView();
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addSubview(progressBar)
        progressBar.startAnimating()
        webView.navigationDelegate = self
        progressBar.hidesWhenStopped = true
        let monitor = NWPathMonitor()
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(recognizer:)))
                    let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(recognizer:)))
                    swipeLeftRecognizer.direction = .left
                    swipeRightRecognizer.direction = .right

                    self.webView.addGestureRecognizer(swipeLeftRecognizer)
                    self.webView.addGestureRecognizer(swipeRightRecognizer)
                    let source: String = "var meta = document.createElement('meta');" +
                          "meta.name = 'viewport';" +
                          "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
                          "var head =  document.getElementsByTagName('head')[0];" + "head.appendChild(meta);";
                    let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                    self.webView.configuration.userContentController.addUserScript(script)
                    self.webView.scrollView.showsHorizontalScrollIndicator = false;
                    self.webView.scrollView.showsVerticalScrollIndicator = false;
                    self.webView.load(URLRequest(url: URL(string:DOMAIN_WEBVIEW_EXTENSION )!))
                    let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: nil, action: nil)
                    longPress.minimumPressDuration = 0.2
                    self.webView.addGestureRecognizer(longPress)
                    if self.view_under.tag == 100
                    {
                        self.view_under.removeFromSuperview()
                    }
                }
            } else {
                DispatchQueue.main.async { [self] in
//                    let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
//                    let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
//                    swipeLeftRecognizer.direction = .left
//                    swipeRightRecognizer.direction = .right
//
//                    webView.addGestureRecognizer(swipeLeftRecognizer)
//                    webView.addGestureRecognizer(swipeRightRecognizer)
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
        progressBar.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressBar.stopAnimating()
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        progressBar.startAnimating()
    }
}
