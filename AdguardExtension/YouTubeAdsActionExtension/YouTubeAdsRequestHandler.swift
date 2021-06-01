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

import UIKit
import MobileCoreServices

class YouTubeAdsRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    private lazy var notifications: UserNotificationServiceProtocol = { UserNotificationService() }()
    
    override init() {
        super.init()
        
        let resources = AESharedResources()
        
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("Start today extension with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }
    
    func beginRequest(with context: NSExtensionContext) {
        self.extensionContext = context
        context.getJsScriptResult { [weak self] host in
            self?.notifications.postNotification(title: "This shortcut is supposed to be launched only on YouTube.", body: "kek", userInfo: nil)
        }
        context.completeRequest(returningItems: [], completionHandler: nil)
    }
}

extension NSExtensionContext {
    func getJsScriptResult(_ onJsExecuted: @escaping (_ host: String?) -> Void) {
        guard let inputItem = self.inputItems.first as? NSExtensionItem,
              let itemProvider = inputItem.attachments?.first,
              itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList))
              else {
            onJsExecuted(nil)
            return
        }
        
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) { [weak self] results, error in
            
        }
    }
}
