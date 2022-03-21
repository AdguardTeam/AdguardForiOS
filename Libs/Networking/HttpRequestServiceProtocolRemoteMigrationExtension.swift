import Foundation

extension HttpRequestServiceProtocol {
    /// FIXME: add comment
    func checkRemoteMigration(_ completion: @escaping (_ result: Result<Bool, Error>) -> Void) {
        let config = RequestFactory.remoteMigrationConfig()
        requestSender.send(requestConfig: config, completionHandler: completion)
    }
}
