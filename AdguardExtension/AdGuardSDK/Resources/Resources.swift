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

public protocol ResourcesProtocol {
    var filtersMetadataCache: ABECFilterClientMetadata? { get set }
    var i18nCacheForFilterSubscription: ABECFilterClientLocalization? { get set }
    var invertedWhitelistContentBlockingObject: AEInvertedWhitelistDomainsObject? { get set }
    var whitelistContentBlockingRules: [ASDFilterRule]? { get set }
}

public class Resources: ResourcesProtocol {
    private let contentFolder: URL
    public init(contentFolder: URL) {
        self.contentFolder = contentFolder
    }
    
    public var filtersMetadataCache: ABECFilterClientMetadata? {
        get {
            readObj(file: "metadata-cache.data")
        }
        set {
            saveObj(newValue, file: "metadata-cache.data")
        }
    }
    
    public var i18nCacheForFilterSubscription: ABECFilterClientLocalization? {
        get {
            readObj(file: "i18-cache.data")
        }
        set {
            saveObj(newValue, file: "i18-cache.data")
        }
    }
    
    public var invertedWhitelistContentBlockingObject: AEInvertedWhitelistDomainsObject? {
        get {
            readObj(file: "safari-inverdet-whitelist-rules.data")
        }
        set {
            saveObj(newValue, file: "safari-inverdet-whitelist-rules.data")
        }
    }
    
    public var whitelistContentBlockingRules: [ASDFilterRule]? {
        get {
            readObj(file: "safari-whitelist-rules.data")
        }
        set {
            saveObj(newValue, file: "safari-whitelist-rules.data")
        }
    }
    
    
    // MARK: - private methods
    
    private func loadDataFrom(_ relativePath: String)->Data?{
        let dataUrl = contentFolder.appendingPathComponent(relativePath)
        return try? Data(contentsOf: dataUrl)
    }
    
    private func saveData(_ data: Data, relativePath: String) {
        let dataUrl = contentFolder.appendingPathComponent(relativePath)
        try? data.write(to: dataUrl)
    }
    
    private func saveObj(_ obj: Any?, file: String) {
        if obj == nil {
            saveData(Data(), relativePath: file)
        }
        else {
            let data = NSKeyedArchiver.archivedData(withRootObject: obj!)
            saveData(data, relativePath: file)
        }
    }
    
    private func readObj<T>(file: String)->T? {
        if let data = loadDataFrom(file) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
        }
        else {
            return nil
        }
    }
}
