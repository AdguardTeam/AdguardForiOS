import Foundation
@_implementationOnly import protocol ContentBlockerConverter.WebExtensionHelpersProtocol

final class WebExtensionHelpersMock: WebExtensionHelpersProtocol {

    var invokedUserRuleIsAssociatedCount = 0
    var invokedUserRuleIsAssociatedParameter: (domain: String, userRule: String)?
    var invokedUserRuleIsAssociatedParameters: [(domain: String, userRule: String)] = []
    var userRuleIsAssociatedResultHandler: ((_ domain: String, _ userRule: String) -> Bool)?
    func userRuleIsAssociated(with domain: String, _ userRule: String) -> Bool {
        invokedUserRuleIsAssociatedCount += 1
        invokedUserRuleIsAssociatedParameter = (domain, userRule)
        invokedUserRuleIsAssociatedParameters.append((domain, userRule))
        return userRuleIsAssociatedResultHandler?(domain, userRule) ?? false
    }

    func convertDomainToAllowlistRule(_ domain: String) -> String {
        return ""
    }

    func convertAllowlistRuleToDomain(_ ruleText: String) -> String {
        return ""
    }

    func convertDomainToInvertedAllowlistRule(_ domain: String) -> String {
        return ""
    }

    func convertInvertedAllowlistRuleToDomain(_ rule: String) -> String {
        return ""
    }
}
