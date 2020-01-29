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

protocol LogCellModelProtocol {
    var isUserCell: Bool { get }
    
    var copiedString: String? { get }
    var copiedLabel: UIButton? { get }
    var labelToHide: UILabel? { get }
}

class LogCellModel: LogCellModelProtocol {
    var isUserCell: Bool
    
    var copiedString: String?
    var copiedLabel: UIButton?
    var labelToHide: UILabel?
    
    init(isUserCell: Bool, copiedString: String? = nil, copiedLabel: UIButton? = nil, labelToHide: UILabel? = nil) {
        self.isUserCell = isUserCell
        self.copiedString = copiedString
        self.copiedLabel = copiedLabel
        self.labelToHide = labelToHide
    }
}

class DnsRequestDetailsController : UITableViewController {
    
    // MARK: - public fields
    var logRecord: DnsLogRecordExtended?
    var shadowView: BottomShadowView? = nil
    var containerController: DnsContainerController? = nil
    
    //MARK: - IB Outlets
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var categoryLabel: ThemableLabel!
    @IBOutlet weak var statusLabel: ThemableLabel!
    @IBOutlet weak var nameLabel: ThemableLabel!
    @IBOutlet weak var timeLabel: ThemableLabel!
    @IBOutlet weak var companyLabel: ThemableLabel!
    @IBOutlet weak var elapsedLabel: ThemableLabel!
    @IBOutlet weak var typeLabel: ThemableLabel!
    @IBOutlet weak var domainLabel: ThemableLabel!
    @IBOutlet weak var serverLabel: ThemableLabel!
    @IBOutlet weak var addressLabel: ThemableLabel!
    @IBOutlet weak var responsesLabel: ThemableLabel!
    @IBOutlet weak var bytesSentLabel: ThemableLabel!
    @IBOutlet weak var bytesReceivedLabel: ThemableLabel!
    @IBOutlet weak var matchedFiltersLabel: ThemableLabel!
    @IBOutlet weak var matchedRulesLabel: ThemableLabel!
    @IBOutlet weak var originalAnswerLabel: ThemableLabel!
    @IBOutlet weak var dnsStatusLabel: ThemableLabel!
    
    
    // MARK: - "Copied labels"
    @IBOutlet weak var categoryCopied: UIButton!
    @IBOutlet weak var statusCopied: UIButton!
    @IBOutlet weak var nameCopied: UIButton!
    @IBOutlet weak var companyCopied: UIButton!
    @IBOutlet weak var timeCopied: UIButton!
    @IBOutlet weak var domainCopied: UIButton!
    @IBOutlet weak var typeCopied: UIButton!
    @IBOutlet weak var serverCopied: UIButton!
    @IBOutlet weak var elapsedCopied: UIButton!
    @IBOutlet weak var sizeCopied: UIButton!
    @IBOutlet weak var upstreamCopied: UIButton!
    @IBOutlet weak var answerCopied: UIButton!
    @IBOutlet weak var filtersCopied: UIButton!
    @IBOutlet weak var rulesCopied: UIButton!
    @IBOutlet weak var originalAnswerCopied: UIButton!
    @IBOutlet weak var dnsStatusCopied: UIButton!
    
    // MARK: - Title labels
    @IBOutlet weak var categoryTitleLabel: ThemableLabel!
    @IBOutlet weak var statusTitleLabel: ThemableLabel!
    @IBOutlet weak var nameTitleLabel: ThemableLabel!
    @IBOutlet weak var companyTitleLabel: ThemableLabel!
    @IBOutlet weak var timeTitleLabel: ThemableLabel!
    @IBOutlet weak var domainTitleLabel: ThemableLabel!
    @IBOutlet weak var typeTitleLabel: ThemableLabel!
    @IBOutlet weak var serverTitleLabel: ThemableLabel!
    @IBOutlet weak var elapsedTitleLabel: ThemableLabel!
    @IBOutlet weak var sizeTitleLabel: ThemableLabel!
    @IBOutlet weak var upstreamTitleLabel: ThemableLabel!
    @IBOutlet weak var answerTitleLabel: ThemableLabel!
    @IBOutlet weak var matchedFiltersTitleLabel: ThemableLabel!
    @IBOutlet weak var matchedRulesTitleLabel: ThemableLabel!
    @IBOutlet weak var originalAnswerTitleLabel: ThemableLabel!
    @IBOutlet weak var dnsStatusTitleLabel: ThemableLabel!
    
    private var notificationToken: NotificationToken?
    private var configurationToken: NSKeyValueObservation?
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - private properties
    
    private var animator = UIViewPropertyAnimator()
    
    private var labelToHide = UILabel()
    private var copiedLabel = UIButton()
    
    private let webPage = "https://whotracks.me"
    
    private let alert = UIAlertController(title: "", message: String.localizedString("whotrackme_message"), preferredStyle: .alert)
    
    private var cellModels: [IndexPath : LogCellModelProtocol?] = [:]
    
    // Sections & Rows
    private let trackerDetailsSection = 0
    private let categoryCell = IndexPath(row: 0, section: 0)
    private let nameCell = IndexPath(row: 1, section: 0)
    private let companyCell = IndexPath(row: 2, section: 0)
    
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
    
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAnimator()
        createAlert()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        configurationToken = configuration.observe(\.developerMode) {[weak self] (_, _) in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        createCellModels()
        updateStatusLabel()
        updateTheme()
    }
    
    override func viewDidLayoutSubviews() {
        guard let container = containerController else { return }
        if container.containerView.frame.height <= tableView.contentSize.height {
            shadowView?.animateAppearingOfShadow()
        }
        containerController = nil
    }
    
    // MARK: - public methods
    
    func updateStatusLabel() {
        
        guard let record = logRecord else { return }
        
        statusLabel.textColor = record.logRecord.status.color()
        
        if record.logRecord.userStatus == .none {
            statusLabel.text = record.logRecord.status.title()
        }
        else {
            statusLabel.text = "\(record.logRecord.status.title())(\(record.logRecord.userStatus.title()))"
        }
        
        statusLabel.superview!.setNeedsLayout()
    }
    
    // MARK: - Actions
    
    @IBAction func whoTracksMeInfo(_ sender: UIButton) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let model = cellModels[indexPath]
        
        cell.isHidden = false
        
        if let model = cellModels[indexPath] {
            if let userCell = model?.isUserCell {
                if !userCell && !configuration.developerMode {
                    cell.isHidden = true
                }
            }
        }
        
        if model == nil {
            cell.isHidden = true
        }

        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = cellModels[indexPath]
        
        if let model = cellModels[indexPath] {
            if let userCell = model?.isUserCell {
                if !userCell && !configuration.developerMode {
                    return 0.0
                }
            }
        }
        
        if model == nil {
            return 0.0
        }
        
        let defaultHeight = super.tableView(tableView, heightForRowAt: indexPath)
        return defaultHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cellModels[indexPath]
        let copiedString = model??.copiedString ?? ""
        
        // copy responses to pasteboard
        UIPasteboard.general.string = copiedString
        showCopiedLabel(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == trackerDetailsSection {
            let categoryModel = cellModels[categoryCell]
            let nameModel = cellModels[nameCell]
            let companyModel = cellModels[companyCell]
            
            if categoryModel == nil && nameModel == nil && companyModel == nil {
                return 0.0
            }
        }
        return 52.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var text = ""
        var needsButton = false
        
        switch section {
        case trackerDetailsSection:
            text = String.localizedString("tracker_details_header")
            needsButton = true
        case generalSection:
            text = String.localizedString("general_header")
        case dnsSection:
            text = configuration.developerMode ? String.localizedString("dns_header") : ""
        default:
            return nil
        }
        
        let view = createHeaderView(with: text.uppercased(), needsButton: needsButton)
        return view
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
    
    // MARK: - private methods
    
    private func updateTheme() {
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.backgroundColor = self.theme.backgroundColor
            self.tableView.reloadData()
        }
        theme.setupLabels(themableLabels)
    }
    
    private func showCopiedLabel(indexPath: IndexPath){
        if let model = cellModels[indexPath] {
            animator.stopAnimation(true)

            createAnimator()
            
            labelToHide.alpha = 1.0
            copiedLabel.alpha = 0.0
            
            copiedLabel = model?.copiedLabel ?? UIButton()
            labelToHide = model?.labelToHide ?? UILabel()
            
            animator.startAnimation()
        }
    }
    
    private func createAnimator(){
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {[weak self] in
            self?.labelToHide.alpha = 0.0
            self?.copiedLabel.alpha = 1.0
        })
        
        animator.addCompletion {[weak self] (position) in
            if position == .end {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.5) {
                        self?.labelToHide.alpha = 1.0
                        self?.copiedLabel.alpha = 0.0
                    }
                }
            }
        }
    }
    
    private func createAlert() {
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_more"), style: .default, handler: {[weak self] (action) in
            guard let sSelf = self else { return }
            guard let url = URL(string: sSelf.webPage) else { return }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: String.localizedString("common_action_cancel"), style: .cancel, handler: nil))
    }
    
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
     Method to create a model for this VC
     */
    private func createCellModels(){
        guard let record = logRecord else { return }
        
        // Category model
        let category = record.category.category
        let categoryModel = category == nil ? nil : LogCellModel(isUserCell: true, copiedString: category, copiedLabel: categoryCopied, labelToHide: categoryTitleLabel)
        cellModels[categoryCell] = categoryModel
        categoryLabel.text = category
        
        // Name model
        let name = record.category.name
        let nameModel = name == nil ? nil : LogCellModel(isUserCell: true, copiedString: name, copiedLabel: nameCopied, labelToHide: nameTitleLabel)
        cellModels[nameCell] = nameModel
        nameLabel.text = name
        
        // Company model
        let company = record.category.company
        let companyModel = company == nil ? nil : LogCellModel(isUserCell: true, copiedString: company, copiedLabel: companyCopied, labelToHide: companyTitleLabel)
        cellModels[companyCell] = companyModel
        companyLabel.text = company
        
        // Domain model
        var domain = record.logRecord.domain
        domain = domain.hasSuffix(".") ? String(domain.dropLast()) : domain
        let domainModel = LogCellModel(isUserCell: true, copiedString: domain, copiedLabel: domainCopied, labelToHide: domainTitleLabel)
        cellModels[domainCell] = domainModel
        domainLabel.text = domain
        
        // Server model
        let server = record.logRecord.server
        let serverModel = server.isEmpty ? nil : LogCellModel(isUserCell: true, copiedString: server, copiedLabel: serverCopied, labelToHide: serverTitleLabel)
        cellModels[serverCell] = serverModel
        serverLabel.text = server
        
        // Status model
        let status = record.logRecord.status.title()
        let userStatus = record.logRecord.userStatus
        let stCopied = userStatus == .none ? status : "\(status)(\(userStatus.title()))"
        let statusModel = LogCellModel(isUserCell: true, copiedString: stCopied, copiedLabel: statusCopied, labelToHide: statusTitleLabel)
        cellModels[statusCell] = statusModel
        
        // Time model
        let time = record.logRecord.time()
        let timeModel = LogCellModel(isUserCell: true, copiedString: time, copiedLabel: timeCopied, labelToHide: timeTitleLabel)
        cellModels[timeCell] = timeModel
        timeLabel.text = time
        
        // Size model
        let bytesSent = record.logRecord.bytesSent
        let bytesReceived = record.logRecord.bytesReceived
        let size = String(format: "%d B / %d B", bytesReceived, bytesSent)
        let sizeModel = LogCellModel(isUserCell: false, copiedString: size, copiedLabel: sizeCopied, labelToHide: sizeTitleLabel)
        cellModels[sizeCell] = sizeModel
        bytesSentLabel.text = String(format: "%d B", bytesSent)
        bytesReceivedLabel.text = String(format: "%d B", bytesReceived)
        
        // Elapsed model
        let elapsed = record.logRecord.elapsed
        let elapsedString = String(format: "%d ms", elapsed)
        let elapsedModel = LogCellModel(isUserCell: false, copiedString: elapsedString, copiedLabel: elapsedCopied, labelToHide: elapsedTitleLabel)
        cellModels[elapsedCell] = elapsedModel
        elapsedLabel.text = elapsedString
        
        // Type model
        let type = record.logRecord.type
        let typeModel = LogCellModel(isUserCell: false, copiedString: type, copiedLabel: typeCopied, labelToHide: typeTitleLabel)
        cellModels[typeCell] = typeModel
        let mappedType: String
        switch type {
        case "A":
            mappedType = "A (IPv4)"
        case "AAAA":
            mappedType = "AAAA (IPv6)"
        default:
            mappedType = type
        }
        typeLabel.text = mappedType
        
        // Dns status model
        let dnsStatus = record.logRecord.answerStatus
        let dnsStatusModel = LogCellModel(isUserCell: false, copiedString: dnsStatus, copiedLabel: dnsStatusCopied, labelToHide: dnsStatusTitleLabel)
        cellModels[dnsStatusCell] = dnsStatusModel
        dnsStatusLabel.text = dnsStatus
        
        // Dns upstream model
        let dnsUpstream = record.logRecord.upstreamAddr ?? ""
        let dnsUpstreamModel = dnsUpstream.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: dnsUpstream, copiedLabel: upstreamCopied, labelToHide: upstreamTitleLabel)
        cellModels[dnsUpstreamCell] = dnsUpstreamModel
        addressLabel.text = dnsUpstream
        
        // Dns answer model
        let dnsAnswer = record.logRecord.answer ?? ""
        let dnsAnswerModel = dnsAnswer.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: dnsAnswer, copiedLabel: answerCopied, labelToHide: answerTitleLabel)
        cellModels[dnsAnswerCell] = dnsAnswerModel
        responsesLabel.text = dnsAnswer
        
        // Matched filters model
        let matchedFilters = record.matchedFilters ?? ""
        let matchedFiltersModel = matchedFilters.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: matchedFilters, copiedLabel: filtersCopied, labelToHide: matchedFiltersTitleLabel)
        cellModels[matchedFiltersCell] = matchedFiltersModel
        matchedFiltersLabel.text = matchedFilters
        
        // Matched rules model
        let matchedRules = record.logRecord.blockRules?.joined(separator: "\n") ?? ""
        let matchedRulesModel = matchedRules.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: matchedRules, copiedLabel: rulesCopied, labelToHide: matchedRulesTitleLabel)
        cellModels[matchedRulesCell] = matchedRulesModel
        matchedRulesLabel.text = matchedRules
        
        // Original answer model
        let originalAnswer = record.logRecord.originalAnswer ?? ""
        let originalAnswerModel = originalAnswer.isEmpty ? nil : LogCellModel(isUserCell: false, copiedString: originalAnswer, copiedLabel: originalAnswerCopied, labelToHide: originalAnswerTitleLabel)
        cellModels[originalAnswerCell] = originalAnswerModel
        originalAnswerLabel.text = originalAnswer
    }
}
