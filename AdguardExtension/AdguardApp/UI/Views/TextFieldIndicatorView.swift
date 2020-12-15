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

class TextFieldIndicatorView: UIView {
    
    enum TextFieldIndicatorViewState {
        case error, enabled, disabled
    }
    
    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    var state: TextFieldIndicatorViewState = .disabled {
        didSet {
            backgroundColor = stateColor
        }
    }
    
    private var stateColor: UIColor {
        switch state {
        case .error: return UIColor.AdGuardColor.red
        case .enabled: return theme.editLineSelectedColor
        case .disabled: return theme.editLineColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = stateColor
    }
}
