import Foundation

public struct AdGuardFilter {
    let text: String
    let group: AdGuardFilterGroup
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

@objc class AdGuardFilterGroupObjWrapper: NSObject{
    @objc static let customGroupId = AdGuardFilterGroup.custom.rawValue
    @objc static let enabledGroupIds: Set<Int> = [AdGuardFilterGroup.ads.rawValue,
                                            AdGuardFilterGroup.privacy.rawValue,
                                            AdGuardFilterGroup.languageSpecific.rawValue]
}

public struct SafariFilter {
    public let type: ContentBlockerType
    public let jsonString: String?
    public let totalRules: Int?
    public let totalConverted: Int?
}

public enum ContentBlockerType: Int, CaseIterable {
    case general
    case privacy
    case socialWidgetsAndAnnoyances
    case other
    case custom
    case security
}
