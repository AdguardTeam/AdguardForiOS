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
        
        timeLabel.text = logRecord?.logRecord.time()
        elapsedLabel.text = String(format: "%d ms", logRecord?.logRecord.elapsed ?? 0)
        typeLabel.text = logRecord?.logRecord.type
        domainLabel.text = logRecord?.logRecord.domain
        serverLabel.text = logRecord?.logRecord.server
        addressLabel.text = logRecord?.logRecord.upstreamAddr
        responsesLabel.text = logRecord?.logRecord.answer
        categoryLabel.text = logRecord?.category.category
        
        nameLabel.text = logRecord?.category.name
        companyLabel.text = logRecord?.category.company
        bytesSentLabel.text = String(format: "%d B", logRecord?.logRecord.bytesSent ?? 0)
        bytesReceivedLabel.text = String(format: "%d B", logRecord?.logRecord.bytesReceived ?? 0)
        matchedRulesLabel.text = logRecord?.logRecord.blockRules?.joined(separator: "\n")
        matchedFiltersLabel.text = logRecord?.matchedFilters
        originalAnswerLabel.text = logRecord?.logRecord.originalAnswer
        dnsStatusLabel.text = logRecord?.logRecord.answerStatus
        
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
        
        if indexPath.row == LogCells.category.rawValue {
            if logRecord?.category == nil{
                cell.isHidden = true
            }
        } else if indexPath.row == LogCells.name.rawValue {
            if logRecord?.category.name == nil {
                cell.isHidden = true
            }
        } else if indexPath.row == LogCells.company.rawValue{
            if logRecord?.category.company == nil {
                cell.isHidden = true
            }
        }

        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let defaultHeight = super.tableView(tableView, heightForRowAt: indexPath)
        
        guard let cellType = LogCells(rawValue: indexPath.row) else {
            return defaultHeight
        }
        
        if !configuration.developerMode && !userCells.contains(cellType) {
            return 0.0
        }
        
        switch cellType {
        case .category:
            if logRecord?.category.category == nil{
                return 0.0
            }
            return defaultHeight
        case .name:
            if logRecord?.category.name == nil {
                return 0.0
            }
        case .company:
            if logRecord?.category.company == nil {
                    return 0.0
            }
            
        case .domain:
            if logRecord?.logRecord.domain.count == 0 {
                return 0.0
            }
        case .type:
            if logRecord?.logRecord.type.count == 0 {
                return 0.0
            }
        case .server:
            if logRecord?.logRecord.server.count == 0 {
                return 0.0
            }
        case .upstream:
            if logRecord?.logRecord.upstreamAddr?.count == 0 {
                return 0.0
            }
        case .answer:
            if logRecord?.logRecord.answer.count == 0 {
                return 0.0
            }
        case .matchedFilters:
            if logRecord?.matchedFilters?.count == 0 {
                return 0.0
            }
        case .matchedRules:
            if logRecord?.logRecord.blockRules?.joined(separator: "").count == 0  {
                return 0.0
            }
        case .originalAnswer:
            if logRecord?.logRecord.originalAnswer?.count == 0 {
                return 0.0
            }
        case .dnsStatus:
            if logRecord?.logRecord.answerStatus?.count == 0 {
                return 0.0
            }
            
        case .status, .time, .elapsed, .size:
            break
            
        }
        
        return defaultHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var copiedString = ""
        let logCell = LogCells(rawValue: indexPath.row)
        
        switch logCell {
        case .category:
            copiedString = logRecord?.category.category ?? ""
        case .status:
            copiedString = logRecord?.logRecord.status.title() ?? ""
        case .name:
            copiedString = logRecord?.category.name ?? ""
        case .company:
            copiedString = logRecord?.category.company ?? ""
        case .time:
            copiedString = logRecord?.logRecord.time() ?? ""
        case .domain:
            copiedString = logRecord?.logRecord.domain ?? ""
        case .type:
            copiedString = logRecord?.logRecord.type ?? ""
        case .server:
            copiedString = logRecord?.logRecord.server ?? ""
        case .elapsed:
            copiedString = String(format: "%d ms", logRecord?.logRecord.elapsed ?? 0)
        case .size:
            copiedString = String(format: "%d B / %d B", logRecord?.logRecord.bytesReceived ?? 0, logRecord?.logRecord.bytesSent ?? 0)
        case .upstream:
            copiedString = logRecord?.logRecord.upstreamAddr ?? ""
        case .answer:
            copiedString = logRecord?.logRecord.answer ?? ""
        case .none:
            copiedString = ""
        case .some(.matchedFilters):
            copiedString = logRecord?.matchedFilters ?? ""
        case .some(.matchedRules):
            copiedString = logRecord?.logRecord.blockRules?.joined(separator: "\n") ?? ""
        case .some(.originalAnswer):
            copiedString = logRecord?.logRecord.originalAnswer ?? ""
        case .some(.dnsStatus):
            copiedString = logRecord?.logRecord.answerStatus ?? ""
        }
        
        // copy responses to pasteboard
        UIPasteboard.general.string = copiedString
        if let row = logCell{
            showCopiedLabel(row: row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
    
    private enum LogCells: Int{
        case category = 0, status, name, company, time, domain, type, server, elapsed, size, upstream, answer, matchedFilters, matchedRules, originalAnswer, dnsStatus
    }
    
    private let userCells:[LogCells] = [.name, .status, .time, .domain]
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
        }
        theme.setupLabels(themableLabels)
    }
    
    private func showCopiedLabel(row: LogCells){
        
        animator.stopAnimation(true)
        
        createAnimator()
        
        labelToHide.alpha = 1.0
        copiedLabel.alpha = 0.0
        
        switch row {
        case .category:
            labelToHide = categoryTitleLabel
            copiedLabel = categoryCopied
        case .status:
            labelToHide = statusTitleLabel
            copiedLabel = statusCopied
        case .name:
            labelToHide = nameTitleLabel
            copiedLabel = nameCopied
        case .company:
            labelToHide = companyTitleLabel
            copiedLabel = companyCopied
        case .time:
            labelToHide = timeTitleLabel
            copiedLabel = timeCopied
        case .domain:
            labelToHide = domainTitleLabel
            copiedLabel = domainCopied
        case .type:
            labelToHide = typeTitleLabel
            copiedLabel = typeCopied
        case .server:
            labelToHide = serverTitleLabel
            copiedLabel = serverCopied
        case .elapsed:
            labelToHide = elapsedTitleLabel
            copiedLabel = elapsedCopied
        case .size:
            labelToHide = sizeTitleLabel
            copiedLabel = sizeCopied
        case .upstream:
            labelToHide = upstreamTitleLabel
            copiedLabel = upstreamCopied
        case .answer:
            labelToHide = answerTitleLabel
            copiedLabel = answerCopied
        case .matchedFilters:
            labelToHide = matchedFiltersTitleLabel
            copiedLabel = filtersCopied
        case .matchedRules:
            labelToHide = matchedRulesTitleLabel
            copiedLabel = rulesCopied
        case .originalAnswer:
            labelToHide = originalAnswerTitleLabel
            copiedLabel = originalAnswerCopied
        case .dnsStatus:
            labelToHide = dnsStatusTitleLabel
        }
        
        animator.startAnimation()
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
}
