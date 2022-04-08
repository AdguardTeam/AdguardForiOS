import Foundation
import CommonCrypto

enum SignatureConstructorError : Error, CustomDebugStringConvertible {
    case queryStringMissing
    case queryItemsListEmpty

    var debugDescription: String {
        switch self {
            case .queryStringMissing: return "Query string is missing"
            case .queryItemsListEmpty: return "Query items list argument is empty"
        }
    }
}

/// Object that generate signature for backend API requests
struct SignatureConstructor {

    // FIXME: Replace this MOCK secret with real
    private let secret = "SUPER_SECRET_VALUE"

    func getSignature(items: [String: String]) throws -> String {
        let items = items.map { URLQueryItem(name: $0.key, value: $0.value) }
        return try getSignature(items: items)
    }

    /// Returns signature for passed query items.
    ///
    /// - Parameter items: Query items
    /// - Throws: Throws error if passed items list is empty or if query string missing
    func getSignature(items: [URLQueryItem]) throws -> String {
        guard !items.isEmpty else {
            throw SignatureConstructorError.queryItemsListEmpty
        }

        let sorted = items.sorted(by: { $0.name < $1.name })

        var components = URLComponents()
        components.queryItems = sorted

        guard let query = components.query else {
            throw SignatureConstructorError.queryStringMissing
        }

        return (query + secret).MD5()
    }
}

fileprivate extension String {

    /// Hashes string with MD5 algorithm
    func MD5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
