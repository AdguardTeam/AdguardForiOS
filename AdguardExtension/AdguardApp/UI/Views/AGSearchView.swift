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

protocol AGSearchViewDelegate: AnyObject {
    func textChanged(to newText: String)
}

final class AGSearchView: UIView {

    weak var delegate: AGSearchViewDelegate?

    let textField: AGTextField = {
        let textField = AGTextField()
        textField.leftTextAreaOffset = 16.0
        textField.rightTextAreaOffset = 16.0
        textField.textFieldType = .normal
        textField.placeholder = String.localizedString("search_view_placeholder")
        return textField
    }()

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    init() {
        super.init(frame: .zero)
        customInit()
    }

    // MARK: - Private methods

    private func customInit() {
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView?.isHidden = true
        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 48.0),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ])

        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
}

extension AGSearchView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        delegate?.textChanged(to: updatedText)

        self.textField.borderState = .enabled
        self.textField.rightView?.isHidden = updatedText.isEmpty
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textField.borderState = .enabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textField.borderState = .disabled
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        self.textField.borderState = .disabled
        return true
    }
}

extension AGSearchView: ThemableProtocol {
    func updateTheme() {
        backgroundColor = themeService.backgroundColor
        textField.themeChanged()
        textField.tintColor = themeService.grayTextColor
        textField.backgroundColor = themeService.selectedCellColor
        textField.textColor = themeService.grayTextColor
    }
}


