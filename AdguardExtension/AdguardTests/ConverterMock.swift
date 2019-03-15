
import Foundation

class ConverterMock: NSObject, AESFilterConverterProtocol {
    func json(fromRules rules: [Any]!, upTo limit: UInt, optimize: Bool) -> [AnyHashable : Any]! {
        
        var json = "["
        for ruleAny in rules {
            let rule = ruleAny as! ASDFilterRule
            json += rule.ruleText + "\n"
        }
        json += "]"
        
        return [AESFConvertedRulesKey: json]
    }
    
}
