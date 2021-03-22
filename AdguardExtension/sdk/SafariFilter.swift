import Foundation

public struct AdGuardFilter {
    let text: String
    let group: AdGuardFilterGroup

    public init(text: String, group: AdGuardFilterGroup) {
        self.text = text
        self.group = group
    }
}

public enum AdGuardFilterGroup: Int {
    case ads = 1
    case privacy = 2
    case socialWidgets = 3
    case annoyances = 4
    case security = 5
    case other = 6
    case languageSpecific = 7
    case custom = 101
}

public struct SafariFilter {
    public let type: ContentBlockerType
    public let jsonString: String?
    public let totalRules: Int?
    public let totalConverted: Int?
    public let error: Error?
}

public enum ContentBlockerType: Int, CaseIterable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security
}
