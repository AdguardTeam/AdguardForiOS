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

/// This object is responsible for executing tasks that can be continued in background
/// Usually iOS gives us 30 seconds to complete such tasks
public final class BackgroundTaskExecutor {

    public static func executeSyncronousTask(_ reason: String, blockToExecute: @escaping () -> Void) {
#if os(iOS)
        ProcessInfo().performExpiringActivity(withReason: reason) { expired in
            if expired {
                // TODO: this does not help much since iOS will still kill the app if the task is still in progress.
                Logger.logInfo("(BackgroundTaskExecutor) - executeSyncronousTask; Task with reason=\(reason) has expired")
            } else {
                blockToExecute()
            }
        }
#endif
    }

    public static func executeAsyncronousTask(_ reason: String, blockToExecute: @escaping (_ onTaskFinished: @escaping () -> Void) -> Void) {
#if os(iOS)
        ProcessInfo().performExpiringActivity(withReason: reason) { expired in
            if expired {
                // TODO: this does not help much since iOS will still kill the app if the task is still in progress.
                Logger.logInfo("(BackgroundTaskExecutor) - executeAsyncronousTask; Task with reason=\(reason) has expired")
            } else {
                Logger.logInfo("(BackgroundTaskExecutor) - executeAsyncronousTask; Task with reason=\(reason) has started")
                let group = DispatchGroup()
                group.enter()

                blockToExecute() {
                    group.leave()
                }

                group.wait()
                Logger.logInfo("(BackgroundTaskExecutor) - executeAsyncronousTask; Task with reason=\(reason) has finished")
            }
        }
#endif
    }
}
