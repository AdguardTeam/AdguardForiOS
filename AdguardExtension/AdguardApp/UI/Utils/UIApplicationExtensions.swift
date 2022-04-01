import Foundation

extension UIApplication {
    /// Returns true if app is belong to ASL dev account
    var aslApp: Bool {
        return Bundle.main.bundleIdentifier == "com.adguard.AdGuardApp"
    }

    /// Checks the type of a legacy app installed on the device
    ///
    /// - Returns: Legacy app type or nil if legacy app was not found
    func detectLegacyAppInstalled() -> LegacyAppType? {
        if canOpenUrl(scheme: "transfer-scheme-adguard-pro:") {
            return .adguardPro
        } else if canOpenUrl(scheme: "transfer-scheme-adguard:") {
            return .adguard
        }
        return nil
    }

    private func canOpenUrl(scheme: String) -> Bool {
        guard let url = URL(string: scheme) else {
            DDLogInfo("Failed to create an url for scheme \(scheme)")
            return false
        }

        return UIApplication.shared.canOpenURL(url)
    }

    /// An enum representation of a legacy app installed
    enum LegacyAppType {
        // Regular AdGuard
        case adguard

        // AdGuardPro
        case adguardPro
    }
}
