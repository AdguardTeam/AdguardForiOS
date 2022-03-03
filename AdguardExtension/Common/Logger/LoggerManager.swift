import Foundation
import SwiftyBeaver

protocol ComLog_LoggerManager: AnyObject {

    var rootLogDirectory: URL { get }

    func configure(_ logLevel: ComLog_LogLevel)
}
