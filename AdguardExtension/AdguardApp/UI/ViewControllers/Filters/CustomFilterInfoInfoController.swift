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

protocol CustomFilterInfoInfoDelegate {
    func deleteFilter(filter: Filter)
}

class CustomFilterInfoInfoController: UIViewController {
    
    var filter: Filter?
    var delegate: CustomFilterInfoInfoDelegate?
    
    let aeService: AEServiceProtocol = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rulesCount: UILabel!
    @IBOutlet weak var homepageCaption: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var contentView: RoundrectView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    // MARK: - view controller methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != contentView && touch.view != homepage {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = filter?.name
        rulesCount.text = "\(filter?.rulesCount ?? 0)"
        
        if let homepageUrl = filter?.homepage, homepageUrl.count > 0 {
            homepage.text = homepageUrl
        }
        else {
            homepage.isHidden = true
            homepageCaption.isHidden = true
        }
        
        updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func deleteAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.deleteFilter(filter: self.filter!)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homepageAction(_ sender: Any) {
        guard   let homepage = filter?.homepage,
                let url = URL(string: homepage) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - private methods
    
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
    }
}
