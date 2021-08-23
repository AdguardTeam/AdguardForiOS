/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

protocol PredefinedDnsProvidersDecoderProtocol {
    var providers: [PredefinedDnsProvider] { get }
}

/**
 Decodes **providers.json** and **providers_i18n.json** and returns their data as an object
 File **providers.json** contains JSON with information about predefined DNS providers
 FIle **providers_i18n.json** contains JSON with localizations for predefined DNS providers
*/
struct PredefinedDnsProvidersDecoder: PredefinedDnsProvidersDecoderProtocol {
    var providers: [PredefinedDnsProvider] = []
    
    // Language for providers localizations
    private let currentLanguage: String
    
    // Bundle variable for tests
    private let bundle: Bundle
    
    /*
     Language map for providers_i18n.json
     Some languages codes from json differ from apple ones
    */
    private let languageMap = ["es": "es-ES",
                               "zh-Hans": "zh-CN",
                               "zh-Hant": "zh-TW"]
    
    init(currentLanguage: String, bundle: Bundle = .main) throws {
        self.currentLanguage = currentLanguage
        self.bundle = bundle
        try initializeDnsProviders()
    }
    
    // MARK: - Private methods
    
    /* Initializes providers from providers.json */
    private mutating func initializeDnsProviders() throws {
        let jsonData = try getData(forFileName: "providers")
        let decoder = JSONDecoder()
        let dnsProviders = try decoder.decode(PredefinedDnsProviders.self, from: jsonData)
        self.providers = try localizeDnsProviders(dnsProviders.providers)
    }
    
    /* Gets localizations for providers obtained from providers.json */
    private func localizeDnsProviders(_ providers: [PredefinedDnsProvider]) throws -> [PredefinedDnsProvider] {
        let jsonData = try getData(forFileName: "providers_i18n")
        let json = try JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
        let providersJson = json["providers"] as! [String: Any]
        let featuresJson = json["features"] as! [String: Any]
        
        return providers.map { provider in
            let localized = localizationsForProvider(provider, providersJson)
            let servers = localizationsForFeatures(provider, featuresJson)
            return PredefinedDnsProvider(name: localized.name,
                               providerDescription: localized.desc,
                               servers: servers,
                               providerId: provider.providerId,
                               logo: provider.logo,
                               homepage: provider.homepage)
        }
    }
    
    /* Helper methods to obtain localized name and desc for provider from providers_i18n.json */
    private func localizationsForProvider(_ provider: PredefinedDnsProvider, _ providersJson: [String: Any]) -> (name: String, desc: String) {
        let lang = languageMap[currentLanguage] ?? currentLanguage
        let id = String(provider.providerId)
        let allLocalizations = providersJson[id] as! [String: Any]
        if let currentLocalization = allLocalizations[lang] as? [String: Any] {
            let name = currentLocalization["name"] as! String
            let desc = currentLocalization["description"] as! String
            return (name, desc)
        } else {
            return (provider.name, provider.providerDescription)
        }
    }
    
    /* Helper methods to obtain localized name and desc for features of servers from providers_i18n.json */
    private func localizationsForFeatures(_ provider: PredefinedDnsProvider, _ featuresJson: [String: Any]) -> [PredefinedDnsServer] {
        let lang = languageMap[currentLanguage] ?? currentLanguage
        
        return provider.servers.map { server in
            let newFeatures = server.features.map { feature -> DnsFeature in
                let allLocalizations = featuresJson[feature.type.rawValue] as! [String: Any]
                var name = feature.name
                var desc = feature.featureDescription
                if let currentLocalization = allLocalizations[lang] as? [String: Any] {
                    name = currentLocalization["name"] as! String
                    desc = currentLocalization["description"] as! String
                }
                return DnsFeature(logo: feature.logo,
                                  type: feature.type,
                                  name: name,
                                  featureDescription: desc)
            }
            return PredefinedDnsServer(features: newFeatures,
                             upstreams: server.upstreams,
                             providerId: server.providerId,
                             type: server.type,
                             id: server.id,
                             name: server.name)
        }
    }
    
    /* Returns json Data from file name */
    private func getData(forFileName fileName: String) throws -> Data {
        guard let pathString = bundle.path(forResource: fileName, ofType: "json") else {
            Logger.logError("(DnsProvidersDecoder) - getData; Failed to get \(fileName).json path")
            throw CommonError.missingFile(filename: "\(fileName).json")
        }
        let pathUrl = URL(fileURLWithPath: pathString)
        return try Data(contentsOf: pathUrl)
    }
}
