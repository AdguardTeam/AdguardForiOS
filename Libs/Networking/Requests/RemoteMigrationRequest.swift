import Foundation

/// Object thant generate URL request for remote migration
final class RemoteMigrationRequest : RequestProtocol {
    private static let BACKEND_DOMAIN = "https://mobile.adtidy.org"
    private static let MIGRATION_URL = "/api/1.0/ios_migration/\(LoginService.APP_TYPE_VALUE)/status"

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
