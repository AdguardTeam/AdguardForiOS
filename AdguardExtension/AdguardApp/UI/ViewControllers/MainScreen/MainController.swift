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
import UIKit

import AdSupport

/**
 Main Screen View Controller
 */
class MainController: UIViewController {
    
    // MARK: - constants
    let enabledColor = UIColor(hexString: "#68BC71")
    let disabledColor = UIColor(hexString: "#DF3812")
    let partlyEnabledColor = UIColor(hexString: "#DC9839")
    
    let RATE_APP_URL_FORMAT = "itms-apps://itunes.apple.com/us/app/itunes-u/id%@?action=write-review"
    #if PRO
    let ITUNES_APP_ID = ITUNES_PRO_APP_ID
    #else
    let ITUNES_APP_ID = "1047223162"
    #endif
    
    let SHARE_APP_URL_FORMAT = "https://itunes.apple.com/app/id%@"
    
    // MARK: - IB outlets
    @IBOutlet weak var headerImage: ThemeableImageView!
    @IBOutlet weak var enabledLabel: UILabel!
    
    @IBOutlet weak var filtersVersionLabel: UILabel!
    @IBOutlet weak var updateFiltersGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var refreshIcon: UIImageView!
    
    @IBOutlet weak var tutorialVideoView: UIView!
    @IBOutlet weak var adguardManView: UIView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var roundArrow: UIImageView!
    @IBOutlet weak var shareView: UIView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var getProView: StackElementView!
    @IBOutlet weak var getProHeight: NSLayoutConstraint!
    @IBOutlet weak var manImage: UIImageView!
    @IBOutlet weak var vikingImage: UIImageView!
    
    @IBOutlet weak var premiumLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    // MARK: - properties
    lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    var observations: [NSKeyValueObservation] = [NSKeyValueObservation]()
    
    var viewModel: MainViewModel?
    
    private var darkThemeLogoImage = UIImage(named: "ahduard-header-disabled-dark") ?? UIImage()
    private var lightThemeLogoImage = UIImage(named: "adguard-header-disabled") ?? UIImage()
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStatusView()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        let ratedObservation = configuration.observe(\.appRated) {[weak self](_, _) in
            self?.updateUI()
        }
        
        let proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            self?.updateUI()
        }
        
        let contenBlockerObservation = configuration.observe(\.contentBlockerEnabled) {[weak self] (_, _) in
            self?.updateUI()
        }
        
        observations.append(ratedObservation)
        observations.append(proObservation)
        observations.append(contenBlockerObservation)
        
        configuration.checkContentBlockerEnabled()
        
        viewModel = MainViewModel(antibanner: antibanner)
        setupBackButton()
        
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateTheme()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return theme.statusbarStyle()
    }
    
    // MARK: - IB Actions
    @IBAction func ratemeAction(_ sender: UITapGestureRecognizer) {
        
        if sender.view is UIImageView {
            
            switch sender.view as! UIImageView {
            case star1:
                star1.isHighlighted = true
            case star2:
                star1.isHighlighted = true
                star2.isHighlighted = true
            case star3:
                star1.isHighlighted = true
                star2.isHighlighted = true
                star3.isHighlighted = true
            case star4:
                star1.isHighlighted = true
                star2.isHighlighted = true
                star3.isHighlighted = true
                star4.isHighlighted = true
            case star5:
                star1.isHighlighted = true
                star2.isHighlighted = true
                star3.isHighlighted = true
                star4.isHighlighted = true
                star5.isHighlighted = true
            default:
                star1.isHighlighted = true
                star2.isHighlighted = true
                star3.isHighlighted = true
                star4.isHighlighted = true
                star5.isHighlighted = true
            }
        }
        if let url = URL.init(string: String.init(format: RATE_APP_URL_FORMAT, ITUNES_APP_ID)) {
            UIApplication.shared.open(url)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.configuration.appRated = true;
            }
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        var message = ACLocalizedString("share_mail_body_text", nil) + "\n"
        message += ACLocalizedString("share_mail_body_subtext", nil) + "\n"
        message += String(format: SHARE_APP_URL_FORMAT, ITUNES_APP_ID)
        
        var items = [message] as [Any]
        if let image =  UIImage(named: "share-logo") {
            items.append(image)
        }
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityController.modalPresentationStyle = .popover
        activityController.excludedActivityTypes = [.saveToCameraRoll]
        
        present(activityController, animated: true, completion: nil)
        
        activityController.popoverPresentationController?.sourceView = shareView
        activityController.popoverPresentationController?.sourceRect = shareView.bounds
    }
    
    @IBAction func updateFiltersAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name.ShowStatusView, object: self)
        
        viewModel?.updateFilters(start: { [weak self] in
            self?.updateStarted()
            self?.filtersVersionLabel.text = ACLocalizedString("update_filter_start_message", nil)
        }, finish: { [weak self] (message) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.filtersVersionLabel.text = message
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                self?.setFiltersTime()
                self?.updateEnded()
            })
        }, error: { [weak self] (message) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.filtersVersionLabel.text = message
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                self?.setFiltersTime()
                self?.updateEnded()
            })
        })
    }
    
    // MARK: - private methods
    private func updateStarted(){
        self.updateFiltersGestureRecognizer.isEnabled = false
        refreshIcon.rotateImage(isNedeed: true)
    }
    
    private func updateEnded(){
        self.updateFiltersGestureRecognizer.isEnabled = true
        refreshIcon.rotateImage(isNedeed: false)
        
        NotificationCenter.default.post(name: NSNotification.Name.HideStatusView, object: self)
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            
            func showProIfNeedeed(){
                sSelf.setFiltersTime()
                if sSelf.configuration.proStatus {
                    sSelf.getProView.isHidden = true
                    sSelf.manImage.isHidden = true
                    sSelf.getProHeight.constant = 0
                }
                else {
                    UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                        sSelf.getProView.isHidden = false
                        sSelf.manImage.isHidden = false
                    }, completion: { (success) in
                        sSelf.getProHeight.constant = 93
                    })
                }
            }
            
            let optionalEnabled = sSelf.configuration.contentBlockerEnabled
            
            sSelf.tutorialVideoView.isHidden = true
            sSelf.adguardManView.isHidden = true
            sSelf.rateView.isHidden = true
            sSelf.roundArrow.isHidden = true
            sSelf.shareView.isHidden = true
            
            guard let enabled = optionalEnabled else {
                showProIfNeedeed()
                return
            }
            
            var allEnabled = true
            var someEnabled = false
            
            for d in enabled {
                allEnabled = allEnabled && d.value
                someEnabled = someEnabled || d.value
            }
            
            if(!allEnabled || (someEnabled && !allEnabled)) {
                sSelf.tutorialVideoView.isHidden = false
                sSelf.roundArrow.isHidden = false
                sSelf.refreshIcon.isHidden = false
            }
            else if(sSelf.configuration.appRated) {
                sSelf.adguardManView.isHidden = false
                sSelf.shareView.isHidden = false
                sSelf.refreshIcon.isHidden = false
            }
            else {
                sSelf.rateView.isHidden = false
                sSelf.shareView.isHidden = false
                sSelf.refreshIcon.isHidden = false
            }
            
            switch (allEnabled, someEnabled) {
            case (false, true):
                sSelf.enabledLabel.text = ACLocalizedString("protection_partly_enabled_caption", nil)
                sSelf.enabledLabel.textColor = sSelf.partlyEnabledColor
            case (false, false):
                sSelf.enabledLabel.text = ACLocalizedString("protection_disabled_caption", nil)
                sSelf.enabledLabel.textColor = sSelf.disabledColor
            case (true, true):
                sSelf.enabledLabel.text = ACLocalizedString("protection_enabled_caption", nil)
                sSelf.enabledLabel.textColor = sSelf.enabledColor
            default:
                break
            }
            
            sSelf.headerImage.isHighlighted = !allEnabled
            
            sSelf.vikingImage.image = UIImage(named: sSelf.configuration.proStatus ? "man" : "adguard-man")
            
            showProIfNeedeed()
        }
    }
    
    private func setFiltersTime() {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let sSelf = self else { return }
            guard let filtersDate = sSelf.antibanner.filtersLastUpdateTime() else { return }
            DispatchQueue.main.async {
                let dateString = filtersDate.formatedString() ?? ""
                sSelf.filtersVersionLabel.text = String(format: ACLocalizedString("filter_date_format", nil), dateString)
            }
        }
    }
    
    private func updateTheme() {
        headerImage.highlightedImage = configuration.darkTheme ? darkThemeLogoImage : lightThemeLogoImage
        
        view.backgroundColor = theme.backgroundColor
        navigationController?.view.backgroundColor = theme.backgroundColor
        theme.setupImage(headerImage)
        theme.setupLabels(themableLabels)
        theme.setupNavigationBar(navigationController?.navigationBar)
        
        getProView.backgroundColor = theme.invertedBackgroundColor
        theme.setupLabelInverted(premiumLabel)
    }
}
