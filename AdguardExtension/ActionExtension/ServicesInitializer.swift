///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import SafariAdGuardSDK
import SharedAdGuardSDK

/// Singleton to quikcly get different services objects and remove initialization logic from view controllers
final class ServicesInitializer {

    static let shared = try! ServicesInitializer()

    let safariProtection: SafariProtectionProtocol
    let resources: AESharedResourcesProtocol
    let themeService: ThemeServiceProtocol
    let configuration: ConfigurationServiceProtocol

    init() throws {
        self.resources = AESharedResources()
        Self.setupLogger(resources)

        // Registering standart Defaults
        let appPath = Bundle.main.bundlePath as NSString
        let fullPath = appPath.appendingPathComponent("../../") as String
        guard let bundle = Bundle(path: fullPath), let path = bundle.path(forResource: "defaults", ofType: "plist") else {
            DDLogError("(ServicesInitializer) - wrong appPath");
            throw CommonError.missingFile(filename: fullPath)
        }
        if let defs = NSDictionary(contentsOfFile: path) as? [String: Any] {
            DDLogInfo("(ServicesInitializer) - default.plist loaded!")
            resources.sharedDefaults().register(defaults: defs)
        } else {
            DDLogError("(ServicesInitializer) - default.plist was not loaded.")
            throw CommonError.missingFile(filename: "default.plist")
        }

        let networkService = ACNNetworking()
        let productInfo = ADProductInfo()
        let purchaseService = PurchaseService(network: networkService, resources: resources, productInfo: productInfo)
        let sharedUrls = SharedStorageUrls()
        let preloadedFilesManager = PreloadedFilesManager(sharedStorageUrls: sharedUrls, bundle: bundle)
        try preloadedFilesManager.processPreloadedFiles()

        /* Initializing SDK */
        let safariProtectionConfiguration = SafariConfiguration(
            bundle: bundle,
            resources: resources,
            isProPurchased: purchaseService.isProPurchased
        )
        let defaultConfiguration = SafariConfiguration.defaultConfiguration()

        self.safariProtection = try SafariProtection(
            configuration: safariProtectionConfiguration,
            defaultConfiguration: defaultConfiguration,
            filterFilesDirectoryUrl: sharedUrls.filtersFolderUrl,
            dbContainerUrl: sharedUrls.dbFolderUrl,
            jsonStorageUrl: sharedUrls.cbJsonsFolderUrl,
            userDefaults: resources.sharedDefaults()
        )
        /* End of initializing SDK */

        self.configuration = ConfigurationService(
            purchaseService: purchaseService,
            resources: resources,
            safariProtection: safariProtection
        )

        self.themeService = ThemeService(configuration)
    }

    private static func setupLogger(_ resources: AESharedResourcesProtocol) {
        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("Start Action extension with log level: \(isDebugLogs ? "DEBUG" : "NORMAL")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }
}
