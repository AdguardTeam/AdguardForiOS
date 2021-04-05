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

protocol StoryViewControllerDelegate: AnyObject {
    func previousStoriesAreOver()
    func nextStoriesAreOver()
}

final class StoryViewController: UIViewController {
    
    weak var delegate: StoryViewControllerDelegate?
    
    private let storyGroup: StoryGroup
    private var currentStoryIndex = 0
    
    private var currentStory: StoryToken { storyGroup.storyTokens[currentStoryIndex] }
    
    /*
     We need to know when controller becomes visible in UIWindow,
     otherwise all animations will immediately call their's completions
     and that will lead to undefined behaviour
     */
    private var controllerIsVisible: Bool = false
    
    // MARK: -  UI elements
    
    private lazy var progressView: StoriesProgressView = {
        let progress = StoriesProgressView(numberOfStories: storyGroup.storyTokens.count, storyDuration: 5.0)
        progress.delegate = self
        return progress
    }()
    
    private lazy var categoryTitleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.lightGreyText = true
        label.textAlignment = .left
        label.text = storyGroup.title
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 20.0 : 14.0, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: ThemeableImageView = {
        let imgView = ThemeableImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private lazy var titleLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 36.0 : 24.0, weight: .bold)
        return label
    }()
    
    private lazy var descLabel: ThemableLabel = {
        let label = ThemableLabel()
        label.greyText = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = theme.grayTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16, weight: .regular)
        return label
    }()
    
    private var button: RoundRectButton?
    
    // Services
    private let theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    
    // Observers
    private var themeNotificationToken: NotificationToken?
    
    // MARK: - UIViewController lifecycle
    
    init(storyGroup: StoryGroup) {
        self.storyGroup = storyGroup
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.storyGroup = StoryGroup(title: "", groupType: .whatsNew, storyTokens: [])
        super.init(coder: coder)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name(ConfigurationService.themeChangeNotification), object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !controllerIsVisible {
            progressView.start()
        }
        controllerIsVisible = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if controllerIsVisible {
            progressView.start()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progressView.stop()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: view)
        
        if let button = self.button, button.frame.contains(location) {
            return
        }
        
        if touch.tapCount == 0 {
            resumeStory()
            return
        }
        
        if location.x < view.frame.width / 2 {
            previousStory()
        } else {
            nextStory()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: view)
        
        if let button = self.button, button.frame.contains(location) {
            return
        }
        
        pauseStory()
    }
    
    // MARK: - Private methods
    
    private func nextStory() {
        DDLogDebug("Next story; Story group = \(storyGroup); current story index = \(currentStoryIndex)")
        
        if currentStoryIndex < storyGroup.storyTokens.count - 1 {
            currentStoryIndex += 1
            changeContent()
            progressView.next()
        } else {
            delegate?.nextStoriesAreOver()
        }
    }
    
    private func previousStory() {
        DDLogDebug("Previous story; Story group = \(storyGroup); current story index = \(currentStoryIndex)")
        
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            changeContent()
            progressView.previous()
        } else {
            progressView.start()
            delegate?.previousStoriesAreOver()
        }
    }
    
    private func pauseStory() {
        DDLogDebug("Pause story; Story group = \(storyGroup); current story index = \(currentStoryIndex)")
        progressView.pause()
    }
    
    private func resumeStory() {
        DDLogDebug("Resume story; Story group = \(storyGroup); current story index = \(currentStoryIndex)")
        progressView.resume()
    }
}

// MARK: - StoryViewController + StoriesProgressComponentViewDelegate

extension StoryViewController: StoriesProgressComponentViewDelegate {
    func segmentFullyFilled() {
        nextStory()
    }
}

// MARK: - StoryViewController + Setup UI

extension StoryViewController {
    private func setupUI() {
        setupProgressView()
        setConstraintsForContent()
        changeContent()
    }
    
    private func changeContent() {
        let title = currentStory.title ?? ""
        let description = currentStory.description ?? ""
        
        imageView.lightThemeImage = currentStory.image
        imageView.darkThemeImage = currentStory.darkImage
        theme.setupImage(imageView)
        
        titleLabel.text = title
        descLabel.text = description
        
        processContentForButton()
    }
    
    private func setConstraintsForContent() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(categoryTitleLabel)
        
        // Category label
        categoryTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        categoryTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isIpadTrait ? -80.0 : -64.0).isActive = true
        categoryTitleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: isIpadTrait ? 64.0 : 32.0).isActive = true
        
        // Image view
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        imageView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: isIpadTrait ? 32.0 : 16.0).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        // Title label
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: isIpadTrait ? 32.0 : 16.0).isActive = true
        
        // Description label
        descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: isIpadTrait ? 16.0 : 8.0).isActive = true
    }
    
    private func processContentForButton() {
        guard let buttonConfig = currentStory.buttonConfig else {
            self.button?.removeFromSuperview()
            self.button = nil
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor, constant: -24.0).isActive = true
            return
        }
        
        let button = RoundRectButton()
        button.applyStandardGreenStyle()
        button.makeTitleTextUppercased()
        button.customBackgroundColor = UIColor.AdGuardColor.green
        button.customHighlightedBackgroundColor = UIColor.AdGuardColor.disabledGreenColor
        button.setTitle(buttonConfig.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: isIpadTrait ? 24.0 : 16.0, weight: .regular)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        descLabel.constraints.forEach { const in
            if const == descLabel.bottomAnchor {
                descLabel.removeConstraint(const)
            }
        }
        
        view.addSubview(button)
        
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: isIpadTrait ? 60.0 : 40.0).isActive = true
        button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -24.0).isActive = true
        button.topAnchor.constraint(greaterThanOrEqualTo: descLabel.topAnchor, constant: 24.0).isActive = true
        
        self.button = button
    }
    
    private func setupProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressView)
        view.bringSubviewToFront(progressView)
        
        progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: isIpadTrait ? 32.0 : 16.0).isActive = true
        progressView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: isIpadTrait ? 16.0 : 8.0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: isIpadTrait ? -16.0 : -8.0).isActive = true
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupImage(imageView)
        theme.setupLabels([categoryTitleLabel, titleLabel, descLabel])
    }
    
    @objc private func buttonTapped() {
        guard let actionType = currentStory.buttonConfig?.actionType else {
            DDLogError("(StoryViewController) Action type in nil")
            return
        }
        
        switch actionType {
        case .readChangeLog:
            dismiss(animated: true)
        case .activateLicense:
            dismiss(animated: true)
        case .downloadAdguardVpn:
            dismiss(animated: true)
        case .moreOnDns:
            dismiss(animated: true)
        case .enableAdguardDns:
            dismiss(animated: true)
        case .enableGoogleDns:
            dismiss(animated: true)
        case .enableCloudflareDns:
            dismiss(animated: true)
        case .addCustomDns:
            dismiss(animated: true)
        }
    }
}
