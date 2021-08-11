//
//  TabBarController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/13/21.
//

import UIKit

@available(iOS 12.0, *)
class TabBarController:UITabBarController,UITabBarControllerDelegate
{
    @IBOutlet weak var tabbar_main: UITabBar!
    var check:Int = 0
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let navigationController1 =  self.viewControllers![0] as? UINavigationController
        navigationController1!.popViewController(animated: false)

        let navigationController2 =  self.viewControllers![1] as? UINavigationController
        navigationController2!.popToRootViewController(animated: false)


        let navigationController3 =  self.viewControllers![2] as? UINavigationController
        navigationController3!.popToRootViewController(animated: false)
        
        if item.tag == 0
        {
            self.tabbar_main.barTintColor = UIColor(hexString: "#FFFFFF", alpha: 1)
            self.tabbar_main.isTranslucent = false
        }
        else if item.tag == 1
        {
            self.tabbar_main.barTintColor = UIColor(hexString: "#0C1847", alpha: 1)
            self.tabbar_main.isTranslucent = false
        }
        else
        {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.tabbar_main.barTintColor = .black
                self.tabbar_main.isTranslucent = false
            } else {
                self.tabbar_main.barTintColor = .white
                self.tabbar_main.isTranslucent = false
            }
        }
    }
    override func viewDidLoad() {
        self.tabBarController?.selectedIndex = 0
    }
}
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
