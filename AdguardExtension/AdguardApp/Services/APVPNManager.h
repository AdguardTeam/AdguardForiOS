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
#import "APSharedResources.h"


@class  ASDFilterRule, DnsProviderInfo, DnsServerInfo, ConfigurationService;

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



/**
 This notification arises when state or mode of the vpn is changed.
 */
extern NSString* __nonnull APVpnChangedNotification;

#define APVPN_MANAGER_ERROR_STANDART                100
#define APVPN_MANAGER_ERROR_NODNSCONFIGURATION      200
#define APVPN_MANAGER_ERROR_CONNECTION_HANDLER      300
#define APVPN_MANAGER_ERROR_BADCONFIGURATION        400
#define APVPN_MANAGER_ERROR_INSTALL_FILTER          500

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

@protocol APVPNManagerProtocol <NSObject>

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
 DNS providers <DnsProviderInfo>
 */
@property (nonnull, readonly) NSArray<DnsProviderInfo*> *providers;

/**
 active remote DNS server
 */
@property (nullable) DnsServerInfo* activeDnsServer;

/**
 serches and returns DNS Provider for activeDnsServer
 */
@property (nullable, readonly) DnsProviderInfo* activeDnsProvider;

/**
 Contains current connection status of the vpn.
 */
@property (readonly, nonatomic) APVpnConnectionStatus connectionStatus;
/**
 If last operation led to error, property contains this error.
 */
@property (nullable, readonly) NSError *lastError;

/**
 Switch on/off of the fake vpn.
 */
@property BOOL enabled;

/**
 tunnel mode full/split/auto
 */
@property APVpnManagerTunnelMode tunnelMode;

/**
 The flag specifies whether to restart the tunnel by reachability event
 */
@property BOOL restartByReachability;

/**
 this flag indicates that vpn configuration allready installed
 */
@property (readonly) BOOL vpnInstalled;

/**
this flag indicates that filtering of Wi-Fi data is on/off
*/
@property BOOL filteringWifiDataEnabled;

/**
this flag indicates that filtering of mobile data is on/off
*/
@property BOOL filteringMobileDataEnabled;

/**
 Adds custom (editable) DNS server.
 
 @param server Server instance. It must be editable.
 @return YES on success.
 */
- (BOOL) addRemoteDnsServer:(nonnull NSString*) name upstreams:(nonnull NSArray<NSString*>*) upstreams;

/**
 Removes custom (editable) DNS server
 @return YES on success.
 */
- (BOOL) deleteCustomDnsProvider: (nonnull DnsProviderInfo*) provider;

/**
 Changes properties of the custom (editable) DNS server.
 When you create new server object, this object obtains uuid.
 This uuid is used for identification of the object.
 And you can change all properties of the server object.
 
 @param server Server instance. It must be editable.
 @return YES on success.
 */

- (BOOL)resetCustomDnsProvider:(nonnull DnsProviderInfo*)provider;

/**
 restarts tunnel& Automaticaly enable it if needed
 */
- (void)restartTunnel;

/**
 Clears DNS Activity Log.
 
 @return Returns YES on success.
 */
- (BOOL)clearDnsRequestsLog;

/**
 Obtains DNS requests logging records,
 and calls `completionBlock` with appropriate parameter.
 */
- (void)obtainDnsLogRecords:(nonnull void (^)( NSArray <DnsLogRecord *>* _Nullable records))completionBlock;

/**
 checks if this provider is active
 */
- (BOOL) isActiveProvider: (nonnull DnsProviderInfo*) provider;

/**
 checks if this provider is custom
 */
- (BOOL) isCustomProvider: (nonnull DnsProviderInfo*) provider;

/**
 checks if this server is custom
 */
- (BOOL) isCustomServer:(nonnull DnsServerInfo *) server;

/**
 checks if active dns server is custom
 */
- (BOOL) isCustomServerActive;

- (nonnull DnsServerInfo*) defaultServer;

/**remove vpn configuration from system settings*/
- (void)removeVpnConfiguration;

@end

/**
 Class controls VPN configuration and controls status of the connection. 
 */
@interface APVPNManager : NSObject<APVPNManagerProtocol>

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize
/////////////////////////////////////////////////////////////////////

- (nonnull id)initWithResources: (nonnull id<AESharedResourcesProtocol>) resources
                  configuration: (nonnull ConfigurationService *) configuration;

@end
