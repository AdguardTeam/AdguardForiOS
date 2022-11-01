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

protocol MigrationServiceVersionProviderProtocol {
    var isMigrationFrom4_1To4_3Needed: Bool { get }
    var isLastVersionLessThan4_1: Bool { get }
    var isMigrationFrom4_3_0To4_3_1Needed: Bool { get }
}

class MigrationServiceVersionProvider: MigrationServiceVersionProviderProtocol {

    var isMigrationFrom4_1To4_3Needed: Bool {
        let lastBuildVersion = resources.buildVersion

        // FIXME: - Are ya releasing, son?
        return lastBuildVersion >= 650 && lastBuildVersion < 876
    }

    var isLastVersionLessThan4_1: Bool {
        let lastBuildVersion = resources.buildVersion
        return lastBuildVersion > 0 && lastBuildVersion < 650
    }

    var isMigrationFrom4_3_0To4_3_1Needed: Bool {
        let lastBuildVersion = resources.buildVersion
        return lastBuildVersion >= 915 && lastBuildVersion <= 918
    }

    var isNeedMigrationForDnsLibsUpdateFrom_1_7_28to2_0_34: Bool {
        let lastBuildVersion = resources.buildVersion
        return lastBuildVersion >= 965 && lastBuildVersion <= 968 && !resources.isMigrationAfterUpdateDnsLibsFrom1_7_28To2_0_34Passed
    }

    private let resources: AESharedResourcesProtocol

    init(resources: AESharedResourcesProtocol) {
        self.resources = resources
    }
}
