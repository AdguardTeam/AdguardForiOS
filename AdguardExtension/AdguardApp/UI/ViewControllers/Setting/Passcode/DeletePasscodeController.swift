//
//  ChangePasscodeController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/8/21.
//

import UIKit
class DeletePasscodeController:UIViewController{
    @IBOutlet weak var label_info_password: UILabel!
    var passcode:String=""
    var dot:Int=0;
    @IBOutlet weak var dot_2: UIImageView!
    @IBOutlet weak var dot_1: UIImageView!
    @IBOutlet weak var dot_4: UIImageView!
    @IBOutlet weak var dot_6: UIImageView!
    @IBOutlet weak var dot_5: UIImageView!
    @IBOutlet weak var dot_3: UIImageView!
    @IBOutlet weak var btn_ok: UIButton!
    
    
    @IBAction func btn_1(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="1"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }

    }
    @IBAction func btn_2(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="2"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_3(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="3"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_4(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="4"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_5(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="5"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_6(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="6"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_7(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="7"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_8(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="8"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_9(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="9"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    
    @IBAction func btn_0(_ sender: UIButton) {
        if (passcode.count < 6)
        {
            passcode+="0"
            dot+=1
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_true")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_true")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_true")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_true")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_true")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_true")
            }
            if passcode.count == 6
            {
                btn_ok.alpha = 1
            }
        }
    }
    @IBAction func btn_return(_ sender: UIButton) {
        let passcode_save:String = StoreData.getMyPlist(key: "passcode") as! String
        if (passcode.count == 6)
        {
            if passcode == passcode_save
            {
                StoreData.removeMyPlist(key: "passcode")
                let alert = UIAlertController(title: "Thông báo", message: "Xoá mã bảo vệ thành công" as? String, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                        }
                       // add an action (button)
                       alert.addAction(okAction)
                       // show the alert
                       self.present(alert, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Thông báo", message: "Nhập sai mã bảo vệ" as? String, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "Xác nhận", style:
                    UIAlertAction.Style.default) {
                       UIAlertAction in
                        self.passcode=""
                        self.label_info_password.text="Nhập mã bảo vệ hiện tại"
                        self.dot_1.image = UIImage(named: "dot_false")
                        self.dot_2.image = UIImage(named: "dot_false")
                        self.dot_3.image = UIImage(named: "dot_false")
                        self.dot_4.image = UIImage(named: "dot_false")
                        self.dot_5.image = UIImage(named: "dot_false")
                        self.dot_6.image = UIImage(named: "dot_false")
                        self.dot=0
                        self.btn_ok.alpha = 0
                        }
                       // add an action (button)
                       alert.addAction(okAction)
                       // show the alert
                       self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    @IBAction func btn_delete(_ sender: UIButton) {
        if (passcode.count != 0)
        {
            passcode.removeLast()
            if (dot == 1)
            {
                dot_1.image = UIImage(named: "dot_false")
            }
            else if (dot == 2)
            {
                dot_2.image = UIImage(named: "dot_false")
            }
            else if (dot == 3)
            {
                dot_3.image = UIImage(named: "dot_false")
            }
            else if (dot == 4)
            {
                dot_4.image = UIImage(named: "dot_false")
            }
            else if (dot == 5)
            {
                dot_5.image = UIImage(named: "dot_false")
            }
            else if (dot == 6)
            {
                dot_6.image = UIImage(named: "dot_false")
            }
            dot-=1
            if passcode.count < 6
            {
                btn_ok.alpha = 0
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_ok.alpha = 0
    }
}
