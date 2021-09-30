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

import DnsAdGuardSDK

enum BlockedRecordType {
    case normal, whitelisted, blocked
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

    var record: DnsLogRecord? {
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

    private let redDotColor = UIColor.AdGuardColor.red
    private let greenDotColor = UIColor.AdGuardColor.lightGreen1
    private let greyDotColor = UIColor.AdGuardColor.lightGray3

    // MARK: - Private methods

    private func processRecord(){
        guard let record = record else { return }
        let timeString = record.time()
        let name = record.tracker?.name
        let domain = record.getDetailsString(infoLabel.font.pointSize, advancedMode)

        companyLabel.text = (name == nil || advancedMode) ? record.firstLevelDomain(parser: domainsParser) : name
        infoLabel.attributedText = domain
        timeLabel.text = timeString

        // Setup cell background color
        let type: BlockedRecordType
        switch record.event.processedStatus {
        case .processed:
            type = .normal
        case .encrypted:
            type = .normal
        case .allowlistedByDnsFilter, .allowlistedByUserFilter:
            type = .whitelisted
        case .blocklistedByDnsFilter, .blocklistedByUserFilter:
            type = .blocked
        }
        setupRecordCell(type: type)

        let categoryImage = UIImage.getCategoryImage(withId: record.tracker?.category.rawValue)
        categoryImageView.isHidden = categoryImage == nil
        categoryImageView.image = categoryImage
    }

    private func updateTheme(){
        theme?.setupTableCell(self)
        theme?.setupLabel(companyLabel)
        theme?.setupLabel(infoLabel)
        theme?.setupLabel(timeLabel)
    }

    private func setupRecordCell(type: BlockedRecordType){

        var logSelectedCellColor: UIColor = .clear
        var logBlockedCellColor: UIColor = .clear

        switch type {
        case .blocked:
            logSelectedCellColor = UIColor.AdGuardColor.logSelectedCellColor
            logBlockedCellColor = UIColor.AdGuardColor.logBlockedCellColor
        case .whitelisted:
            logSelectedCellColor = UIColor.AdGuardColor.logSelectedAllowlistedCellColor
            logBlockedCellColor = UIColor.AdGuardColor.logAllowlistedCellColor
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
