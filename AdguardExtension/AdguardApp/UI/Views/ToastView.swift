/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

class ToastView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var contentView: UIView!
    
    // MARK: - constans
    private static let toastHeight = CGFloat(80.0)
    private static let duration = 1.2
    private static let animationDuration = 0.2
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    static func presentinController(_ controller: UIViewController, message: String) {
        let yPos = controller.view.frame.height
        let width = controller.view.frame.width
        let toast = ToastView(frame: CGRect(x: CGFloat(0), y: yPos, width: width, height: toastHeight))
        toast.label.text = message
        controller.view.addSubview(toast)
        
        UIView.animate(withDuration: animationDuration) {
            let rect = CGRect(x: 0, y: yPos - toastHeight, width: width, height: toastHeight)
            toast.frame = rect
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            UIView.animate(withDuration: 0.3) {
                let rect = CGRect(x: 0, y: yPos, width: width, height: toastHeight)
                toast.frame = rect
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + animationDuration) {
            toast.removeFromSuperview()
        }
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ToastView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
