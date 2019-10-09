
import Foundation

class NotEcapingJsonSerialization {
    
    open class func data(withJSONObject: Any, options: JSONSerialization.WritingOptions) throws -> Data {
        
        do {
            if #available(iOS 13.0, *) {
                var newOption = options
                newOption.insert(.withoutEscapingSlashes)
                return try JSONSerialization.data(withJSONObject: withJSONObject, options: newOption)
            }
            else {
                let data = try JSONSerialization.data(withJSONObject: withJSONObject, options: options)
                let str = String(data: data, encoding: .utf8)
                let replaced = str!.replacingOccurrences(of: "\\/", with: "/")
                return replaced.data(using: .utf8)!
            }
        }
        catch {
            throw error
        }
    }
}
