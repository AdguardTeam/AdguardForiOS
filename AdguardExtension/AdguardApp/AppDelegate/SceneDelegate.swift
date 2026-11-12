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

/// Connects the scene life cycle, which apps built with SDK 27 must adopt, to `AppDelegate`.
///
/// UIKit creates the window from `UISceneStoryboardFile` in Info.plist. Scene events are passed to the
/// matching `AppDelegate` methods. The launch work that needs the UI runs on the first foreground entry
/// of the scene, see `AppDelegate.performForegroundLaunchWorkIfNeeded()`.
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    /// URLs the app has been launched with. They are opened after the launch work, as before the scene life cycle.
    private var launchURLContexts: Set<UIOpenURLContext> = []

    private var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        appDelegate?.window = window
        launchURLContexts = connectionOptions.urlContexts
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        appDelegate?.performForegroundLaunchWorkIfNeeded()
        open(launchURLContexts)
        launchURLContexts = []
        appDelegate?.applicationWillEnterForeground(UIApplication.shared)
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        appDelegate?.applicationDidBecomeActive(UIApplication.shared)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        appDelegate?.applicationWillResignActive(UIApplication.shared)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        appDelegate?.applicationDidEnterBackground(UIApplication.shared)
    }

    func windowScene(_ windowScene: UIWindowScene,
                     didUpdate previousCoordinateSpace: UICoordinateSpace,
                     interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
                     traitCollection previousTraitCollection: UITraitCollection) {
        // The app reads the system appearance only on scene activation by default
        // (see AppDelegate.setAppInterfaceStyle call sites). Forward live appearance
        // changes here so the System theme mode re-themes without a background trip.
        // Orientation-only or size-only updates are ignored via the style guard.
        let newStyle = windowScene.traitCollection.userInterfaceStyle
        guard previousTraitCollection.userInterfaceStyle != newStyle else { return }
        appDelegate?.setAppInterfaceStyle()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        open(URLContexts)
    }

    private func open(_ urlContexts: Set<UIOpenURLContext>) {
        for context in urlContexts {
            var options: [UIApplication.OpenURLOptionsKey: Any] = [.openInPlace: context.options.openInPlace]
            options[.sourceApplication] = context.options.sourceApplication
            options[.annotation] = context.options.annotation
            _ = appDelegate?.application(UIApplication.shared, open: context.url, options: options)
        }
    }
}
