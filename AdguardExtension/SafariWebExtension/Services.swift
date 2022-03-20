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

import Foundation
import SharedAdGuardSDK

private let LOG = LoggerFactory.getLoggerWrapper(Services.self)

final class Services {
    static let shared = Services()

    let resources: AESharedResourcesProtocol
    let urlsStorage: SharedStorageUrlsProtocol
    let processor: SafariWebExtensionMessageProcessorProtocol
    private let loggerManager: LoggerManager
    
    init() {
        self.resources = AESharedResources()
        self.urlsStorage = SharedStorageUrls()
        self.processor = SafariWebExtensionMessageProcessor(resources: resources)
        let resources = AESharedResources()
        self.loggerManager = LoggerManagerImpl(url: resources.sharedLogsURL())
        let logLevel: LogLevel = resources.isDebugLogs ? .debug : .info
        loggerManager.configure(logLevel)
        LOG.info("Init services start with logLevel \(logLevel)")

    }
}
