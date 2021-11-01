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

/// UIWindow object for displaying status information in the bottom of the screen
final class StatusBarWindow: UIWindow {

    // MARK: - Internal properties

    var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    // MARK: - Private properties

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 14.0 : 10.0, weight: .regular)
        label.textColor = UIColor.AdGuardColor.lightGray2
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        initialize()
    }

    // MARK: - Private methods

    private func initialize() {
        setupWindowAppearence()
        setupConstraints()
    }

    private func setupWindowAppearence() {
        backgroundColor = UIColor.AdGuardColor.lightGray5
        windowLevel = UIWindow.Level.statusBar
    }

    private func setupConstraints() {
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}
