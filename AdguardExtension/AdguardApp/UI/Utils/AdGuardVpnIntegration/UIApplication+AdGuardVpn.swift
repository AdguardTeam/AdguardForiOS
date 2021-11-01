///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
///

import UIKit

extension UIApplication {

    /* Checks if AdGuard VPN is installed on device */
    static var adGuardVpnIsInstalled: Bool {
        let appUrl = URL(string: "\(adguardVpnScheme)://")!
        return shared.canOpenURL(appUrl)
    }

    /* Checks if AdGuard VPN tunnel is running */
    static var adGuardVpnIsActive: Bool {
        let activeNetworkInterfaces = NetworkManager.networkInterfaces

        /// Checks if there is AdGuard VPN tunnel interface among all active interfaces
        for adgInterface in AdGuardVpnOperatingMode.allAvailableInterfaces {
            for interface in activeNetworkInterfaces {
                guard let cidrRange = ACNCidrRange(cidrString: interface) else { continue }

                if adgInterface.contains(cidrRange) {
                    return true
                }
            }
        }
        return false
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

    static func youtubeAppInstalled()->Bool {
        let appUrl = URL(string: "youtube://")!
        return shared.canOpenURL(appUrl)
    }
}
