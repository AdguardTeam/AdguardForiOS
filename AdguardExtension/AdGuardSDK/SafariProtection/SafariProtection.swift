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

import Foundation

public typealias SafariProtectionProtocol = SafariProtectionFiltersProtocol
                                            & SafariProtectionUserRulesProtocol
                                            & SafariProtectionConfigurationProtocol
                                            & SafariProtectionContentBlockersProtocol
                                            & SafariProtectionBackgroundFetchProtocol
                                            & ResetableAsyncProtocol
    
public final class SafariProtection: SafariProtectionProtocol {
    
    // MARK: - Internal variables
    
    // Serial queue to avoid races in services
    let workingQueue = DispatchQueue(label: "AdGuardSDK.SafariProtection.workingQueue")
    // Queue to call completion handlers
    let completionQueue = DispatchQueue.main
    
    /* Services */
    var configuration: ConfigurationProtocol
    let userDefaults: UserDefaultsStorageProtocol
    let filters: FiltersServiceProtocol
    let converter: FiltersConverterServiceProtocol
    let cbStorage: ContentBlockersInfoStorage
    let cbService: ContentBlockerServiceProtocol
    let userRulesManagersProvider: UserRulesManagersProviderProtocol
    private let defaultConfiguration: ConfigurationProtocol
    
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
    public init(configuration: ConfigurationProtocol,
                defaultConfiguration: ConfigurationProtocol,
                filterFilesDirectoryUrl: URL,
                dbContainerUrl: URL,
                jsonStorageUrl: URL,
                userDefaults: UserDefaults) throws
    {
        let services = try ServicesStorage(configuration: configuration,
                                          filterFilesDirectoryUrl: filterFilesDirectoryUrl,
                                          dbContainerUrl: dbContainerUrl,
                                          userDefaults: userDefaults,
                                          jsonStorageUrl: jsonStorageUrl)
        
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration.copy
        self.userDefaults = services.userDefaults
        self.filters = services.filters
        self.converter = services.converter
        self.cbStorage = services.cbStorage
        self.cbService = services.cbService
        self.userRulesManagersProvider = services.userRulesManagersProvider
    }
    
    // Initializer for tests
    init(configuration: ConfigurationProtocol,
         defaultConfiguration: ConfigurationProtocol,
         userDefaults: UserDefaultsStorageProtocol,
         filters: FiltersServiceProtocol,
         converter: FiltersConverterServiceProtocol,
         cbStorage: ContentBlockersInfoStorage,
         cbService: ContentBlockerServiceProtocol,
         userRulesManagersProvider: UserRulesManagersProviderProtocol)
    {
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration
        self.userDefaults = userDefaults
        self.filters = filters
        self.converter = converter
        self.cbStorage = cbStorage
        self.cbService = cbService
        self.userRulesManagersProvider = userRulesManagersProvider
    }
    
    // MARK: - Public method
    
    /* Resets all sdk to default configuration. Deletes all stored filters, filters meta ans user rules */
    public func reset(_ onResetFinished: @escaping (Error?) -> Void) {
        workingQueue.async { [weak self] in
            guard let self = self else {
                Logger.logError("(SafariProtection) - reset; self is missing!")
                DispatchQueue.main.async { onResetFinished(CommonError.missingSelf) }
                return
            }
            
            Logger.logInfo("(SafariProtection) - reset start")
            
            // Update filters meta; Ignore it's error and continue to reset
            let group = DispatchGroup()
            group.enter()
            self.filters.reset { _ in
                group.leave()
            }
            group.wait()
            
            do {
                Logger.logInfo("(SafariProtection) - reset; filters service was reset")
                
                try self.userRulesManagersProvider.reset()
                Logger.logInfo("(SafariProtection) - reset; user rules managers were reset")
                
                try self.cbStorage.reset()
                Logger.logInfo("(SafariProtection) - reset; CB storage was reset")
            } catch {
                Logger.logError("(SafariProtection) - reset; Error reseting one of the service; Error: \(error)")
                self.completionQueue.async { onResetFinished(error) }
                return
            }
            
            self.configuration = self.defaultConfiguration.copy
            
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
    func executeBlockAndReloadCbs(block: () throws -> Void, onCbReloaded: @escaping (_ error: Error?) -> Void) {
        do {
            try block()
        }
        catch {
            Logger.logError("(SafariProtection) - createNewCbJsonsAndReloadCbs; Error: \(error)")
            onCbReloaded(error)
            return
        }
        
        reloadContentBlockers(onCbReloaded: onCbReloaded)
    }
    
    /* Creates JSON files for Content blockers and reloads CBs to apply new JSONs */
    func reloadContentBlockers(onCbReloaded: @escaping (_ error: Error?) -> Void) {
        do {
            let convertedfilters = try converter.convertFiltersAndUserRulesToJsons()
            try cbStorage.save(cbInfos: convertedfilters)
        }
        catch {
            Logger.logError("(SafariProtection) - createNewCbJsonsAndReloadCbs; Error conveerting filters: \(error)")
            onCbReloaded(error)
            return
        }
        
        cbService.updateContentBlockers { [weak self] error in
            guard let self = self else {
                Logger.logError("(SafariProtection) - reloadContentBlockers; self is missing!")
                onCbReloaded(CommonError.missingSelf)
                return
            }
            
            self.workingQueue.sync { onCbReloaded(error) }
        }
    }
}
