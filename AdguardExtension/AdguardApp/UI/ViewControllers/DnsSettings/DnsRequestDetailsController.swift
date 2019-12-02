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
    var logRecord: LogRecord?
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
    
    private var notificationToken: NotificationToken?
    
    // MARK: - services
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        timeLabel.text = logRecord?.time
        elapsedLabel.text = String(format: "%d ms", logRecord?.elapsed ?? 0)
        typeLabel.text = logRecord?.type
        domainLabel.text = logRecord?.domain
        serverLabel.text = logRecord?.serverName
        addressLabel.text = logRecord?.upstreamAddr
        responsesLabel.text = logRecord?.answer
        categoryLabel.text = logRecord?.category
        statusLabel.text = logRecord?.status.status()
        statusLabel.textColor = logRecord?.status.color()
        
        nameLabel.text = logRecord?.name
        companyLabel.text = logRecord?.company
        bytesSentLabel.text = String(format: "%d B", logRecord?.bytesSent ?? 0)
        bytesReceivedLabel.text = String(format: "%d B", logRecord?.bytesReceived ?? 0)
        
        updateTheme()
    }
    
    override func viewDidLayoutSubviews() {
        guard let container = containerController else { return }
        if container.containerView.frame.height <= tableView.contentSize.height {
            shadowView?.animateAppearingOfShadow()
        }
        containerController = nil
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.row == LogCells.category.rawValue {
            if logRecord?.category == nil{
                cell.isHidden = true
            }
        } else if indexPath.row == LogCells.name.rawValue {
            if logRecord?.name == nil {
                cell.isHidden = true
            }
        } else if indexPath.row == LogCells.company.rawValue{
            if logRecord?.company == nil {
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
        
        if cellType == .category {
            if logRecord?.category == nil{
                return 0.0
            }
        } else if cellType == .name {
            if logRecord?.name == nil {
                return 0.0
            }
        } else if cellType == .company {
            if logRecord?.company == nil {
                return 0.0
            }
        }
        
        if !configuration.developerMode && !userCells.contains(cellType) {
            return 0.0
        }
        
        return defaultHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var copiedString = ""
        let logCell = LogCells(rawValue: indexPath.row)
        
        switch logCell {
        case .category:
            copiedString = logRecord?.category ?? ""
        case .status:
            copiedString = logRecord?.status.status() ?? ""
        case .name:
            copiedString = logRecord?.name ?? ""
        case .company:
            copiedString = logRecord?.company ?? ""
        case .time:
            copiedString = logRecord?.time ?? ""
        case .domain:
            copiedString = logRecord?.domain ?? ""
        case .type:
            copiedString = logRecord?.type ?? ""
        case .server:
            copiedString = logRecord?.serverName ?? ""
        case .elapsed:
            copiedString = String(format: "%d ms", logRecord?.elapsed ?? 0)
        case .size:
            copiedString = String(format: "%d B / %d B", logRecord?.bytesReceived ?? 0, logRecord?.bytesSent ?? 0)
        case .upstream:
            copiedString = logRecord?.upstreamAddr ?? ""
        case .answer:
            copiedString = logRecord?.answer ?? ""
        case .none:
            copiedString = ""
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
        case category = 0, status, name, company, time, domain, type, server, elapsed, size, upstream, answer
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
        var labelToHide = UILabel()
        var copiedLabel = UIButton()
        
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
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            labelToHide.alpha = 0.0
            copiedLabel.alpha = 1.0
        }, completion: { (success) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3) {
                    labelToHide.alpha = 1.0
                    copiedLabel.alpha = 0.0
                }
            }
        })
    }
}
