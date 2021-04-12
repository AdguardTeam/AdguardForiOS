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
    let productInfo = ProductInfoMock()
    let antibanner = AntibannerMock()
    let contentBlockerService = ContentBlockerServiceMock()
    
    override func setUp() {
        migrationService = MigrationService(vpnManager: vpnManager, dnsProvidersService: dnsProvidersService, resources: resources, antibanner: antibanner, dnsFiltersService: DnsFiltersServiceMock(), networking: NetworkMock(), activityStatisticsService: ActivityStatisticsServiceMock(), dnsStatisticsService: DnsStatisticsServiceMock(), dnsLogService: DnsLogRecordsServiceMock(), configuration: ConfigurationServiceMock(), filtersService: FiltersServiceMock(), productInfo: productInfo, contentBlockerService: contentBlockerService, nativeProviders: NativeProvidersServiceMock(), filtersStorage: FiltersStorageMock())
    }
    
    func testMajorMigration() {
        let savedSchemaVersion = 3
        resources.sharedDefaults().set(savedSchemaVersion, forKey: AEDefaultsProductSchemaVersion)
        
        migrationService.migrateIfNeeded(inBackground: false)
        
        let savedSchemaVersionAfterMigration = resources.sharedDefaults().integer(forKey: AEDefaultsProductSchemaVersion)
        
        XCTAssertEqual(savedSchemaVersionAfterMigration, savedSchemaVersion)
    }
    
    func testMinorAndPatchMigration() {
        let lastBuildVersion = "440"
        resources.sharedDefaults().set(lastBuildVersion, forKey: AEDefaultsProductBuildVersion)
        
        migrationService.migrateIfNeeded(inBackground: false)
        sleep(1)
        
        let currentBuildVersion = Int(productInfo.buildNumber())!
        let lastBuildVersionAfterMigration = resources.sharedDefaults().integer(forKey: AEDefaultsProductBuildVersion)
        
        XCTAssertEqual(currentBuildVersion, lastBuildVersionAfterMigration)
    }
    
    func testBackgroundMigration() {
        resources.buildVersion = 100
        productInfo.buildNumberInternal = "200"
        
        // migrate in background
        
        migrationService.migrateIfNeeded(inBackground: true)
        
        usleep(200000)
        
        // in this case filters must not be updated
        XCTAssertFalse(antibanner.updateStarted)
        
        XCTAssert(resources.buildVersion == 200)
        
        // then migrate in foreground
        migrationService.migrateIfNeeded(inBackground: false)
        
        usleep(200000)
        
        XCTAssertTrue(antibanner.updateStarted)
    }
}
