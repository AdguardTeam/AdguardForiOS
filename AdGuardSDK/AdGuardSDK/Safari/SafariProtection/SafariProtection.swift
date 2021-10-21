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
import class ContentBlockerConverter.WebExtensionHelpers
import protocol ContentBlockerConverter.WebExtensionHelpersProtocol

/// Reset protocol for safari protection
public protocol ResetableSafariProtectionAsyncProtocol: ResetableProtocol {
    /**
     Reset safari protection
     - Parameter withReloadCB: if true reload CB
     - Parameter onResetFinished: Closure return error if it occurred while reseting safari protection
     */
    func reset(withReloadCB: Bool, _ onResetFinished: @escaping (_ error: Error?) -> Void)
}

public typealias SafariProtectionProtocol = SafariProtectionFiltersProtocol
                                            & SafariProtectionUserRulesProtocol
                                            & SafariProtectionConfigurationProtocol
                                            & SafariProtectionContentBlockersProtocol
                                            & SafariProtectionBackgroundFetchProtocol
                                            & ResetableSafariProtectionAsyncProtocol

public final class SafariProtection: SafariProtectionProtocol {

    // MARK: - Internal variables

    // Serial queue to avoid races in services
    let workingQueue = DispatchQueue(label: "SafariAdGuardSDK.SafariProtection.workingQueue")

    // Serial queue for converting Content Blockers to avoid working queue load
    let cbQueue = DispatchQueue(label: "SafariAdGuardSDK.SafariProtection.cbQueue", qos: .background)

    // Queue to call completion handlers
    let completionQueue = DispatchQueue.main

    /* Services */
    var configuration: SafariConfigurationProtocol
    let userDefaults: UserDefaultsStorageProtocol
    let filters: FiltersServiceProtocol
    let converter: FiltersConverterServiceProtocol
    let cbStorage: ContentBlockersInfoStorageProtocol
    let cbService: ContentBlockerServiceProtocol
    let safariManagers: SafariUserRulesManagersProviderProtocol
    let converterHelper: WebExtensionHelpersProtocol
    let dnsBackgroundFetchUpdater: DnsBackgroundFetchUpdateProtocol?
    private let defaultConfiguration: SafariConfigurationProtocol

    // MARK: - Initialization

    /**
     Mediator object that controls all SDK. Every call to SDK must go through this object
     - Parameter configuration: Current application configuration
     - Parameter defaultConfiguration: Сonfiguration that will replace the current one when resetting the settings, a copy of passed object will be made
     - Parameter filterFilesDirectoryUrl: Directory URL where SDK should store filter files
     - Parameter dbContainerUrl: Directory URL where db files should be located
     - Parameter jsonStorageUrl: Directory URL where Content Blockers JSON files should be stored
     - Parameter userDefaults: UserDefaults objects where SDK will store temporary variables
     - Throws: Can throw an error if initialization of one of inner services fails
     */
    public init(configuration: SafariConfigurationProtocol,
                defaultConfiguration: SafariConfigurationProtocol,
                filterFilesDirectoryUrl: URL,
                dbContainerUrl: URL,
                jsonStorageUrl: URL,
                userDefaults: UserDefaults,
                dnsBackgroundFetchUpdater: DnsBackgroundFetchUpdateProtocol? = nil) throws
    {
        let services = try ServicesStorage(configuration: configuration,
                                          filterFilesDirectoryUrl: filterFilesDirectoryUrl,
                                          dbContainerUrl: dbContainerUrl,
                                          userDefaults: userDefaults,
                                          jsonStorageUrl: jsonStorageUrl)

        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration
        self.userDefaults = services.userDefaults
        self.filters = services.filters
        self.converter = services.converter
        self.cbStorage = services.cbStorage
        self.cbService = services.cbService
        self.safariManagers = services.safariManagers
        self.converterHelper = WebExtensionHelpers()
        self.dnsBackgroundFetchUpdater = dnsBackgroundFetchUpdater
    }

    // Initializer for tests
    init(configuration: SafariConfigurationProtocol,
         defaultConfiguration: SafariConfigurationProtocol,
         userDefaults: UserDefaultsStorageProtocol,
         filters: FiltersServiceProtocol,
         converter: FiltersConverterServiceProtocol,
         cbStorage: ContentBlockersInfoStorageProtocol,
         cbService: ContentBlockerServiceProtocol,
         safariManagers: SafariUserRulesManagersProviderProtocol,
         converterHelper: WebExtensionHelpersProtocol = WebExtensionHelpers(),
         dnsBackgroundFetchUpdater: DnsBackgroundFetchUpdateProtocol? = nil
    ) {
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration
        self.userDefaults = userDefaults
        self.filters = filters
        self.converter = converter
        self.cbStorage = cbStorage
        self.cbService = cbService
        self.safariManagers = safariManagers
        self.converterHelper = converterHelper
        self.dnsBackgroundFetchUpdater = dnsBackgroundFetchUpdater
    }

    // MARK: - Public method

    /* Resets all sdk to default configuration. Deletes all stored filters, filters meta and user rules */
    public func reset(withReloadCB: Bool, _ onResetFinished: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection) - reset; self is missing!")
                DispatchQueue.main.async { onResetFinished(CommonError.missingSelf) }
                return
            }

            Logger.logInfo("(SafariProtection) - reset start")

            //Update config with default configuration
            self.configuration.updateConfig(with: self.defaultConfiguration)

            // Update filters meta
            var filtersError: Error?
            let group = DispatchGroup()
            group.enter()
            self.filters.reset { error in
                filtersError = error
                group.leave()
            }
            group.wait()

            guard filtersError == nil else {
                Logger.logError("(SafariProtection) - reset; Error reseting filters service; Error: \(filtersError!)")
                self.completionQueue.async { onResetFinished(filtersError) }
                return
            }

            do {
                Logger.logInfo("(SafariProtection) - reset; filters service was reset")

                try self.safariManagers.reset()
                Logger.logInfo("(SafariProtection) - reset; user rules managers were reset")

                try self.cbStorage.reset()
                Logger.logInfo("(SafariProtection) - reset; CB storage was reset")
            } catch {
                Logger.logError("(SafariProtection) - reset; Error reseting one of the service; Error: \(error)")
                self.completionQueue.async { onResetFinished(error) }
                return
            }

            guard withReloadCB else {
                return self.completionQueue.async { onResetFinished(nil) }
            }

            self.reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(SafariProtection) - reset; Error reloading CBs after reset; Error: \(error)")
                } else {
                    Logger.logInfo("(SafariProtection) - reset; Successfully reloaded CB after reset")
                }
                self.completionQueue.async { onResetFinished(error) }
            }
        }
    }

    // MARK: - Internal methods

    /* Executes block that leads to CB JSON files changes, after that reloads CBs */
    func executeBlockAndReloadCbs(block: () throws -> Void, onCbReloaded: @escaping (_ error: Error?) -> Void) rethrows {
        do {
            try block()
        }
        catch {
            Logger.logError("(SafariProtection) - createNewCbJsonsAndReloadCbs; Error: \(error)")
            onCbReloaded(error)
            throw error
        }

        reloadContentBlockers(onCbReloaded: onCbReloaded)
    }

    /* Creates JSON files for Content blockers and reloads CBs to apply new JSONs */
    func reloadContentBlockers(onCbReloaded: @escaping (_ error: Error?) -> Void) {
        cbQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection) - reloadContentBlockers; self is missing!")
                onCbReloaded(CommonError.missingSelf)
                return
            }

            do {
                let convertedfilters = self.converter.convertFiltersAndUserRulesToJsons()
                try self.cbStorage.save(converterResults: convertedfilters)
            }
            catch {
                Logger.logError("(SafariProtection) - createNewCbJsonsAndReloadCbs; Error converting filters: \(error)")
                self.workingQueue.sync { onCbReloaded(error) }
                return
            }

            // TODO: - Can be improved
            // This flag is set when advanced rules are converted and saved to file
            // Now it is done for messaging in Safari Web extension as we haven't found another solution yet
            self.userDefaults.shouldUpdateAdvancedRules = true

            self.cbService.updateContentBlockers { [weak self] error in
                guard let self = self else {
                    Logger.logError("(SafariProtection) - reloadContentBlockers; self is missing!")
                    self?.workingQueue.sync { onCbReloaded(CommonError.missingSelf) }
                    return
                }

                self.workingQueue.sync { onCbReloaded(error) }
            }
        }
    }
}

// MARK: - UserDefaultsStorageProtocol + shouldUpdateAdvancedRulesKey

fileprivate extension UserDefaultsStorageProtocol {

    private var shouldUpdateAdvancedRulesKey: String { "SafariAdGuardSDK.shouldUpdateAdvancedRulesKey" }

    /// Returns true if advanced protection rules should be updated
    var shouldUpdateAdvancedRules: Bool {
        get {
            storage.bool(forKey: shouldUpdateAdvancedRulesKey)
        }
        set {
            storage.set(newValue, forKey: shouldUpdateAdvancedRulesKey)
        }
    }
}
