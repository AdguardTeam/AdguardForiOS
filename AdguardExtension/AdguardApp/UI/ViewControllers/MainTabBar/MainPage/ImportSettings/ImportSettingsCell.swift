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

protocol ImportSettingsCellDelegate: class {
    func stateChanged(tag: Int, state: Bool)
}

class ImportSettingsCell: UITableViewCell {
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var title: ThemableLabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var subtitleTopConstraint: NSLayoutConstraint!
    
    weak var delegate: ImportSettingsCellDelegate?
    
    @IBAction func checkAction(_ sender: Any) {
        let newState = !check.isHighlighted
        check.isHighlighted = newState
        delegate?.stateChanged(tag: self.tag, state: newState)
    }
}
