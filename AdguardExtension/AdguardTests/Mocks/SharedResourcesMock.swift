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

class SharedResourcesMock: NSObject, AESharedResourcesProtocol {
    
    var systemProtectionEnabled: Bool = true
    
    var safariProtectionEnabled: Bool = true
    
    var userDefaults: UserDefaults = {
        let userDefaults = UserDefaults(suiteName: "TestDefaults")
        userDefaults?.removePersistentDomain(forName: "TestDefaults")
        userDefaults?.synchronize()
        return userDefaults!
    } ()
    
    var files = [String: Data]()
    
    func reset() {
        do {
            try FileManager.default.removeItem(at: sharedResuorcesURL())
        }
        catch {
            print(error)
        }
        
        try? FileManager.default.createDirectory(at: sharedResuorcesURL(), withIntermediateDirectories: true, attributes: nil)
    }
    
    func sharedResuorcesURL() -> URL { return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("resources_mock") }
    
    func sharedAppLogsURL() -> URL { return URL(string: "")!}
    
    func sharedLogsURL() -> URL  { return URL(string: "")!}
    
    func sharedDefaults() -> UserDefaults {
        return userDefaults
    }
    
    func synchronizeSharedDefaults() { }
    
    func save(_ data: Data, toFileRelativePath relativePath: String) -> Bool {
        files[relativePath] = data
        return true
    }
    
    func loadData(fromFileRelativePath relativePath: String) -> Data? {
        return files[relativePath]
    }
    
    var blockingContentRules: Data!
    
    var whitelistContentBlockingRules: NSMutableArray?
    
    var invertedWhitelistContentBlockingObject: AEInvertedWhitelistDomainsObject?
    
    var lastUpdateFilterMetadata: ABECFilterClientMetadata?
    
    var filtersMetadataCache: ABECFilterClientMetadata?
    
    var i18nCacheForFilterSubscription: ABECFilterClientLocalization?
    
    var lastUpdateFilterIds: [NSNumber]?
    
    var lastUpdateFilters: [NSNumber : ASDFilter]?
    
    var activeDnsServer: DnsServerInfo? = nil
    
    func path(forRelativePath relativePath: String) -> String {
        return "test_domain\(relativePath)"
    }
    
    
    override init() {
        super.init()
        try? FileManager.default.createDirectory(at: sharedResuorcesURL(), withIntermediateDirectories: true, attributes: nil)
    }
}
