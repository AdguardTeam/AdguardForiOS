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

import UIKit.UIImage
import SafariAdGuardSDK
import SafariServices
import UIKit

protocol SafariGroupsModelDelegate: AnyObject {
    func modelChanged(_ rowToChange: Int)
    func modelsChanged()
}

final class SafariGroupsModel {

    private(set) var groups: [SafariProtectionGroupCellModel] = []
    weak var delegate: SafariGroupsModelDelegate?

    // MARK: - Private properties

    private var proStatusObserver: NotificationToken?

    /* Services */
    private let safariProtection: SafariProtectionProtocol
    private let configuration: ConfigurationServiceProtocol

    // MARK: - Initialization

    init(safariProtection: SafariProtectionProtocol, configuration: ConfigurationServiceProtocol) {
        self.safariProtection = safariProtection
        self.configuration = configuration

        self.proStatusObserver = NotificationCenter.default.observe(name: .proStatusChanged, object: nil, queue: .main) { [weak self] _ in
            self?.createModels()
            self?.delegate?.modelsChanged()
        }
        createModels()
    }

    // MARK: - Public methods

    func setGroup(_ groupType: SafariGroup.GroupType, enabled: Bool) {
        DDLogInfo("(SafariGroupsModel) - setGroup; Trying to change group=\(groupType) to state=\(enabled)")

        do {
            try safariProtection.setGroup(groupType, enabled: enabled, shouldReloadCB: true, onCbReloaded: nil)
            let row = groups.firstIndex(where: { $0.groupType == groupType }) ?? 0
            createModels()
            delegate?.modelChanged(row)
        }
        catch {
            DDLogError("(SafariGroupsModel) - setGroup; DB error when changing group=\(groupType) to state=\(enabled); Error: \(error)")
        }
    }

    func updateModels() {
        createModels()
        delegate?.modelsChanged()
    }

    // MARK: - Private methods

    private func createModels() {
        let groupsFromSDK = safariProtection.groups
        self.groups = groupsFromSDK.map {
            return SafariProtectionGroupCellModel(group: $0, proStatus: configuration.proStatus)
        }
    }
}


