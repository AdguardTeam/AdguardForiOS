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

protocol TagButtonTappedDelegate: AnyObject {
    func tagButtonTapped(_ sender: TagButton)
}

protocol FilterTagsViewModel: AnyObject {
    var delegate: TagButtonTappedDelegate? { get set }
}

protocol SendTagNameButtonProtocol: FilterTagsViewModel {
    var name: String? { get set }
    func sendName(_ sender: TagButton)
}

class TagButton: RoundRectButton, SendTagNameButtonProtocol{
    
    init() {
        super.init(frame: .zero)
        addTarget(self, action: #selector(self.sendName(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: TagButtonTappedDelegate?
    
    var name: String?
    
    @objc func sendName(_ sender: TagButton) {
        delegate?.tagButtonTapped(sender)
    }
}
