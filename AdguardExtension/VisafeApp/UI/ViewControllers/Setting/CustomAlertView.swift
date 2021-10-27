//
//  CustomAlertView.swift
//  visafe_ios
//
//  Created by NCSC P5 on 6/15/21.
//

import UIKit

class CustomAlertView: UIViewController {
    @IBOutlet var alertView: UIView!
    
    let scrollVie = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var button: UIButton!
    @IBAction func button_ok(_ sender: UIButton) {
        //dismiss
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
        StoreData.saveMyPlist(key: "status", value: "0")
        return
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
    private func configure() {
        let titles = "Chống lừa đảo và mã độc"
        
        let pageView = UIView(frame: CGRect(x: CGFloat(0) * alertView.frame.size.width, y: 0, width: alertView.frame.size.width, height: alertView.frame.size.height))
        alertView.addSubview(pageView)
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 10, height: 140))
        
        let button = UIButton(frame: CGRect(x: 20, y: pageView.frame.size.height - 150, width: pageView.frame.size.width - 40, height: 00))
        
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 30)
        label.numberOfLines = 2
        pageView.addSubview(label)
        label.text = titles
        // set up scrollview
        
//        scrollView.frame = alertView.bounds
//        alertView.addSubview(scrollView)
    
//        let titles = ["Chống lừa đảo\nvà mã độc", "Hạn chế quảng cáo\nvà theo dõi", "Kiểm soát chủ động", "Quản trị Dashboard", "Chào mừng"]
//        let subTitles = ["", "", "", "", ""]
        
        for x in 0..<5 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * alertView.frame.size.width, y: 0, width: alertView.frame.size.width, height: alertView.frame.size.height))
            alertView.addSubview(pageView)
            
            // Title, image, button
            let label1 = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width - 10, height: 140))
            
            
            let imageView = UIImageView(frame: CGRect(x: 20, y: 0+100, width: pageView.frame.size.width - 30, height: pageView.frame.size.height - 60 - 130 - 15))
            
            
            let button = UIButton(frame: CGRect(x: 20, y: pageView.frame.size.height - 150, width: pageView.frame.size.width - 40, height: 00))
            
            label1.textAlignment = .center
            label1.font = UIFont(name: "Helvetica-Bold", size: 30)
            label1.numberOfLines = 2
            pageView.addSubview(label1)
            label1.text = titles[x]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "intro-\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemYellow
            button.setTitle("Tiếp theo", for: .normal)
            if x == 4 {
                button.setTitle("Bắt đầu ngay", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
        }
        
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 5 else {
            //dismiss
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
//        scrollView.setContentOffset(CGPoint(x: alertView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }

}
