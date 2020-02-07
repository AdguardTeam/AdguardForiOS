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
import SafariServices

class SafariManagerMock: SFContentBlockerManagerProtocol {
    
    var maximumCount = 0
    var currentCount = 0
    var sleepTime = 0.5 //seconds
    
    var errors: [String: [Bool]] = [String: [Bool]]()
    
    let errorsQueue = DispatchQueue(label: "errors queue")
    
    func reloadContentBlocker(withIdentifier identifier: String, completionHandler: ((Error?) -> Void)?) {
        DispatchQueue(label: "reload").async {
            self.currentCount = self.currentCount + 1
            self.maximumCount = max(self.maximumCount, self.currentCount)
            DispatchQueue(label: "completion").asyncAfter(deadline: .now() + self.sleepTime) {
                self.currentCount = self.currentCount - 1
                
                var error: Error?
                
                self.errorsQueue.sync {
                    if var errorsByIdentifier = self.errors[identifier] {
                        if errorsByIdentifier.count > 0 {
                            
                            error = errorsByIdentifier.first! ? NSError(domain: "", code: 0, userInfo: nil) : nil
                            errorsByIdentifier.remove(at: 0)
                            self.errors[identifier] = errorsByIdentifier
                        }
                    }
                }
                
                completionHandler?(error)
            }
        }
    }
    
    func getStateOfContentBlocker(withIdentifier identifier: String, completionHandler: @escaping (SFContentBlockerState?, Error?) -> Void) {
        DispatchQueue(label: "state").async {
            completionHandler(SFContentBlockerState(), nil)
        }
    }
}

class SafariServiceMock: NSObject, SafariServiceProtocol {
    
    var contentBlockerManager: SFContentBlockerManagerProtocol = SafariManagerMock()
    
    var errors: [ContentBlockerType: Bool] = [ContentBlockerType: Bool]()
    
    func invalidateBlockingJson(type: ContentBlockerType, completion: @escaping (Error?) -> Void) {
        DispatchQueue(label: "safari mock invalidate").asyncAfter(deadline: .now() + 0.5) {
            completion((self.errors[type] ?? false) ? NSError(domain: "", code: 0, userInfo: nil):nil)
        }
    }
    
    func checkStatus(completion: @escaping ([ContentBlockerType : Bool]) -> Void) {
    }
    
    func getContentBlockerEnabled(type: ContentBlockerType) -> Bool {
        return true
    }
    
    var jsons = [ContentBlockerType: Data]()
    
    func invalidateBlockingJsons(completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    let saveQueue = DispatchQueue(label: "save_queue")
    
    func save(json: Data, type: ContentBlockerType) {
        saveQueue.sync {
            jsons[type] = json
        }
    }
    
    func readJson(forType type: ContentBlockerType) -> Data? {
        return jsons[type]
    }
    
    func allBlockingContentRules() -> [String : Data] {
        return [:]
    }
}
