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

public typealias AdGuardSDKMediatorProtocol = AdGuardSDKMediatorFiltersProtocol
                                            & AdGuardSDKMediatorUserRulesProtocol
                                            & AdGuardSDKMediatorConfigurationProtocol
                                            & AdGuardSDKMediatorContentBlockersProtocol
                                            & ResetableProtocol
    
public final class AdGuardSDKMediator: AdGuardSDKMediatorProtocol {
    
    // MARK: - Internal variables
    
    // Serial queue to avoid races in services
    let workingQueue = DispatchQueue(label: "AdGuardSDK.AdGuardSDKMediator.workingQueue")
    // Queue to call completion handlers
    let completionQueue = DispatchQueue.main
    
    /* Services */
    var configuration: ConfigurationProtocol
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
        let services = try ServiceLocator(configuration: configuration,
                                          filterFilesDirectoryUrl: filterFilesDirectoryUrl,
                                          dbContainerUrl: dbContainerUrl,
                                          userDefaults: userDefaults,
                                          jsonStorageUrl: jsonStorageUrl)
        
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration.copy
        self.filters = services.filters
        self.converter = services.converter
        self.cbStorage = services.cbStorage
        self.cbService = services.cbService
        self.userRulesManagersProvider = services.userRulesManagersProvider
    }
    
    // Initializer for tests
    init(configuration: ConfigurationProtocol,
         defaultConfiguration: ConfigurationProtocol,
         filters: FiltersServiceProtocol,
         converter: FiltersConverterServiceProtocol,
         cbStorage: ContentBlockersInfoStorage,
         cbService: ContentBlockerServiceProtocol,
         userRulesManagersProvider: UserRulesManagersProviderProtocol)
    {
        self.configuration = configuration
        self.defaultConfiguration = defaultConfiguration
        self.filters = filters
        self.converter = converter
        self.cbStorage = cbStorage
        self.cbService = cbService
        self.userRulesManagersProvider = userRulesManagersProvider
    }
    
    // MARK: - Public method
    
    public func reset(_ onResetFinished: @escaping (Error?) -> Void) {
        workingQueue.async { [unowned self] in
            var resultErrors: [Error] = []
            
            var filtersError: Error?
            filters.reset { error in
                filtersError = error
            }
            
            if let filtersError = filtersError {
                Logger.logError("(AdGuardSDKMediator) - reset; Error reseting filters service; Error: \(filtersError)")
                resultErrors.append(filtersError)
            } else {
                Logger.logInfo("(AdGuardSDKMediator) - reset; Successfully reset filters service")
            }
            
            var userRulesError: Error?
            userRulesManagersProvider.reset { error in
                userRulesError = error
            }
            
            if let userRulesError = userRulesError {
                Logger.logError("(AdGuardSDKMediator) - reset; Error reseting user rules service; Error: \(userRulesError)")
                resultErrors.append(userRulesError)
            } else {
                Logger.logInfo("(AdGuardSDKMediator) - reset; Successfully reset user rules service")
            }
            
            var cbStorageError: Error?
            cbStorage.reset { error in
                cbStorageError = error
            }
            
            if let cbStorageError = cbStorageError {
                Logger.logError("(AdGuardSDKMediator) - reset; Error reseting CB storage service; Error: \(cbStorageError)")
                resultErrors.append(cbStorageError)
            } else {
                Logger.logInfo("(AdGuardSDKMediator) - reset; Successfully reset CB storage service")
            }
            
            configuration = defaultConfiguration.copy
            
            reloadContentBlockers { error in
                if let error = error {
                    Logger.logError("(AdGuardSDKMediator) - reset; Error reloading CBs after reset; Error: \(error)")
                    onResetFinished(error)
                } else {
                    Logger.logInfo("(AdGuardSDKMediator) - reset; Successfully reloaded CB after reset")
                    onResetFinished(resultErrors.first) // Return any error if some occured
                }
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
            Logger.logError("(AdGuardSDKMediator) - createNewCbJsonsAndReloadCbs; Error: \(error)")
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
            Logger.logError("(AdGuardSDKMediator) - createNewCbJsonsAndReloadCbs; Error conveerting filters: \(error)")
            onCbReloaded(error)
            return
        }
        
        cbService.updateContentBlockers { [unowned self] error in
            workingQueue.sync { onCbReloaded(error) }
        }
    }
}
