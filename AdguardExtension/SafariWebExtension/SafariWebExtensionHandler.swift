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

import SafariServices
import SharedAdGuardSDK

private let LOG = LoggerFactory.getLoggerWrapper(SafariWebExtensionHandler.self)

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    private let resources = Services.shared.resources
    private let processor = Services.shared.processor

    override init() {
        super.init()
        setupLogger()
    }

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem

        let messageDict = item.userInfo?[SFExtensionMessageKey] as! [String: Any]

        guard let message = Message(message: messageDict) else {
            LOG.info("Received unknown message: \(messageDict)")
            context.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }

        LOG.info("Received message from JS: \(messageDict)")
        let result = processor.process(message: message)
        let response = NSExtensionItem()
        response.userInfo = [SFExtensionMessageKey: result]
        context.completeRequest(returningItems: [response], completionHandler: nil)
    }

    // MARK: - Private methods

    private func setupLogger() {
        let isDebugLogs = resources.isDebugLogs
        LOG.debug("Safari Web Extension was initialized with log level: \(isDebugLogs ? "DEBUG" : "NORMAL")")

        let logManager = LoggerManagerImpl(url: resources.sharedLogsURL())
        let logLevel: LogLevel = isDebugLogs ? .debug : .info
        logManager.configure(logLevel)
        LOG.info("initLogger \(logLevel)")
    }
}
