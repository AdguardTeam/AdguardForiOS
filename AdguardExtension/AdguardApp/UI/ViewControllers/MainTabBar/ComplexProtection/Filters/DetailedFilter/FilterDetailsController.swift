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
import AdGuardSDK

protocol FilterDetailsControllerAnimationDelegate {
    func scrolledToBottom()
    func isScrolling()
}

protocol FilterDetailsControllerTableViewDelegate {
    func tableViewWasLoaded(with contentSizeHeight: CGFloat)
}

class FilterDetailsController : UIViewController, FilterDetailsControllerAnimationDelegate, FilterDetailsControllerTableViewDelegate, EditFilterDelegate {
    
    var filter: SafariFilterProtocol!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: BottomShadowView!
    
    private let embedTableSegue = "embedTableSegue"
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let dnsFiltersService:DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResources = ServiceLocator.shared.getService()!
    
    weak var delegate: DnsFiltersControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = filter.name
        
        setupButtons()
        updateTheme()
        setupBackItem()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == embedTableSegue {
            guard let tableController = segue.destination as? FilterDetailsTableCotroller else { return }
            tableController.animationDelegate = self
            tableController.tableViewDelegate = self
            tableController.delegate = delegate
            tableController.filter = filter
        }
    }
    
    // MARK: - Private methods
    
    private func setupButtons(){
        var buttons: [BottomShadowButton] = []
        
        if filter.group.groupId == SafariGroup.GroupType.custom.rawValue {
            let editButton = BottomShadowButton()
            editButton.title = String.localizedString("common_edit").uppercased()
            editButton.titleColor = nil
            editButton.action = {[weak self] in
                guard let self = self else { return }
                if let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterDetailsController") as? NewCustomFilterDetailsController {
                    let model: NewCustomFilterDetailsControllerInterface = NewCustomFilterDetailsControllerModel(name: self.filter.name, rulesCount: self.filter.rulesCount, homepage: self.filter.homePage)
                    
                    controller.editDelegate = self
                    controller.model = model
                    controller.controllerModeType = .editingFilter
                    self.present(controller, animated: true, completion: nil)
                }
            }
            buttons.append(editButton)
        }
        
        if filter.group.groupId == SafariGroup.GroupType.custom.rawValue {
            let deleteButton = BottomShadowButton()
            deleteButton.title = String.localizedString("common_delete").uppercased()
            deleteButton.titleColor = UIColor(hexString: "#df3812")
            deleteButton.action = {[weak self] in
                self?.showAlert(deleteButton)
            }
            buttons.append(deleteButton)
        }
        
        shadowView.buttons = buttons
    }
    
    private func showAlert(_ sender: UIButton){
        let alert = UIAlertController(title: String.localizedString("delete_filter_title"), message: String.localizedString("delete_filter_message"), preferredStyle: .deviceAlertStyle)
        
        let yesAction = UIAlertAction(title: String.localizedString("common_action_yes"), style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            
            if let customFilter = self.filter {
                self.safariProtection.deleteCustomFilter(withId: customFilter.filterId) { _ in
                    // todo: proces error
                }
            }
            
            if let dnsFilter = self.filter as? DnsFilter {
                self.dnsFiltersService.deleteFilter(dnsFilter) { [weak self] in
                    self?.delegate?.filtersStateWasChanged()
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    /**
     We use different image and method, because the title is glitching while view controller is beeing popped up
     */
    private func setupBackItem(){
        let imgBackArrow = UIImage(named: "arrow_back") ?? UIImage()
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    // MARK: - FilterDetailsControllerAnimationDelegate
    
    func scrolledToBottom() {
        shadowView.animateHidingOfShadow()
    }
    
    func isScrolling() {
        shadowView.animateAppearingOfShadow()
    }
    
    func tableViewWasLoaded(with contentSizeHeight: CGFloat) {
        if containerView.frame.height <= contentSizeHeight {
            shadowView.animateAppearingOfShadow()
        }
    }
    
    // MARK: - EditFilterDelegate
    
    func renameFilter(newName: String) {
        title = newName
        if let safariFilter = filter {
            // todo: catch error
            try? safariProtection.renameCustomFilter(withId: safariFilter.filterId, to: newName)
        }
    }
}

class FilterDetailsTableCotroller : UITableViewController {
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet var separators: [UIView]!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var versionLabel: ThemableLabel!
    @IBOutlet weak var updatedLabel: ThemableLabel!
    @IBOutlet weak var rulesCountLabel: ThemableLabel!
    @IBOutlet weak var websiteLabel: ThemableLabel!
    @IBOutlet weak var subscriptionURLLabel: ThemableLabel!
    @IBOutlet weak var tagsView: FilterTagsView!
    @IBOutlet weak var enabledLabel: ThemableLabel!
    
    var filter: SafariFilterProtocol!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService:DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResources = ServiceLocator.shared.getService()!
    private let safariProtection: SafariProtectionProtocol = ServiceLocator.shared.getService()!
    
    var animationDelegate: FilterDetailsControllerAnimationDelegate?
    var tableViewDelegate: FilterDetailsControllerTableViewDelegate?
    weak var delegate: DnsFiltersControllerDelegate?
    
    private let zeroVersion = "0.0.0.0"
    
    // MARK: - constants
    
    // rows
    private enum Row: Int {
        
    case enabled = 0,
        description,
        version,
        updated,
        rulesCount,
        website,
        subscriptionURL,
        tags
    }
    
    // MARK: view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabledSwitch.isOn = filter.isEnabled
        enabledLabel.text = filter.isEnabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        descriptionLabel.text = filter.description
        versionLabel.text = filter.version == zeroVersion ? nil : filter.version
        updatedLabel.text = filter.lastUpdateDate?.formatedString()
        rulesCountLabel.text = "\(filter.rulesCount ?? 0)"
        
        tagsView.highlightIsOn = false
        
        tagsView.filter = filter
        
        updateTheme()
        setupBackButton()
    }
    
    override func viewDidLayoutSubviews() {
        tableViewDelegate?.tableViewWasLoaded(with: tableView.contentSize.height)
        tableViewDelegate = nil
    }
    
    // MARK: - table view delegate and datasource methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let calculatedHeight = super.tableView(tableView, heightForRowAt: indexPath)
        
        guard let row = Row(rawValue: indexPath.row) else {
            assertionFailure("unexpected index")
            return calculatedHeight
        }
        
        switch row {
        case .enabled:
            return calculatedHeight
        
        case .description:
            return filter.description == nil || filter.description?.count == 0 ? 0.0 : calculatedHeight
            
        case .version:
            return (filter.version == nil || filter.version?.count == 0 || filter.version == zeroVersion) ? 0.0 : calculatedHeight
            
        case .updated:
            return filter.lastUpdateDate == nil ? 0.0 : calculatedHeight
            
        case .rulesCount:
            return filter.rulesCount == nil ? 0.0 : calculatedHeight
            
        case .website:
            return filter.homePage == nil || filter.homePage?.count == 0 ? 0.0 : calculatedHeight
            
        case .subscriptionURL:
            guard filter.group.groupId == SafariGroup.GroupType.custom.rawValue else { return 0 }
            return calculatedHeight
            
        case .tags:
            let tagsCount = filter.tags.count + filter.languages.count
            return tagsCount == 0 ? 0.0 : calculatedHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = Row(rawValue: indexPath.row) else { return }
        if row == .website {
            if let url = URL(string: filter.homePage ?? "") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        if row == .subscriptionURL {
            if let url = URL(string: filter.filterDownloadPage ?? "") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if maximumOffset - contentOffset < 5.0 {
            animationDelegate?.scrolledToBottom()
        } else {
            animationDelegate?.isScrolling()
        }
    }
    
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        
        safariProtection.setFilter(withId: filter.filterId, filter.group.groupId, enabled: sender.isOn) { error in
            // todo: process error
        }

        // todo: change it when dnsProtection will be implemented
//        if let dnsFilter = filter as? DnsFilter {
//            dnsFiltersService.setFilter(filterId: dnsFilter.id, enabled: sender.isOn)
//        }
        enabledLabel.text = filter.isEnabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        delegate?.filtersStateWasChanged()
    }
}

extension FilterDetailsController: ThemableProtocol {
    func updateTheme () {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        shadowView.updateTheme()
    }
}

extension FilterDetailsTableCotroller: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        theme.setupSeparators(separators)
        theme.setupSwitch(enabledSwitch)
        
        if let homepage = filter.homePage {
            let homepage = NSAttributedString(string: homepage, attributes:
                                                [.foregroundColor: theme.grayTextColor,
                                                 .underlineStyle: NSUnderlineStyle.single.rawValue])
            websiteLabel.attributedText = homepage
        }
        
        if let subscriptionUrl = filter.filterDownloadPage {
            let subscriptionUrl = NSAttributedString(string: subscriptionUrl, attributes:
                                                        [.foregroundColor: theme.grayTextColor,
                                                         .underlineStyle: NSUnderlineStyle.single.rawValue])
            subscriptionURLLabel.attributedText = subscriptionUrl
        }
    }
}
