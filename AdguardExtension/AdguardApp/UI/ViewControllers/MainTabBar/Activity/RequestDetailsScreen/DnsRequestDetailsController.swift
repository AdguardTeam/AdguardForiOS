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
    
    private let alert = UIAlertController(title: "", message: String.localizedString("whotrackme_message"), preferredStyle: .alert)
    private let webPage = "https://whotracks.me"
    
    private let requestDetailsCellId = "RequestDetailsCellId"
    
    // MARK: - Notifications
    private var notificationToken: NotificationToken?
    private var configurationToken: NSKeyValueObservation?
    
    // MARK: - Services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - Sections & Rows
    private let trackerDetailsSection = 0
    private let categoryCell = IndexPath(row: 0, section: 0)
    private let nameCell = IndexPath(row: 1, section: 0)
    private let websiteCell = IndexPath(row: 2, section: 0)
    
    private let generalSection = 1
    private let domainCell = IndexPath(row: 0, section: 1)
    private let serverCell = IndexPath(row: 1, section: 1)
    private let statusCell = IndexPath(row: 2, section: 1)
    private let timeCell = IndexPath(row: 3, section: 1)
    private let sizeCell = IndexPath(row: 4, section: 1)
    private let elapsedCell = IndexPath(row: 5, section: 1)
    
    private let dnsSection = 2
    private let typeCell = IndexPath(row: 0, section: 2)
    private let dnsStatusCell = IndexPath(row: 1, section: 2)
    private let dnsUpstreamCell = IndexPath(row: 2, section: 2)
    private let dnsAnswerCell = IndexPath(row: 3, section: 2)
    private let matchedFiltersCell = IndexPath(row: 4, section: 2)
    private let matchedRulesCell = IndexPath(row: 5, section: 2)
    private let originalAnswerCell = IndexPath(row: 6, section: 2)
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        configurationToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        updateTheme()
        createAlert()
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
        
        if let sectionModel = sectionModels[indexPath.section] {
            if sectionModel.count - 1 == indexPath.row {
                cell.hideSeparator()
            } else {
                cell.showSeparator()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight = super.tableView(tableView, heightForRowAt: indexPath)
        
        if let cellModel = getModel(for: indexPath) {
            if !cellModel.isUserCell && !configuration.developerMode {
                return 0.0
            } else {
                return defaultHeight
            }
        }
        return 0.0
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
        if section == trackerDetailsSection {
            if let sectionModel = sectionModels[section] {
                let categoryModel = sectionModel[categoryCell.row]
                let nameModel = sectionModel[nameCell.row]
                let websiteModel = sectionModel[websiteCell.row]
                    
                if categoryModel == nil && nameModel == nil && websiteModel == nil{
                    return 0.0
                }
            }
        }
        
        if section == dnsSection && !configuration.developerMode {
            return 0.0
        }
        
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
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Public function
    
    func updateStatusLabel(){
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
        
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: tableWidth, height: 52.0)
        let view = UIView(frame: viewFrame)
        view.backgroundColor = theme.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = needsButton ? 60.0 : 24.0
        let labelFrame = CGRect(x: 24.0, y: 24.0, width: tableWidth - padding, height: 16.0)
        let label = ThemableLabel(frame: labelFrame)
        label.lightGreyText = true
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        
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
    private func createAlert() {
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_more"), style: .default, handler: {[weak self] (action) in
            guard let self = self else { return }
            guard let url = URL(string: self.webPage) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil))
    }
    
    private func getStatusCellModel() -> LogCellModel? {
        guard let record = logRecord else { return nil }
        
        let status = record.logRecord.status.title()
        let userStatus = record.logRecord.userStatus
        let stCopied = userStatus == .none ? status : "\(status)(\(userStatus.title()))"
        let color = record.logRecord.status.color()
        let statusFont = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        let statusTitle = String.localizedString("status_title")
        let statusModel = status.isEmpty ? nil : LogCellModel(copiedString: stCopied, title: statusTitle, info: stCopied, infoFont: statusFont, infoColor: color, theme: theme, configuration: configuration)
        return statusModel
    }
    
    /**
     Method to create a model for this VC
     */
    private func createCellModels(){
        guard let record = logRecord else { return }
        
        /**
         Tracker Details Section
         */
        var trackerDetailsSectionModel: [Int : LogCellModelProtocol?] = [:]
        
        // Category model
        let category = record.category.category ?? ""
        let categoryTitle = String.localizedString("category_title")
        let categoryModel = category.isEmpty ? nil : LogCellModel(copiedString: category, title: categoryTitle, info: category, theme: theme, configuration: configuration)
        trackerDetailsSectionModel[categoryCell.row] = categoryModel
        
        // Name model
        let name = record.category.name ?? ""
        let nameTitle = String.localizedString("name_title")
        let nameFont = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        let nameModel = name.isEmpty ? nil : LogCellModel(copiedString: name, title: nameTitle, info: name, infoFont: nameFont, theme: theme, configuration: configuration)
        trackerDetailsSectionModel[nameCell.row] = nameModel
        
        // Website model
        let website = record.category.url ?? ""
        let websiteTitle = String.localizedString("website_title")
        let color: UIColor = UIColor(hexString: "#4CA524")
        let attrString = NSMutableAttributedString(string: website)
        attrString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attrString.length))
        let websiteModel = website.isEmpty ? nil : LogCellModel(copiedString: website, title: websiteTitle, info: website, infoAttributedString: attrString, theme: theme, configuration: configuration)
        trackerDetailsSectionModel[websiteCell.row] = websiteModel
        
        sectionModels[trackerDetailsSection] = trackerDetailsSectionModel
        
        
        /**
         General Section
         */
        var generalSectionModel: [Int : LogCellModelProtocol?] = [:]
        
        // Domain model
        var domain = record.logRecord.domain
        domain = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        let domainTitle = String.localizedString("domain_title")
        let domainModel = domain.isEmpty ? nil : LogCellModel(copiedString: domain, title: domainTitle, info: domain, theme: theme, configuration: configuration)
        generalSectionModel[domainCell.row] = domainModel
        
        // Server model
        let server = record.logRecord.server
        let serverTitle = String.localizedString("server_title")
        let serverModel = server.isEmpty ? nil : LogCellModel(copiedString: server, title: serverTitle, info: server, theme: theme, configuration: configuration)
        generalSectionModel[serverCell.row] = serverModel
        
        // Status model
        let statusModel = getStatusCellModel()
        generalSectionModel[statusCell.row] = statusModel
        
        // Time model
        let time = record.logRecord.time()
        let timeTitle = String.localizedString("time_title")
        let timeModel = time.isEmpty ? nil : LogCellModel(copiedString: time, title:timeTitle, info: time, theme: theme, configuration: configuration)
        generalSectionModel[timeCell.row] = timeModel
        
        // Size model
        let bytesSent = record.logRecord.bytesSent
        let bytesReceived = record.logRecord.bytesReceived
        let bytesSentText = String(format: "%d B", bytesSent)
        let bytesReceivedText = String(format: "%d B", bytesReceived)
        let sizeTitle = String.localizedString("size_title")
        let size = String(format: "%d B / %d B", bytesReceived, bytesSent)
        let sizeModel = LogCellModel(isUserCell: false, isDataCell: true, copiedString: size, title: sizeTitle, bytesSent: bytesSentText, bytesReceived: bytesReceivedText, theme: theme, configuration: configuration)
        generalSectionModel[sizeCell.row] = sizeModel
        
        // Elapsed model
        let elapsed = record.logRecord.elapsed
        let elapsedTitle = String.localizedString("elapsed_title")
        let elapsedString = String(format: "%d ms", elapsed)
        let elapsedModel = LogCellModel(isUserCell: false, copiedString: elapsedString, title: elapsedTitle, info: elapsedString, theme: theme, configuration: configuration)
        generalSectionModel[elapsedCell.row] = elapsedModel
        
        sectionModels[generalSection] = generalSectionModel
        
        /**
         DNS Section
        */
        var dnsSectionModel: [Int : LogCellModelProtocol?] = [:]
        
        // Type model
        let type = record.logRecord.getTypeAndIp()
        let typeTitle = String.localizedString("type_title")
        let typeModel = type.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: type, title: typeTitle, info: type, theme: theme, configuration: configuration)
        dnsSectionModel[typeCell.row] = typeModel
        
        // Dns status model
        let dnsStatus = record.logRecord.answerStatus ?? ""
        let dnsStatusTitle = String.localizedString("dns_status_title")
        let dnsStatusModel = dnsStatus.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: dnsStatus, title: dnsStatusTitle, info: dnsStatus, theme: theme, configuration: configuration)
        dnsSectionModel[dnsStatusCell.row] = dnsStatusModel
        
        // Dns upstream model
        let dnsUpstream = record.logRecord.upstreamAddr ?? ""
        let dnsUpstreamTitle = String.localizedString("dns_upstream_title")
        let dnsUpstreamModel = dnsUpstream.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: dnsUpstream, title: dnsUpstreamTitle, info: dnsUpstream, theme: theme, configuration: configuration)
        dnsSectionModel[dnsUpstreamCell.row] = dnsUpstreamModel
        
        // Dns answer model
        let dnsAnswer = record.logRecord.answer
        let emptyAnswer = String.localizedString("empty_dns_answer")
        let answerString = dnsAnswer.isEmpty ? emptyAnswer : dnsAnswer
        let dnsAnserTitle = String.localizedString("dns_answer_title")
        let dnsAnswerModel = LogCellModel(isUserCell: false, copiedString: answerString, title: dnsAnserTitle, info: answerString, theme: theme, configuration: configuration)
        dnsSectionModel[dnsAnswerCell.row] = dnsAnswerModel
        
        // Matched filters model
        let matchedFilters = record.matchedFilters ?? ""
        let matchedFiltersTitle = String.localizedString("matched_filters_title")
        let matchedFiltersModel = matchedFilters.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: matchedFilters, title: matchedFiltersTitle, info: matchedFilters, theme: theme, configuration: configuration)
        dnsSectionModel[matchedFiltersCell.row] = matchedFiltersModel
        
        // Matched rules model
        let matchedRules = record.logRecord.blockRules?.joined(separator: "\n") ?? ""
        let matchedRulesTitle = String.localizedString("matched_rules_title")
        let matchedRulesModel = matchedRules.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: matchedRules, title: matchedRulesTitle, info: matchedRules, theme: theme, configuration: configuration)
        dnsSectionModel[matchedRulesCell.row] = matchedRulesModel
        
        // Original answer model
        let originalAnswer = record.logRecord.originalAnswer ?? ""
        let originalAnswerTitle = String.localizedString("original_answer_title")
        let originalAnswerModel = originalAnswer.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: originalAnswer, title: originalAnswerTitle, info: originalAnswer, theme: theme, configuration: configuration)
        dnsSectionModel[originalAnswerCell.row] = originalAnswerModel
        
        sectionModels[dnsSection] = dnsSectionModel
    }
}

