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
import AdGuardSDK

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        
        let resources = AESharedResources()
        
        // Init Logger
        ACLLogger.singleton().initLogger(resources.sharedAppLogsURL())
        ACLLogger.singleton().logLevel = resources.isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
        
        DDLogInfo("ActionRequestHandler start request")
        
        let configuration = SafariConfiguration(safariProtectionEnabled: resources.safariProtectionEnabled)
        let jsonProvider = SafariJsonProvider(bundleId: Bundle.main.bundleIdentifier ?? "", mainAppBundleId: Bundle.main.hostAppBundleId, jsonStorageUrl: resources.sharedResuorcesURL(), userDefaults: resources.sharedDefaults(), configuration: configuration as! SafariConfigurationProtocol)
        
        guard let url = jsonProvider.jsonUrl(),
              let attachment = NSItemProvider(contentsOf: url) else {
            DDLogError("can not init attachment")
            context.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        DDLogInfo("ActionRequestHandler complete request")
        context.completeRequest(returningItems: [item], completionHandler: nil)
        return
    }
}
