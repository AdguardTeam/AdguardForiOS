import Foundation
import SQLite

// MARK: - DnsUpstream + save/load from DB
extension DnsUpstream: Value {
    public static var declaredDatatype: String { Blob.declaredDatatype }
    
    public static func fromDatatypeValue(_ datatypeValue: Blob) -> Self {
        let decoder = JSONDecoder()
        let upstream = try! decoder.decode(DnsUpstream.self, from: Data.fromDatatypeValue(datatypeValue))
        return upstream
    }
    
    public var datatypeValue: Blob {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data.datatypeValue
    }
}

// MARK: - Array<Codable> + save/load from DB
extension Array: Value where Element: Codable {
    public static var declaredDatatype: String {
        return Blob.declaredDatatype
    }

    public static func fromDatatypeValue(_ datatypeValue: Blob) -> Self {
        let decoder = JSONDecoder()
        let array = try! decoder.decode(Self.self, from: Data.fromDatatypeValue(datatypeValue))
        return array
    }

    public var datatypeValue: Blob {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return data.datatypeValue
    }
}

extension Array: Expressible where Element: Codable {
    public var expression: Expression<Void> {
        return Expression(value: self).expression
    }
}
