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
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses>.
*/

import Foundation
import UIKit.UIDevice
import CoreTelephony

/// This object is responsible for providing information whether the user is from China or not
/// For more info contact iOS team
final class ChineseUserExposer {

    static let isUserFromChina: Bool = {
        return hasChineseLanguageInSystem
            || hasChineseCarrier
            || hasChineseKeybord
    }()

    private static var hasChineseLanguageInSystem: Bool {
        let langId = Locale.current.identifier
        return langId.lowercased().contains("zh")
    }

    private static var hasChineseCarrier: Bool {
        var providers: [CTCarrier] = []
        if #available(iOS 12.0, *) {
            if let carriers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
                providers = Array(carriers.values)
            }
        } else {
            if let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider {
                providers = [carrier]
            }
        }

        // All ISO codes can be found here https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
        let chineseIsoCodes = ["cn", "chn", "hk", "hkg", "mo", "mac", "tw", "twn"]
        return providers.reduce(false) { partialResult, carrier in
            if let isoCode = carrier.isoCountryCode {
                return chineseIsoCodes.contains(isoCode.lowercased())
            }
            return partialResult || false
        }
    }

    private static var hasChineseKeybord: Bool {
        let keyboards = UITextInputMode.activeInputModes
        return keyboards.reduce(false) { partialResult, inputMode in
            if let primary = inputMode.primaryLanguage {
                return partialResult || primary.lowercased().contains("zh")
            }
            return partialResult || false
        }
    }
}
