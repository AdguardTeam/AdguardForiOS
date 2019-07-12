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

class GetProTableController: UITableViewController {
    
    // MARK: - IB outlets
    
    @IBOutlet weak var upgradeButton: RoundRectButton!
    @IBOutlet weak var restoreButton: RoundRectButton!
    @IBOutlet weak var purchaseDescriptionTextView: UITextView!
    @IBOutlet weak var trialLabel: ThemableLabel!
    
    @IBOutlet weak var subscriptionPeriodLabel: ThemableLabel!
    @IBOutlet weak var subscriptionPriceLabel: ThemableLabel!
    @IBOutlet weak var permanentPriceLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var permanentCheck: UIImageView!
    @IBOutlet weak var subscriptionCheck: UIImageView!
    
    @IBOutlet weak var separator: UIView!
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    
    // MARK: - private fields
    
    var proObservation: NSKeyValueObservation?
    
    private let securityRow = 0
    private let privacyRow = 1
    private let customRow = 2
    private let subscribedRow = 3
    private let trialRow = 4
    private let purchaseRow = 5
    
    private var subscriptionSelected: Bool {
        get {
            return subscriptionCheck.isHighlighted
        }
        set {
            subscriptionCheck.isHighlighted = newValue
            permanentCheck.isHighlighted = !newValue
        }
    }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscriptionSelected = true
        
        updateTheme()
        
        upgradeButton.setTitle(ACLocalizedString("upgrade_button_title", nil), for: .normal)
        
        setPrice()
        setPurchaseDescription()
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            DispatchQueue.main.async {
                self?.updateTheme()
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // hide "you are subscribed" row
        
        if indexPath.row == subscribedRow && !configuration.proStatus {
            return 0
        }
        
        // hide purchase row for premium users
        if indexPath.row == purchaseRow && configuration.proStatus {
            return 0
        }
        
        // hide trial row for premium users
        if indexPath.row == trialRow && configuration.proStatus {
            return 0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - public methods

    func enablePurchaseButtons(_ enable: Bool) {
        upgradeButton.isEnabled = enable
        restoreButton.isEnabled = enable
    }
    
    func setPrice() {
        
        if purchaseService.ready {
            subscriptionPriceLabel.text = purchaseService.subscriptionPrice
            subscriptionPeriodLabel.text = purchaseService.subscriptionPeriod
            trialLabel.text = String(format: ACLocalizedString("trial_format", nil), purchaseService.trialPeriod)
            permanentPriceLabel.text = purchaseService.nonConsumablePrice
            upgradeButton.isEnabled = true
        }
        else {
            subscriptionPriceLabel.text = ""
            subscriptionPeriodLabel.text = ""
            trialLabel.text = ""
            permanentPriceLabel.text = ""
            upgradeButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func upgradeAction(_ sender: Any) {
        enablePurchaseButtons(false)
        
        if subscriptionSelected {
            purchaseService.requestSubscriptionPurchase()
        }
        else {
            purchaseService.requestNonConsumablePurchase()
        }
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        enablePurchaseButtons(false)
        purchaseService.requestRestore()
    }
    
    @IBAction func selectSubscribeAction(_ sender: Any) {
        subscriptionSelected = true
    }
    
    @IBAction func selectPurchaseAction(_ sender: Any) {
        subscriptionSelected = false
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        setPurchaseDescription()
        theme.setupSeparator(separator)
    }
    
    private func setPurchaseDescription() {
        let format = ACLocalizedString("purchase_description_format", nil)
        let privacy = UIApplication.shared.adguardUrl(action: "privacy", from: "license")
        let eula = UIApplication.shared.adguardUrl(action: "eula", from: "license")
        
        let htmlString = String(format: format, privacy, eula)
        guard let data = htmlString.data(using: .unicode) else { return }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return }
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: theme.lightGrayTextColor], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange(location: 0, length: attributedString.length))
        
        purchaseDescriptionTextView.attributedText = attributedString
    }
    
    
}
