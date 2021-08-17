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
import SafariAdGuardSDK

struct SafariFilterCellModel {
    let filterId: Int // Filter unique identifier
    let filterName: String // Filter name
    let isEnabled: Bool // Filter state
    let version: String? // Filter version. Filter content always changes by it's authors, so we store the version of filter to identify it
    let lastUpdateDate: Date? // The last time the filter was updated
    let tags: [ExtendedFiltersMeta.Tag] // Some tags that filters can be grouped by
}

extension SafariFilterCellModel {
    init() {
        self.filterId = 0
        self.filterName = ""
        self.isEnabled = false
        self.version = nil
        self.lastUpdateDate = nil
        self.tags = []
    }
}

protocol SafariFilterCellDelegate: AnyObject {
    func safariFilterStateChanged(_ filterId: Int, _ newState: Bool)
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
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textAlignment = .left
        label.text = model.filterName
        return label
    }()
    
    private var descriptionLabels: [ThemableLabel] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var tagsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()
    
    private lazy var stateSwitch: UISwitch = {
        let stateSwitch = UISwitch()
        stateSwitch.translatesAutoresizingMaskIntoConstraints = false
        stateSwitch.onTintColor = UIColor.AdGuardColor.green
        stateSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return stateSwitch
    }()
    
    // MARK: - Private properties
    
    // UI elements constraints
    private var sideInset: CGFloat { isIpadTrait ? 24.0 : 16.0 }
    private var topBottomInset: CGFloat { isIpadTrait ? 16.0 : 12.0 }
    private let switchWidth: CGFloat = 50.0
    private var tagsInset: CGFloat { isIpadTrait ? 16.0 : 8.0 }
    private var tagHeight: CGFloat { isIpadTrait ? 32.0 : 22.0 }
    private var tagsStackViewWidth: CGFloat { lastFrame.width - (sideInset * 3) - switchWidth }
    
    // We use it to avoid changing constraints when frame didn't change
    private var lastFrame: CGRect = .zero
    
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?
        
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.lastFrame = frame
        setupUI()
        setupTheme()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.lastFrame = frame
        setupUI()
        setupTheme()
    }
    
    override func layoutSubviews() {
        if frame != lastFrame {
            lastFrame = frame
            processModel()
        }
    }
    
    // MARK: - Private methods
    
    private func setupTheme() {
        updateTheme()
        
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    /// Sets constraints to all views in cell
    private func setupUI() {
        addSubview(stateSwitch)
        addSubview(stackView)
        addSubview(tagsStackView)
        
        NSLayoutConstraint.activate([
            stateSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
            stateSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideInset),
            stateSwitch.widthAnchor.constraint(equalToConstant: switchWidth),
            
            stackView.topAnchor.constraint(equalTo: stateSwitch.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: stateSwitch.leadingAnchor, constant: -sideInset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideInset),
            
            tagsStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            tagsStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            tagsStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8.0),
            tagsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset)
        ])
    }
    
    private func processModel() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        tagsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        stateSwitch.isOn = model.isEnabled
        titleLabel.text = model.filterName
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
        }
    }
    
    private func processTags() {
        var horStack = getHorizontalTagStackView()
        var currentStackWidth: CGFloat = 0.0
        
        for tag in model.tags {
            let button = SafariTagButton(tagName: tag.tagName, isLang: tag.tagType == .lang)
            button.updateTheme(themeService)
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
    
    private func getDescriptionLabel(_ text: String) -> ThemableLabel {
        let label = ThemableLabel()
        label.lightGreyText = true
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
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
        stackView.spacing = tagsInset
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
    
    /// Switch action handler
    @objc private final func switchValueChanged() {
        delegate?.safariFilterStateChanged(model.filterId, !model.isEnabled)
    }
}

// MARK: - SafariFilterCell + ThemableProtocol

extension SafariFilterCell: ThemableProtocol {
    func updateTheme() {
        themeService.setupTableCell(self)
        themeService.setupLabel(titleLabel)
        themeService.setupLabels(descriptionLabels)
    }
}
