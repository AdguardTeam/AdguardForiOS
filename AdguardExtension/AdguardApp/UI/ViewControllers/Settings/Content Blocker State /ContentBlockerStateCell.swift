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

import UIKit

class ContentBlockerStateCell: UITableViewCell {
    
    var blockerState: ContentBlockerStateProtocol? {
        didSet {
            var name = ""
            guard let state = blockerState?.contentBlockerType else { return }
            switch  state{
            case .general:
                name = "AdGuard — General"
            case .privacy:
                name = "AdGuard — Privacy"
            case .socialWidgetsAndAnnoyances:
                name = "AdGuard — Social"
            case .other:
                name = "AdGuard — Other"
            case .custom:
                name = "AdGuard — Custom"
            case .security:
                name = "AdGuard — Security"
            default:
                name = ""
            }
            
            self.filterNameLabel.text = name
            self.filterListLabel.text = self.blockerState?.filters
            gotState()
        }
    }
    
    lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    private let disabledImage = UIImage(named: "attention")
    private let enabledImage = UIImage(named: "logocheck")
    private let updatingImage = UIImage(named: "loading")
    private let errorImage = UIImage(named: "errorAttention")

    @IBOutlet weak var stateImage: UIImageView!
    
    @IBOutlet weak var filterNameLabel: ThemableLabel!
    
    @IBOutlet weak var currentFilterStateLabel: ThemableLabel!
    
    @IBOutlet weak var filterListLabel: ThemableLabel!
    
    @IBOutlet weak var constraintToHide: NSLayoutConstraint!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var filterState: ContentBlockerState = .disabled
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func gotState(){
        guard let state = blockerState?.currentState else { return }
        switch  state{
        case .enabled:
            enabledUISetup()
        case .disabled:
            disabledUISetup()
        case .updating:
            updatingUISetup()
        case .overLimited:
            overLimitedUISetup()
        case .failedUpdating:
            failedUpdatingUISetup()
        }
    }
    
    private func enabledUISetup(){
        self.stateImage.image = enabledImage
        
        let numberOfRules = String.formatSringNumber(number: blockerState?.numberOfRules ?? 0)

        self.currentFilterStateLabel.text = String(format: ACLocalizedString("enabled_current_state_label", nil), numberOfRules)
        self.currentFilterStateLabel.textColor = theme.lightGrayTextColor
        
        hideFilterListIfNeeded()
        
        stateImage.rotateImage(isNedeed: false)
    }
    
    private func disabledUISetup(){
        self.stateImage.image = disabledImage
        
        self.currentFilterStateLabel.text = ACLocalizedString("disabled_current_state_label", nil)
        self.currentFilterStateLabel.textColor = theme.lightGrayTextColor
        
        hideFilterListIfNeeded()
        
        stateImage.rotateImage(isNedeed: false)
    }
    
    private func updatingUISetup(){
        self.stateImage.image = updatingImage

        self.currentFilterStateLabel.text = ACLocalizedString("update_current_state_label", nil)
        self.currentFilterStateLabel.textColor = theme.lightGrayTextColor
        
        hideFilterListIfNeeded()
        
        stateImage.rotateImage(isNedeed: true)
    }
    
    private func overLimitedUISetup(){
        self.stateImage.image = errorImage
        guard let rules = blockerState?.numberOfRules else { return }
        guard let overLimitRules = blockerState?.numberOfOverlimitedRules else { return }
        
        let firstString = String.formatSringNumber(number: rules + overLimitRules)
        let secondString = String.formatSringNumber(number: overLimitRules)
        
        self.currentFilterStateLabel.text = String(format: ACLocalizedString("over_limit_current_state_label", nil), firstString, secondString)
        self.currentFilterStateLabel.textColor = theme.errorRedColor
        
        hideFilterListIfNeeded()
        
        stateImage.rotateImage(isNedeed: false)
    }
    
    private func failedUpdatingUISetup(){
        self.stateImage.image = errorImage

        self.currentFilterStateLabel.text = ACLocalizedString("failed_updating_current_state_label", nil)
        self.currentFilterStateLabel.textColor = theme.errorRedColor
        
        hideFilterListIfNeeded()
        
        stateImage.rotateImage(isNedeed: false)
    }
    
    private func hideFilterListIfNeeded(){
        if blockerState?.filters.count == 0{
            self.filterListLabel.isHidden = true
            constraintToHide.constant = 0
        }else if blockerState?.currentState == .updating {
            self.filterListLabel.text = ""
            constraintToHide.constant = 0
            self.filterListLabel.isHidden = true
        }else {
            self.filterListLabel.isHidden = false
            constraintToHide.constant = 20
        }
    }
}
