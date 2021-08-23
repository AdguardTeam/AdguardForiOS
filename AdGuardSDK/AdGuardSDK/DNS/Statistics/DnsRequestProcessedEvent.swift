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

/// Wrapper object for AGDnsRequestProcessedEventWrapper
/// Here we preprocess and modify some data that we receive from DNS-libs
public struct DnsRequestProcessedEvent {
    let domain: String // Queried domain name
    let startDate: Date // Time when dnsproxy started processing request
    let elapsed: Int // Time elapsed on processing (in milliseconds)
    let type: String // Query type
    let answer: String // DNS Answers string representation
    let processedStatus: ProcessedStatus // DNS answer's status
    let originalAnswer: String // If blocked by CNAME, here will be DNS original answer's string representation
    let upstream: DnsUpstream // The upstream that provided the answer
    let bytesSent: Int // Number of bytes sent to a server
    let bytesReceived: Int // Number of bytes received from a server
    let blockRules: [String] // Filtering rules texts
    let cacheHit: Bool // True if this response was served from the cache
    
    var isBlocked: Bool {
        switch processedStatus {
        case .blocklistedByDnsFilter, .blocklistedByUserFilter: return true
        default: return false
        }
    }
    var isEncrypted: Bool { upstream.`protocol`.isCrypto }
}

/// Initializer from wrapper for DNS-libs object
extension DnsRequestProcessedEvent {
    init(event: AGDnsRequestProcessedEventWrapper, upstream: DnsUpstream, dnsFiltersIds: [Int]) {
        self.domain = event.domain
        self.startDate = Date(timeIntervalSince1970: TimeInterval(event.startTime / 1000))
        self.elapsed = event.elapsed
        self.type = event.type
        self.answer = event.answer
        self.processedStatus = Self.getEventStatus(event, isEncrypted: upstream.`protocol`.isCrypto, dnsFiltersIds: dnsFiltersIds)
        self.originalAnswer = event.originalAnswer
        self.upstream = upstream
        self.bytesSent = event.bytesSent
        self.bytesReceived = event.bytesReceived
        self.blockRules = event.rules
        self.cacheHit = event.cacheHit
    }
    
    private static func isLocalHost(dnsAnswer: String, type: String) -> Bool {
        guard type == "A" || type == "AAAA" else { return false }
        
        let splitedAnswers = dnsAnswer.split(separator: "\n").map({ String($0) })
        guard splitedAnswers.count == 1 else { return false }
        
        let dnsAnswer = splitedAnswers[0]
                
        guard let range = dnsAnswer.range(of: ", ") else { return false }
        let ip = dnsAnswer[range.upperBound...]
        
        let isIpv4Localhost = type == "A" && (ip == "0.0.0.0" || ip == "127.0.0.1")
        let isIpv6Localhost = type == "AAAA" && (ip == "::" || ip == "::1")
        return isIpv4Localhost || isIpv6Localhost
    }
    
    private static func getEventStatus(_ event: AGDnsRequestProcessedEventWrapper, isEncrypted: Bool, dnsFiltersIds: [Int]) -> ProcessedStatus {
        if event.whitelist {
            let allowlistFilterId = DnsUserRuleType.allowlist.enabledRulesFilterId
            return event.filterListIds.contains(allowlistFilterId) ? .allowlistedByUserFilter : .allowlistedByDnsFilter
        }
        else if event.filterListIds.contains(DnsUserRuleType.blocklist.enabledRulesFilterId) {
            return .blocklistedByUserFilter
        }
        else if dnsFiltersIds.contains(where: { event.filterListIds.contains($0) }) {
            return .blocklistedByDnsFilter
        }
        else if event.status == "REFUSED" {
            return .blocklistedByDnsFilter
        }
        else if isLocalHost(dnsAnswer: event.answer, type: event.type) {
            return .blocklistedByDnsFilter
        }
        else if isEncrypted {
            return .encrypted
        }
        else {
            return .processed
        }
    }
}

extension DnsRequestProcessedEvent {
    enum ProcessedStatus: Int {
        // IMPORTANT: - DO NOT CHANGE RAW VALUES
        // We store this values in database
        case processed = 0
        case encrypted = 1
        case blocklistedByUserFilter = 2
        case blocklistedByDnsFilter = 3
        case allowlistedByUserFilter = 4
        case allowlistedByDnsFilter = 5
    }
}

extension DnsRequestProcessedEvent: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        let dateDiff = lhs.startDate.timeIntervalSince1970 - rhs.startDate.timeIntervalSince1970
        let datesAreEqual = abs(dateDiff) < 1
        return lhs.domain == rhs.domain
                && datesAreEqual
                && lhs.elapsed == rhs.elapsed
                && lhs.type == rhs.type
                && lhs.answer == rhs.answer
                && lhs.processedStatus == rhs.processedStatus
                && lhs.originalAnswer == rhs.originalAnswer
                && lhs.upstream == rhs.upstream
                && lhs.bytesSent == rhs.bytesSent
                && lhs.bytesReceived == rhs.bytesReceived
                && lhs.blockRules == rhs.blockRules
                && lhs.cacheHit == rhs.cacheHit
    }
}

fileprivate extension DnsServerMetaProtocol {
    var isCrypto: Bool { type != .dns }
}
