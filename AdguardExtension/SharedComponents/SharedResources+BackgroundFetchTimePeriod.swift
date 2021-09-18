
extension AESharedResourcesProtocol {

    dynamic var backgroundFetchUpdatePeriod: BackgroundFetchUpdateInterval {
        get {
            guard let object = sharedDefaults().object(forKey: BackgroundFetchUpdatePeriod) as? Int else {
                return .defaultPeriod
            }
            return BackgroundFetchUpdateInterval(rawValue: object) ?? .defaultPeriod
        }
        set {
            sharedDefaults().set(newValue.rawValue, forKey: BackgroundFetchUpdatePeriod)
        }
    }
}
