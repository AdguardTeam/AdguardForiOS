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

/// Wrapper for `AGDnsRequestProcessedEvent`
/// It is needed to be able to write tests for other objects
struct AGDnsRequestProcessedEventWrapper {
    let domain: String // Queried domain name
    let type: String // Query type
    let startTime: Int // Time when dnsproxy started processing request (epoch in milliseconds)
    let elapsed: Int // Time elapsed on processing (in milliseconds)
    let status: String // DNS answer's status
    let answer: String // DNS Answers string representation
    let originalAnswer: String // If blocked by CNAME, here will be DNS original answer's string representation
    let upstreamId: Int? // ID of the upstream that provided this answer
    let bytesSent: Int // Number of bytes sent to a server
    let bytesReceived: Int // Number of bytes received from a server
    let rules: [String] // Filtering rules texts
    let filterListIds: [Int] // Filter lists IDs of corresponding rules
    let whitelist: Bool // True if filtering rule is whitelist
    let cacheHit: Bool // True if this response was served from the cache
    let error: String? // If not empty, contains the error text (occurred while processing the DNS query)
}

/// Initializer from DNS-lib object
extension AGDnsRequestProcessedEventWrapper {
    init(event: AGDnsRequestProcessedEvent) {
        self.domain = event.domain
        self.type = event.type
        self.startTime = event.startTime
        self.elapsed = event.elapsed
        self.status = event.status
        self.answer = event.answer
        self.originalAnswer = event.originalAnswer
        self.upstreamId = event.upstreamId == nil ? nil : event.upstreamId.intValue
        self.bytesSent = event.bytesSent
        self.bytesReceived = event.bytesReceived
        self.rules = event.rules
        self.filterListIds = event.filterListIds.map { $0.intValue }
        self.whitelist = event.whitelist
        self.cacheHit = event.cacheHit
        self.error = event.error
    }
}
