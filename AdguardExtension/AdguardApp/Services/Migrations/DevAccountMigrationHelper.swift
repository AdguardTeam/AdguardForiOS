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

import SafariAdGuardSDK

/**
 A helper class to process dev account migration issues
 */
final class DevAccountMigrationHelper {

    private let resources: AESharedResourcesProtocol
    private let productInfo: ADProductInfoProtocol
    private let notificationService: UserNotificationServiceProtocol
    private let fromExtension: Bool

    init(
        fromExtension: Bool = false,
        _ resources: AESharedResourcesProtocol,
        _ productInfo: ADProductInfoProtocol,
        _ notificationService: UserNotificationServiceProtocol
    ) {
        self.fromExtension = fromExtension
        self.resources = resources
        self.productInfo = productInfo
        self.notificationService = notificationService
    }

    /* Processes Performiks to ASL dev account migration */
    func processDevAccountMigrationIfNeeded() {
        if resources.safariContentBlockersAreDisabledAfterDevTeamMigrationNotificationShown {
            DDLogDebug("(DevAccountMigrationHelper) 'Safari content blockers are disabled after dev team migration' notification has been shown before, do nothing")
            return
        }

        guard let currentBuildVersion = Int(productInfo.buildNumber()) else { return }
        let previousBuildVersion = resources.buildVersion

        if previousBuildVersion == 0 {
            DDLogDebug("(DevAccountMigrationHelper) no needs to handle migration since previous version is unknown")
            return
        }

        if !areAllContentBlockersDisabled() {
            DDLogDebug("(DevAccountMigrationHelper) Content blockers are enabled, do nothing")
            return
        }

        if currentBuildVersion > previousBuildVersion {
            DDLogDebug("(DevAccountMigrationHelper) Let's show the 'Safari content blockers are disabled after dev team migration' notification")
            notificationService.postNotification(title: String.localizedString("dev_account_migration_helper_content_blockers_disabled_title"), body: "", userInfo: nil)
            resources.safariContentBlockersAreDisabledAfterDevTeamMigrationNotificationShown = true
        }
    }

    /* Checks if all content blockers are disabled */
    private func areAllContentBlockersDisabled() -> Bool {
        !ContentBlockerService(appBundleId: mainAppBundleId())
            .allContentBlockersStates
            .values
            .contains(true)
    }

    /* Returns main app bundle ID */
    private func mainAppBundleId() -> String {
        let bundleId = Bundle.main.bundleIdentifier ?? ""

        return fromExtension ? bundleId.split(separator: ".").dropLast().joined(separator: ".") : bundleId
    }
}
