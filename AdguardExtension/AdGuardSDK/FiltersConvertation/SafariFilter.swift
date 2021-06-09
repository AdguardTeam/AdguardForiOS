import Foundation

struct FilterFileContent {
    let text: String
    let lines: [String]
    let group: AdGuardFilterGroup
    
    init(text: String, group: AdGuardFilterGroup) {
        self.text = text
        self.lines = text.components(separatedBy: .newlines)
        self.group = group
    }
}

enum AdGuardFilterGroup: Int {
    case ads = 1
    case privacy = 2
    case socialWidgets = 3
    case annoyances = 4
    case security = 5
    case other = 6
    case languageSpecific = 7
    case custom = 101
    
    var contentBlockerType: ContentBlockerType {
        switch self {
        case .ads: return .general
        case .privacy: return .privacy
        case .socialWidgets: return .socialWidgetsAndAnnoyances
        case .annoyances: return .socialWidgetsAndAnnoyances
        case .security: return .security
        case .other: return .other
        case .languageSpecific: return .general
        case .custom: return .custom
        }
    }
}

@objc class AdGuardFilterGroupObjWrapper: NSObject{
    @objc static let customGroupId = AdGuardFilterGroup.custom.rawValue
    @objc static let enabledGroupIds: Set<Int> = [AdGuardFilterGroup.ads.rawValue,
                                            AdGuardFilterGroup.privacy.rawValue,
                                            AdGuardFilterGroup.languageSpecific.rawValue]
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
