import Foundation
import AGDnsProxy
import SharedAdGuardSDK

extension AGLogger {
    static func setup(_ logLevel: AGLogLevel) {

        AGLogger.setLevel(logLevel)

        AGLogger.setCallback { level, msg, length in
            guard let msg = msg else { return }
            let data = Data(bytes: msg, count: Int(length))
            let label = "DnsLibs"
            if let str = String(data: data, encoding: .utf8) {
                switch (level) {
                case .AGLL_ERR:
                    LoggerWrapper.error(label, str)
                case .AGLL_WARN:
                    LoggerWrapper.warn(label, str)
                case .AGLL_INFO:
                    LoggerWrapper.info(label, str)
                case .AGLL_DEBUG:
                    LoggerWrapper.debug(label, str)
                case .AGLL_TRACE:
                    LoggerWrapper.debug(label, str)
                @unknown default:
                    LoggerWrapper.info(label, str)
                }
            }
        }
    }
}
