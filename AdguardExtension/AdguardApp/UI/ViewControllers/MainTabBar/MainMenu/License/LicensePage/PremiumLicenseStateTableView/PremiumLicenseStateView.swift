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

protocol PremiumLicenseStateViewDelegate: AnyObject {
    func goToMyAccount()
}

/// This view is responsible for displaying info about user's license status and premium features available
final class PremiumLicenseStateView: UIView {

    // MARK: - Public methods

    weak var delegate: PremiumLicenseStateViewDelegate?

    var models: [PremiumFeatureViewModel] = [] {
        didSet {
            optionsTableView.reloadData()
        }
    }

    // MARK: - Private properties

    private lazy var imageView: ThemableImageView = {
        let imageView = ThemableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.lightThemeImage = UIImage(named: "adguard-premium-logo")
        imageView.darkThemeImage = UIImage(named: "adguard-premium-logo-dark")
        return imageView
    }()

    private lazy var optionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var myAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        button.backgroundColor = UIColor.AdGuardColor.lightGreen1
        button.setTitleColor(.white, for: .normal)
        button.setTitle(String.localizedString("go_to_my_account_title"), for: .normal)
        button.addTarget(self, action: #selector(myAccountButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        return button
    }()

    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Public methods

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    init() {
        super.init(frame: .zero)
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
        setFonts(for: traitCollection)
    }

    func setAccountButtonHidden(_ isHidden: Bool) {
        myAccountButton.isHidden = isHidden
    }

    func updateTheme() {
        backgroundColor = themeService.backgroundColor
        themeService.setupImage(imageView)
        optionsTableView.reloadData()
    }

    // MARK: - Private methods

    private func initialize() {
        setupTableView()
        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
    }

    private func initializeConstraints() {
        addSubview(imageView)
        addSubview(optionsTableView)
        addSubview(myAccountButton)

        sharedConstraints = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            optionsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsTableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]

        iPhoneConstraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            imageView.widthAnchor.constraint(equalToConstant: 264.0),
            imageView.heightAnchor.constraint(equalToConstant: 82.0),

            optionsTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0),
            optionsTableView.bottomAnchor.constraint(equalTo: myAccountButton.topAnchor, constant: -24.0),

            myAccountButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.0),
            myAccountButton.heightAnchor.constraint(equalToConstant: 40.0),
            myAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            myAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0)
        ]

        iPadConstraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40.0),
            imageView.widthAnchor.constraint(equalToConstant: 528.0),
            imageView.heightAnchor.constraint(equalToConstant: 164.0),

            optionsTableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40.0),
            optionsTableView.bottomAnchor.constraint(equalTo: myAccountButton.topAnchor, constant: -40.0),

            myAccountButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32.0),
            myAccountButton.heightAnchor.constraint(equalToConstant: 60.0),
            myAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
            myAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0)
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

    private func setFonts(for traitCollection: UITraitCollection) {
        let font = UIFont.systemFont(ofSize: traitCollection.isIpadTraitCollection ? 20.0 : 16.0, weight: .regular)
        myAccountButton.titleLabel?.font = font
    }

    private func setupTableView() {
        optionsTableView.backgroundColor = .clear
        optionsTableView.dataSource = self
        optionsTableView.bounces = false
        optionsTableView.separatorStyle = .none
        optionsTableView.showsHorizontalScrollIndicator = false
        optionsTableView.showsVerticalScrollIndicator = false
        PremiumOptionCell.registerCell(forTableView: optionsTableView)
    }

    @objc private func myAccountButtonTapped() {
        delegate?.goToMyAccount()
    }
}

// MARK: - PremiumLicenseStateView + UITableViewDataSource

extension PremiumLicenseStateView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PremiumOptionCell.getCell(forTableView: tableView)
        cell.model = models[indexPath.row]
        cell.updateTheme(themeService)
        return cell
    }
}
