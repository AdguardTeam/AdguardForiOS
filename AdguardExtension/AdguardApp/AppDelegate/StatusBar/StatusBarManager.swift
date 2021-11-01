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

import SharedAdGuardSDK
import UIKit

/// This object is responsible for controlling `StatusBarWindow` position, size and content
final class StatusBarManager: NSObject {

    // MARK: - Private properties

    private let configuration: ConfigurationServiceProtocol
    private let keyWindow: UIWindow
    private let statusBarWindow: StatusBarWindow
    private let animationDuration: CGFloat = 0.5

    private var statusBarWindowSize: CGSize {
        let bottomSafeAreaInset = keyWindow.safeAreaInsets.bottom / 2.0
        let height = statusBarWindow.isIpadTrait ? 20.0 : 16.0
        return CGSize(
            width: keyWindow.frame.width,
            height: height + bottomSafeAreaInset
        )
    }

    private var shownOrigin: CGPoint {
        return CGPoint(
            x: 0.0,
            y: keyWindow.frame.maxY - statusBarWindowSize.height
        )
    }

    private var hiddenOrigin: CGPoint {
        return CGPoint(
            x: 0.0,
            y: keyWindow.frame.maxY
        )
    }

    private var showAnimator: UIViewPropertyAnimator?
    private var hideAnimator: UIViewPropertyAnimator?

    /* Observers */
    private var filtersUpdateStarted: SharedAdGuardSDK.NotificationToken?
    private var filtersUpdateFinished: SharedAdGuardSDK.NotificationToken?
    private var filtersConvertionStarted: SharedAdGuardSDK.NotificationToken?
    private var filtersConvertionFinished: SharedAdGuardSDK.NotificationToken?
    private var contentBlockersUpdateStarted: SharedAdGuardSDK.NotificationToken?
    private var contentBlockersUpdateFinished: SharedAdGuardSDK.NotificationToken?
    private var orientationChangeNotification: SharedAdGuardSDK.NotificationToken?
    private var advancedModeObserver: NotificationToken?
    private var showStatusBarObserver: NotificationToken?

    init(configuration: ConfigurationServiceProtocol, keyWindow: UIWindow) {
        self.configuration = configuration
        self.keyWindow = keyWindow
        self.statusBarWindow = StatusBarWindow(frame: .zero)
        super.init()

        self.statusBarWindow.frame.size = statusBarWindowSize
        self.statusBarWindow.frame.origin = hiddenOrigin
        initializeObservers()
    }

    // MARK: - Private methods

    private func initializeObservers() {
        filtersUpdateStarted = NotificationCenter.default.filtersUpdateStart(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.showStatusBar(with: String.localizedString("loading_filters"))
            }
        }

        filtersUpdateFinished = NotificationCenter.default.filtersUpdateFinished(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.hideStatusBar()
            }
        }

        filtersConvertionStarted = NotificationCenter.default.filtersConvertionStarted(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.showStatusBar(with: String.localizedString("converting_rules"))
            }
        }

        filtersConvertionFinished = NotificationCenter.default.filtersConvertionFinished(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.hideStatusBar()
            }
        }

        contentBlockersUpdateStarted = NotificationCenter.default.contentBlockersUpdateStart(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.showStatusBar(with: String.localizedString("loading_content_blockers"))
            }
        }

        contentBlockersUpdateFinished = NotificationCenter.default.contentBlockersUpdateFinished(queue: .main) { [weak self] in
            if self?.configuration.showStatusBar == true {
                self?.hideStatusBar()
            }
        }

        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { _ in
            // This code will be executed after the rotation was completed (in the main queue) and the new sizes are available
            DispatchQueue.main.async { [weak self] in
                self?.rotate()
            }
        }

        advancedModeObserver = NotificationCenter.default.observe(name: .advancedModeChanged, object: nil, queue: .main) { [weak self] _ in
            if self?.configuration.showStatusBar == false {
                self?.hideStatusBar()
            }
        }

        showStatusBarObserver = NotificationCenter.default.observe(name: .showStatusBarChanged, object: nil, queue: .main) { [weak self] _ in
            if self?.configuration.showStatusBar == false {
                self?.hideStatusBar()
            }
        }
    }

    /// Shows status bar if is not already shown
    /// Also handles cases when status bar has 2 animations at a time
    private func showStatusBar(with text: String?) {
        statusBarWindow.text = text

        // If animation is currently hiding when we want to show status bar
        if let hideAnimator = hideAnimator, hideAnimator.isRunning {
            let percentOfCompletion = hideAnimator.fractionComplete
            let restAnimationDuration = animationDuration * (1.0 - percentOfCompletion)
            hideAnimator.stopAnimation(true)
            hideAnimator.finishAnimation(at: .current)
            self.hideAnimator = nil

            let animator = UIViewPropertyAnimator(duration: restAnimationDuration, curve: .easeOut) { [unowned self] in
                statusBarWindow.frame.origin = shownOrigin
            }

            statusBarWindow.isHidden = false
            showAnimator = animator
            showAnimator?.startAnimation()
            return
        }

        // If status bar is showing now or is already shown
        if let showAnimator = showAnimator, showAnimator.isRunning || showAnimator.state == .inactive {
            return
        }

        // If status bar is hidden
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) { [unowned self] in
            statusBarWindow.frame.origin = shownOrigin
        }
        statusBarWindow.isHidden = false
        showAnimator = animator
        showAnimator?.startAnimation()
        hideAnimator = nil
    }

    /// Hides status bar if is not already hidden
    /// Also handles cases when status bar has 2 animations at a time
    private func hideStatusBar() {
        // If animation is showing when we want to hide status bar
        if let showAnimator = showAnimator, showAnimator.isRunning {
            let percentOfCompletion = showAnimator.fractionComplete
            let restAnimationDuration = animationDuration * (1.0 - percentOfCompletion)
            showAnimator.stopAnimation(true)
            showAnimator.finishAnimation(at: .current)
            self.showAnimator = nil

            let animator = UIViewPropertyAnimator(duration: restAnimationDuration, curve: .easeIn) { [unowned self] in
                statusBarWindow.frame.origin = hiddenOrigin
            }
            animator.addCompletion { [weak self] position in
                if position == .end {
                    self?.statusBarWindow.isHidden = true
                }
            }
            hideAnimator = animator
            hideAnimator?.startAnimation()
            return
        }

        // Status bar is hiding now or is already hidden
        if let hideAnimator = hideAnimator, hideAnimator.isRunning || hideAnimator.state == .inactive {
            return
        }

        // If status bar is shown
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeIn) { [unowned self] in
            statusBarWindow.frame.origin = hiddenOrigin
        }
        animator.addCompletion { [weak self] position in
            if position == .end {
                self?.statusBarWindow.isHidden = true
            }
        }
        hideAnimator = animator
        hideAnimator?.startAnimation()
        showAnimator = nil
    }

    /// Rotates status bar when device orientation changes
    private func rotate() {
        // If status bar is showing now
        if let showAnimator = showAnimator, showAnimator.isRunning {
            // Stop animation and save percentage of animation completed
            let percentOfCompletion = showAnimator.fractionComplete
            let restAnimationDuration = animationDuration * (1.0 - percentOfCompletion)
            showAnimator.stopAnimation(true)
            showAnimator.finishAnimation(at: .current)
            statusBarWindow.isHidden = true

            // Set status bar new position with respect to percentage of animation completed
            let currentYposition = CGPoint(
                x: 0.0,
                y: keyWindow.frame.maxY - (statusBarWindowSize.height * (1.0 - percentOfCompletion))
            )
            statusBarWindow.frame.size = statusBarWindowSize
            statusBarWindow.frame.origin = currentYposition

            // Continue animation with new orientation
            let animator = UIViewPropertyAnimator(duration: restAnimationDuration, curve: .easeOut) { [unowned self] in
                statusBarWindow.frame.origin = shownOrigin
            }
            statusBarWindow.isHidden = false
            self.showAnimator = animator
            self.showAnimator?.startAnimation()
            hideAnimator = nil
            return
        }

        // If status bar is hiding now
        if let hideAnimator = hideAnimator, hideAnimator.isRunning {
            // Stop animation and save percentage of animation completed
            let percentOfCompletion = hideAnimator.fractionComplete
            let restAnimationDuration = animationDuration * (1.0 - percentOfCompletion)
            hideAnimator.stopAnimation(true)
            hideAnimator.finishAnimation(at: .current)
            statusBarWindow.isHidden = true

            // Set status bar new position with respect to percentage of animation completed
            let currentYposition = CGPoint(
                x: 0.0,
                y: keyWindow.frame.maxY - (statusBarWindowSize.height * percentOfCompletion)
            )
            statusBarWindow.frame.size = statusBarWindowSize
            statusBarWindow.frame.origin = currentYposition

            // Continue animation with new orientation
            let animator = UIViewPropertyAnimator(duration: restAnimationDuration, curve: .easeIn) { [unowned self] in
                statusBarWindow.frame.origin = hiddenOrigin
            }
            animator.addCompletion { [weak self] position in
                if position == .end {
                    self?.statusBarWindow.isHidden = true
                }
            }
            statusBarWindow.isHidden = false
            self.hideAnimator = animator
            self.hideAnimator?.startAnimation()
            showAnimator = nil
            return
        }

        // If status bar is shown
        if let showAnimator = showAnimator, showAnimator.state == .inactive {
            statusBarWindow.frame.size = statusBarWindowSize
            statusBarWindow.frame.origin = shownOrigin
            return
        }

        // If status bar is hidden
        if hideAnimator == nil || hideAnimator?.state == .inactive {
            statusBarWindow.frame.size = statusBarWindowSize
            statusBarWindow.frame.origin = hiddenOrigin
            return
        }
    }
}
