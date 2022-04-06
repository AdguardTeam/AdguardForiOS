import Foundation

protocol OpenUrlInfo {
    var action: String { get }
    var from: String { get }
    var buildVersion: String { get }

    func getUrlWithQueryItems() -> URL?
}

