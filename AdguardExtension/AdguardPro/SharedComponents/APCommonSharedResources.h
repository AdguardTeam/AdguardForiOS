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
#import <Foundation/Foundation.h>
#import "AESharedResources.h"

#define AP_TUNNEL_ID                       @ADGUARD_TUNNEL_BUNDLE_ID

#define AP_URLSCHEME                        @ADGUARD_URL_SCHEME
#define AP_URLSCHEME_COMMAND_STATUS_ON      @"status-on"
#define AP_URLSCHEME_COMMAND_STATUS_OFF     @"status-off"

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources Constants

/**
 User Defaults key that define, create log of the DNS requests or not.
 */
extern NSString *APDefaultsDnsLoggingEnabled;

/**
 User Defaults key, which defines active remote DNS server (APDnsServerObject object).
 */
extern NSString *APDefaultsActiveRemoteDnsServer;

extern NSString *APDefaultsCustomDnsProviders;

/**
 Key of the parameter, which contains remote DNS server configuration.
 */
extern NSString *APVpnManagerParameterRemoteDnsServer;

/**
 Key of the parameter,
 which contains BOOL value of local filtering switch.
 */
extern NSString *APVpnManagerParameterLocalFiltering;

/**
 Error domain for errors from vpn manager.
 */
extern NSString *APVpnManagerErrorDomain;

/**
 Key of the paramenter, wich contain APVpnManagerTunnelMode value.
 */
extern NSString *APVpnManagerParameterTunnelMode;

/**
 Key of the paramenter, wich contain APVpnManagerRestartByReachability value.
 */
extern NSString *APVpnManagerRestartByReachability;
