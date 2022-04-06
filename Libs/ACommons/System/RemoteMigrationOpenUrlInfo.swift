import Foundation

struct RemoteMigrationOpenUrlInfo : OpenUrlInfo {
    let action: String
    let from: String
    let buildVersion: String

    let appId: String
    let appName: String
    let license: String?
    let receipt: String?

    func getUrlWithQueryItems() -> URL? {
        let items = getURLQueryItems()
        return UIApplication.shared.adguardUrl(with: items)
    }

    private func getURLQueryItems() -> [URLQueryItem] {
        var result: [URLQueryItem] = []
        result.append(URLQueryItem(name: "app", value: "ios"))
        result.append(URLQueryItem(name: "action", value: action))
        result.append(URLQueryItem(name: "from", value: from))
        result.append(URLQueryItem(name: "v", value: from))
        result.append(URLQueryItem(name: "app_id", value: appId))
        result.append(URLQueryItem(name: "app_name", value: appName))

        if let license = license {
            result.append(URLQueryItem(name: "license", value: license))
        }

        if let receipt = receipt {
            result.append(URLQueryItem(name: "receipt_data", value: receipt))
        }

        return result
    }
}
