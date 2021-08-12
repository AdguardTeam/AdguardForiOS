//
//  SettingController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/12/21.
//

import UIKit
class SettingController:UITableViewController
{
    @IBOutlet weak var tableSection: UITableView!
    @IBOutlet weak var share: UIView!
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    
    @IBOutlet weak var btn_logout_outlet: UIButton!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet var status_register: UILabel!
    @IBOutlet var table_view: UITableView!
    @IBOutlet weak var switch_for_vip: UISwitch!
    @IBOutlet weak var image_setting: UIImageView!
    @IBAction func switch_vip(_ sender: UISwitch) {
        if sender.isOn == true
        {
            let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "vip_layout") as! VipController
            _ = self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(secondVC, animated:false)
        }
        else
        {
            let alertController = UIAlertController (title: "Cảnh báo", message: "Bạn có muốn tắt chế độ VIP?", preferredStyle: .alert)
            let until_turn_on = UIAlertAction(title: "Đồng ý", style: .default) { (_) -> Void in
                StoreData.saveMyPlist(key: "switch_vip", value: false)
                StoreData.saveMyPlist(key: "domain_vip", value: DOMAIN_NORMAL)
            }
            alertController.addAction(until_turn_on)
            let cancel = UIAlertAction(title: "Hủy bỏ", style: .default) { (_) -> Void in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancel)
           present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        if StoreData.getMyPlist(key: "userid") != nil
        {
            postRequestCheckDeviceStatus(ran_str: StoreData.getMyPlist(key: "userid") as! String)
        }
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        deviceName.text = UIDevice.current.name
        if StoreData.getMyPlist(key: "switch_vip") == nil
        {
            StoreData.saveMyPlist(key: "switch_vip", value: false)
        }
        else
        {
            if StoreData.getMyPlist(key: "switch_vip") as! Bool == true
            {
                switch_for_vip.setOn(true, animated: false)
            }
            else
            {
                switch_for_vip.setOn(false, animated: false)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        postRequestCheckDeviceStatus(ran_str: StoreData.getMyPlist(key: "userid") as! String)
        if StoreData.getMyPlist(key: "switch_vip") == nil
        {
            StoreData.saveMyPlist(key: "switch_vip", value: false)
        }
        else
        {
            if StoreData.getMyPlist(key: "switch_vip") as! Bool == true
            {
                switch_for_vip.setOn(true, animated: false)
            }
            else
            {
                switch_for_vip.setOn(false, animated: false)
            }
        }
        tableView.reloadData()
    }
    func postRequestCheckDeviceStatus(ran_str:String){
        struct RequestData: Codable {
            var deviceId:String
        }

        let url = URL(string: DOMAIN_CHECK_STATUS_DEVICE)
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("applicsation/json", forHTTPHeaderField: "Content-Type")
        let request_json = RequestData(deviceId: ran_str)
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
                    if (json["status_code"] as! Int == 1)
                    {
                        StoreData.saveMyPlist(key: "status_code", value: 1)
                        StoreData.saveMyPlist(key: "groupId", value: json["groupId"] as! String)
                    }
                    else
                    {
                        StoreData.saveMyPlist(key: "status_code", value: 0)
                        StoreData.saveMyPlist(key: "groupId", value:"")
                    }
                    if StoreData.getMyPlist(key: "status_code") as! Int == 1
                    {
                        self.status_register.text = "Thiết bị đã được đăng ký"
                        self.status_register.textColor = .systemGreen
                    }
                    else
                    {
                        self.status_register.text = "Thiết bị chưa được đăng ký"
                        self.status_register.textColor = .gray
                    }
                }
            }catch let jsonErr{
           }
        }
        task.resume()
    }
    
    @IBAction func btn_logout(_ sender: UIButton) {
        if StoreData.getMyPlist(key: "token_login") == nil
        {
            
        }
        else
        {
            print(StoreData.getMyPlist(key: "token_login") as! String)
            if StoreData.getMyPlist(key: "token_login") as! String == ""
            {
               
            }
            else
            {
                let alert = UIAlertController(title: "Thông báo", message: "Bạn có chắc chắn muốn đăng xuất tài khoản?" , preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                        StoreData.saveMyPlist(key: "token_login", value: "")
                    }
                let cancelAction = UIAlertAction(title: "Hủy bỏ", style:
                UIAlertAction.Style.default) {
                   UIAlertAction in
                    }
                    alert.addAction(cancelAction)
                   alert.addAction(okAction)

                   // show the alert
                self.present(alert, animated: true, completion: nil)
               
            }
        }
        
        
    }
  
}

