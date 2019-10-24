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

class StatusView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupLabel()
    }
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    private let textLabel: UILabel = UILabel()
    
    private func setupView(){
        frame.size.height = 16.0
        backgroundColor = UIColor(hexString: "#d8d8d8")
    }
    
    private func setupLabel(){
        textLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        textLabel.textColor = UIColor(hexString: "#4d4d4d")
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 1
    
        addSubview(textLabel)
        
        textLabel.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 16.0)
    }
}
