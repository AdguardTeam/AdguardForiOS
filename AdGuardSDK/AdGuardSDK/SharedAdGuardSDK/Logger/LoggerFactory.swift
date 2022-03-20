public class LoggerFactory : NSObject {

    @objc
    public static func getLoggerWrapper(_ label: String) -> LoggerWrapper {
        return LoggerWrapper(label)
    }

    @objc
    public static func objcGetLoggerWrapper(_ clazz: AnyObject.Type) -> LoggerWrapper {
        return LoggerWrapper("\(clazz)")
    }

    public static func getLoggerWrapper(_ clazz: Any.Type) -> LoggerWrapper {
        return LoggerWrapper("\(clazz)")
    }
}
