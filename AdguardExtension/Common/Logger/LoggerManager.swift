import Foundation
import SwiftyBeaver

protocol LoggerManager: AnyObject {

    var rootLogDirectory: URL { get }

    func configure(_ logLevel: LogLevel)
}
