import Foundation

// Protocol for objects that would  be provide TDS url
protocol OpenUrlInfo {
    var action: String { get }
    var from: String { get }
    var buildVersion: String { get }

    func getUrlWithQueryItems() -> URL?
}

