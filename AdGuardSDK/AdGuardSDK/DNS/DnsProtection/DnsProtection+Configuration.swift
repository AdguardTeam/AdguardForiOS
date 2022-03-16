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

public protocol DnsProtectionConfigurationProtocol {
    /* Shows if user has Premium app version */
    var proStatus: Bool { get }

    /* State of the whole Dns protection. If it is false nothing will be filtered */
    var dnsProtectionEnabled: Bool { get }

    /* State of the list that is responsible for blocking rules. */
    var blocklistIsEnabled: Bool { get }

    /* State of the list that is responsible for the rules that cancel blocklist rules actions */
    var allowlistIsEnabled: Bool { get }

    /* Updates pro status in configuration */
    func update(proStatus: Bool)

    /* Updates Dns protection state and reloads content blockers */
    func update(dnsProtectionEnabled: Bool)

    /* Updates block list state */
    func update(blocklistIsEnabled: Bool)

    /* Updates allow list state */
    func update(allowlistIsEnabled: Bool)

    //TODO: Need tests
    /* Updated dns configuration with new one */
    func updateConfig(with newConfig: DnsConfigurationProtocol)
}

private let LOG = LoggerFactory.getLoggerWrapper(DnsProtection.self)

extension DnsProtection {
    public var proStatus: Bool {
        return workingQueue.sync { return configuration.proStatus }
    }

    public var dnsProtectionEnabled: Bool {
        return workingQueue.sync { return configuration.dnsFilteringIsEnabled }
    }

    public var blocklistIsEnabled: Bool {
        return workingQueue.sync { return configuration.blocklistIsEnabled }
    }

    public var allowlistIsEnabled: Bool {
        return workingQueue.sync { return configuration.allowlistIsEnabled }
    }

    public func update(proStatus: Bool) {
        workingQueue.sync {
            self.configuration.proStatus = proStatus
        }
    }

    public func update(dnsProtectionEnabled: Bool) {
        workingQueue.sync {
            self.configuration.dnsFilteringIsEnabled = dnsProtectionEnabled
        }
    }

    public func update(blocklistIsEnabled: Bool) {
        workingQueue.sync {
            self.configuration.blocklistIsEnabled = blocklistIsEnabled
        }
    }

    public func update(allowlistIsEnabled: Bool) {
        workingQueue.sync {
            self.configuration.allowlistIsEnabled = allowlistIsEnabled
        }
    }

    public func updateConfig(with newConfig: DnsConfigurationProtocol) {
        workingQueue.sync {
            LOG.info("updateConfig")
            self.configuration.updateConfig(with: newConfig)
        }
    }
}
