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

import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK

protocol SDKMigrationServiceHelperProtocol: AnyObject {
    func migrate() throws
}

/// This object is a helper for `MigrationService`
/// It is responsible for migrating data to new storages our SDK uses
/// We've started to use AdGuard SDK in v4.3
final class SDKMigrationServiceHelper: SDKMigrationServiceHelperProtocol {

    private let dnsMigration: DnsMigration4_3Protocol
    private let safariMigration: SafariMigration4_3Protocol
    
    init(
        safariMigration: SafariMigration4_3Protocol,
        dnsMigration: DnsMigration4_3Protocol
    ) {
        self.dnsMigration = dnsMigration
        self.safariMigration = safariMigration
    }

    func migrate() throws {
        safariMigration.migrate()
        dnsMigration.migrate()
    }
}
