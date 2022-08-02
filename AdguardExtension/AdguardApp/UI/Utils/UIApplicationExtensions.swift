import Foundation

extension UIApplication {

    private func canOpenUrl(scheme: String) -> Bool {
        guard let url = URL(string: scheme) else {
            DDLogInfo("Failed to create an url for scheme \(scheme)")
            return false
        }

        return canOpenURL(url)
    }
}
