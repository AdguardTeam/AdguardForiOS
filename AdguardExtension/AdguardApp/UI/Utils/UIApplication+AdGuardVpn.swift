import UIKit

extension UIApplication {
    
    /* Checks if AdGuard VPN is installed on device */
    static var adGuardVpnIsInstalled: Bool {
        let appUrl = URL(string: "\(adguardVpnScheme)://")!
        return shared.canOpenURL(appUrl)
    }
    
    /* AdGuard VPN app scheme */
    static let adguardVpnScheme = "adguard-vpn"
    
    /* Opens AppStore app and redirects to AdGuard VPN app page */
    static func openAdGuardVpnAppStorePage() {
        let vpnAppUrlString = "https://itunes.apple.com/app/id1525373602"
        if let vpnAppUrl = URL(string: vpnAppUrlString) {
            shared.open(vpnAppUrl, options: [:], completionHandler: nil)
        }
    }
    
    /*
     Opens AdGuard VPN app if it is installed
     Does nothing otherwise
     */
    static func openAdGuardVpnAppIfInstalled() {
        let appUrl = URL(string: "\(adguardVpnScheme)://")!
        if shared.canOpenURL(appUrl) {
            DDLogInfo("AdGuard VPN is installed, open it now")
            shared.open(appUrl)
        }
    }
}
