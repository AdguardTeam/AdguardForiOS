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

import CoreServices
import Foundation
import UIKit.UIImage
import SharedAdGuardSDK

struct Context {
    let icon: UIImage?
    let url: URL
    let domain: String
    let isJsInjectSupported: Bool
}

/// This object is responsible for providing extension context
/// It transforms `NSExtensionContext` into normal readable object `Context`

private let LOG = LoggerFactory.getLoggerWrapper(ContextProvider.self)

struct ContextProvider {

    enum ContextError: Error, CustomDebugStringConvertible {
        case typeInconformance
        case errorLoadingItem
        case obtainDomain

        var debugDescription: String {
            return ""
        }
    }

    private let favIconService: FavIconServiceProtocol

    init(favIconService: FavIconServiceProtocol = FavIconService()) {
        self.favIconService = favIconService
    }

    func process(context: NSExtensionContext?, onContextObtained: @escaping (Result<Context>) -> Void) {
        let completionQueue = DispatchQueue.main

        guard let item = context?.inputItems.first as? NSExtensionItem,
              let itemProvider = item.attachments?.first
        else {
            completionQueue.async { onContextObtained(.error(ContextError.errorLoadingItem)) }
            return
        }

        let type = String(kUTTypePropertyList)
        guard itemProvider.hasItemConformingToTypeIdentifier(type) else {
            LOG.error("Error: itemProvider doesn't conform to type \(type))")
            completionQueue.async { onContextObtained(.error(ContextError.typeInconformance)) }
            return
        }

        itemProvider.loadItem(forTypeIdentifier: type, options: nil) { result, loadItemError in
            guard loadItemError == nil else {
                LOG.error("Error loading item: \(loadItemError!)")
                completionQueue.async { onContextObtained(.error(ContextError.errorLoadingItem)) }
                return
            }
            processDictionary(result, onContextObtained)
        }
    }

    private func processDictionary(_ dict: NSSecureCoding?, _ onContextObtained: @escaping (Result<Context>) -> Void) {
        let completionQueue = DispatchQueue.main

        guard let dictResult = dict as? [String: Any] else {
            LOG.error("Error result is not a valid dict. Results: \(String(describing: dict))")
            completionQueue.async { onContextObtained(.error(ContextError.typeInconformance)) }
            return
        }

        guard let infoDict = dictResult[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] else {
            LOG.error("Can't get NSExtensionJavaScriptPreprocessingResultsKey. Results: \(dictResult)")
            completionQueue.async { onContextObtained(.error(ContextError.typeInconformance)) }
            return
        }

        // Obtaining url and domain of the current page
        guard let urlString = infoDict["urlString"] as? String,
              let url = URL(string: urlString),
              let domain = url.host
        else {
            LOG.error("Error obtaining page url")
            completionQueue.async { onContextObtained(.error(ContextError.obtainDomain)) }
            return
        }

        // True if page supports JS injections
        let jsInjectSupportedKey = infoDict["injectScriptSupported"] as? Int
        let isJsInjectSupported = jsInjectSupportedKey == 1 ? true : false

        // WebSite favicon url
        favIconService.provideImage(for: domain) { image in
            let context = Context(
                icon: image,
                url: url,
                domain: domain,
                isJsInjectSupported: isJsInjectSupported
            )
            onContextObtained(.success(context))
        }
    }
}
