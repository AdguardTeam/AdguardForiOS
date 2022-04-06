import Foundation

extension UIApplication {

    /// Returns true if legacy app was detected.
    /// - Warning: True may be returned only if this computed property called from ASL app
    var legacyAppDetected: Bool {
        if let _ = detectLegacyAppInstalled() {
            return true
        }
        return false
    }

    /// Checks the type of a legacy app installed on the device
    ///
    /// - Returns: Legacy app type or nil if legacy app was not found.
    /// - Warning: Legacy type will be returned only if ASL app call this function
    func detectLegacyAppInstalled() -> LegacyAppType? {
        let isASL = Bundle.main.isAslApp
        if canOpenUrl(scheme: "transfer-scheme-adguard-pro:"), isASL {
            return .adguardPro
        } else if canOpenUrl(scheme: "transfer-scheme-adguard:"), isASL {
            return .adguard
        }
        return nil
    }

    private func canOpenUrl(scheme: String) -> Bool {
        guard let url = URL(string: scheme) else {
            DDLogInfo("Failed to create an url for scheme \(scheme)")
            return false
        }

        return canOpenURL(url)
    }

    /// An enum representation of a legacy app installed
    enum LegacyAppType : String {
        // Regular AdGuard
        case adguard

        // AdGuardPro
        case adguardPro
    }
}
