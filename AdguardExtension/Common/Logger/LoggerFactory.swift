class ComLog_LoggerFactory {

    static func getLoggerWrapper(_ label: String) -> ComLog_LoggerWrapper {
        return ComLog_LoggerWrapper(label)
    }

    static func getLoggerWrapper(_ clazz: Any.Type) -> ComLog_LoggerWrapper {
        return ComLog_LoggerWrapper("\(clazz)")
    }
}
