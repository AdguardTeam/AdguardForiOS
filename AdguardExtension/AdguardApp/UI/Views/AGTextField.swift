///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import UIKit

final class AGTextField: UITextField {

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

        func color(_ themeService: ThemeServiceProtocol) -> UIColor {
            switch self {
            case .error: return UIColor.AdGuardColor.red
            case .enabled, .disabled: return themeService.textFieldIndicatorBorderColor
            }
        }
    }

    // MARK: - Properties

    var leftTextAreaOffset: CGFloat = 0 {
        didSet {
            layoutIfNeeded()
        }
    }

    var rightTextAreaOffset: CGFloat = 0 {
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

    private let imageRightBorderInset: CGFloat = 8.0

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBorderStyle(state: .disabled)
        textFieldType = self.isSecureTextEntry ? .secure : .normal
        setupTextFieldRighViewImages()
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

    // MARK: - Public methods

    func themeChanged() {
        setupBorderStyle(state: borderState)
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
    }

    private func getRect(forBounds bounds: CGRect) -> CGRect {
        let edge = UIEdgeInsets(top: 0, left: leftTextAreaOffset, bottom: 0, right: rightTextAreaOffset)
        return bounds.inset(by: edge)
    }

    private func setupBorderStyle(state: IndicatorState) {
        self.layer.cornerRadius = 8
        let width: CGFloat
        switch state {
        case .disabled: width = 0.0
        case .enabled, .error: width = 1.0
        }
        animateBorderStyle(with: state.color(themeService), width: width)
    }

    @objc private final func secureTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
    }

    @objc private final func clearTapped(_ sender: UIButton) {
        self.text = nil
        let _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(), replacementString: "")
    }

    private func animateBorderStyle(with color: UIColor, width: CGFloat) {
        let animationGroup = CAAnimationGroup()

        let borderColorAnimation: CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = layer.borderColor
        borderColorAnimation.toValue = color.cgColor

        let borderWidthAnimation: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.fromValue = layer.borderWidth
        borderWidthAnimation.toValue = width

        animationGroup.animations = [borderColorAnimation, borderWidthAnimation]
        animationGroup.duration = 0.2

        layer.add(animationGroup, forKey: "animation group")
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
