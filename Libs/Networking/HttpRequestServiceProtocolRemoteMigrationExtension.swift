import Foundation

extension HttpRequestServiceProtocol {

    /**
     Checks if remote migration is triggered by the server side
     - See: https://bit.adguard.com/projects/JAVA/repos/mobile-backend/browse#resources-ios-app-migration-controller-test-test-migration-status
     - Parameters:
       - appId: application ID
       - completion: lambda to handle the result with
     */
    func checkRemoteMigration(_ appId: String, _ completion: @escaping (_ result: Result<Bool, Error>) -> Void) {
        let config = RequestFactory.remoteMigrationConfig(appId)
        requestSender.send(requestConfig: config, completionHandler: completion)
    }

    /// Returns in-app purchase receipt hash value
    func getInAppPurchaseReceiptHash(_ appId: String, inAppPurchaseBase64Receipt: String, completion: @escaping (_ result: Result<String, Error>) -> Void) {
        let config = RequestFactory.inAppPurchaseReceiptHashConfig(appId, inAppPurchaseBase64Receipt: inAppPurchaseBase64Receipt)
        requestSender.send(requestConfig: config, completionHandler: completion)
    }
}
