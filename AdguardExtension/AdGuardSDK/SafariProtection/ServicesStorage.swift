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

protocol ServicesStorageProtocol {
    var configuration: ConfigurationProtocol { get }
    var userDefaults: UserDefaultsStorageProtocol { get }
    var userRulesManagersProvider: UserRulesManagersProviderProtocol { get }
    var cbStorage: ContentBlockersInfoStorage { get }
    var cbService: ContentBlockerServiceProtocol { get }
    var filters: FiltersServiceProtocol { get }
    var converter: FiltersConverterServiceProtocol { get }
}

final class ServicesStorage: ServicesStorageProtocol {
    
    let configuration: ConfigurationProtocol
    let userDefaults: UserDefaultsStorageProtocol
    let userRulesManagersProvider: UserRulesManagersProviderProtocol
    let cbStorage: ContentBlockersInfoStorage
    let cbService: ContentBlockerServiceProtocol
    let filters: FiltersServiceProtocol
    let converter: FiltersConverterServiceProtocol

    init(configuration: ConfigurationProtocol,
         filterFilesDirectoryUrl: URL,
         dbContainerUrl: URL,
         userDefaults: UserDefaults,
         jsonStorageUrl: URL) throws
    {
        let filterFilesStorage = try FilterFilesStorage(filterFilesDirectoryUrl: filterFilesDirectoryUrl)
        let productionDbManager = try ProductionDatabaseManager(dbContainerUrl: dbContainerUrl)
        let metaStorage = MetaStorage(productionDbManager: productionDbManager)
        let apiMethods = ApiMethods()
        
        self.userDefaults = UserDefaultsStorage(storage: userDefaults)
        
        self.configuration = configuration
        
        self.userRulesManagersProvider = UserRulesManagersProvider(userDefaultsStorage: self.userDefaults)
        
        self.cbStorage = try ContentBlockersInfoStorage(jsonStorageUrl: jsonStorageUrl,
                                                        userDefaultsStorage: self.userDefaults)
        
        self.cbService = ContentBlockerService(configuration: self.configuration,
                                               jsonStorage: self.cbStorage)
        
        self.filters = try FiltersService(configuration: self.configuration,
                                          filterFilesStorage: filterFilesStorage,
                                          metaStorage: metaStorage,
                                          userDefaultsStorage: self.userDefaults,
                                          apiMethods: apiMethods)
        
        self.converter = FiltersConverterService(configuration: self.configuration,
                                                 filtersService: self.filters,
                                                 filterFilesStorage: filterFilesStorage,
                                                 userRulesManagersProvider: userRulesManagersProvider)
    }
}
