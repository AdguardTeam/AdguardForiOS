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

enum BlockedRecordType {
    case normal, whitelisted, blocked, trackedAndBlocked
}

class ActivityTableViewCell: UITableViewCell {
    @IBOutlet weak var companyLabel: ThemableLabel!
    @IBOutlet weak var infoLabel: ThemableLabel!
    @IBOutlet weak var blockStateView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var timeLabel: ThemableLabel!
    
    var advancedMode: Bool = true
    
    var domainsParser: DomainParser?
    
    var theme: ThemeServiceProtocol? {
        didSet {
            updateTheme()
        }
    }
    
    var record: DnsLogRecordExtended? {
        didSet {
            processRecord()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundColor = nil
        blockStateView.backgroundColor = .clear
        infoLabel.attributedText = nil
        companyLabel.text = nil
        timeLabel.text = nil
        categoryImageView.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blockStateView.layer.cornerRadius = blockStateView.frame.height / 2.0
    }
    
    // MARK: - Private variables
    
    private let redDotColor = UIColor(hexString: "#DF3812")
    private let greenDotColor = UIColor(hexString: "#67B279")
    private let greyDotColor = UIColor(hexString: "#888888")
    
    // MARK: - Private methods
    
    private func processRecord(){
        guard let record = record else { return }
        let timeString = record.logRecord.time()
        let name = record.category.name
        let domain = record.logRecord.getDetailsString(infoLabel.font.pointSize, advancedMode)
        
        companyLabel.text = (name == nil || advancedMode) ? record.logRecord.firstLevelDomain(parser: domainsParser) : name
        infoLabel.attributedText = domain
        timeLabel.text = timeString
        
        // Setup cell background color
        let type: BlockedRecordType
        switch (record.logRecord.status, record.category.categoryId ?? 0) {
        case (.processed, _):
            type = .normal
        case (.encrypted, _):
            type = .normal
        case (.whitelistedByUserFilter, _), (.whitelistedByOtherFilter, _):
            type = .whitelisted
        case (.blacklistedByUserFilter, let catergoryId), (.blacklistedByOtherFilter, let catergoryId):
            type = (catergoryId == 6 || catergoryId == 101) ? .trackedAndBlocked : .blocked
        }
        setupRecordCell(type: type, dnsStatus: record.logRecord.answerStatus ?? "")
        
        // Setup blockStateView color
        switch record.logRecord.userStatus {
        case .removedFromWhitelist:
            blockStateView.backgroundColor = .clear
        case .removedFromBlacklist:
            blockStateView.backgroundColor = .clear
        case .movedToWhitelist:
            blockStateView.backgroundColor = greenDotColor
        case .movedToBlacklist:
            blockStateView.backgroundColor = redDotColor
        case .modified:
            blockStateView.backgroundColor = greyDotColor
        default:
            blockStateView.backgroundColor = .clear
        }
        
        let categoryImage = UIImage.getCategoryImage(withId: record.category.categoryId)
        categoryImageView.isHidden = categoryImage == nil
        categoryImageView.image = categoryImage
    }
    
    private func updateTheme(){
        theme?.setupTableCell(self)
        theme?.setupLabel(companyLabel)
        theme?.setupLabel(infoLabel)
        theme?.setupLabel(timeLabel)
    }
    
    private func setupRecordCell(type: BlockedRecordType, dnsStatus: String){
        
        var logSelectedCellColor: UIColor = .clear
        var logBlockedCellColor: UIColor = .clear
        
        switch type {
        case .blocked:
            logSelectedCellColor = UIColor(hexString: "#4DDF3812")
            logBlockedCellColor = UIColor(hexString: "#33DF3812")
        case .whitelisted:
            logSelectedCellColor = UIColor(hexString: "#4D67b279")
            logBlockedCellColor = UIColor(hexString: "#3367b279")
        case .trackedAndBlocked:
            logSelectedCellColor = UIColor(hexString: "#4Df5a623")
            logBlockedCellColor = UIColor(hexString: "#33f5a623")
        default:
            return
        }
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = logSelectedCellColor
        selectedBackgroundView = bgColorView
        contentView.backgroundColor = .clear
        backgroundColor = logBlockedCellColor
    }
}
