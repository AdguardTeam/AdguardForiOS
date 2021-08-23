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
    
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var upgradeButton: RoundRectButton!
    @IBOutlet weak var restoreButton: RoundRectButton!
    @IBOutlet weak var trialDescriptionLabel: ThemableLabel!
    @IBOutlet weak var periodButton: RoundRectButton!
    @IBOutlet weak var purchaseDescriptionTextView: UITextView!
    @IBOutlet weak var subscribedView: UIView!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var logoImage: ThemeableImageView!
    
    @IBOutlet weak var notPurchasedLogoCell: UITableViewCell!
    @IBOutlet weak var purchasedLogoCell: UITableViewCell!
    @IBOutlet weak var purchaseCell: UITableViewCell!
    @IBOutlet weak var descriptionCell: UITableViewCell!
    
    @IBOutlet weak var periodLabel: ThemableLabel!
    @IBOutlet weak var priceLabel: ThemableLabel!
    
    // MARK: - feature icons
    
    @IBOutlet weak var trackingProtectionImageView: UIImageView!
    @IBOutlet weak var securityFiltersImageView: UIImageView!
    @IBOutlet weak var customFiltersImageView: UIImageView!
    @IBOutlet weak var premiumImageView: UIImageView!
    
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationServiceProtocol = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseServiceProtocol = ServiceLocator.shared.getService()!
    private let productInfo: ADProductInfoProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - private fields
    
    var proStatusObserver: NotificationToken?
    
    private let notPurchasedLogoRow = 0
    private let purchasedLogoRow = 1
    private let featuresRow = 2
    private let purchaseRow = 3
    private let descriptionRow = 4
    
    var selectedProduct: Product?
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        selectedProduct = purchaseService.standardProduct
              
        setPrice()

        proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
            self?.setPrice()
        }
        
        upgradeButton.makeTitleTextUppercased()
        upgradeButton.applyStandardGreenStyle()
        titleLabel.text = titleLabel.text?.uppercased()
        
        periodButton.accessibilityLabel = String.localizedString("choose_sub_voiceover")
        
        trackingProtectionImageView.image = UIImage(named: "ic_adguard")
        securityFiltersImageView.image = UIImage(named: "ic_encryption")
        customFiltersImageView.image = UIImage(named: "custom")
        premiumImageView.image = UIImage(named: "subscribed-icon")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        periodButton.layer.cornerRadius = periodButton.frame.height / 2
    }
    
    // MARK: - table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // hide "you are subscribed" row
        subscribedView.isHidden = !configuration.proStatus
        
        // hide purchase row for premium users
        if indexPath.row == purchaseRow && configuration.proStatus {
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
        
        let lifetime = selectedProduct?.type == .some(.lifetime)
        
        trialDescriptionLabel.text = getTrialDescriptionLabelString(product: selectedProduct)
        periodLabel.text = getPeriodString(product: selectedProduct)
        priceLabel.text = selectedProduct?.price
        upgradeButton.isEnabled = selectedProduct != nil
        
        setPurchaseDescription()
        
        upgradeButton.setTitle(ACLocalizedString(lifetime ? "upgrade_lifetime_button_title" : "upgrade_button_title", nil), for: .normal)
        upgradeButton.makeTitleTextUppercased()
        
        setCellsVisibility()
        
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func upgradeAction(_ sender: Any) {
        enablePurchaseButtons(false)
        
        if selectedProduct != nil {
            purchaseService.requestPurchase(productId: selectedProduct!.productId)
        }
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        enablePurchaseButtons(false)
        purchaseService.requestRestore()
    }
    
    @IBAction func choosePeriodAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .deviceAlertStyle)
        
        for product in purchaseService.products {
            let title = "\(getPeriodString(product: product)) - \(product.price)"
            let action = UIAlertAction(title: title, style: .default) { [weak self] (_) in
                self?.selectedProduct = product
                self?.setPrice()
            }
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: ACLocalizedString("common_action_cancel", nil), style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: - private methods
    
    private func setPurchaseDescription() {
        
        let stringKey = selectedProduct?.type == .some(.lifetime) ? "lifetime_purchase_description_format" : "purchase_description_format"
        let format = ACLocalizedString(stringKey, nil)
        let privacy = UIApplication.shared.adguardUrl(action: "privacy", from: "license", buildVersion: productInfo.buildVersion())
        let eula = UIApplication.shared.adguardUrl(action: "eula", from: "license", buildVersion: productInfo.buildVersion())
        
        let htmlString = String(format: format, privacy, eula)
        guard let data = htmlString.data(using: .utf8) else { return }
        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding:NSNumber(value:String.Encoding.utf8.rawValue)],
            documentAttributes: nil) else { return }
        
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: theme.lightGrayTextColor], range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttributes([NSAttributedString.Key.font: purchaseDescriptionTextView.font!], range: NSRange(location: 0, length: attributedString.length))
        
        purchaseDescriptionTextView.attributedText = attributedString
    }
    
    private func setCellsVisibility() {
        let pro = configuration.proStatus
        notPurchasedLogoCell.isHidden = pro
        purchasedLogoCell.isHidden = !pro
        purchaseCell.isHidden = pro
        descriptionCell.isHidden = pro
    }
    
    private func getTrialDescriptionLabelString(product: Product?) -> String {
        if product?.type == .some(.lifetime) {
            return ""
        }
        
        guard let period = product?.trialPeriod else {return ""}
        var formatString : String = ""
        
        switch period.unit {
        case .day:
            formatString = ACLocalizedString("trial_description_days", nil)
        case .week:
            if period.numberOfUnits == 1 {
                formatString = ACLocalizedString("trial_description_days", nil)
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = ACLocalizedString("trial_description_weeks", nil)
        case .month:
            formatString = ACLocalizedString("trial_description_months", nil)
        case .year:
            formatString = ACLocalizedString("trial_description_years", nil)
        }
        
        let resultString : String = String.localizedStringWithFormat(formatString, period.numberOfUnits)
        
        return resultString
    }
    
    private func getPeriodString(product: Product?) -> String {
        
        if product == nil {
            let formatString = ACLocalizedString("trial_period_years", nil)
            let resultString : String = String.localizedStringWithFormat(formatString, 1)
            return resultString
        }
        
        if product!.type == .lifetime {
            return ACLocalizedString("permanent_subscription_title", nil)
        }
        
        guard let period = product?.period else { return "" }
        
        var formatString : String = ""
        
        switch period.unit {
        case .day:
            formatString = ACLocalizedString("trial_period_days", nil)
        case .week:
            if period.numberOfUnits == 1 {
                formatString = ACLocalizedString("trial_period_days", nil)
                return String.localizedStringWithFormat(formatString, 7)
            }
            formatString = ACLocalizedString("trial_period_weeks", nil)
        case .month:
            formatString = ACLocalizedString("trial_period_months", nil)
        case .year:
            formatString = ACLocalizedString("trial_period_years", nil)
        }
        
        let resultString : String = String.localizedStringWithFormat(formatString, period.numberOfUnits)
        
        return resultString
    }
}

extension GetProTableController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.setPurchaseDescription()
            self.tableView.reloadData()
        }
        theme.setupLabels(themableLabels)
        theme.setupImage(logoImage)
    }
}
