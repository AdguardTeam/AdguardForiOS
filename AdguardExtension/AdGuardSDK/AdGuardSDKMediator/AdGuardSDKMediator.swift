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
    
    // MARK: - Initialization
    
    init(configuration: ConfigurationProtocol,
         filterFilesDirectoryUrl: URL,
         dbContainerUrl: URL,
         userDefaults: UserDefaults,
         jsonStorageUrl: URL) throws
    {
        let services = try ServiceLocator(configuration: configuration,
                                          filterFilesDirectoryUrl: filterFilesDirectoryUrl,
                                          dbContainerUrl: dbContainerUrl,
                                          userDefaults: userDefaults,
                                          jsonStorageUrl: jsonStorageUrl)
        
        self.configuration = configuration
        self.filters = services.filters
        self.converter = services.converter
        self.cbStorage = services.cbStorage
        self.cbService = services.cbService
        self.userRulesManagersProvider = services.userRulesManagersProvider
    }
    
    // MARK: - Public method
    
    public func reset(_ onResetFinished: @escaping (Error?) -> Void) {
        workingQueue.async {
            
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
