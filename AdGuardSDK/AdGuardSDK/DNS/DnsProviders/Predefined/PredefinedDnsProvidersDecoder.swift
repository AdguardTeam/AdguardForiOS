//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK

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

    // Locale for providers localizations
    private let currentLocale: Locale

    // Bundle variable for tests
    private let bundle: Bundle

    //Init bundle with DnsProtection class type as default value
    init(currentLocale: Locale, bundle: Bundle = .init(for: DnsProtection.self) ) throws {
        self.currentLocale = currentLocale
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
                                         logoDark: provider.logoDark,
                                         homepage: provider.homepage)
        }
    }

    /* Helper methods to obtain localized name and desc for provider from providers_i18n.json */
    private func localizationsForProvider(_ provider: PredefinedDnsProvider, _ providersJson: [String: Any]) -> (name: String, desc: String) {
        let suitableLanguages = currentLocale.getSuitableLanguages(delimiter: .dash)
        let id = String(provider.providerId)
        let allLocalizations = providersJson[id] as! [String: Any]
        let lang = collectLocalizationLanguage(suitableLanguages: suitableLanguages, availableLanguages: allLocalizations)
        if let currentLocalization = allLocalizations[lang] as? [String: Any] {
            let name = currentLocalization["name"] as? String
            let desc = currentLocalization["description"] as? String
            return (name ?? provider.name, desc ?? provider.providerDescription)
        } else {
            return (provider.name, provider.providerDescription)
        }
    }

    /* Helper methods to obtain localized name and desc for features of servers from providers_i18n.json */
    private func localizationsForFeatures(_ provider: PredefinedDnsProvider, _ featuresJson: [String: Any]) -> [PredefinedDnsServer] {
        let suitableLanguages = currentLocale.getSuitableLanguages(delimiter: .dash)

        return provider.servers.map { server in
            let newFeatures = server.features.map { feature -> DnsFeature in
                let allLocalizations = featuresJson[feature.type.rawValue] as! [String: Any]
                var name = feature.name
                var desc = feature.featureDescription
                let lang = collectLocalizationLanguage(suitableLanguages: suitableLanguages, availableLanguages: allLocalizations)
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

    private func collectLocalizationLanguage(suitableLanguages: [String], availableLanguages: [String: Any]) -> String {
        // Trying to find available language
        for language in suitableLanguages {
            if availableLanguages[language] != nil {
                return language
            }
        }

        var foundLanguage = Locale.defaultLanguageCode

        /*
         Trying to find similar languages if language is still missed.
         The last element of the `suitableLanguages` list is a simple language code such as `se` or `en`.
         We're sorting because some keys from provider_i18n.json, like Portugals, have multiple language code options (pt_PT and pt_BR)
         */
        let keys = availableLanguages.keys.filter { $0.contains(suitableLanguages.last ?? foundLanguage) }.sorted()
        if let lang = keys.first {
            foundLanguage = lang
        }
        return foundLanguage
    }
}
