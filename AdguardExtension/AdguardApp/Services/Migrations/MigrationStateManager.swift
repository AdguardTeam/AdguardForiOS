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

enum MigrationState: Int {
    case notStarted = 0
    case started = 1
    case finished = 2
}


/// this manager manages the states of partial migrations
protocol MigrationStateManagerProtocol {

    /// current state
    var state: MigrationState { get }

    func start()
    func finish()
    func failure()

    func onMigrationFinished(_ callback: @escaping ()->Void)
}

class MigrationStateManager: NSObject, MigrationStateManagerProtocol {

    private let migrationKey: String
    private let resources: AESharedResourcesProtocol

    private var callback: (()->Void)? = nil

    init(resources: AESharedResourcesProtocol, migrationKey: String) {
        self.resources = resources
        self.migrationKey = migrationKey
    }

    var state: MigrationState {
        return MigrationState(rawValue: resources.sharedDefaults().integer(forKey: migrationKey)) ?? .notStarted
    }

    func start() {
        resources.sharedDefaults().set(MigrationState.started.rawValue, forKey: migrationKey)
        resources.sharedDefaults().synchronize()
    }

    func finish() {
        resources.sharedDefaults().set(MigrationState.finished.rawValue, forKey: migrationKey)
        resources.sharedDefaults().synchronize()
    }

    func failure() {
        resources.sharedDefaults().set(MigrationState.notStarted.rawValue, forKey: migrationKey)
        resources.sharedDefaults().synchronize()
    }

    func onMigrationFinished(_ callback: @escaping () -> Void) {

        if state != .started {
            callback()
            return
        }
        self.callback = callback
        resources.sharedDefaults().addObserver(self, forKeyPath: migrationKey, options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == migrationKey && state != .started {
            callback?()

            resources.sharedDefaults().removeObserver(self, forKeyPath: migrationKey)
            callback = nil
        }
    }

    deinit {
        if callback != nil {
            resources.sharedDefaults().removeObserver(self, forKeyPath: migrationKey)
        }
    }
}
