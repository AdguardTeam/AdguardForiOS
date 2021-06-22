import Foundation

struct FilterFileContent: Equatable {
    let text: String
    let lines: [String]
    let group: SafariGroup.GroupType
    
    init(text: String, group: SafariGroup.GroupType) {
        self.text = text
        self.lines = text.components(separatedBy: .newlines)
        self.group = group
    }
}

public enum ContentBlockerType: Int, CaseIterable, Codable {
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
