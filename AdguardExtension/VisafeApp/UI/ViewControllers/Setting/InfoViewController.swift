//
//  InfoViewController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/9/21.
//

import UIKit
import StoreKit

class InfoViewController:UITableViewController
{
    @IBAction func btn_rate(_ sender: UIButton) {
        if #available(iOS 14.0, *) {
            guard let scene = view.window?.windowScene else{
                return
            }
            SKStoreReviewController.requestReview(in:scene)
        } else {
            if let url = URL(string: "https://apps.apple.com/vn/app/visafe-internet-an-to%C3%A0n/id1564635388") {
                UIApplication.shared.open(url)
            }
        }
        
    }
    private func callNumber(phoneNumber:String) {

      if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {

        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            application.open(phoneCallURL, options: [:], completionHandler: nil)
        }
      }
    }
    @IBAction func btn_call(_ sender: UIButton) {
        callNumber(phoneNumber: "02432091616")
        
    }
    @IBAction func btn_email(_ sender: UIButton) {
        let email = "ncsc@ais.gov.vn"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    @IBAction func btn_openfacebook(_ sender: UIButton) {
        if let url = URL(string: "https://www.facebook.com/visafe.vn") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func btn_question(_ sender: UIButton) {
        if let url = URL(string: "https://visafe.vn/faq/") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func btn_policy(_ sender: UIButton) {
        if let url = URL(string: "https://visafe.vn/privacy-policy/") {
            UIApplication.shared.open(url)
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    @IBAction func btn_version(_ sender: Any) {
        let alert = UIAlertController(title: "Phiên bản", message: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
    }
}
