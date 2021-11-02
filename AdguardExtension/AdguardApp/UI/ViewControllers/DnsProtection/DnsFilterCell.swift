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

/// Model for `DnsFilterCell`
struct DnsFilterCellModel {
    let filterId: Int // Filter unique identifier
    let filterNameAttrString: NSAttributedString // Filter name
    let isEnabled: Bool // Filter state
    let version: String? // Filter version. Filter content always changes by it's authors, so we store the version of filter to identify it
    let lastUpdateDate: Date? // The last time the filter was updated

    init(filterId: Int, filterNameAttrString: NSAttributedString, isEnabled: Bool, version: String?, lastUpdateDate: Date?) {
        self.filterId = filterId
        self.filterNameAttrString = filterNameAttrString
        self.isEnabled = isEnabled
        self.version = version
        self.lastUpdateDate = lastUpdateDate
    }

    init() {
        self.filterId = 0
        self.filterNameAttrString = NSAttributedString(string: "")
        self.isEnabled = false
        self.version = nil
        self.lastUpdateDate = nil
    }
}

protocol DnsFilterCellDelegate: AnyObject {
    func dnsFilterStateChanged(_ filterId: Int, newState: Bool)
}

/// Cell for displaying DnsFilter info
final class DnsFilterCell: UITableViewCell, Reusable {

    // MARK: - Public variables

    var model = DnsFilterCellModel() {
        didSet { processModel() }
    }

    weak var delegate: DnsFilterCellDelegate?

    // MARK: - UI elements

    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.greyText = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textAlignment = .left
        label.attributedText = model.filterNameAttrString
        return label
    }()

    private var descriptionLabels: [ThemableLabel] = []

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2.0
        return stackView
    }()

    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.lightGreen1
        stateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return stateSwitch
    }()

    /* UI elements constants */
    private var sideInset: CGFloat { isIpadTrait ? 24.0 : 16.0 }
    private var topBottomInset: CGFloat { isIpadTrait ? 16.0 : 12.0 }
    private let switchWidth: CGFloat = 50.0

    // MARK: - Initialization

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    private func initialize() {
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
        descriptionLabels = []
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        stateSwitch.isOn = model.isEnabled

        titleLabel.attributedText = model.filterNameAttrString
        stackView.addArrangedSubview(titleLabel)

        if let version = model.version {
            let format = String.localizedString("filter_version_format")
            let versionString = String(format: format, version)
            let label = getDescriptionLabel(versionString)
            stackView.addArrangedSubview(label)
            descriptionLabels.append(label)
        }

        if let updateDate = model.lastUpdateDate, let dateString = updateDate.formatedStringWithHoursAndMinutes() {
            let format = String.localizedString("filter_date_format")
            let updateDateString = String(format: format, dateString)
            let label = getDescriptionLabel(updateDateString)
            stackView.addArrangedSubview(label)
            descriptionLabels.append(label)
        }
    }

    private func getDescriptionLabel(_ text: String) -> ThemableLabel {
        let label = ThemableLabel()
        label.lightGreyText = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textAlignment = .left
        label.text = text
        return label
    }

    // MARK: - Public methods

    func updateTheme(_ themeService: ThemeServiceProtocol) {
        themeService.setupTableCell(self)
        themeService.setupLabel(titleLabel)
        themeService.setupLabels(descriptionLabels)
    }

    // MARK: - Private methods

    /// Switch action handler
    @objc private final func switchValueChanged() {
        delegate?.dnsFilterStateChanged(model.filterId, newState: !model.isEnabled)
    }
}
