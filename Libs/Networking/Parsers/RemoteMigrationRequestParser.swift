import Foundation

/// The struct that stores 'migration is needed' response from AdGuard backend
struct RemoteMigrationTransfer : Decodable {
    let migrateApp: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.migrateApp = try container.decode(Bool.self, forKey: .migrateApp)
    }

    enum CodingKeys: String, CodingKey {
        case migrateApp = "migrate_app"
    }
}

struct RemoteMigrationRequestParser : ParserProtocol {

    typealias Model = Bool

    func parse(data: Data, response: URLResponse?) -> Model? {
        if let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    let transfer = try JSONDecoder().decode(RemoteMigrationTransfer.self, from: data)
                    return transfer.migrateApp
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
