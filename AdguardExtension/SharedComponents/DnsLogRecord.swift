//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import DnsAdGuardSDK

enum UserFilterStatus {
    case allowlisted, blocklisted, none
}

/**
 model for dns request log record
 */
final class DnsLogRecord {
    // processed dns requestinfo
    let event: DnsRequestProcessedEvent
    // dns tracker info for event.domain
    let tracker: DnsTracker?
    // status determines whether the matched rules are contained in custom filters
    var userFilterStatus: UserFilterStatus
    // first level domain
    let firstLevelDomain: String

    init(event: DnsRequestProcessedEvent, tracker: DnsTracker?, firstLevelDomain: String, userFilterStatus: UserFilterStatus) {
        self.event = event
        self.firstLevelDomain = firstLevelDomain
        self.tracker = tracker
        self.userFilterStatus = userFilterStatus
    }

    // returns in completion attributed string
    func getAttributedText(_ fontSize: CGFloat, _ advancedMode: Bool, completion: @escaping (_ attributedString: NSMutableAttributedString) -> Void) {
        DispatchQueue.asyncSafeMain { [weak self] in
            guard let self = self else { return }
            let recordType = self.event.type

            if advancedMode {
                var newDomain = self.event.domain.hasSuffix(".") ? String(self.event.domain.dropLast()) : self.event.domain
                newDomain = " " + newDomain

                let typeAttr = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold) ]
                let domainAttr = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .regular) ]

                let typeAttrString = NSAttributedString(string: recordType, attributes: typeAttr)
                let domainAttrString = NSAttributedString(string: newDomain, attributes: domainAttr)

                let combination = NSMutableAttributedString()
                combination.append(typeAttrString)
                combination.append(domainAttrString)

                completion(combination)
            } else {
                let typeAttr = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .semibold) ]
                let statusAttr = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: .regular),
                                   NSAttributedString.Key.foregroundColor: self.event.processedStatus.textColor]

                let typeAttrString = NSAttributedString(string: " (" + recordType + ")", attributes: typeAttr)
                let statusAttrString = NSAttributedString(string: self.event.processedStatus.title, attributes: statusAttr)

                let combination = NSMutableAttributedString()
                combination.append(statusAttrString)
                combination.append(typeAttrString)

                completion(combination)
            }
        }
    }
}

extension DnsLogRecord {
    private func getTypeString() -> String {
        let IPv4 = "A"
        let IPv6 = "AAAA"

        let IPv4String = "IPv4"
        let IPv6String = "IPv6"

        if event.type == IPv4 {
            return IPv4String
        } else if event.type == IPv6 {
            return IPv6String
        } else {
            return event.type
        }
    }

    func getTypeAndIp() -> String {
        let IPv4 = "A"
        let IPv6 = "AAAA"

        let IPv4String = "IPv4"
        let IPv6String = "IPv6"

        if event.type == IPv4 {
            return "\(event.type)(\(IPv4String))"
        } else if event.type == IPv6 {
            return "\(event.type)(\(IPv6String))"
        } else {
            return event.type
        }
    }
}
