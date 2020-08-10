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

extension UIImage {
    /* Returns category image by category id  */
    static func getCategoryImage(withId id: Int?) -> UIImage? {
        guard let id = id else { return nil }
        switch id {
        case 3:
            return UIImage(named: "porn")
        case 4:
            return UIImage(named: "ads")
        case 6, 101:
            return UIImage(named: "trackers")
        case 7:
            return UIImage(named: "social")
        default:
            return nil
        }
    }
}
