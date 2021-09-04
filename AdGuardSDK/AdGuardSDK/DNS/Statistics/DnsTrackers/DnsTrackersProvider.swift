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

/**
 This file is downloaded from https://github.com/AdguardTeam/AdGuardHome/tree/master/client/src/helpers/trackers
 */
final class DnsTrackersProvider {
    private let whoTracksMeTrackers: DnsTrackers
    private let adguardTrackers: DnsTrackers
    
    init() throws {
        let bundle = Bundle(for: type(of: self))
        guard let whotracksmeUrl = bundle.url(forResource: DnsTrackers.JsonType.whoTracksMe.rawValue, withExtension: "json"),
              let adguardUrl = bundle.url(forResource: DnsTrackers.JsonType.adGuard.rawValue, withExtension: "json")
        else {
            throw CommonError.missingFile(filename: "whotracksme.json||adguard.json")
        }
        
        let whotracksmeData = try Data(contentsOf: whotracksmeUrl)
        let adguardData = try Data(contentsOf: adguardUrl)
        
        self.whoTracksMeTrackers = try JSONDecoder().decode(DnsTrackers.self, from: whotracksmeData)
        self.adguardTrackers = try JSONDecoder().decode(DnsTrackers.self, from: adguardData)
    }
}
