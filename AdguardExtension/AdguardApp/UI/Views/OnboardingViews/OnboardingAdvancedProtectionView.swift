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

/// OnboardingAdvancedProtectionView - Custom view for onboarding screen
final class OnboardingAdvancedProtectionView: UIView {

    // MARK: - Properties

    private let safariIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "safari_onboarding")
        return view
    }()

    private let attributedLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    var labelString: String? {
        didSet {
            guard let string = labelString else { return }
            processAttributes(with: string)
        }
    }

    // MARK: - Services

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }

    // MARK: - Private methods

    private func setupConstraints() {
        safariIcon.translatesAutoresizingMaskIntoConstraints = false
        attributedLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(safariIcon)
        self.addSubview(attributedLabel)

        let heightWidthConst = isIpadTrait ? 32.0 : 24.0

        safariIcon.heightAnchor.constraint(equalToConstant: heightWidthConst).isActive = true
        safariIcon.widthAnchor.constraint(equalToConstant: heightWidthConst).isActive = true
        safariIcon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        safariIcon.trailingAnchor.constraint(equalTo: attributedLabel.leadingAnchor, constant: isIpadTrait ? -12.0 : -8.0).isActive = true
        safariIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

        attributedLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        attributedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        attributedLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    private func processAttributes(with string: String) {
        guard let image = UIImage(named: "advancedSafariProtection") else { return }
        let attachmentSettings = NSMutableAttributedString.AttachmentSettings(
            image: image,
            topEdge: 7.5,
            leftEdge: 5,
            size: .customSize(width: image.size.width, height: image.size.height)
        )

        let attributedText = NSMutableAttributedString.fromHtml(string, fontSize: isIpadTrait ? 24.0 : 16.0, color: themeService.grayTextColor, attachmentSettings: attachmentSettings, textAlignment: .left)
        attributedLabel.attributedText = attributedText
    }
}

extension OnboardingAdvancedProtectionView: ThemableProtocol {
    func updateTheme() {
        self.backgroundColor = themeService.backgroundColor
        guard let string = labelString else { return }
        processAttributes(with: string)
    }
}
