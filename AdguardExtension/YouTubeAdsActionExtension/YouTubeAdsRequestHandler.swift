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

struct YouTubeAdsJsResult {
    
    enum Status: String {
        case success
        case wrongDomain
        case alreadyExecuted
        case error
        
        var title: String {
            switch self {
            case .success: return String.localizedString("youtube_script_success_title")
            case .wrongDomain: return String.localizedString("youtube_script_wrong_domain_title")
            case .alreadyExecuted: return String.localizedString("youtube_script_already_executed_title")
            case .error: return String.localizedString("youtube_script_error_title")
            }
        }
    }
    
    let successfullyExecuted: Bool
    let status: Status
    
    init?(jsDict: [String: Any]) {
        guard let successfullyExecuted = jsDict["success"] as? Bool,
              let statusString = jsDict["status"] as? String,
              let status = Status(rawValue: statusString)
        else {
            return nil
        }
        
        self.successfullyExecuted = successfullyExecuted
        self.status = status
    }
}

class YouTubeAdsRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    private lazy var notifications: UserNotificationServiceProtocol = { UserNotificationService() }()
    
    override init() {
        super.init()
        
        let resources = AESharedResources()
        
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("(YouTubeAdsRequestHandler) Start with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }
    
    func beginRequest(with context: NSExtensionContext) {
        self.extensionContext = context
        context.getJsScriptResult { [weak self] result in
            if let result = result {
                self?.notifications.postNotificationWithoutBadge(title: result.status.title, body: nil, onNotificationSent: {
                    DDLogInfo("(YouTubeAdsRequestHandler) js finished with result: \(result)")
                    context.completeRequest(returningItems: [], completionHandler: nil)
                })
            } else {
                DDLogInfo("(YouTubeAdsRequestHandler) js finished, result is nil")
                context.completeRequest(returningItems: [], completionHandler: nil)
            }
        }
    }
}

fileprivate extension NSExtensionContext {
    func getJsScriptResult(_ onJsExecuted: @escaping (_ jsResult: YouTubeAdsJsResult?) -> Void) {
        guard let inputItem = self.inputItems.first as? NSExtensionItem,
              let itemProvider = inputItem.attachments?.first,
              itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList))
              else {
            onJsExecuted(nil)
            return
        }
        
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) { results, error in
            
            if let error = error {
                DDLogError("(YouTubeAdsRequestHandler) Error: \(error)")
                onJsExecuted(nil)
                return
            }
            
            guard let jsResultDict = results as? [String: Any] else {
                DDLogError("(YouTubeAdsRequestHandler) Error - result dict incorrect. Results: \(results.debugDescription )")
                onJsExecuted(nil)
                return
            }
            
            guard let youTubeAdsJsResultDict = jsResultDict[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] else {
                DDLogError("(YouTubeAdsRequestHandler) Error - can not get NSExtensionJavaScriptPreprocessingResultsKey. Results: \(results.debugDescription )")
                onJsExecuted(nil)
                return
            }
    
            let youTubeAdsJsResult = YouTubeAdsJsResult(jsDict: youTubeAdsJsResultDict)
            onJsExecuted(youTubeAdsJsResult)
        }
    }
}
