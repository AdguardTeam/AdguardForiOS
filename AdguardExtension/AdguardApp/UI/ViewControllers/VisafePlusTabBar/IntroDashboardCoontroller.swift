//
//  IntroDashboardCoontroller.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/23/21.
//

import UIKit


class IntroDashboardController:UIViewController{
    @IBOutlet weak var btn_discover: UIButton!
    @IBAction func btn_discover_action(_ sender: UIButton) {
        if Core_Dashboard.shared.isNewUser() == true{
            if StoreData.getMyPlist(key: "token_login") == nil
            {
                Core_Dashboard.shared.setIsNotNewUser()
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
                self.definesPresentationContext = true
                secondVC?.modalPresentationStyle = .overCurrentContext
                self.present(secondVC!, animated: true)
            }
            else
            {
                Core_Dashboard.shared.setIsNotNewUser()
                if StoreData.getMyPlist(key: "token_login") as! String == ""
                {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
                    self.definesPresentationContext = true
                    secondVC?.modalPresentationStyle = .overCurrentContext
                    self.present(secondVC!, animated: true)
                }
                else
                {
                    let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboard_controller")
                    self.definesPresentationContext = true
                    secondVC?.modalPresentationStyle = .overCurrentContext
                    self.present(secondVC!, animated: true)
                }
            }
        }

    }
    override func viewDidLoad() {
        btn_discover.layer.cornerRadius = 5
        btn_discover.layer.borderWidth = 0
        btn_discover.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn_discover.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        btn_discover.layer.shadowOpacity = 0.7
        btn_discover.layer.shadowRadius = 0
        btn_discover.layer.masksToBounds = false
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
           
        }
    }
}
