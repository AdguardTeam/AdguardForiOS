import Foundation

/// Object that generate URL request for fetching in-app purchase receipt hash value
final class InAppPurchaseReceiptHashRequest : RequestProtocol {
    // FIXME replace with prod backend when ready
    private static let BACKEND_DOMAIN = "https://testmobile.adtidy.org"
    private static let API_URL = "/api/1.0/ios_migration/\(LoginService.APP_TYPE_VALUE)/store_receipt"

    let appId: String
    let inAppPurchaseBase64Receipt: String

    init(appId: String,
         inAppPurchaseBase64Receipt: String) {
        self.appId = appId
        self.inAppPurchaseBase64Receipt = inAppPurchaseBase64Receipt
    }

    /// URL request to AdGuard backend for remote migration
    var urlRequest: URLRequest? {
        guard let components = URLComponents(string: InAppPurchaseReceiptHashRequest.BACKEND_DOMAIN + InAppPurchaseReceiptHashRequest.API_URL) else {
            DDLogError("(InAppPurchaseReceiptHashRequest) - Wrong URL")
            return nil
        }

        var queryItems = [
            "app_id": appId,
            "license": inAppPurchaseBase64Receipt,
        ]

        let signatureConstructor = SignatureConstructor()
        do {
            let signature = try signatureConstructor.getSignature(items: queryItems)
            queryItems["signature"] = signature
        } catch {
            DDLogError("(InAppPurchaseReceiptHashRequest) - Failed to get signature, error: \(error)")
            return nil
        }

        if let url = components.url,
           let httpBody = queryItems.percentEncoded() {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = Data(httpBody)
            return request
        }

        DDLogError("(InAppPurchaseReceiptHashRequest) - Request missing")
        return nil
    }
}
