import Foundation

/// Object that generate TDS url
struct RemoteMigrationOpenUrlInfo : OpenUrlInfo {
    let action: String
    let from: String
    let buildVersion: String

    let appId: String
    let appType: String
    let license: String?

    /// Returns TDS url or nil if TDS url not valid
    func getUrlWithQueryItems() -> URL? {
        let items = getURLQueryItems()
        return UIApplication.shared.adguardUrl(with: items)
    }

    private func getURLQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "app", value: "ios"),
            URLQueryItem(name: "action", value: action),
            URLQueryItem(name: "from", value: from),
            URLQueryItem(name: "v", value: buildVersion),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_type", value: appType),
            URLQueryItem(name: "license", value: license ?? "null")
        ]
    }
}
