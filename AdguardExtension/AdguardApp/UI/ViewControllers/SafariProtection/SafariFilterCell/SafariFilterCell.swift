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

struct SafariFilterCellModel {
    let filterId: Int // Filter unique identifier
    let groupType: SafariGroup.GroupType // Filter group type
    let filterNameAttrString: NSAttributedString // Filter name
    let isEnabled: Bool // Filter state
    let version: String? // Filter version. Filter content always changes by it's authors, so we store the version of filter to identify it
    let lastUpdateDate: Date? // The last time the filter was updated
    let tags: [SafariTagButtonModel] // Some tags that filters can be grouped by
    let groupIsEnabled: Bool // Every filter belongs to group. If group is disabled cell alpha will be 0.5
}

extension SafariFilterCellModel {
    init() {
        self.filterId = 0
        self.groupType = .ads
        self.filterNameAttrString = NSAttributedString(string: "")
        self.isEnabled = false
        self.version = nil
        self.lastUpdateDate = nil
        self.tags = []
        self.groupIsEnabled = false
    }
}

protocol SafariFilterCellDelegate: AnyObject {
    func safariFilterStateChanged(_ filterId: Int, _ groupType: SafariGroup.GroupType, _ newState: Bool)
    func tagTapped(_ tagName: String)
}

// MARK: - SafariFilterCell

final class SafariFilterCell: UITableViewCell, Reusable {

    // MARK: - Public properties

    var model = SafariFilterCellModel() {
        didSet { processModel() }
    }

    weak var delegate: SafariFilterCellDelegate?

    // MARK: - UI

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)
        label.textAlignment = .left
        DispatchQueue.asyncSafeMain { label.attributedText = self.model.filterNameAttrString }
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 2.0
        return stackView
    }()

    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()

    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.lightGreen1
        stateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return stateSwitch
    }()

    // MARK: - Private properties

    // UI elements constraints
    private var sideInset: CGFloat { isIpadTrait ? 24.0 : 16.0 }
    private var topBottomInset: CGFloat { isIpadTrait ? 16.0 : 12.0 }
    private let switchWidth: CGFloat = 50.0
    private var tagHeight: CGFloat { isIpadTrait ? 22.0 : 16.0 }
    private var tagsInset: CGFloat { isIpadTrait ? 10.0 : 6.0 }
    private var tagsStackViewWidth: CGFloat { UIScreen.main.bounds.width - (sideInset * 3) - switchWidth }

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        DispatchQueue.asyncSafeMain { self.titleLabel.attributedText = nil }
    }

    // MARK: - Private methods

    private func setupUI() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(stateSwitch)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stateSwitch.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topBottomInset),
            stateSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -sideInset),
            stateSwitch.widthAnchor.constraint(equalToConstant: switchWidth),
            stateSwitch.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -topBottomInset),

            stackView.topAnchor.constraint(equalTo: stateSwitch.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: stateSwitch.leadingAnchor, constant: -sideInset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: sideInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -topBottomInset)
        ])
    }

    private func processModel() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        stateSwitch.isOn = model.isEnabled

        DispatchQueue.asyncSafeMain { self.titleLabel.attributedText = self.model.filterNameAttrString }
        stackView.addArrangedSubview(titleLabel)

        if let version = model.version {
            let format = String.localizedString("filter_version_format")
            let versionString = String(format: format, version)
            let label = getDescriptionLabel(versionString)
            stackView.addArrangedSubview(label)
        }

        if let updateDate = model.lastUpdateDate, let dateString = updateDate.formatedStringWithHoursAndMinutes() {
            let format = String.localizedString("filter_date_format")
            let updateDateString = String(format: format, dateString)
            let label = getDescriptionLabel(updateDateString)
            stackView.addArrangedSubview(label)
        }

        if !model.tags.isEmpty {
            processTags()
            stackView.addArrangedSubview(tagsStackView)
        } else {
            tagsStackView.removeFromSuperview()
        }

        contentView.alpha = model.groupIsEnabled ? 1.0 : 0.5
        contentView.isUserInteractionEnabled = model.groupIsEnabled
    }

    private func processTags() {
        var horStack = getHorizontalTagStackView()
        var currentStackWidth: CGFloat = 0.0

        for tag in model.tags {
            let button = SafariTagButton(model: tag)
            button.addTarget(self, action: #selector(tagButtonTapped(_:)), for: .touchUpInside)
            button.setTitleColor(UIColor.AdGuardColor.lightGreen1, for: .normal)
            button.setTitleColor(UIColor.AdGuardColor.lightGreen1.withAlphaComponent(0.3), for: .highlighted)
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

    private func getDescriptionLabel(_ text: String) -> ThemableLabel {
        let label = ThemableLabel()
        label.lightGreyText = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 18.0 : 12.0, weight: .regular)
        label.textAlignment = .left
        label.text = text
        themeService.setupLabel(label)
        return label
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

    /// Switch action handler
    @objc private final func switchValueChanged() {
        delegate?.safariFilterStateChanged(model.filterId, model.groupType, !model.isEnabled)
    }

    @objc private final func tagButtonTapped(_ sender: SafariTagButton) {
        delegate?.tagTapped(sender.model.tagName)
    }
}

// MARK: - SafariFilterCell + ThemableProtocol

extension SafariFilterCell: ThemableProtocol {
    func updateTheme() {
        themeService.setupTableCell(self)
        themeService.setupLabel(titleLabel)
    }
}
