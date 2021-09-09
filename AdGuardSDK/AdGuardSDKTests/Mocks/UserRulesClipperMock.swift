import Foundation
@_implementationOnly import ContentBlockerConverter

final class UserRulesClipperMock: QuickAllowlistClipperProtocol {
    
    var replaceRuleCalledCount = 0
    var replaceRuleCalledParams: (rule: String, newRule: String, conversionResult: ConversionResult)!
    var replaceRuleResult: Result<ConversionResult> = .error(CommonError.error(message: ""))
    func replace(rule: String, with newRule: String, in conversionResult: ConversionResult) throws -> ConversionResult {
        replaceRuleCalledCount += 1
        replaceRuleCalledParams = (rule, newRule, conversionResult)
        switch replaceRuleResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
    
    var addAllowlistRuleCalledCount = 0
    var addAllowlistRuleCalledParams: (domain: String, conversionResult: ConversionResult)!
    var addAllowlistRuleResult: Result<ConversionResult> = .error(CommonError.error(message: ""))
    func addAllowlistRule(by domain: String, to conversionResult: ConversionResult) throws -> ConversionResult {
        addAllowlistRuleCalledCount += 1
        addAllowlistRuleCalledParams = (domain, conversionResult)
        switch addAllowlistRuleResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
    
    var addInvertedAllowlistRuleCalledCount = 0
    var addInvertedAllowlistRuleCalledParams: (domain: String, conversionResult: ConversionResult)!
    var addInvertedAllowlistRuleResult: Result<ConversionResult> = .error(CommonError.error(message: ""))
    func addInvertedAllowlistRule(by domain: String, to conversionResult: ConversionResult) throws -> ConversionResult {
        addInvertedAllowlistRuleCalledCount += 1
        addInvertedAllowlistRuleCalledParams = (domain, conversionResult)
        switch addInvertedAllowlistRuleResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
    
    var removeAllowlistRuleCalledCount = 0
    var removeAllowlistRuleCalledParams: (domain: String, conversionResult: ConversionResult)!
    var removeAllowlistRuleResult: Result<ConversionResult> = .error(CommonError.error(message: ""))
    func removeAllowlistRule(by domain: String, from conversionResult: ConversionResult) throws -> ConversionResult {
        removeAllowlistRuleCalledCount += 1
        removeAllowlistRuleCalledParams = (domain, conversionResult)
        switch removeAllowlistRuleResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
    
    var removeInvertedAllowlistRuleCalledCount = 0
    var removeInvertedAllowlistRuleCalledParams: (domain: String, conversionResult: ConversionResult)!
    var removeInvertedAllowlistRuleResult: Result<ConversionResult> = .error(CommonError.error(message: ""))
    func removeInvertedAllowlistRule(by domain: String, from conversionResult: ConversionResult) throws -> ConversionResult {
        removeInvertedAllowlistRuleCalledCount += 1
        removeInvertedAllowlistRuleCalledParams = (domain, conversionResult)
        switch removeInvertedAllowlistRuleResult {
        case .success(let result): return result
        case .error(let error): throw error
        }
    }
}
