
import Foundation

@objc
class FilterGroupId: NSObject {
    static let user = 0
    static let ads = 1
    static let privacy = 2
    static let socialWidgets = 3
    static let annoyances = 4
    static let security = 5
    static let other = 6
    static let languageSpecific = 7
    @objc static let custom = 101
}

@objc
class EnabledFilterGroups: NSObject {
    @objc static let groupIds: Set<Int> = [FilterGroupId.ads,
                                          FilterGroupId.privacy,
                                          FilterGroupId.languageSpecific]
}


