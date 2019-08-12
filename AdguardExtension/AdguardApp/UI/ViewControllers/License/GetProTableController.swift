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
    @IBOutlet weak var periodButton: RoundRectButton!
    @IBOutlet weak var purchaseDescriptionTextView: UITextView!
    @IBOutlet weak var trialLabel: ThemableLabel!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var logoImage: ThemeableImageView!
    
    @IBOutlet weak var notPurchasedLogoCell: UITableViewCell!
    @IBOutlet weak var purchasedLogoCell: UITableViewCell!
    @IBOutlet weak var purchaseCell: UITableViewCell!
    @IBOutlet weak var trialCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    @IBOutlet weak var periodLabel: ThemableLabel!
    @IBOutlet weak var priceLabel: ThemableLabel!
    @IBOutlet weak var startTrialTitleLable: ThemableLabel!
    @IBOutlet weak var startTrialDescriptionLabel: ThemableLabel!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    
    // MARK: - private fields
    
    var proObservation: NSKeyValueObservation?
    
    private let notPurchasedLogoRow = 0
    private let purchasedLogoRow = 1
    private let purchaseRow = 2
    private let securityRow = 3
    private let privacyRow = 4
    private let customRow = 5
    private let subscribedRow = 6
    private let trialRow = 7
    private let descriptionRow = 8
    
    var permanentSubscription = false
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        updateTheme()
        
        upgradeButton.setTitle(ACLocalizedString("upgrade_button_title", nil), for: .normal)
        
        setPrice()
        setPurchaseDescription()
        setCellsVisibility()
        
        let trialDescriptionFormat = ACLocalizedString("trial_description_format", nil)
        let trialDescriptionText = String(format: trialDescriptionFormat, purchaseService.subscriptionPrice, purchaseService.subscriptionPeriod)
        startTrialDescriptionLabel.text = trialDescriptionText
        
        proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            DispatchQueue.main.async {
                self?.updateTheme()
                self?.setCellsVisibility()
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
        
        // hide notPurchased logo for premium users
        if indexPath.row == notPurchasedLogoRow && configuration.proStatus {
            return 0
        }
        
        // hide Purchased logo for not a premium users
        if indexPath.row == purchasedLogoRow && !configuration.proStatus {
            return 0
        }
        
        // hide description for premium users
        if indexPath.row == descriptionRow && configuration.proStatus {
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
            trialLabel.text = String(format: ACLocalizedString("trial_format", nil), purchaseService.trialPeriod)
            
            if permanentSubscription {
                periodLabel.text = ACLocalizedString("permanent_subscription_title", nil)
                priceLabel.text = purchaseService.nonConsumablePrice
            }
            else {
                periodLabel.text = purchaseService.subscriptionPeriod
                priceLabel.text = purchaseService.subscriptionPrice
            }
            
            upgradeButton.isEnabled = true
        }
        else {
            trialLabel.text = ""
            upgradeButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func upgradeAction(_ sender: Any) {
        enablePurchaseButtons(false)
        
        if permanentSubscription {
            purchaseService.requestNonConsumablePurchase()
        }
        else {
            purchaseService.requestSubscriptionPurchase()
        }
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        enablePurchaseButtons(false)
        purchaseService.requestRestore()
    }
    
    @IBAction func choosePeriodAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let subsriptionTitle = "\(purchaseService.subscriptionPeriod) - \(purchaseService.subscriptionPrice)"
        let subscribeAction = UIAlertAction(title: subsriptionTitle , style: .default) { [weak self] (_) in
            self?.permanentSubscription = false
            self?.setPrice()
        }
            
        actionSheet.addAction(subscribeAction)
        
        let permanentTitle = "\(ACLocalizedString("permanent_subscription_title", nil)) - \(purchaseService.nonConsumablePrice)"
        let permanentAction = UIAlertAction(title: permanentTitle , style: .default) { [weak self] (_) in
            self?.permanentSubscription = true
            self?.setPrice()
        }
        
        actionSheet.addAction(permanentAction)
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = periodButton
        actionSheet.popoverPresentationController?.sourceRect = periodButton.bounds
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: - private methods
    
    private func updateTheme() {
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupLabels(themableLabels)
        setPurchaseDescription()
        theme.setupImage(logoImage)
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
    
    private func setCellsVisibility() {
        let pro = configuration.proStatus
        notPurchasedLogoCell.isHidden = pro
        purchasedLogoCell.isHidden = !pro
        trialCell.isHidden = pro
        purchaseCell.isHidden = pro
        descriptionCell.isHidden = pro
    }
}
