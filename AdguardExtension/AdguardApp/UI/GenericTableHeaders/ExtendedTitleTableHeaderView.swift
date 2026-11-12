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

final class ExtendedTitleTableHeaderView: UIView {

    // MARK: - UI Elements

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.textContainerInset = .zero
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0.0
        return textView
    }()

    // MARK: - Layout metrics

    private var layoutConstraints: [NSLayoutConstraint] = []

    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Properties

    private var themeObserver: NotificationToken?

    var title: String {
        didSet {
            titleLabel.text = title
        }
    }
    private(set) var descr: String

    required init?(coder: NSCoder) {
        self.title = ""
        self.descr = ""
        super.init(coder: coder)
        setupTheme()
    }

    override init(frame: CGRect) {
        self.title = ""
        self.descr = ""
        super.init(frame: frame)
        setupTheme()
    }

    init(title: String, normalDescription: String) {
        self.title = title
        self.descr = normalDescription
        super.init(frame: .zero)
        // setupUI must run first: it applies the size-class fonts that
        // setupTextView reads when building the attributed description.
        setupUI()
        setNormalTitle(normalDescription)
        setupTheme()
    }

    init(title: String, htmlDescription: String) {
        self.title = title
        self.descr = htmlDescription
        super.init(frame: .zero)
        // See the note in init(title:normalDescription:).
        setupUI()
        setAttributedTitle(htmlDescription)
        setupTheme()
    }

    // MARK: - Public methods

    func setAttributedTitle(_ html: String) {
        descr = html
        descriptionTextView.isSelectable = true
        setupTextView()
    }

    func setNormalTitle(_ title: String) {
        descr = title
        descriptionTextView.isSelectable = false
        setupTextView()
    }

    // MARK: - Private methods

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            applyLayoutMetrics()
        }
    }

    private func setupUI() {
        titleLabel.text = title
        addSubview(titleLabel)
        addSubview(descriptionTextView)
        applyLayoutMetrics()
    }

    private func applyLayoutMetrics() {
        let sideInset: CGFloat = isIpadTrait ? 24.0 : 16.0
        let bottomInset: CGFloat = isIpadTrait ? -96.0 : -24.0

        titleLabel.font = UIFont.systemFont(ofSize: isIpadTrait ? 40.0 : 24.0, weight: .bold)
        descriptionTextView.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 16.0, weight: .bold)

        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: titleLabel.font.pointSize + 2.0),

            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomInset),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: descriptionTextView.font!.pointSize + 2.0)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

        // The description is an attributed string rendered with the font size
        // at build time — rebuild it after the font changes.
        setupTextView()

    }

    private func setupTheme() {
        updateTheme()
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }

    private func setupTextView() {
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.setAttributedTitle(
            descr,
            fontSize: descriptionTextView.font!.pointSize,
            color: themeService.lightGrayTextColor,
            textAlignment: .center
        )
        descriptionTextView.tintColor = UIColor.AdGuardColor.lightGreen2 //link color
    }
}

// MARK: - ExtendedTitleTableHeaderView + ThemableProtocol

extension ExtendedTitleTableHeaderView: ThemableProtocol {
    func updateTheme() {
        themeService.setupLabel(titleLabel)
        setupTextView()
    }
}
