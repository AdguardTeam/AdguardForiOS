/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

@import NetworkExtension;

#import "APVPNManager.h"

/**
 Error domain for errors from tunnel provider.
 */
extern NSString *APTunnelProviderErrorDomain;

#define APTN_ERROR_STANDART                100
#define APTN_ERROR_CONNECTION_HANDLER      200


/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider

@interface PacketTunnelProvider : NEPacketTunnelProvider

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Returns current selected VPN Mode
 */
- (APVpnMode)vpnMode;

@end
