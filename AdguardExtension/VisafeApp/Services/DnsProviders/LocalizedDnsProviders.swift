import Foundation

class LocalizedDnsFeature: Codable {
    let featureId: String
    let localizedName: String?
    let localizedDescription: String?
    let logo: String?
    
    init(featureId:String ,name: String?, description: String?, logo: String?) {
        self.featureId = featureId
        self.localizedName = name
        self.localizedDescription = description
        self.logo = logo
    }
}

class LocalizedDnsProviderInfo: Codable {
    
    let provider: DnsProvider
    let localizedName: String?
    let localizedDescription: String?
    let features: [LocalizedDnsFeature]?
    
    init(provider: DnsProvider, name: String?, description: String?, features: [LocalizedDnsFeature]) {
        self.provider = provider
        self.localizedName = name
        self.localizedDescription = description
        self.features = features
    }
}
