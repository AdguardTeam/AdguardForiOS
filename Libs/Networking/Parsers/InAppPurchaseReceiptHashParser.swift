import Foundation

/// Object that parse InAppPurchaseReceiptHashRequest response
struct InAppPurchaseReceiptHashParser : ParserProtocol {
    typealias Model = String

    func parse(data: Data, response: URLResponse?) -> Model? {
        guard let response = response as? HTTPURLResponse else {
            DDLogError("(InAppPurchaseReceiptHashParser) - HTTP response missing")
            return nil
        }

        var result: Model?

        if response.statusCode == 200 {
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                    result = json["hash"]
                    DDLogInfo("(InAppPurchaseReceiptHashParser) - Successfully fetch receipt hash")
                }

                DDLogError("(InAppPurchaseReceiptHashParser) - JSON object is missing")
            } catch {
                DDLogError("(InAppPurchaseReceiptHashParser) - JSON serialisation error: \(error)")
            }

            return result
        }

        DDLogError("(InAppPurchaseReceiptHashParser) - HTTP response status code: \(response.statusCode)")
        return nil
    }
}
