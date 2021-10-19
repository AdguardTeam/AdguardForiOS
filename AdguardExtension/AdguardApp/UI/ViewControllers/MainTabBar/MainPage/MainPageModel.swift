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

import SharedAdGuardSDK
import SafariAdGuardSDK
import DnsAdGuardSDK

protocol MainPageModelDelegate: AnyObject {
    func updateStarted()
    func updateFinished(message: String?)
    func updateFailed(error: String)
}

protocol MainPageModelProtocol: AnyObject {
    func updateFilters()
    var delegate: MainPageModelDelegate? { get set }
}

/// Super old model, it should be removed
/// Actually it was rewritten in Stories PR
final class MainPageModel: MainPageModelProtocol {

    weak var delegate: MainPageModelDelegate?

    // MARK: - private members

    private let safariProtection: SafariProtectionProtocol
    private let dnsProtection: DnsProtectionProtocol
    private let resources: AESharedResourcesProtocol
    private let vpnManager: VpnManagerProtocol

    // MARK: - init

    init(
        resource: AESharedResourcesProtocol,
        safariProtection: SafariProtectionProtocol,
        dnsProtection: DnsProtectionProtocol,
        vpnManager: VpnManagerProtocol
    ) {
        self.resources = resource
        self.safariProtection = safariProtection
        self.dnsProtection = dnsProtection
        self.vpnManager = vpnManager
    }

    // MARK: - public methods

    /**
     updates filters. calls callback during updating process
     */
    func updateFilters() {
        delegate?.updateStarted()

        @Atomic var filtersCount = 0
        @Atomic var updateError: Error?
        let group = DispatchGroup()

        group.enter()
        safariProtection.updateFiltersMetaAndLocalizations(true) { result in
            switch result {
            case .error(let error):
                _updateError.mutate { $0 = error }
            case .success(let updateResult):
                _filtersCount.mutate { $0 += updateResult.updatedFilterIds.count }
            }
        } onCbReloaded: { error in
            _updateError.mutate { $0 = error }
            group.leave()
        }

        group.enter()
        dnsProtection.updateAllFilters { [weak vpnManager] result in
            _filtersCount.mutate { $0 += result.updatedFiltersIds.count }
            if result.updatedFiltersIds.count > 0 {
                vpnManager?.updateSettings(completion: nil)
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak delegate] in
            let message: String
            if let error = updateError {
                DDLogError("(MainPageModel) - updateFilters; Error: \(error)")
                message = String.localizedString("filter_updates_error")
            }
            else if filtersCount > 0 {
                let format = String.localizedString("filters_updated_format")
                message = String(format: format, filtersCount)
            }
            else {
                message = String.localizedString("filters_noUpdates")
            }
            delegate?.updateFinished(message: message)
        }
    }
}
