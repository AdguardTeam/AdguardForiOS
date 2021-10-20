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
import NetworkExtension

class NetworkSettingsServiceMock: NetworkSettingsServiceProtocol {

    var invokedExceptionsGetter = false
    var invokedExceptionsGetterCount = 0
    var stubbedExceptions: [WifiException]! = []

    var exceptions: [WifiException] {
        invokedExceptionsGetter = true
        invokedExceptionsGetterCount += 1
        return stubbedExceptions
    }

    var invokedEnabledExceptionsGetter = false
    var invokedEnabledExceptionsGetterCount = 0
    var stubbedEnabledExceptions: [WifiException]! = []

    var enabledExceptions: [WifiException] {
        invokedEnabledExceptionsGetter = true
        invokedEnabledExceptionsGetterCount += 1
        return stubbedEnabledExceptions
    }

    var invokedFilterWifiDataEnabledSetter = false
    var invokedFilterWifiDataEnabledSetterCount = 0
    var invokedFilterWifiDataEnabled: Bool?
    var invokedFilterWifiDataEnabledList = [Bool]()
    var invokedFilterWifiDataEnabledGetter = false
    var invokedFilterWifiDataEnabledGetterCount = 0
    var stubbedFilterWifiDataEnabled: Bool! = false

    var filterWifiDataEnabled: Bool {
        set {
            invokedFilterWifiDataEnabledSetter = true
            invokedFilterWifiDataEnabledSetterCount += 1
            invokedFilterWifiDataEnabled = newValue
            invokedFilterWifiDataEnabledList.append(newValue)
        }
        get {
            invokedFilterWifiDataEnabledGetter = true
            invokedFilterWifiDataEnabledGetterCount += 1
            return stubbedFilterWifiDataEnabled
        }
    }

    var invokedFilterMobileDataEnabledSetter = false
    var invokedFilterMobileDataEnabledSetterCount = 0
    var invokedFilterMobileDataEnabled: Bool?
    var invokedFilterMobileDataEnabledList = [Bool]()
    var invokedFilterMobileDataEnabledGetter = false
    var invokedFilterMobileDataEnabledGetterCount = 0
    var stubbedFilterMobileDataEnabled: Bool! = false

    var filterMobileDataEnabled: Bool {
        set {
            invokedFilterMobileDataEnabledSetter = true
            invokedFilterMobileDataEnabledSetterCount += 1
            invokedFilterMobileDataEnabled = newValue
            invokedFilterMobileDataEnabledList.append(newValue)
        }
        get {
            invokedFilterMobileDataEnabledGetter = true
            invokedFilterMobileDataEnabledGetterCount += 1
            return stubbedFilterMobileDataEnabled
        }
    }

    var invokedDelegateSetter = false
    var invokedDelegateSetterCount = 0
    var invokedDelegate: NetworkSettingsChangedDelegate?
    var invokedDelegateList = [NetworkSettingsChangedDelegate?]()
    var invokedDelegateGetter = false
    var invokedDelegateGetterCount = 0
    var stubbedDelegate: NetworkSettingsChangedDelegate!

    var delegate: NetworkSettingsChangedDelegate? {
        set {
            invokedDelegateSetter = true
            invokedDelegateSetterCount += 1
            invokedDelegate = newValue
            invokedDelegateList.append(newValue)
        }
        get {
            invokedDelegateGetter = true
            invokedDelegateGetterCount += 1
            return stubbedDelegate
        }
    }

    var invokedOnDemandRulesGetter = false
    var invokedOnDemandRulesGetterCount = 0
    var stubbedOnDemandRules: [NEOnDemandRule]! = []

    var onDemandRules: [NEOnDemandRule] {
        invokedOnDemandRulesGetter = true
        invokedOnDemandRulesGetterCount += 1
        return stubbedOnDemandRules
    }

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (exception: WifiException, Void)?
    var invokedAddParametersList = [(exception: WifiException, Void)]()
    var stubbedAddError: Error?

    func add(exception: WifiException) throws {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (exception, ())
        invokedAddParametersList.append((exception, ()))
        if let error = stubbedAddError {
            throw error
        }
    }

    var invokedDelete = false
    var invokedDeleteCount = 0
    var invokedDeleteParameters: (exception: WifiException, Void)?
    var invokedDeleteParametersList = [(exception: WifiException, Void)]()

    func delete(exception: WifiException) {
        invokedDelete = true
        invokedDeleteCount += 1
        invokedDeleteParameters = (exception, ())
        invokedDeleteParametersList.append((exception, ()))
    }

    var invokedRename = false
    var invokedRenameCount = 0
    var invokedRenameParameters: (oldName: String, newName: String)?
    var invokedRenameParametersList = [(oldName: String, newName: String)]()
    var stubbedRenameError: Error?

    func rename(oldName: String, newName: String) throws {
        invokedRename = true
        invokedRenameCount += 1
        invokedRenameParameters = (oldName, newName)
        invokedRenameParametersList.append((oldName, newName))
        if let error = stubbedRenameError {
            throw error
        }
    }

    var invokedChangeState = false
    var invokedChangeStateCount = 0
    var invokedChangeStateParameters: (name: String, enabled: Bool)?
    var invokedChangeStateParametersList = [(name: String, enabled: Bool)]()

    func changeState(name: String, enabled: Bool) {
        invokedChangeState = true
        invokedChangeStateCount += 1
        invokedChangeStateParameters = (name, enabled)
        invokedChangeStateParametersList.append((name, enabled))
    }

    var invokedFetchCurrentWiFiName = false
    var invokedFetchCurrentWiFiNameCount = 0
    var stubbedFetchCurrentWiFiNameCompletionHandlerResult: (String?, Void)?

    func fetchCurrentWiFiName(_ completionHandler: @escaping (String?)->Void) {
        invokedFetchCurrentWiFiName = true
        invokedFetchCurrentWiFiNameCount += 1
        if let result = stubbedFetchCurrentWiFiNameCompletionHandlerResult {
            completionHandler(result.0)
        }
    }
}
