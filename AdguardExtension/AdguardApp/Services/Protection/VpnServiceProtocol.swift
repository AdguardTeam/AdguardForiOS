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

protocol VpnServiceNotifierDelegate {
    /**
     Method is called when tunnel mode (full tunnel / split tunnel) changes
     */
    func tunnelModeChanged()
    
    /**
     Method is called when vpn configuration changes
     */
    func vpnConfigurationChanged(with error: Error?)
    
    /**
     Method is called when app asks user to install vpn configuration
     and user refuses
     */
    func cancelledAddingVpnConfiguration()
    
    /**
     Method is called when trying to turn tracking protection on, and proStatus is false
     */
    func proStatusEnableFailure()
}

protocol TurnSystemProtectionProtocol: class {
    func turnSystemProtection(to state: Bool, with vc: UIViewController?, completion: @escaping () -> ())
}

protocol VpnServiceProtocol: TurnSystemProtectionProtocol {
    
    var notifier: VpnServiceNotifierDelegate? { get set }
    
    var vpnEnabled: Bool { get }
    
    var currentServerName: String { get }
        
    func turnSystemProtection(to state: Bool, with vc: UIViewController?, completion: @escaping () -> ())
}
