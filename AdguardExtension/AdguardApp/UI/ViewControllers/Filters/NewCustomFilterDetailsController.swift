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

protocol NewCustomFilterDetailsDelegate {
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool)
}

class NewCustomFilterDetailsController : UIViewController {
    
    let aeService: AEServiceProtocol = ServiceLocator.shared.getService()!
    let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    var filter : AASCustomFilterParserResult?
    var delegate : NewCustomFilterDetailsDelegate?
    var overwriteExisted = false
    
    // MARK: - IB Outlets
    @IBOutlet weak var contentView: RoundrectView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rulesCount: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var homepageCaption: UILabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        name.text = filter?.meta.name
        let count: Int = filter?.rules.count ?? 0
        rulesCount.text = String(count)
        
        if let homepageUrl = filter?.meta.homepage, homepageUrl.count > 0 {
            homepage.text = homepageUrl
        }
        else {
            homepageCaption.isHidden = true
            homepage.isHidden = true
        }
        
        updateTheme()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if touch.view != contentView {
            navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            super.touchesBegan(touches, with: event)
        }
    }
    
    // MARK: - Actions
    @IBAction func AddAction(_ sender: Any) {
        delegate?.addCustomFilter(filter: filter!, overwriteExisted: overwriteExisted)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupPopupLabels(themableLabels)
    }
}
