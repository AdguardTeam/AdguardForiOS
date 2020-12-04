protocol FeedBackProtocol {
    var applicationId: String? { get }
    var version: String? { get }
    var email: String? { get }
    var language: String? { get }
    var subject: String? { get }
    var description: String? { get }
    var applicationState: String? { get }
    var appName: String { get }
    var debugInfo: String? { get }
}

struct FeedBack: FeedBackProtocol {
    let applicationId: String?
    let version: String?
    let email: String?
    let language: String?
    let subject: String?
    let description: String?
    let applicationState: String?
    let appName: String = "adguard_ios"
    let debugInfo: String?
    
    init(applicationId: String?, version: String?, email: String?, language: String?, subject: String?, description: String?, applicationState: String?, debugInfo: String) {
        self.applicationId = applicationId
        self.version = version
        self.email = email
        self.language = language
        self.subject = subject
        self.description = description
        self.applicationState = applicationState
        self.debugInfo = debugInfo
    }
}

enum ReportType {
    case bugReport
    case feedback
    
    // email subject
    var subject: String {
        let appName = Bundle.main.applicationName ?? "AdGuard"
        switch self {
        case .bugReport: return "\(appName) app bug report"
        case .feedback: return "\(appName) app user feedback"
        }
    }
}
