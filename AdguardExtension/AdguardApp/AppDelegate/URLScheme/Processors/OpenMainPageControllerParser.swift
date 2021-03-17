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

struct OpenMainPageControllerParser: IURLSchemeParametersParser {
    private let executor: IURLSchemeExecutor
    
    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }
    
    func parse(parameters: [String : Any]) -> Bool {
        guard let showLaunchScreen = parameters["showLaunchScreen"] as? Bool else { return false }
        if let url = parameters["url"] as? URL {
            let complexProtectionIsEnabled = protectionStateIsEnabled(url: url)
            return executor.openMainPageController(showLaunchScreen: showLaunchScreen, complexProtectionIsEnabled: complexProtectionIsEnabled)
        }
        return executor.openMainPageController(showLaunchScreen: showLaunchScreen, complexProtectionIsEnabled: nil)
    }
    
    private func protectionStateIsEnabled(url: URL) -> Bool? {
        if url.path.isEmpty { return nil }
        let suffix = String(url.path.suffix(url.path.count - 1))
        let parameters = suffix.split(separator: "/")
        
        let enabledString = String(parameters.first ?? "")
        let isSufixValid = enabledString == "on" || enabledString == "off"
        if isSufixValid {
            return enabledString == "on"
        }
        return nil
    }
}
