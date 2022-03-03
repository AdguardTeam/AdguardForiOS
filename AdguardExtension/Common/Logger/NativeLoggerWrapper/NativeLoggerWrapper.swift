import os.log

/// Logger protocol for Apple logging system `Logger` and `os_Log`
protocol ComLog_NativeLoggerWrapper {
    /// Sends message to console app and debug console with specified log level
    func send(_ message: String, _ logLevel: ComLog_LogLevel)
}
