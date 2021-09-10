//
//  IntroScreenViewController.swift
//  Visafe Pro
//
//  Created by NCSC P5 on 9/6/21.
//  Copyright © 2021 Performiks. All rights reserved.
//

import Foundation


class IntroViewScreenController:UIViewController{
    @IBAction func btn_start(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        Core.shared.setIsNotNewUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
