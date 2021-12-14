//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

protocol AGTextFieldOnDeleBackwardDelegate: AnyObject {
    /// Called when remove button tapped on keyboard
    func didDeleteBackward(newText: String?)
}

class AGTextField: UITextField {

    enum TextSecurityType {
        case normal
        case secure

        var defaultImages: [UIControl.State.RawValue: UIImage] {
            switch self {
            case .normal: return [UIControl.State.normal.rawValue: UIImage(named: "cross") ?? UIImage()]
            case .secure: return [UIControl.State.normal.rawValue: UIImage(named: "EyeClosed") ?? UIImage(),
                                  UIControl.State.selected.rawValue: UIImage(named: "EyeOpened") ?? UIImage()]
            }
        }
    }

    enum IndicatorState {
        case error, enabled, disabled

        func borderColor(_ themeService: ThemeServiceProtocol) -> UIColor {
            switch self {
            case .error: return UIColor.AdGuardColor.red
            case .enabled: return themeService.enabledBorderColor
            case .disabled: return themeService.disabledBorderColor
            }
        }
    }

    // MARK: - Properties

    weak var onDeleBackwardDelegate: AGTextFieldOnDeleBackwardDelegate?

    var leftTextAreaOffset: CGFloat = 16.0 {
        didSet {
            layoutIfNeeded()
        }
    }

    var rightTextAreaOffset: CGFloat = 16.0 {
        didSet {
            layoutIfNeeded()
        }
    }

    var bottomTextAreaOffset: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }

    var topTextAreaOffset: CGFloat = 0.0 {
        didSet {
            layoutIfNeeded()
        }
    }

    var textFieldType: TextSecurityType = .normal {
        didSet {
            self.isSecureTextEntry = textFieldType == .secure
            setupTextFieldRighViewImages()
        }
    }

    var borderState: IndicatorState = .disabled {
        didSet {
            setupBorderStyle(state: borderState)
        }
    }

    // MARK: - Overriden properties

    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.AdGuardColor.lightGray4]
            )
        }
    }

    private weak var _delegate: UITextFieldDelegate?
    override var delegate: UITextFieldDelegate? {
        get {
            return self._delegate
        }
        set {
            self._delegate = newValue
        }
    }

    // MARK: - Private properties

    private let imageRightBorderInset: CGFloat = 8.0
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        super.delegate = self
        setupBorderStyle(state: .disabled)
        textFieldType = self.isSecureTextEntry ? .secure : .normal
        setupTextFieldRighViewImages()
        rightView?.isHidden = true
    }

    // MARK: - Overrided UITextField methods

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superBounds = super.textRect(forBounds: bounds)
        return getRect(forBounds: superBounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superBounds = super.editingRect(forBounds: bounds)
        return getRect(forBounds: superBounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= imageRightBorderInset
        return rect
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if let outerDelegate = _delegate, outerDelegate.responds(to: aSelector) {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let outerDelegate = _delegate, outerDelegate.responds(to: aSelector) {
            return outerDelegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    override func deleteBackward() {
        super.deleteBackward()
        onDeleBackwardDelegate?.didDeleteBackward(newText: text)
    }

    // MARK: - Public methods

    func updateTheme() {
        backgroundColor = themeService.textFieldBackgroundColor
        setupBorderStyle(state: borderState)
        rightView?.tintColor = themeService.iconTintColor
        textColor = themeService.textColor
        tintColor = themeService.textFieldTintColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.AdGuardColor.lightGray4]
        )
    }

    // MARK: - Private methods

    private func setupTextFieldRighViewImages(images: [UIControl.State.RawValue: UIImage] = [:]) {
        let images = images.isEmpty ? textFieldType.defaultImages : images
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 25, height: 25)))

        for (_, image) in images.enumerated() {
            button.setBackgroundImage(image.value, for: .init(rawValue: image.key))
        }

        switch textFieldType {
        case .normal:
            button.addTarget(self, action: #selector(clearTapped(_:)), for: .touchUpInside)

        case .secure:
            button.addTarget(self, action: #selector(secureTapped(_:)), for: .touchUpInside)
        }

        self.rightView = button
        self.rightViewMode = .always
        self.rightView?.isHidden = text == nil || text?.isEmpty == true
    }

    private func getRect(forBounds bounds: CGRect) -> CGRect {
        let edge = UIEdgeInsets(top: topTextAreaOffset, left: leftTextAreaOffset, bottom: bottomTextAreaOffset, right: rightTextAreaOffset)
        return bounds.inset(by: edge)
    }

    private func setupBorderStyle(state: IndicatorState) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1.0
        animateBorderStyle(with: state.borderColor(themeService))
    }

    @objc private final func secureTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
    }

    @objc private final func clearTapped(_ sender: UIButton) {
        self.text = nil
        let _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(), replacementString: "")
    }

    private func animateBorderStyle(with color: UIColor) {
        let borderColorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = layer.borderColor
        borderColorAnimation.toValue = color.cgColor
        borderColorAnimation.duration = 0.2

        layer.add(borderColorAnimation, forKey: "animation")
        layer.borderColor = color.cgColor
    }
}

// MARK: - AGTextField + UITextFieldDelegate

extension AGTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textField(_:shouldChangeCharactersIn:replacementString:))) {
            return outerDelegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
        }

        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        self.borderState = .enabled
        self.rightView?.isHidden = updatedText.isEmpty
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textFieldDidBeginEditing(_:))) {
            return outerDelegate.textFieldDidBeginEditing!(textField)
        }

        self.rightView?.isHidden = (textField.text ?? "").isEmpty
        self.borderState = .enabled
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textFieldDidEndEditing(_:))) {
            return outerDelegate.textFieldDidEndEditing!(textField)
        }

        self.rightView?.isHidden = (textField.text ?? "").isEmpty
        self.borderState = .disabled
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let outerDelegate = _delegate, outerDelegate.responds(to: #selector(textFieldShouldReturn(_:))) {
            return outerDelegate.textFieldShouldReturn!(textField)
        }

        self.resignFirstResponder()
        self.borderState = .disabled
        return true
    }
}

// MARK: AGTextField + themable colors

fileprivate extension ThemeServiceProtocol {
    var textFieldBackgroundColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray2 : UIColor.AdGuardColor.lightGray6 }
    var disabledBorderColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray3 : UIColor.AdGuardColor.lightGray5 }
    var enabledBorderColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray5 : UIColor.AdGuardColor.lightGray4 }
    var iconTintColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray5 : UIColor.AdGuardColor.lightGray4 }
    var textFieldTintColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray7 : UIColor.AdGuardColor.lightGray2 }
    var textColor: UIColor { themeIsDark ? UIColor.AdGuardColor.lightGray7 : UIColor.AdGuardColor.lightGray2 }
}
