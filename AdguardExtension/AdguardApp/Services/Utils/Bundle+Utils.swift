import Foundation

extension Bundle {
    /*
     Returns locale code with script code
     Example:
        locale code = zh
        script code = Hans
     preferredLocaleCode = zh-Hans
     */
    dynamic var preferredLocaleCode: String {
        if let localeCode = self.preferredLocalizations.first {
            return localeCode
        }
        return Locale.current.languageCode ?? Locale.current.identifier
    }
    
    var applicationName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "AdGuard"
    }
}
