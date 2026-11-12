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
import SafariAdGuardSDK

final class FilterDetailsTagsCell: UITableViewCell, Reusable {

    var tagModels: [SafariTagButtonModel] = [] {
        didSet {
            processModels()
        }
    }

    // MARK: - Private properties

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // UI elements constraints
    private var sideInset: CGFloat { isIpadTrait ? 24.0 : 16.0 }
    private var topBottomInset: CGFloat { isIpadTrait ? 16.0 : 12.0 }
    private var tagsInset: CGFloat { isIpadTrait ? 10.0 : 6.0 }
    private var tagHeight: CGFloat { isIpadTrait ? 22.0 : 16.0 }

    /// Width of the area the tags are wrapped into.
    private var tagsStackViewWidth: CGFloat {
        let availableWidth = contentView.bounds.width > 0
            ? contentView.bounds.width
            : contentView.window?.frame.width ?? 0.0
        return availableWidth - (sideInset * 2)
    }

    private var layoutConstraints: [NSLayoutConstraint] = []
    private var lastTagLayoutWidth: CGFloat = 0.0

    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        traitCollection.onSizeClassChange(previousTraitCollection) {
            // The tag buttons bake the font and height at creation,
            // so they are rebuilt together with the metrics.
            applyLayoutMetrics()
            processModels()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // The wrap depends on the width, which can change without a size
        // class change — re-wrap the tags then.
        guard !tagModels.isEmpty, contentView.bounds.width != lastTagLayoutWidth else { return }
        processModels()
    }

    func updateTheme() {
        themeService.setupTableCell(self)
    }

    private func setupUI() {
        selectionStyle = .none
        tagsStackView.isUserInteractionEnabled = false
        contentView.addSubview(tagsStackView)
        applyLayoutMetrics()
    }

    private func applyLayoutMetrics() {
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints = [
            tagsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            tagsStackView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -sideInset),
            tagsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topBottomInset),
            tagsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topBottomInset)
        ]
        NSLayoutConstraint.activate(layoutConstraints)

    }

    private func processModels() {
        lastTagLayoutWidth = contentView.bounds.width
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        processTags()
    }

    private func processTags() {
        var horStack = getHorizontalTagStackView()
        var currentStackWidth: CGFloat = 0.0

        for tag in tagModels {
            // Metrics are passed explicitly: the ambient trait collection is
            // not guaranteed when the tags are re-wrapped outside cellForRowAt.
            let button = SafariTagButton(model: tag, isIpadTrait: isIpadTrait)
            button.setTitleColor(UIColor.AdGuardColor.lightGreen1, for: .normal)
            let width = button.frame.width
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: width).isActive = true

            if currentStackWidth + width > tagsStackViewWidth {
                tagsStackView.addArrangedSubview(horStack)
                horStack = getHorizontalTagStackView()
                currentStackWidth = 0.0
            }

            horStack.addArrangedSubview(button)
            currentStackWidth += width
            currentStackWidth += tagsInset
        }

        tagsStackView.addArrangedSubview(horStack)
    }

    private func getHorizontalTagStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.heightAnchor.constraint(equalToConstant: tagHeight).isActive = true
        stackView.spacing = tagsInset
        return stackView
    }
}
