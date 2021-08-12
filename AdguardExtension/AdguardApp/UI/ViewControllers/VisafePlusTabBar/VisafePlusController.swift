//
//  VisafePlusController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 7/6/21.
//

import UIKit

class VisafePlusController:UIViewController
{

    override func viewDidLoad() {
        self.tabBarController?.selectedIndex = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        if StoreData.getMyPlist(key: "token_login") == nil
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
            _ = self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(secondVC!, animated:false)
        }
        else
        {
            if StoreData.getMyPlist(key: "token_login") as! String == ""
            {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(secondVC!, animated:false)
            }
            else{
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboard_controller")
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(secondVC!, animated:false)
            }

        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if StoreData.getMyPlist(key: "token_login") == nil
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
            _ = self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(secondVC!, animated:false)
        }
        else
        {
            if StoreData.getMyPlist(key: "token_login") as! String == ""
            {
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "login_view_controller")
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(secondVC!, animated:false)
            }
            else{
                let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboard_controller")
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(secondVC!, animated:false)
            }

        }
    }
}
