//
//  DetailModeView.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/17/21.
//

import UIKit

class DetailModeViewController:UIViewController
{
    @IBOutlet weak var view_main_mode: UIView!
    @IBOutlet weak var image_detail_mode: UIImageView!
    
    @IBAction func remove_view(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        image_detail_mode.image = UIImage(named: "visafe_basic")
        if StoreData.getMyPlist(key: "status_code") != nil
        {
            if StoreData.getMyPlist(key: "status_code") as! Int == 1
            {
                image_detail_mode.image = UIImage(named: "visafe_basic+")
            }
        }
        if StoreData.getMyPlist(key: "switch_vip") != nil
        {
            if StoreData.getMyPlist(key: "switch_vip") as! Bool == true
            {
                image_detail_mode.image = UIImage(named: "visafe_vip")
            }
        }
        showAnimate()
    }
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

}
