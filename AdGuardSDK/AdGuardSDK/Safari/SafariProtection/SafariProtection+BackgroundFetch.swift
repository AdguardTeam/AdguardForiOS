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
import UIKit.UIBackgroundConfiguration

/// This object contains all information about background fetch update result
public struct BackgroundFetchUpdateResult: Equatable {
    public let backgroundFetchResult: UIBackgroundFetchResult
    public let newBackgroundFetchState: BackgroundFetchState
    public let oldBackgroundFetchState: BackgroundFetchState
    public let error: Error?

    public static func == (lhs: BackgroundFetchUpdateResult, rhs: BackgroundFetchUpdateResult) -> Bool {
        return lhs.backgroundFetchResult.rawValue == rhs.backgroundFetchResult.rawValue
        && lhs.newBackgroundFetchState == rhs.newBackgroundFetchState
        && lhs.oldBackgroundFetchState == rhs.oldBackgroundFetchState
    }

    public init(backgroundFetchResult: UIBackgroundFetchResult, newBackgroundFetchState: BackgroundFetchState, oldBackgroundFetchState: BackgroundFetchState, error: Error?) {
        self.backgroundFetchResult = backgroundFetchResult
        self.newBackgroundFetchState = newBackgroundFetchState
        self.oldBackgroundFetchState = oldBackgroundFetchState
        self.error = error
    }
}

/**
 The process of filters update while app is in the background is rather complex
 We have 30 seconds to download all filters content, update filters and localizations and reload all content blockers
 If that huge process of update is run at once there is a big chance to fail an update
 If we fail an update the OS can ban our background fethces and we will be unable to update filters in background
 To avoid this ban we've devided an update process into 3 sequential steps:
 1. Update filters content, meta and localizations; Update DNS filters
 2. Convert new filters to JSON files for Safari Content Blockers
 3. Reload Safari Content Blockers with newely converted rules
 With this approach, the chances of a successful background fetch increases
 */
public enum BackgroundFetchState: Int, CustomDebugStringConvertible {
    case loadAndSaveFilters
    case convertFilters
    case reloadContentBlockers
    case updateFinished

    public var debugDescription: String {
        switch self {
        case .loadAndSaveFilters: return "loadAndSaveFilters"
        case .convertFilters: return "convertFilters"
        case .reloadContentBlockers: return "reloadContentBlockers"
        case .updateFinished: return "updateFinished"
        }
    }
}

public protocol SafariProtectionBackgroundFetchProtocol {
    /// Updates filters while background fetch is active
    func updateSafariProtectionInBackground(_ onStateExecutionFinished: @escaping (_ result: BackgroundFetchUpdateResult) -> Void)

    /**
     This method is neede to finish the update process that did start in the background

     For example:
        The background update did complete 2 out of 3 steps.
        To provide user with the latest data we should finish the update and complete the 3rd step
     Note:
        If background update did already finished successfully this method will do nothing

     The method should be called on the app start in **didFinishLaunchingWithOptions**
     */
    func finishBackgroundUpdate(_ onUpdateFinished: @escaping (_ error: Error?) -> Void)
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(SafariProtection.self)

/* Extension is used to update filters while main app is in the background */
extension SafariProtection {

    private var currentBackgroundFetchState: BackgroundFetchState {
        get {
            return userDefaults.currentBackgroundFetchState
        }
        set {
            userDefaults.currentBackgroundFetchState = newValue
        }
    }

    // MARK: - Public methods

    public func updateSafariProtectionInBackground(_ onStateExecutionFinished: @escaping (_ result: BackgroundFetchUpdateResult) -> Void) {
        LOG.info("(SafariProtection+BackgroundFetch) - updateSafariProtectionInBackground; Start background fetch, current state = \(currentBackgroundFetchState)")

        switch currentBackgroundFetchState {
        case .loadAndSaveFilters, .updateFinished:
            updateFilters(onStateExecutionFinished)
        case .convertFilters:
            convertFilters(onStateExecutionFinished)
        case .reloadContentBlockers:
            reloadContentBlockers(onStateExecutionFinished)
        }
    }

    public func finishBackgroundUpdate(_ onUpdateFinished: @escaping (_ error: Error?) -> Void) {
        BackgroundTaskExecutor.executeAsynchronousTask("SafariProtection+BackgroundFetch.finishBackgroundUpdate") { [weak self] onTaskFinished in
            guard let self = self else {
                LOG.error("(SafariProtection+BackgroundFetch) - finishBackgroundUpdate; Missing self")
                onUpdateFinished(CommonError.missingSelf)
                onTaskFinished()
                return
            }
            LOG.info("(SafariProtection+BackgroundFetch) - finishBackgroundUpdate start; Current state = \(self.currentBackgroundFetchState)")

            switch self.currentBackgroundFetchState {
            case .loadAndSaveFilters:
                let group = DispatchGroup()
                group.enter()
                self.updateFilters { _ in
                    group.leave()
                }
                group.wait()
                fallthrough
            case .convertFilters:
                var result: BackgroundFetchUpdateResult?
                let group = DispatchGroup()
                group.enter()
                self.convertFilters { res in
                    result = res
                    group.leave()
                }
                group.wait()
                if let error = result?.error {
                    self.completionQueue.async {
                        onUpdateFinished(error)
                        onTaskFinished()
                    }
                    return
                }
                fallthrough
            case .reloadContentBlockers:
                self.reloadContentBlockers({ result in
                    self.completionQueue.async {
                        onUpdateFinished(result.error)
                        onTaskFinished()
                    }
                })
            case .updateFinished:
                self.completionQueue.async {
                    onUpdateFinished(nil)
                    onTaskFinished()
                }
            }
        }
    }

    // MARK: - Private methods

    // 1st step of background update
    private func updateFilters(_ onFiltersUpdated: @escaping (_ result: BackgroundFetchUpdateResult) -> Void) {
        LOG.info("(SafariProtection+BackgroundFetch) - updateFilters start")

        workingQueue.async { [weak self] in
            guard let self = self else { return }

            var safariFiltersUpdateError: Error?
            var dnsFiltersUpdateError: Error?
            let group = DispatchGroup()

            // Update Safari filters
            group.enter()
            self.filters.updateAllMeta(forcibly: true) { result in
                switch result {
                case .success(_): safariFiltersUpdateError = nil
                case .error(let error): safariFiltersUpdateError = error
                }
                group.leave()
            }

            // Update DNS filters
            if let dnsUpdater = self.dnsBackgroundFetchUpdater {
                group.enter()
                dnsUpdater.updateFiltersInBackground { error in
                    dnsFiltersUpdateError = error
                    group.leave()
                }
            }

            // On Safari and DNS filters updated
            group.notify(queue: self.completionQueue) { [weak self] in
                guard let self = self else { return }

                let oldState = self.currentBackgroundFetchState

                // Successfully updated
                if safariFiltersUpdateError == nil && dnsFiltersUpdateError == nil {
                    self.currentBackgroundFetchState = .convertFilters
                    let result = BackgroundFetchUpdateResult(
                        backgroundFetchResult: .newData,
                        newBackgroundFetchState: .convertFilters,
                        oldBackgroundFetchState: oldState,
                        error: nil
                    )
                    LOG.info("(SafariProtection+BackgroundFetch) - updateFilters; Filters were successfully loaded and saved; Update result: \(result)")
                    onFiltersUpdated(result)
                    return
                }

                // Failed to update
                if let error = safariFiltersUpdateError {
                    LOG.error("(SafariProtection+BackgroundFetch) - updateFilters; Safari update error: \(error)")

                }
                if let error = dnsFiltersUpdateError {
                    LOG.error("(SafariProtection+BackgroundFetch) - updateFilters; DNS update error: \(error)")
                }
                let result = BackgroundFetchUpdateResult(
                    backgroundFetchResult: .noData,
                    newBackgroundFetchState: oldState,
                    oldBackgroundFetchState: oldState,
                    error: CommonError.error(message: "Background fetch update failed")
                )
                onFiltersUpdated(result)
            }
        }
    }

    // 2nd step of the background update
    private func convertFilters(_ onFiltersConverted: @escaping (_ result: BackgroundFetchUpdateResult) -> Void) {
        LOG.info("(SafariProtection+BackgroundFetch) - convertFiltersInBackground start")

        cbQueue.async {
            let oldState = self.currentBackgroundFetchState
            do {
                let convertedFilters = self.converter.convertFiltersAndUserRulesToJsons()
                try self.cbStorage.save(converterResults: convertedFilters)
                self.currentBackgroundFetchState = .reloadContentBlockers
                LOG.info("(SafariProtection+BackgroundFetch) - convertFilters; Successfully converted all filters to JSONs")
                let result = BackgroundFetchUpdateResult(
                        backgroundFetchResult: .newData,
                        newBackgroundFetchState: .reloadContentBlockers,
                        oldBackgroundFetchState: oldState,
                        error: nil)
                self.completionQueue.async { onFiltersConverted(result) }
            } catch {
                LOG.error("(SafariProtection+BackgroundFetch) - convertFilters; Error converting filters: \(error)")
                let result = BackgroundFetchUpdateResult(
                        backgroundFetchResult: .noData,
                        newBackgroundFetchState: oldState,
                        oldBackgroundFetchState: oldState,
                        error: error)
                self.completionQueue.async { onFiltersConverted(result) }
            }
        }
    }

    // 3rd step of background update
    private func reloadContentBlockers(_ onCbReloaded: @escaping (_ result: BackgroundFetchUpdateResult) -> Void) {
        LOG.info("(SafariProtection+BackgroundFetch) - reloadContentBlockers start")

        cbQueue.async { [weak self] in
            self?.cbService.updateContentBlockers { [weak self] error in
                guard let self = self else { return }

                let oldState = self.currentBackgroundFetchState

                if let error = error {
                    LOG.error("(SafariProtection+BackgroundFetch) - reloadContentBlockers; Error reloading CBs: \(error)")
                    let result = BackgroundFetchUpdateResult(
                        backgroundFetchResult: .noData,
                        newBackgroundFetchState: oldState,
                        oldBackgroundFetchState: oldState,
                        error: error
                    )
                    self.completionQueue.async { onCbReloaded(result) }
                } else {
                    LOG.info("(SafariProtection+BackgroundFetch) - reloadContentBlockers; Successfully reloaded all CBs")
                    self.currentBackgroundFetchState = .updateFinished
                    let result = BackgroundFetchUpdateResult(
                        backgroundFetchResult: .newData,
                        newBackgroundFetchState: .updateFinished,
                        oldBackgroundFetchState: oldState,
                        error: error
                    )
                    self.completionQueue.async { onCbReloaded(result) }
                }
            }
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + currentBackgroundFetchState

fileprivate extension UserDefaultsStorageProtocol {

    private var currentBackgroundFetchStateKey: String { "AdGuardSDK.currentBackgroundFetchStateKey" }

    var currentBackgroundFetchState: BackgroundFetchState {
        get {
            if let intObject = storage.value(forKey: currentBackgroundFetchStateKey) as? Int {
                return BackgroundFetchState(rawValue: intObject) ?? .updateFinished
            }
            return .updateFinished
        }
        set {
            storage.setValue(newValue.rawValue, forKey: currentBackgroundFetchStateKey)
        }
    }
}
