import Foundation

struct RemoteMigrationRequest : RequestProtocol {

    /// URL request to our backend for remote migration
    var urlRequest: URLRequest? {
        let request = "some/api"

        if let url = URL(string: request) {
            var request = URLRequest(url: url)
            // FIXME: Implement request parameters
            return request
        }
        return nil
    }
}
