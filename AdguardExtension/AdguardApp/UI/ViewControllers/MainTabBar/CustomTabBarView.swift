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

import Foundation
import UIKit

/// Model of a single tab bar item.
struct TabBarItem {
    let image: UIImage?
    let accessibilityLabel: String?
}

/// Custom flat tab bar view
final class CustomTabBarView: UIView {

    /// Height of the bar content zone (the icons area above the home indicator zone).
    static let barHeight: CGFloat = 49.0

    /// Vertical offset of the item icons (matches the former imageInsets of the system bar items).
    private static let iconVerticalOffset: CGFloat = 6.0

    /// Shadow parameters of the bar (match the former system bar shadow).
    private static let shadowRadius: CGFloat = 2.0

    private var buttons: [TabItemButton] = []
    private var itemConstraints: [NSLayoutConstraint] = []
    private var heightConstraint: NSLayoutConstraint?

    private(set) var items: [TabBarItem] = []

    /// Index of the currently selected item.
    private(set) var selectedItemIndex: Int = 0

    /// Called when the user taps the item at the given index.
    var onItemTap: ((Int) -> Void)?

    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        accessibilityTraits = .tabBar
        isAccessibilityElement = false

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = CustomTabBarView.shadowRadius

        let heightConstraint = heightAnchor.constraint(equalToConstant: CustomTabBarView.barHeight + safeAreaInsets.bottom)
        heightConstraint.isActive = true
        self.heightConstraint = heightConstraint

        updateTheme()
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()

        heightConstraint?.constant = CustomTabBarView.barHeight + safeAreaInsets.bottom
    }

    // MARK: - Public API

    /// Replaces the items and rebuilds the buttons.
    func setItems(_ newItems: [TabBarItem]) {
        items = newItems
        rebuildButtons()
    }

    /// Selects the item at the given index, updating the tints.
    func setSelectedItemIndex(_ index: Int) {
        guard items.indices.contains(index) else { return }
        selectedItemIndex = index
        refreshSelection()
    }

    /// Applies the current theme colors.
    func updateTheme() {
        backgroundColor = theme.tabBarColor
        refreshSelection()
    }

    // MARK: - Item taps

    @objc private func itemTapped(_ sender: TabItemButton) {
        guard let index = buttons.firstIndex(where: { $0 === sender }) else { return }
        onItemTap?(index)
    }

    // MARK: - Layout

    private func rebuildButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = []

        for item in items {
            let button = TabItemButton(iconVerticalOffset: CustomTabBarView.iconVerticalOffset)
            button.iconImageView.image = item.image?.withRenderingMode(.alwaysTemplate)
            button.accessibilityLabel = item.accessibilityLabel
            button.addTarget(self, action: #selector(itemTapped(_:)), for: .touchUpInside)
            addSubview(button)
            buttons.append(button)
        }

        pinItemsToBar()
        refreshSelection()
    }

    /// Pins the item buttons to the bar content zone with equal widths (like `itemPositioning = .fill`).
    private func pinItemsToBar() {
        itemConstraints.forEach { $0.isActive = false }
        itemConstraints = []

        var constraints: [NSLayoutConstraint] = []

        for button in buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(button.topAnchor.constraint(equalTo: topAnchor))
            constraints.append(button.heightAnchor.constraint(equalToConstant: CustomTabBarView.barHeight))
        }

        if let firstButton = buttons.first, let lastButton = buttons.last {
            constraints.append(firstButton.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(lastButton.trailingAnchor.constraint(equalTo: trailingAnchor))

            zip(buttons, buttons.dropFirst()).forEach { previousButton, currentButton in
                constraints.append(currentButton.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor))
                constraints.append(currentButton.widthAnchor.constraint(equalTo: previousButton.widthAnchor))
            }
        }

        NSLayoutConstraint.activate(constraints)
        itemConstraints = constraints
    }

    /// Updates the item tints and accessibility traits to match the selection.
    private func refreshSelection() {
        for (index, button) in buttons.enumerated() {
            let isSelected = index == selectedItemIndex
            button.tintColor = isSelected
                ? UIColor.AdGuardColor.lightGreen1
                : UIColor.AdGuardColor.lightGray3
            button.accessibilityTraits = isSelected ? [.button, .selected] : [.button]
        }
    }
}

/// A single icon-only tab bar item button.
private final class TabItemButton: UIControl {

    let iconImageView: UIImageView

    /// - Parameter iconVerticalOffset: the icon offset below the button center
    ///   (matches the former imageInsets of the system bar items).
    init(iconVerticalOffset: CGFloat) {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = false
        iconImageView = imageView

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        accessibilityTraits = .button

        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: iconVerticalOffset)
        ])
    }

    required init?(coder: NSCoder) {
        assertionFailure("TabItemButton is created in code only")
        // Satisfy the strict initialization rules of the designated initializer path.
        iconImageView = UIImageView()
        super.init(coder: coder)
    }
}
