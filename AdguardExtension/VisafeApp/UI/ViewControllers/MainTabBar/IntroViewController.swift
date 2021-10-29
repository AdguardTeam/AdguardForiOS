//
//  IntroViewController.swift
//  visafe_ios
//
//  Created by TIEN on 5/6/21.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet var holderView: UIView!
    
    let scrollView = UIScrollView()
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
//        dismiss(animated: true, completion: nil)
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbar_main")
        self.definesPresentationContext = true
        secondVC?.modalPresentationStyle = .overCurrentContext
        self.present(secondVC!, animated: true)
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
        // set up scrollview
        
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
    
        let titles = ["Chống lừa đảo, mã độc,\ntấn công mạng", "Hạn chế quảng cáo\nvà theo dõi", "Kiểm soát chủ động", "Quản trị Dashboard", "Chào mừng"]
        let subTitles = ["Phòng tránh nguy cơ, thiệt hại từ\ncác cuộc tấn công mạng, lừa đảo trực tuyến", "", "", "", ""]
        
        for x in 0..<1 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * holderView.frame.size.width, y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // Title, image, button
            let label1 = UILabel(frame: CGRect(x: 10, y: pageView.frame.size.height - 280, width: pageView.frame.size.width - 10, height: 140))
            let label2 = UILabel(frame: CGRect(x: 10, y: pageView.frame.size.height - 220, width: pageView.frame.size.width - 10, height: 140))
            
            let imageView = UIImageView(frame: CGRect(x: 50, y: 0+5, width: pageView.frame.size.width - 100, height: pageView.frame.size.height - 60 - 130 - 15))
            
            
            let button = UIButton(frame: CGRect(x: 40, y: pageView.frame.size.height - 150, width: pageView.frame.size.width - 80, height: 00))
            
            label1.textAlignment = .center
            label1.font = UIFont(name: "Helvetica-Bold", size: 24)
            label1.numberOfLines = 2
            pageView.addSubview(label1)
            label1.text = titles[x]
            
            label2.textAlignment = .center
            label2.font = UIFont(name: "Helvetica", size: 15)
            label2.textColor = UIColor.gray
            label2.numberOfLines = 2
            pageView.addSubview(label2)
            label2.text = subTitles[x]
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "intro-\(x+1)")
            pageView.addSubview(imageView)
            
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemYellow
            button.setTitle("Bắt đầu", for: .normal)
            if x == 4 {
                button.setTitle("Bắt đầu", for: .normal)
            }
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
//            pageView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width*1, height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 5 else {
            //dismiss
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
}
