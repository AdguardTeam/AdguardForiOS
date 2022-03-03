extension ComLog_LogLevelMode {
    func toLogLevel() -> ComLog_LogLevel {
        switch (self) {
            case .defaultMode: return .info
            case .extendedMode: return .debug
        }
    }
}
