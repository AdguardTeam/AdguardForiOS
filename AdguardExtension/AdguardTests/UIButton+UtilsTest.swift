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

import XCTest

class UIButtonUtilsTest: XCTestCase {

    // MARK: - makeTitleTextUppercased function test
    
    func testMakeTitleTextUppercasedWithString() {
        let button = UIButton()
        let buttonTitle: String? = "Title"
        let uppercasedTitle: String? = "TITLE"
        
        button.setTitle(buttonTitle, for: .normal)
        button.makeTitleTextUppercased()
        
        let titleToCheck = button.title(for: .normal)
        XCTAssertEqual(uppercasedTitle, titleToCheck)
    }
    
    func testMakeTitleTextUppercasedWithEmptyString() {
        let button = UIButton()
        let buttonTitle: String? = ""
        let uppercasedTitle: String? = nil
        
        button.setTitle(buttonTitle, for: .normal)
        button.makeTitleTextUppercased()
        
        let titleToCheck = button.title(for: .normal)
        XCTAssertEqual(uppercasedTitle, titleToCheck)
    }
    
    func testMakeTitleTextUppercasedWithNil() {
        let button = UIButton()
        let buttonTitle: String? = nil
        let uppercasedTitle: String? = nil
        
        button.setTitle(buttonTitle, for: .normal)
        button.makeTitleTextUppercased()
        
        let titleToCheck = button.title(for: .normal)
        XCTAssertEqual(uppercasedTitle, titleToCheck)
    }
}
