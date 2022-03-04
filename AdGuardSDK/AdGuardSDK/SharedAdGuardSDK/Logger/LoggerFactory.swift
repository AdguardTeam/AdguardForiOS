public class ComLog_LoggerFactory {

    public static func getLoggerWrapper(_ label: String) -> ComLog_LoggerWrapper {
        return ComLog_LoggerWrapper(label)
    }

    public static func getLoggerWrapper(_ clazz: Any.Type) -> ComLog_LoggerWrapper {
        return ComLog_LoggerWrapper("\(clazz)")
    }
}
