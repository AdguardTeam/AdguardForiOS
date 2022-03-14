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
                    ComLog_LoggerWrapper.error(label, str)
                case .AGLL_WARN:
                    ComLog_LoggerWrapper.warn(label, str)
                case .AGLL_INFO:
                    ComLog_LoggerWrapper.info(label, str)
                case .AGLL_DEBUG:
                    ComLog_LoggerWrapper.debug(label, str)
                case .AGLL_TRACE:
                    ComLog_LoggerWrapper.debug(label, str)
                @unknown default:
                    ComLog_LoggerWrapper.info(label, str)
                }
            }
        }
    }
}
