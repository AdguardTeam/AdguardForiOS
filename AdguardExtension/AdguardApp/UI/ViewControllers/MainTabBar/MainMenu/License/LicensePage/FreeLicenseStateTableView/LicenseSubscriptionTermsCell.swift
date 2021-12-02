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

/// This cell displays EULA and Privacy policy for selected license product
final class LicenseSubscriptionTermsCell: UITableViewCell, Reusable {

    // MARK: - Private properties

    /* UI elements */

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0.0
        textView.backgroundColor = .clear
        textView.tintColor = UIColor.AdGuardColor.lightGreen1
        textView.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        return textView
    }()

    /* Constraints */
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []

    // MARK: - Public methods

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass ||
            previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
        else {
            return
        }
        layout(for: traitCollection)
    }

    func setAttributedText(_ text: NSAttributedString) {
        let mutableAttrString = NSMutableAttributedString(attributedString: text)

        mutableAttrString.removeAttribute(NSAttributedString.Key.foregroundColor, range: NSRange(location: 0, length: mutableAttrString.length))
        mutableAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: textView.textColor!, range: NSRange(location: 0, length: mutableAttrString.length))

        mutableAttrString.removeAttribute(NSAttributedString.Key.font, range: NSRange(location: 0, length: mutableAttrString.length))
        mutableAttrString.addAttribute(NSAttributedString.Key.font, value: textView.font!, range: NSRange(location: 0, length: mutableAttrString.length))

        textView.attributedText = mutableAttrString
    }

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
        textView.textColor = themeService.lightGrayTextColor

        if let currentAttrString = textView.attributedText {
            let mutableAttrString = NSMutableAttributedString(attributedString: currentAttrString)
            mutableAttrString.removeAttribute(NSAttributedString.Key.foregroundColor, range: NSRange(location: 0, length: mutableAttrString.length))
            mutableAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: textView.textColor!, range: NSRange(location: 0, length: mutableAttrString.length))
            textView.attributedText = mutableAttrString
        }
    }

    // MARK: - Private methods

    private func initialize() {
        selectionStyle = .none
        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
    }

    private func initializeConstraints() {
        let container = UILayoutGuide()
        contentView.addLayoutGuide(container)
        contentView.addSubview(textView)

        sharedConstraints = [
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            textView.topAnchor.constraint(equalTo: container.topAnchor),
            textView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ]

        iPhoneConstraints = [
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.0),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0)
        ]

        iPadConstraints = [
            container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            container.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0)
        ]
    }

    private func layout(for traitCollection: UITraitCollection) {
        if traitCollection.isIpadTraitCollection {
            NSLayoutConstraint.deactivate(iPhoneConstraints)
            NSLayoutConstraint.activate(iPadConstraints)
        } else {
            NSLayoutConstraint.deactivate(iPadConstraints)
            NSLayoutConstraint.activate(iPhoneConstraints)
        }
    }
}
