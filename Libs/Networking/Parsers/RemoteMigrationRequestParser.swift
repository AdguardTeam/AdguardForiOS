import Foundation

fileprivate struct RemoteMigrationTransfer : Decodable {
    let transferApp: Bool
}

struct RemoteMigrationRequestParser : ParserProtocol {

    typealias Model = Bool

    func parse(data: Data, response: URLResponse?) -> Model? {
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let transfer = try JSONDecoder().decode(RemoteMigrationTransfer.self, from: data)
                    return transfer.transferApp
                } catch {
                    DDLogError("(RemoteMigrationRequestParser) - Serialization error: \(error)")
                    return nil
                }
            }
            DDLogError("(RemoteMigrationRequestParser) - Response status code is \(response.statusCode)")
            return nil
        }
        DDLogError("(RemoteMigrationRequestParser) - Response is nil")
        return nil
    }
}
