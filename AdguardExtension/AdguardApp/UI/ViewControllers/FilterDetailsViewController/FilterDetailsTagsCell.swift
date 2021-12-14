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
    private var tagsStackViewWidth: CGFloat { lastFrame.width - (sideInset * 2) }

    // We use it to avoid changing constraints when frame didn't change
    private var lastFrame: CGRect = .zero

    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        if frame != lastFrame {
            lastFrame = frame
            processModels()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    func updateTheme() {
        themeService.setupTableCell(self)
    }

    private func setupUI() {
        selectionStyle = .none
        tagsStackView.isUserInteractionEnabled = false
        contentView.addSubview(tagsStackView)

        NSLayoutConstraint.activate([
            tagsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            tagsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            tagsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topBottomInset),
            tagsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topBottomInset)
        ])
    }

    private func processModels() {
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        processTags()
        layoutIfNeeded()
    }

    private func processTags() {
        var horStack = getHorizontalTagStackView()
        var currentStackWidth: CGFloat = 0.0

        for tag in tagModels {
            let button = SafariTagButton(model: tag)
            button.setTitleColor(UIColor.AdGuardColor.lightGreen1, for: .normal)
            let width = button.frame.width
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.heightAnchor.constraint(equalToConstant: tagHeight).isActive = true

            if currentStackWidth + width > tagsStackViewWidth {
                addEmptyView(to: horStack, currentStackWidth: currentStackWidth)
                tagsStackView.addArrangedSubview(horStack)
                horStack = getHorizontalTagStackView()
                currentStackWidth = 0.0
            }

            horStack.addArrangedSubview(button)
            currentStackWidth += width
            currentStackWidth += tagsInset
        }

        addEmptyView(to: horStack, currentStackWidth: currentStackWidth)
        tagsStackView.addArrangedSubview(horStack)
    }

    private func getHorizontalTagStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = tagsInset
        stackView.alignment = .leading
        stackView.heightAnchor.constraint(equalToConstant: tagHeight).isActive = true
        return stackView
    }

    private func addEmptyView(to stack: UIStackView, currentStackWidth: CGFloat) {
        let spaceLeft = tagsStackViewWidth - currentStackWidth
        let emptyView = UIView()
        emptyView.frame.size.width = spaceLeft
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.widthAnchor.constraint(equalToConstant: spaceLeft).isActive = true
        emptyView.heightAnchor.constraint(equalToConstant: tagHeight).isActive = true
        stack.addArrangedSubview(emptyView)
    }
}
