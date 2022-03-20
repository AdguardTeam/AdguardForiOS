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
import SharedAdGuardSDK

private let LOG = LoggerFactory.getLoggerWrapper(UIBackgroundTask.self)

public final class UIBackgroundTask {

    // We assume that 20 seconds is enough for any background operation.
    // TODO: consider parameterizing this as an argument in the "execute" function instead
    private static let safeRemainingTimeSeconds: TimeInterval = 20.0

    /**
     Executes an operation guarding it with using beginBackgroundTask/endBackgroundTask. Why is this important?
     Note that all heavy operations should be accompanied by calling beginBackgroundTask/endBackgroundTask. There's
     always a chance that the heavy operation does not end when the app is in the foreground (or that they start when
     it is already in the background). In this case there's a high chance that the OS will try to suspend the app.
     The problem is that when the app holds an open file handle, suspending actually transforms into killing an app.
     An open file handle is not necessarily a file, it might mean that you're working with an SQLite database.
     So if we do not use beginBackgroundTask/endBackgroundTask there's a high chance of data corruption.
     The explanation on why it is important can be found in the documentation (see the section on 0xdead10cc).
     https://developer.apple.com/documentation/xcode/understanding-the-exception-types-in-a-crash-report
     - Parameters:
       - name: operation name.
       - checkRemainingTime: if true, we check if the remaining time is enough to run the operation.
       - blockToExecute: the function to execute safely.
     - Returns: true if the operation was successfully executed. false if it was not (not enough remaining time,
        cannot call beginBackgroundTask).
     */
    public static func execute(name: String, checkRemainingTime: Bool, blockToExecute: @escaping () -> Void) -> Bool {
        let backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: name) {
            LOG.info("Execute \(name); background task is expiring, remaining time: \(UIApplication.shared.backgroundTimeRemaining)")
        }

        if backgroundTaskId == UIBackgroundTaskIdentifier.invalid {
            LOG.warn("Execute \(name); cannot start background operation")
            return false
        }

        LOG.info("Execute \(name); start background operation")

        if checkRemainingTime && UIApplication.shared.backgroundTimeRemaining < UIBackgroundTask.safeRemainingTimeSeconds {
            LOG.info("Execute \(name); remaining time is not enough to complete the task, exiting immediately")
            UIApplication.shared.endBackgroundTask(backgroundTaskId)
            return false
        }

        blockToExecute()

        LOG.info("Execute \(name); finished background operation")
        UIApplication.shared.endBackgroundTask(backgroundTaskId)
        return true
    }

    public static func execute(name: String, blockToExecute: @escaping () -> Void) -> Bool {
        UIBackgroundTask.execute(name: name, checkRemainingTime: false, blockToExecute: blockToExecute)
    }
}
