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

import XCTest

class MigrationServiceTest: XCTestCase {
    
    var migrationService: MigrationServiceProtocol!
    let vpnManager = VpnManagerMock()
    let dnsProvidersService = DnsProvidersServiceMock()
    let resources = SharedResourcesMock()

    override func setUp() {
        migrationService = MigrationService(vpnManager: vpnManager, dnsProvidersService: dnsProvidersService, resources: resources)
    }
    
    func testMajorMigration() {
        let savedSchemaVersion = 3
        resources.sharedDefaults().set(savedSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
        
        migrationService.migrateIfNeeded()
        
        let savedSchemaVersionAfterMigration = resources.sharedDefaults().integer(forKey: AEDefaultsProductSchemaVersion)
        
        XCTAssertEqual(savedSchemaVersionAfterMigration, savedSchemaVersion)
    }
    
    func testMinorAndPatchMigration() {
        let lastBuildVersion = "440"
        resources.sharedDefaults().set(lastBuildVersion, forKey: AEDefaultsProductBuildVersion)
        
        migrationService.migrateIfNeeded()
        sleep(1)
        
        let currentBuildVersion = Int(ADProductInfo.buildNumber())!
        let lastBuildVersionAfterMigration = resources.sharedDefaults().integer(forKey: AEDefaultsProductBuildVersion)
        
        XCTAssertEqual(currentBuildVersion, lastBuildVersionAfterMigration)
    }
}
