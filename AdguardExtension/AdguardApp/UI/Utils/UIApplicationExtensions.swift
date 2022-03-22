import Foundation

extension UIApplication {

    /// Checks the type of a legacy app installed on the device
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
