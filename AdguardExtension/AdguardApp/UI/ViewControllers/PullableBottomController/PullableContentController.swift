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

import UIKit

class PullableContentController: UIViewController {
    
    /*
     True if pullable view is in the lowest positiion
     False if pullable view is in the highest position
     Nil if pullable view is in the process of transition between states
     */
    private(set) var isCompact: Bool? = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func parentViewWillTransitionToCompactSize() {
        isCompact = nil
    }
    
    func parentViewDidTransitionToCompactSize() {
        isCompact = true
    }
    
    func parentViewWillTransitionToFullSize() {
        isCompact = nil
    }
    
    func parentViewDidTransitionToFullSize() {
        isCompact = false
    }
    
    func parentViewIsTransitioning(percent: CGFloat) {
        
    }
}
