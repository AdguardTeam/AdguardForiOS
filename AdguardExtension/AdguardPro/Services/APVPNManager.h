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

@class  APDnsLogRecord, ASDFilterRule, APDnsServerObject;

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager Constants

typedef enum {
    
    APVpnConnectionStatusDisabled = 0,
    APVpnConnectionStatusDisconnected,
    APVpnConnectionStatusDisconnecting,
    APVpnConnectionStatusConnecting,
    APVpnConnectionStatusReconnecting,
    APVpnConnectionStatusConnected,
    APVpnConnectionStatusInvalid
} APVpnConnectionStatus;

typedef enum : NSUInteger {
    
    APVpnManagerTunnelModeSplit = 0,
    APVpnManagerTunnelModeFull
} APVpnManagerTunnelMode;


/**
 This notification arises when state or mode of the vpn is changed.
 */
extern NSString *APVpnChangedNotification;

#define APVPN_MANAGER_ERROR_STANDART                100
#define APVPN_MANAGER_ERROR_NODNSCONFIGURATION      200
#define APVPN_MANAGER_ERROR_CONNECTION_HANDLER      300
#define APVPN_MANAGER_ERROR_BADCONFIGURATION        400
#define APVPN_MANAGER_ERROR_INSTALL_FILTER          500


#define APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX              0
#define APVPN_MANAGER_DEFAULT_LOCAL_FILTERING               NO

#define APVPN_MANAGER_DEFAULT_REMOTE_DNS_SERVER_INDEX       1

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
@property (class, readonly) APVPNManager *singleton;

/**
 List of the app defined DNS servers.
 */
@property (class, readonly) NSMutableArray <APDnsServerObject *> *predefinedDnsServers;

/**
 List of the app defined DNS Crypt servers.
 */
@property (nonatomic, readonly) NSArray <APDnsServerObject *> *predefinedDnsCryptServers;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

@property (readonly, nonatomic) NSArray <APDnsServerObject *> *remoteDnsServers;

/**
 remote DNS Crypt serevrs
 */
@property (readonly, nonatomic) NSArray <APDnsServerObject *> *remoteDnsCryptServers;

/**
 Defines state of the filtering using "Simplified domain names filter" filter rules.
 */
//@property BOOL localFiltering;
/**
 Active DNS server.
 */
@property APDnsServerObject *activeRemoteDnsServer;

/**
 Maximum count of DNS servers.
 */
@property (readonly, nonatomic) NSUInteger maxCountOfRemoteDnsServers;

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
 Switch on/off of the fake vpn.
 */
@property BOOL enabled;

/** 
 tunnel mode full/split/auto
 */
@property APVpnManagerTunnelMode tunnelMode;

/**
 Adds custom (editable) DNS server.

 @param server Server instance. It must be editable.
 @return YES on success.
 */
- (BOOL)addRemoteDnsServer:(APDnsServerObject *)server;

/**
 Removes custom (editable) DNS server

 @param server Server instance. It must be editable.
 @return YES on success.
 */
- (BOOL)removeRemoteDnsServer:(APDnsServerObject *)server;

/**
 Changes properties of the custom (editable) DNS server.
 When you create new server object, this object obtains uuid.
 This uuid is used for identification of the object.
 And you can change all properties of the server object.

 @param server Server instance. It must be editable.
 @return YES on success.
 */
- (BOOL)resetRemoteDnsServer:(APDnsServerObject *)server;

/**
 Clears DNS Activity Log.
 
 @return Returns YES on success. 
 */
- (BOOL)clearDnsRequestsLog;

/**
 Obtains DNS requests logging records,
 and calls `completionBlock` with appropriate parameter.
 */
- (void)obtainDnsLogRecords:(void (^)(NSArray <APDnsLogRecord *> *records))completionBlock;

/**
 Sends message to tunnel extension,
 which notifies that extension needs reload whitelist/blacklist of the domains.
 */
- (void)sendReloadSystemWideDomainLists;

@end
