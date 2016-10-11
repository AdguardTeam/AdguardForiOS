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

#import <Foundation/Foundation.h>

@class  APDnsLogRecord, ASDFilterRule;

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager Constants

typedef enum {
    
    APVpnModeUndef = -1,
    APVpnModeNone,
    APVpnModeDNS,
    APVpnModeFamilyDNS
} APVpnMode;

typedef enum {
    
    APVpnConnectionStatusDisabled = 0,
    APVpnConnectionStatusDisconnected,
    APVpnConnectionStatusDisconnecting,
    APVpnConnectionStatusConnecting,
    APVpnConnectionStatusReconnecting,
    APVpnConnectionStatusConnected,
    APVpnConnectionStatusInvalid
} APVpnConnectionStatus;


/**
 This notification arises when state or mode of the vpn is changed.
 */
extern NSString *APVpnChangedNotification;

/**
 Key of the parameter, which contains mode of the vpn configuration.
*/
extern NSString *APVpnManagerParameterMode;
/**
 Key of the parameter, 
 which contains DNS addresses for current mode of the vpn configuration.
 */
extern NSString *APVpnManagerParameterIPv4DNSAddresses;

/**
 Error domain for errors from vpn manager.
 */
extern NSString *APVpnManagerErrorDomain;

#define APVPN_MANAGER_ERROR_STANDART                100
#define APVPN_MANAGER_ERROR_NODNSCONFIGURATION      200
#define APVPN_MANAGER_ERROR_CONNECTION_HANDLER      300

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

/**
 Class controls VPN configuration and controls status of the connection. 
 */
@interface APVPNManager  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize
/////////////////////////////////////////////////////////////////////

/**
    Returns singleton object.
 */
+ (APVPNManager *)singleton;


/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
 Contains current mode of the vpn configuration.
 If configuration was not created, then property contains APVpnModeNone.
 */
@property (readonly, nonatomic) APVpnMode vpnMode;
/**
 Contains current connection status of the vpn.
 */
@property (readonly, nonatomic) APVpnConnectionStatus connectionStatus;
/**
 If last operation led to error, property contains this error.
 */
@property (readonly) NSError *lastError;

/**
 Defines, turned on/off logging of the DNS requests. 
 */
@property BOOL dnsRequestsLogging;

/**
    Returns localized description of the configuration mode.
    
    @param vpnMode Mode of the vpn configuration.
 */
- (NSString *)modeDescription:(APVpnMode)vpnMode;

/**
 Switch on/off of the fake vpn.
 */
@property BOOL enabled;

/**
 Sets mode of the vpn configuration.
 */
- (void)setMode:(APVpnMode)vpnMode;

/**
 Sends command to network extension, that it will reset DNS Activity Log.
 
 @return Returns YES on success. 
 */
- (BOOL)clearDnsRequestsLog;

/**
 Obtains DNS requests logging records,
 and calls `completionBlock` with appropriate parameter.
 */
- (void)obtainDnsLogRecords:(void (^)(NSArray <APDnsLogRecord *> *records))completionBlock;

/**
 Checks that rule is type of whitelist or blacklist,
 if so, sends message to tunnel extension,
 which notifies that extension needs reload whitelist/blacklist of the domains.
 */
- (void)sendReloadUserfilterDataIfRule:(ASDFilterRule *)rule;

@end
