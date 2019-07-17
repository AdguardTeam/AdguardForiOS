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

protocol GetProTableControllerDelegate  {
    
    func subscribeAction()
    func restorePurchasesAction()
}

class GetProTableController: UITableViewController {
    
    // MARK: - IB outlets
    
    @IBOutlet weak var upgradeButton: RoundRectButton!
    @IBOutlet weak var restoreButton: RoundRectButton!
    @IBOutlet weak var priceLabel: ThemableLabel!
    @IBOutlet weak var periodLabel: ThemableLabel!
    @IBOutlet weak var purchaseDescriptionTextView: UITextView!
    
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let purchaseService: PurchaseService = ServiceLocator.shared.getService()!
    
    // MARK: - private fields
    
    var delegate: GetProTableControllerDelegate?
    
    var proObservation: NSKeyValueObservation?
    
    private let securityRow = 0
    private let privacyRow = 1
    private let customRow = 2
    private let subscribedRow = 3
    private let purchaseRow = 4
    
    // MARK: - View controller livecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
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
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - public methods
    
    func enablePurchaseButtons(_ enable: Bool) {
        upgradeButton.isEnabled = enable
        restoreButton.isEnabled = enable
    }
    
    func setPrice() {
        
        if purchaseService.ready {
            priceLabel.text = purchaseService.price
            periodLabel.text = purchaseService.period
            upgradeButton.isEnabled = true
        }
        else {
            priceLabel.text = ""
            periodLabel.text = ""
            upgradeButton.isEnabled = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func upgradeAction(_ sender: Any) {
        enablePurchaseButtons(false)
        purchaseService.requestPurchase()
    }
    
    @IBAction func restoreAction(_ sender: Any) {
        enablePurchaseButtons(false)
        purchaseService.requestRestore()
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
