import Foundation

struct FilterFileContent {
    let text: String
    let lines: [String]
    let group: SafariGroup.GroupType
    
    init(text: String, group: SafariGroup.GroupType) {
        self.text = text
        self.lines = text.components(separatedBy: .newlines)
        self.group = group
    }
}

@objc class AdGuardFilterGroupObjWrapper: NSObject{
    @objc static let customGroupId = SafariGroup.GroupType.custom.rawValue
    @objc static let enabledGroupIds: Set<Int> = [SafariGroup.GroupType.ads.rawValue,
                                                  SafariGroup.GroupType.privacy.rawValue,
                                                  SafariGroup.GroupType.languageSpecific.rawValue]
}

struct SafariFilter {
    let type: ContentBlockerType
    let jsonString: String
    let totalRules: Int
    let totalConverted: Int
    let overlimit: Bool
}

public enum ContentBlockerType: Int, CaseIterable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security
    
    var affinity: Affinity {
        switch self {
        case .general: return .general
        case .privacy: return .privacy
        case .socialWidgetsAndAnnoyances: return .socialWidgetsAndAnnoyances
        case .other: return .other
        case .custom: return .custom
        case .security: return .security
        }
    }
}
