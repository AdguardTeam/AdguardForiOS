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

protocol FilterDetailsControllerAnimationDelegate {
    func scrolledToBottom()
    func isScrolling()
}

protocol FilterDetailsControllerTableViewDelegate {
    func tableViewWasLoaded(with contentSizeHeight: CGFloat)
}

class FilterDetailsController : UIViewController, FilterDetailsControllerAnimationDelegate, FilterDetailsControllerTableViewDelegate {
    
    var filter: FilterDetailedInterface!
    var isCustom: Bool!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    
    private let embedTableSegue = "embedTableSegue"
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService:DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    
    private var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = filter.name
        deleteButtonHeightConstraint.constant = isCustom ? 60 : 0
        
        deleteButton.isHidden = !filter.removable
        
        updateTheme()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        setupBackItem()
        deleteButton.makeTitleTextUppercased()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == embedTableSegue {
            guard let tableController = segue.destination as? FilterDetailsTableCotroller else { return }
            tableController.animationDelegate = self
            tableController.tableViewDelegate = self
            tableController.filter = filter
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        showAlert(sender)
    }
    
    private func updateTheme () {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        deleteButton.backgroundColor = theme.backgroundColor
        guard let deleteButtonShadowAlpha = deleteButton.layer.shadowColor?.alpha else { return }
        deleteButton.layer.shadowColor = configuration.darkTheme ? UIColor.white.withAlphaComponent(deleteButtonShadowAlpha).cgColor : UIColor.black.withAlphaComponent(deleteButtonShadowAlpha).cgColor
    }
    
    private func setupDeleteButton(){
        let color: UIColor = configuration.darkTheme ? .white : .black
        deleteButton.layer.shadowColor = color.withAlphaComponent(0.25).cgColor
        deleteButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        deleteButton.layer.shadowOpacity = 1.0
        deleteButton.layer.shadowRadius = 10.0
        deleteButton.layer.masksToBounds = false
    }
    
    private func animateHidingOfShadow(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            DispatchQueue.main.async {
                guard let color = self?.deleteButton.layer.shadowColor else { return }
                self?.deleteButton.layer.shadowColor = color.copy(alpha: 0.0)
            }
        }
    }
    
    private func animateAppearingOfShadow(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            DispatchQueue.main.async {
                guard let color = self?.deleteButton.layer.shadowColor else { return }
                self?.deleteButton.layer.shadowColor = color.copy(alpha: 0.5)
            }
        }
    }
    
    private func showAlert(_ sender: UIButton){
        let alert = UIAlertController(title: String.localizedString("delete_filter_title"), message: String.localizedString("delete_filter_message"), preferredStyle: .actionSheet)
        
        let yesAction = UIAlertAction(title: String.localizedString("common_action_yes"), style: .destructive) {[weak self] _ in
            guard let self = self else { return }
            alert.dismiss(animated: true, completion: nil)
            
            if let customFilter = self.filter as? Filter {
                self.filtersService.deleteCustomFilter(customFilter)
            }
            
            if let dnsFilter = self.filter as? DnsFilter {
                self.dnsFiltersService.deleteFilter(dnsFilter)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(yesAction)
        
        let cancelAction = UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
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
        animateHidingOfShadow()
    }
    
    func isScrolling() {
        animateAppearingOfShadow()
    }
    
    func tableViewWasLoaded(with contentSizeHeight: CGFloat) {
        if containerView.frame.height <= contentSizeHeight {
            setupDeleteButton()
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
    @IBOutlet weak var tagsView: FilterTagsView!
    @IBOutlet weak var enabledLabel: ThemableLabel!
    
    var filter: FilterDetailedInterface!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let filtersService: FiltersServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsFiltersService:DnsFiltersServiceProtocol = ServiceLocator.shared.getService()!
    
    var animationDelegate: FilterDetailsControllerAnimationDelegate?
    var tableViewDelegate: FilterDetailsControllerTableViewDelegate?
    
    private var notificationToken: NotificationToken?
    
    private let zeroVersion = "0.0.0.0"
    
    // MARK: - constants
    
    // rows
    enum Row: Int {
        
    case enabled = 0,
        description,
        version,
        updated,
        rulesCount,
        website,
        tags
    }
    
    // MARK: view controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabledSwitch.isOn = filter.enabled
        enabledLabel.text = filter.enabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
        descriptionLabel.text = filter.desc
        versionLabel.text = filter.version == zeroVersion ? nil : filter.version
        updatedLabel.text = filter.updateDate?.formatedString()
        rulesCountLabel.text = "\(filter.rulesCount ?? 0)"
        
        tagsView.highlightIsOn = false
        
        if let safariFilter = filter as? Filter {
            tagsView.filter = safariFilter
        } else {
            tagsView.filter = nil
        }
        
        updateTheme()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
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
            return filter.desc == nil || filter.desc?.count == 0 ? 0.0 : calculatedHeight
            
        case .version:
            return (filter.version == nil || filter.version?.count == 0 || filter.version == zeroVersion) ? 0.0 : calculatedHeight
            
        case .updated:
            return filter.updateDate == nil ? 0.0 : calculatedHeight
            
        case .rulesCount:
            return filter.rulesCount == nil ? 0.0 : calculatedHeight
            
        case .website:
            return filter.homepage == nil || filter.homepage?.count == 0 ? 0.0 : calculatedHeight
            
        case .tags:
            if let safariFilter = filter as? Filter {
                let tagsCount = (safariFilter.tags?.count ?? 0) + (safariFilter.langs?.count ?? 0)
                return tagsCount == 0 ? 0.0 : calculatedHeight
            }
            return 0.0
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
            if let url = URL(string: filter.homepage ?? "") {
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
        if let safariFilter = filter as? Filter {
            filtersService.setFilter(safariFilter, enabled: sender.isOn)
        }
        if let dnsFilter = filter as? DnsFilter {
            dnsFiltersService.setFilter(filterId: dnsFilter.id, enabled: sender.isOn)
        }
        enabledLabel.text = filter.enabled ? ACLocalizedString("on_state", nil) : ACLocalizedString("off_state", nil)
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
        theme.setupSeparators(separators)
        theme.setupSwitch(enabledSwitch)
        
        if filter.homepage != nil {
            let homepage = NSAttributedString(string: filter.homepage!, attributes:
                [.foregroundColor: theme.grayTextColor,
                 .underlineStyle: NSUnderlineStyle.single.rawValue])
            websiteLabel.attributedText = homepage
        }
    }
}
