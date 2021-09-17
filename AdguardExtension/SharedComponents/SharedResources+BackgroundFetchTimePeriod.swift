
extension AESharedResourcesProtocol {

    dynamic var backgroundFetchUpdatePeriod: BackgroundFetchUpdateTimePeriod {
        get {
            guard let object = sharedDefaults().object(forKey: BackgroundFetchUpdatePeriod) as? Int else {
                return .defaultPeriod
            }
            return BackgroundFetchUpdateTimePeriod(rawValue: object) ?? .defaultPeriod
        }
        set {
            sharedDefaults().set(newValue.rawValue, forKey: BackgroundFetchUpdatePeriod)
        }
    }
}
