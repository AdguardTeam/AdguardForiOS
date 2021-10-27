//
//  PasscodeSettings.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/8/21.
//

import UIKit
class PasscodeSettingsController:UITableViewController
{
    var passcode:String = ""
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if StoreData.getMyPlist(key: "passcode") != nil
        {
            
            if indexPath.row == 0 {
                return 0
            }
        }
        else
        {
            if indexPath.row == 2 {
                return 0
            }
            if indexPath.row == 1 {
                return 0
            }
        }
        
            
        return tableView.rowHeight
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
