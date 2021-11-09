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

public protocol SafariProtectionContentBlockersProtocol {
    /* Number of advanced rules that will be passed to Safari Web Extension */
    var advancedRulesCount: Int { get }

    /* Returns every content blocker reloading state */
    var reloadingContentBlockers: [ContentBlockerType: Bool] { get }

    /* Returns every content blocker state */
    var allContentBlockersStates: [ContentBlockerType: Bool] { get }

    /* Returns all content blocker conversion results */
    var allConverterResults: [ConverterResult] { get }

    /* Returns all content blocker JSON urls */
    var allContentBlockerJsonUrls: [URL] { get }

    /* Returns state of the specified content blocker */
    func getState(for cbType: ContentBlockerType) -> Bool
}

/* Extension is used get information about Safari Content Blockers and JSON files they use */
extension SafariProtection {
    public var advancedRulesCount: Int {
        return workingQueue.sync { return cbStorage.advancedRulesCount }
    }

    public var reloadingContentBlockers: [ContentBlockerType : Bool] {
        return workingQueue.sync { return cbService.reloadingContentBlockers }
    }

    public var allContentBlockersStates: [ContentBlockerType : Bool] {
        return workingQueue.sync { return cbService.allContentBlockersStates }
    }

    public var allConverterResults: [ConverterResult] {
        return workingQueue.sync { return cbStorage.allConverterResults }
    }

    public var allContentBlockerJsonUrls: [URL] {
        return ContentBlockerType.allCases.map { cbStorage.getJsonUrl(for: $0) }
    }

    public func getState(for cbType: ContentBlockerType) -> Bool {
        return workingQueue.sync {
            return cbService.getState(for: cbType)
        }
    }
}
