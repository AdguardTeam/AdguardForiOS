import Foundation

final class RemoteMigrationRequest : RequestProtocol {

    // FIXME replace with prod backend when ready
    private static let BACKEND_DOMAIN = "https://testmobile.adtidy.org"
    private static let MIGRATION_URL = "/api/1.0/ios_migration/\(Bundle.main.isPro ? "ADGUARD_FOR_IOS_PRO" : "ADGUARD_FOR_IOS")/status"

    private let appId: String

    init(_ appId: String) {
        self.appId = appId
    }

    /// URL request to AdGuard backend for remote migration
    var urlRequest: URLRequest? {
        let query = "app_id=\(appId)"
        let request = "\(RemoteMigrationRequest.BACKEND_DOMAIN)\(RemoteMigrationRequest.MIGRATION_URL)?\(query)"

        if let url = URL(string: request) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
        return nil
    }
}