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
    
    //MARK: - IB Outlets
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    @IBOutlet weak var timeLabel: ThemableLabel!
    @IBOutlet weak var elapsedLabel: ThemableLabel!
    @IBOutlet weak var typeLabel: ThemableLabel!
    @IBOutlet weak var domainLabel: ThemableLabel!
    @IBOutlet weak var serverLabel: ThemableLabel!
    @IBOutlet weak var addressLabel: ThemableLabel!
    @IBOutlet weak var responsesLabel: ThemableLabel!
    
    // MARK: - constants
    
    private let responsesRow = 6
    
    // MARK: - services
    
    let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = logRecord?.time
        elapsedLabel.text = String(format: "%d ms", logRecord!.elapsed)
        typeLabel.text = logRecord?.type
        domainLabel.text = logRecord?.name
        serverLabel.text = logRecord?.serverName
        addressLabel.text = logRecord?.upstreamAddr
        responsesLabel.text = logRecord?.answer

        updateTheme()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        theme.setupTableCell(cell)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == responsesRow {
            // copy responses to pasteboard
            if let responsesString = logRecord?.answer {
                UIPasteboard.general.string = responsesString
                ToastView.presentinController(self, message: ACLocalizedString("text_copied", nil))
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == responsesRow {
            return UITableView.automaticDimension
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupTable(tableView)
        theme.setupLabels(themableLabels)
    }
}
