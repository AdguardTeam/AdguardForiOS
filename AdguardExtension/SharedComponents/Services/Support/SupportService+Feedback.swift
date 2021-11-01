///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

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
        let appName = Bundle.main.applicationName
        switch self {
        case .bugReport: return "\(appName) app bug report"
        case .feedback: return "\(appName) app user feedback"
        }
    }
}
