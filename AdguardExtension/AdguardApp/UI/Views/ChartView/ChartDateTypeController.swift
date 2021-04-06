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

protocol DateTypeChangedProtocol: class {
    func dateTypeChanged(dateType: ChartDateType)
}

class ChartDateTypeController: BottomAlertController {
    
    @IBOutlet weak var periodLabel: ThemableLabel!
    @IBOutlet weak var content: UIView!
    
    @IBOutlet var buttons: [RoundRectButton]!
    @IBOutlet var separators: [UIView]!
    
    weak var delegate: DateTypeChangedProtocol?
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let todayTag = 0
    private let oneDayTag = 1
    private let weekTag = 2
    private let monthTag = 3
    private let allTimeTag = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
    }
    
    @IBAction func charDataTypeAction(_ sender: UIButton) {
        
        switch sender.tag {
        case todayTag:
            delegate?.dateTypeChanged(dateType: .today)
        case oneDayTag:
            delegate?.dateTypeChanged(dateType: .day)
        case weekTag:
            delegate?.dateTypeChanged(dateType: .week)
        case monthTag:
            delegate?.dateTypeChanged(dateType: .month)
        case allTimeTag:
            delegate?.dateTypeChanged(dateType: .alltime)
        default:
            break
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ChartDateTypeController: ThemableProtocol {
    func updateTheme() {
        contentView.backgroundColor = theme.popupBackgroundColor
        periodLabel.textColor = theme.popupTitleTextColor
        theme.setupSeparators(separators)
        for button in buttons {
            button.setTitleColor(theme.grayTextColor, for: .normal)
        }
    }
}
