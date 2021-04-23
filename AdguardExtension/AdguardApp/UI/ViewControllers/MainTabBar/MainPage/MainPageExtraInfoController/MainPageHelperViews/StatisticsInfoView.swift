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

protocol StatisticsInfoViewDelegate: AnyObject {
    func activeTypeChanged()
}

final class StatisticsInfoView: UIView {
    
    // MARK: - Public properties
    
    weak var delegate: StatisticsInfoViewDelegate?
    
    var statisticsModel: StatisticsModel.Statistics = StatisticsModel.Statistics() {
        didSet {
            requestsLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: statisticsModel.allRequests))
            encryptedLabel.text = String.formatNumberByLocale(NSNumber(integerLiteral: statisticsModel.encryptedRequests))
            avgTimeLabel.text = String.simpleSecondsFormatter(NSNumber(floatLiteral: statisticsModel.averageElapsedTimeMs))
        }
    }
    
    private(set) var currentType: ChartView.ChartRequestType = .requests {
        didSet {
            if currentType != oldValue {
                delegate?.activeTypeChanged()
            }
        }
    }
    
    // MARK: - Private properties
    
    private let clickableButtons: Bool
    
    // MARK: - UIElements
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var requestsButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitle("", for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(requestsButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = clickableButtons
        button.isSelected = currentType == .requests
        if clickableButtons {
            button.alpha = currentType == .requests ? 1.0 : 0.5
        }
        return button
    }()
    
    private lazy var requestsLabel: ThemableLabel = {
        let label = generateNumberLabel()
        label.text = "0"
        return label
    }()
    private lazy var requestsTitleLabel: ThemableLabel = {
        let label = generateTitleLabel()
        label.text = String.localizedString("requests_title")
        return label
    }()
    
    private lazy var encryptedButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitle("", for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(encryptedButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = clickableButtons
        button.isSelected = currentType == .encrypted
        if clickableButtons {
            button.alpha = currentType == .encrypted ? 1.0 : 0.5
        }
        return button
    }()
    
    private lazy var encryptedLabel: ThemableLabel = {
        let label = generateNumberLabel()
        label.text = "0"
        return label
    }()
    private lazy var encryptedTitleLabel: ThemableLabel = {
        let label = generateTitleLabel()
        label.text = String.localizedString("encrypted_title")
        return label
    }()
    
    private lazy var avgTimeButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setTitle("", for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(avgTimeButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = clickableButtons
        return button
    }()
    
    private lazy var avgTimeLabel: ThemableLabel = {
        let label = generateNumberLabel()
        label.text = "0.0"
        return label
    }()
    private lazy var avgTimeTitleLabel: ThemableLabel = {
        let label = generateTitleLabel()
        label.text = String.localizedString("average_time_title")
        return label
    }()
    
    // MARK: - StatisticsInfoView initialization
    
    init(clickableButtons: Bool = true) {
        self.clickableButtons = clickableButtons
        super.init(frame: .zero)
        initialize()
    }
    
    override init(frame: CGRect) {
        self.clickableButtons = true
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        self.clickableButtons = true
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        setConstraints(forView: requestsButton, numbersLabel: requestsLabel, titleLabel: requestsTitleLabel)
        stackView.addArrangedSubview(requestsButton)
        
        setConstraints(forView: encryptedButton, numbersLabel: encryptedLabel, titleLabel: encryptedTitleLabel)
        stackView.addArrangedSubview(encryptedButton)
        
        let minHeight = setConstraints(forView: avgTimeButton, numbersLabel: avgTimeLabel, titleLabel: avgTimeTitleLabel)
        stackView.addArrangedSubview(avgTimeButton)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
    }
    
    // MARK: - Public methods
    
    func updateTheme(_ themeService: ThemeServiceProtocol) {
        backgroundColor = themeService.popupBackgroundColor
        themeService.setupLabels([requestsLabel, requestsTitleLabel, encryptedLabel, encryptedTitleLabel, avgTimeLabel, avgTimeTitleLabel])
    }
    
    // MARK: - Private methods
    
    private func generateNumberLabel() -> ThemableLabel {
        let label = ThemableLabel()
        label.greyText = true
        label.numberOfLines = 1
        label.textAlignment = .center
        let font = UIFont.systemFont(ofSize: isIpadTrait ? 30.0 : 21.0, weight: .semibold)
        label.font = font
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func generateTitleLabel() -> ThemableLabel {
        let label = ThemableLabel()
        label.greyText = true
        label.numberOfLines = 1
        label.textAlignment = .center
        let font = UIFont.systemFont(ofSize: isIpadTrait ? 26.0 : 16.0, weight: .regular)
        label.font = font
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @discardableResult
    private func setConstraints(forView view: UIView, numbersLabel: UILabel, titleLabel: UILabel) -> CGFloat {
        view.addSubview(numbersLabel)
        view.addSubview(titleLabel)
        
        let numbersLabelHeight = numbersLabel.font.pointSize + 4.0
        numbersLabel.heightAnchor.constraint(equalToConstant: numbersLabelHeight).isActive = true
        numbersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        numbersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        numbersLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        let titleLabelHeight =  titleLabel.font.pointSize + 4.0
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: numbersLabel.bottomAnchor, constant: 2.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let viewMinHeight = numbersLabelHeight + 2.0 + titleLabelHeight
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: viewMinHeight).isActive = true
        return viewMinHeight
    }
    
    // MARK: - Buttons actions
    
    @objc
    private func requestsButtonTapped() {
        if !requestsButton.isSelected {
            requestsButton.isSelected = true
            encryptedButton.isSelected = false
            requestsButton.alpha = 1.0
            encryptedButton.alpha = 0.5
            currentType = .requests
            return
        }
        
        let title = String.localizedString("requests_info_alert_title")
        let message = String.localizedString("requests_info_alert_message")
        responsibleViewController?.presentSimpleAlert(title: title, message: message)
    }
    
    @objc
    private func encryptedButtonTapped() {
        if !encryptedButton.isSelected {
            encryptedButton.isSelected = true
            requestsButton.isSelected = false
            encryptedButton.alpha = 1.0
            requestsButton.alpha = 0.5
            currentType = .encrypted
            return
        }
        
        let title = String.localizedString("encrypted_info_alert_title")
        let message = String.localizedString("encrypted_info_alert_message")
        responsibleViewController?.presentSimpleAlert(title: title, message: message)
    }
    
    @objc
    private func avgTimeButtonTapped() {
        let title = String.localizedString("average_info_alert_title")
        let message = String.localizedString("average_info_alert_message")
        responsibleViewController?.presentSimpleAlert(title: title, message: message)
    }
}
