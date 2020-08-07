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

class DnsRequestDetailsController: UITableViewController {

    // MARK: - public fields
    var logRecord: DnsLogRecordExtended? {
        didSet{
            createCellModels()
        }
    }
    var shadowView: BottomShadowView? = nil
    var containerController: DnsContainerController? = nil
    
    // MARK: - private fields
    private var sectionModels: [Int : [Int : LogCellModelProtocol?]] = [:]
    
    private let webPage = "https://whotracks.me"
    
    private let requestDetailsCellId = "RequestDetailsCellId"
    
    // MARK: - Notifications
    private var notificationToken: NotificationToken?
    private var configurationToken: NSKeyValueObservation?
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - Sections & Rows
    
    private var generalSection: Int?
    private var domainCell: IndexPath?
    private var statusCell: IndexPath?
    private var elapsedCell: IndexPath?
    private var timeCell: IndexPath?
    private var serverCell: IndexPath?
    private var sizeCell: IndexPath?
    private var matchedFiltersCell: IndexPath?
    private var matchedRulesCell: IndexPath?
    
    private var trackerDetailsSection: Int?
    private var categoryCell: IndexPath?
    private var nameCell: IndexPath?
    private var websiteCell: IndexPath?
    
    private var dnsSection: Int?
    private var typeCell: IndexPath?
    private var dnsStatusCell: IndexPath?
    private var dnsUpstreamCell: IndexPath?
    private var dnsAnswerCell: IndexPath?
    private var originalAnswerCell: IndexPath?
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        configurationToken = configuration.observe(\.advancedMode) {[weak self] (_, _) in
            guard let self = self else { return }
            self.createCellModels()
            self.tableView.reloadData()
        }
        
        updateTheme()
    }
    
    override func viewDidLayoutSubviews() {
        guard let container = containerController else { return }
        if container.containerView.frame.height <= tableView.contentSize.height {
            shadowView?.animateAppearingOfShadow()
        }
        containerController = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionModels.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionModel = sectionModels[section] else { return 0 }
        return sectionModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestDetailsCellId) as? RequestDetailsCell else { return UITableViewCell() }
        
        let model = getModel(for: indexPath)
        cell.model = model
        theme.setupTableCell(cell)
        
        guard let sectionModel = sectionModels[indexPath.section] else {
            cell.hideSeparator()
            return cell
        }
    
        if sectionModel.count == indexPath.row + 1 {
            cell.hideSeparator()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let record = logRecord else { return nil }
        
        var text = ""
        var needsButton = false
        
        switch section {
        case trackerDetailsSection:
            text = String.localizedString("tracker_details_header")
            needsButton = !record.category.isAdguardJson
        case generalSection:
            text = String.localizedString("general_header")
        case dnsSection:
            text = String.localizedString("dns_header")
        default:
            return nil
        }
        
        let view = createHeaderView(with: text.uppercased(), needsButton: needsButton)
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if indexPath == websiteCell {
            guard let cell = tableView.cellForRow(at: indexPath) as? RequestDetailsCell else { return }
            cell.openWebsite()
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CopiableCellInfo else { return }
        cell.showCopyLabel()
        UIPasteboard.general.string = cell.stringToCopy
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if maximumOffset - contentOffset < 5.0 {
            shadowView?.animateHidingOfShadow()
        } else {
            shadowView?.animateAppearingOfShadow()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func whoTracksMeInfo(_ sender: UIButton) {
        showAlert(sender)
    }
    
    // MARK: - Public function
    
    func updateStatusLabel(){
        guard let statusCell = statusCell, let generalSection = generalSection else { return }
        let statusCellModel = getStatusCellModel()
        sectionModels[generalSection]?[statusCell.row] = statusCellModel
        tableView.reloadRows(at: [statusCell], with: .fade)
    }
    
    // MARK: - Private methods
    
    private func updateTheme() {
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = self.theme.backgroundColor
            self.tableView.reloadData()
        }
    }
    
    /**
     Returns view model for specific cell
     */
    private func getModel(for indexPath: IndexPath) -> LogCellModelProtocol? {
        let section = indexPath.section
        let row = indexPath.row
        
        if let sectionModel = sectionModels[section] {
            if let cellModel = sectionModel[row] {
                return cellModel
            }
        }
        return nil
    }
    
    /**
     Creates header view for sections
     */
    private func createHeaderView(with text: String, needsButton: Bool) -> UIView{
        let tableWidth = tableView.frame.width
        let isBigScreen = traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
        
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: tableWidth, height: 52.0)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = theme.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = needsButton ? 60.0 : 24.0
        let labelFrame = CGRect(x: 24.0, y: 24.0, width: tableWidth - padding, height: isBigScreen ? 24.0 : 16.0)
        let label = ThemableLabel(frame: labelFrame)
        label.lightGreyText = true
        label.text = text
        label.numberOfLines = 0
        
        label.font = UIFont.systemFont(ofSize: isBigScreen ? 24.0 : 16.0, weight: .regular)
        
        view.addSubview(label)
        
        if needsButton {
            let image = UIImage(named: "question") ?? UIImage()
            let imageView = UIImageView(image: image)
            let imageViewFrame = CGRect(x: tableWidth - 48.0, y: label.frame.midY - 12.0, width: 24.0, height: 24.0)
            imageView.frame = imageViewFrame
            
            let buttonFrame = CGRect(x: imageViewFrame.midX - 24.0, y: imageViewFrame.midY - 24.0, width: 48.0, height: 48.0)
            let button = UIButton(frame: buttonFrame)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(whoTracksMeInfo(_:)), for: .touchUpInside)
            
            view.addSubview(imageView)
            view.addSubview(button)
        }
        
        theme.setupLabel(label)
        return view
    }

    /**
     Creates alert for additional info about whoTracksMe json
     */
    private func showAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: String.localizedString("whotrackme_message"), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_more"), style: .default, handler: {[weak self] (action) in
            guard let self = self else { return }
            guard let url = URL(string: self.webPage) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil))
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func getStatusCellModel() -> LogCellModel? {
        guard let record = logRecord else { return nil }
        
        let status = record.logRecord.status.title()
        let userStatus = record.logRecord.userStatus
        let stCopied = (userStatus == .none || userStatus == .modified) ? status : "\(status) (\(userStatus.title()))"
        let color = record.logRecord.status.textColor
        let statusFontWeight = UIFont.Weight.bold
        let statusTitle = String.localizedString("status_title")
        let statusModel = status.isEmpty ? nil : LogCellModel(copiedString: stCopied, title: statusTitle, info: stCopied, infoFontWeight: statusFontWeight, infoColor: color, theme: theme)
        return statusModel
    }
    
    /**
     Method to create a model for this VC
     */
    private func createCellModels(){
        trackerDetailsSection = nil
        generalSection = nil
        dnsSection = nil
        sectionModels.removeAll()
        
        guard let record = logRecord else { return }
        var sectionsArray: [Int] = []
        var sectionNumber: Int {
            let lastSection = sectionsArray.last ?? 0
            return sectionsArray.isEmpty ? 0 : (lastSection + 1)
        }
        
        /**
         General Section
         */
        var generalSectionModel: [Int : LogCellModelProtocol?] = [:]
        var generalRows = 0
        let generalSectionToAssign = sectionNumber
        
        // Domain model
        var domain = record.logRecord.domain
        domain = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        let domainTitle = String.localizedString("domain_title")
        let domainModelIsNil = domain.isEmpty
        let domainModel = domainModelIsNil ? nil : LogCellModel(copiedString: domain, title: domainTitle, info: domain, theme: theme)
        if !domainModelIsNil{
            generalSection = generalSectionToAssign
            domainCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[domainCell!.row] = domainModel
        }
        
        // Status model
        let statusModel = getStatusCellModel()
        let statusModelIsNil = statusModel == nil
        if !statusModelIsNil {
            generalSection = generalSectionToAssign
            statusCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[statusCell!.row] = statusModel
        }
        
        // Elapsed model
        let elapsed = record.logRecord.elapsed
        let elapsedTitle = String.localizedString("elapsed_title")
        let elapsedString = String(format: "%d ms", elapsed)
        let elapsedModel = LogCellModel(copiedString: elapsedString, title: elapsedTitle, info: elapsedString, theme: theme)
        if configuration.advancedMode {
            generalSection = generalSectionToAssign
            elapsedCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[elapsedCell!.row] = elapsedModel
        }
        
        // Time model
        let time = record.logRecord.time()
        let timeTitle = String.localizedString("time_title")
        let timeModelIsNil = time.isEmpty
        let timeModel = timeModelIsNil ? nil : LogCellModel(copiedString: time, title:timeTitle, info: time, theme: theme)
        if !timeModelIsNil {
            generalSection = generalSectionToAssign
            timeCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[timeCell!.row] = timeModel
        }
        
        // Server model
        let server = record.logRecord.server
        let serverTitle = String.localizedString("server_title")
        let serverModelIsNil = server.isEmpty
        let serverModel = serverModelIsNil ? nil : LogCellModel(copiedString: server, title: serverTitle, info: server, theme: theme)
        if !serverModelIsNil {
            generalSection = generalSectionToAssign
            serverCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[serverCell!.row] = serverModel
        }
        
        // Size model
        let bytesSent = record.logRecord.bytesSent
        let bytesReceived = record.logRecord.bytesReceived
        let bytesSentText = String(format: "%d B", bytesSent)
        let bytesReceivedText = String(format: "%d B", bytesReceived)
        let sizeTitle = String.localizedString("size_title")
        let size = String(format: "%d B / %d B", bytesReceived, bytesSent)
        let sizeModel = LogCellModel(isDataCell: true, copiedString: size, title: sizeTitle, bytesSent: bytesSentText, bytesReceived: bytesReceivedText, theme: theme)
        if configuration.advancedMode {
            generalSection = generalSectionToAssign
            sizeCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[sizeCell!.row] = sizeModel
        }
        
        
        // Matched filters model
        let matchedFilters = record.matchedFilters ?? ""
        let matchedFiltersTitle = String.localizedString("matched_filter_title")
        let matchedFiltersModelIsNil = matchedFilters.isEmpty
        let matchedFiltersModel = matchedFiltersModelIsNil ? nil : LogCellModel(copiedString: matchedFilters, title: matchedFiltersTitle, info: matchedFilters, theme: theme)
        if !matchedFiltersModelIsNil {
            generalSection = generalSectionToAssign
            matchedFiltersCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[matchedFiltersCell!.row] = matchedFiltersModel
        }
        
        // Matched rules model
        let matchedRules = record.logRecord.blockRules?.joined(separator: "\n") ?? ""
        let matchedRulesModelIsNil = matchedRules.isEmpty
        let matchedRulesTitle = String.localizedString("matched_rule_title")
        let matchedRulesModel = matchedRulesModelIsNil ? nil : LogCellModel(copiedString: matchedRules, title: matchedRulesTitle, info: matchedRules, theme: theme)
        generalSection = generalSectionToAssign
        if !matchedRulesModelIsNil {
            generalSection = generalSectionToAssign
            matchedRulesCell = IndexPath(row: generalRows, section: generalSection!)
            generalRows += 1
            generalSectionModel[matchedRulesCell!.row] = matchedRulesModel
        }
        
        if let generalSection = generalSection {
            sectionsArray.append(generalSection)
            sectionModels[generalSection] = generalSectionModel
        }
        
        /**
         Tracker Details Section
         */
        var trackerDetailsSectionModel: [Int : LogCellModelProtocol?] = [:]
        var trackerDetailsRows = 0
        let trackerSectionToAssign = sectionNumber
        
        // Category model
        let category = record.category.category ?? ""
        let categoryTitle = String.localizedString("category_title")
        let categoryModelIsNil = category.isEmpty
        let categoryModel = categoryModelIsNil ? nil : LogCellModel(copiedString: category, title: categoryTitle, info: category, theme: theme)
        if !categoryModelIsNil {
            trackerDetailsSection = trackerSectionToAssign
            categoryCell = IndexPath(row: trackerDetailsRows, section: trackerDetailsSection!)
            trackerDetailsRows += 1
            trackerDetailsSectionModel[categoryCell!.row] = categoryModel
        }
        
        // Name model
        let name = record.category.name ?? ""
        let nameTitle = String.localizedString("name_title")
        let nameFontWeight = UIFont.Weight.bold
        let nameModelIsNil = name.isEmpty
        let nameModel = nameModelIsNil ? nil : LogCellModel(copiedString: name, title: nameTitle, info: name, infoFontWeight: nameFontWeight, theme: theme)
        if !nameModelIsNil {
            trackerDetailsSection = trackerSectionToAssign
            nameCell = IndexPath(row: trackerDetailsRows, section: trackerDetailsSection!)
            trackerDetailsRows += 1
            trackerDetailsSectionModel[nameCell!.row] = nameModel
        }
        
        // Website model
        let website = record.category.url ?? ""
        let websiteTitle = String.localizedString("website_title")
        let color: UIColor = UIColor(hexString: "#4CA524")
        let websiteModelIsNil = website.isEmpty
        let websiteModel = websiteModelIsNil ? nil : LogCellModel(copiedString: website, title: websiteTitle, info: website, infoColor: color,  theme: theme)
        if !websiteModelIsNil {
            trackerDetailsSection = trackerSectionToAssign
            websiteCell = IndexPath(row: trackerDetailsRows, section: trackerDetailsSection!)
            trackerDetailsRows += 1
            trackerDetailsSectionModel[websiteCell!.row] = websiteModel
        }
        
        if let trackerDetailsSection = trackerDetailsSection {
            sectionsArray.append(trackerDetailsSection)
            sectionModels[trackerDetailsSection] = trackerDetailsSectionModel
        }

        
        /**
         DNS Section
        */
        var dnsSectionModel: [Int : LogCellModelProtocol?] = [:]
        var dnsRows = 0
        let dnsSectionToAssign = sectionNumber
        
        // Type model
        let type = record.logRecord.getTypeAndIp()
        let typeTitle = String.localizedString("type_title")
        let typeModelIsNil = type.isEmpty
        let typeModel = typeModelIsNil ? nil : LogCellModel(copiedString: type, title: typeTitle, info: type, theme: theme)
        if !typeModelIsNil && configuration.advancedMode {
            dnsSection = dnsSectionToAssign
            typeCell = IndexPath(row: dnsRows, section: dnsSection!)
            dnsRows += 1
            dnsSectionModel[typeCell!.row] = typeModel
        }
        
        // Dns status model
        let dnsStatus = record.logRecord.answerStatus ?? ""
        let dnsStatusTitle = String.localizedString("dns_status_title")
        let dnsStatusModelIsNil = dnsStatus.isEmpty
        let dnsStatusModel = dnsStatusModelIsNil ? nil : LogCellModel(copiedString: dnsStatus, title: dnsStatusTitle, info: dnsStatus, theme: theme)
        if !dnsStatusModelIsNil && configuration.advancedMode {
            dnsSection = dnsSectionToAssign
            dnsStatusCell = IndexPath(row: dnsRows, section: dnsSection!)
            dnsRows += 1
            dnsSectionModel[dnsStatusCell!.row] = dnsStatusModel
        }
        
        // Dns upstream model
        let dnsUpstream = record.logRecord.upstreamAddr ?? ""
        let dnsUpstreamTitle = String.localizedString("dns_upstream_title")
        let dnsUpstreamModelIsNil = dnsUpstream.isEmpty
        let dnsUpstreamModel = dnsUpstreamModelIsNil ? nil : LogCellModel(copiedString: dnsUpstream, title: dnsUpstreamTitle, info: dnsUpstream, theme: theme)
        if !dnsUpstreamModelIsNil && configuration.advancedMode {
            dnsSection = dnsSectionToAssign
            dnsUpstreamCell = IndexPath(row: dnsRows, section: dnsSection!)
            dnsRows += 1
            dnsSectionModel[dnsUpstreamCell!.row] = dnsUpstreamModel
        }
        
        // Dns answer model
        let dnsAnswer = record.logRecord.answer
        let emptyAnswer = String.localizedString("empty_dns_answer")
        let answerString = dnsAnswer.isEmpty ? emptyAnswer : dnsAnswer
        let dnsAnserTitle = String.localizedString("dns_answer_title")
        let dnsAnswerModel = LogCellModel(copiedString: answerString, title: dnsAnserTitle, info: answerString, theme: theme)
        if configuration.advancedMode {
            dnsSection = dnsSectionToAssign
            dnsAnswerCell = IndexPath(row: dnsRows, section: dnsSection!)
            dnsRows += 1
            dnsSectionModel[dnsAnswerCell!.row] = dnsAnswerModel
        }
        
        // Original answer model
        let originalAnswer = record.logRecord.originalAnswer ?? ""
        let originalAnswerTitle = String.localizedString("original_answer_title")
        let originalAnswerModelIsNil = originalAnswer.isEmpty
        let originalAnswerModel = originalAnswerModelIsNil ? nil : LogCellModel(copiedString: originalAnswer, title: originalAnswerTitle, info: originalAnswer, theme: theme)
        if !originalAnswerModelIsNil && configuration.advancedMode {
            dnsSection = dnsSectionToAssign
            originalAnswerCell = IndexPath(row: dnsRows, section: dnsSection!)
            dnsRows += 1
            dnsSectionModel[originalAnswerCell!.row] = originalAnswerModel
        }
        
        if let dnsSection = dnsSection {
            sectionModels[dnsSection] = dnsSectionModel
        }
    }
}

