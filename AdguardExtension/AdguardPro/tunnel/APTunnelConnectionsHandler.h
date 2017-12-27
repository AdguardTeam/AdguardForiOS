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
#import "AERDomainFilter.h"
#import "APDnsServerAddress.h"

@class APTUdpProxySession, PacketTunnelProvider;

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

/**
 Class controller for UDP sessions, which controls of the DNS traffic.
 */
@interface APTunnelConnectionsHandler : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithProvider:(PacketTunnelProvider *)provider;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@property (weak, readonly) PacketTunnelProvider *provider;

/**
 Sets addresses of the DNS servers.
 */
-(void)setDeviceDnsAddressesIpv4:(NSArray<APDnsServerAddress *> *)deviceDnsAddressesIpv4
          deviceDnsAddressesIpv6:(NSArray<APDnsServerAddress *> *)deviceDnsAddressesIpv6
   adguardRemoteDnsAddressesIpv4:(NSArray<APDnsServerAddress *> *)remoteDnsAddressesIpv4
   adguardRemoteDnsAddressesIpv6:(NSArray<APDnsServerAddress *> *)remoteDnsAddressesIpv6
     adguardFakeDnsAddressesIpv4:(NSArray<NSString *> *)fakeDnsAddressesIpv4
     adguardFakeDnsAddressesIpv6:(NSArray<NSString *> *)fakeDnsAddressesIpv6;

/**
 Sets whitelist filter.
 */
- (void)setGlobalWhitelistFilter:(AERDomainFilter *)filter;
/**
 Sets global blacklist filter.
 */
- (void)setGlobalBlacklistFilter:(AERDomainFilter *)filter;

/**
 Sets user whitelist filter.
 */
- (void)setUserWhitelistFilter:(AERDomainFilter *)filter;
/**
 Sets user blacklist filter.
 */
- (void)setUserBlacklistFilter:(AERDomainFilter *)filter;
/**
 Sets trackrs filter.
 */
- (void)setTrackersFilter:(AERDomainFilter *)filter;


/**
 Make the initial readPacketsWithCompletionHandler call.
 */
- (void)startHandlingPackets;

/**
 Stop packet handling cycle
 */
- (void)stopHandlingPackets;

/**
 Removes session for endpont if it exists.
 */
- (void)removeSession:(APTUdpProxySession *)endpoint;

/**
 Update statistics.
 */
- (void)sessionWorkDoneWithTime:(float)workTime tracker:(BOOL)tracker;

/**
 Sets that sessions will be create log of the DNS activity.
 */
- (void)setDnsActivityLoggingEnabled:(BOOL)enabled;

/**
 Checks domain name, that it is included in global whitelist.
 */
- (BOOL)isGlobalWhitelistDomain:(NSString *)domainName;
/**
 Checks domain name, that it is included in global blacklist.
 */
- (BOOL)isGlobalBlacklistDomain:(NSString *)domainName;

/**
 Checks domain name, that it is included in user whitelist.
 */
- (BOOL)isUserWhitelistDomain:(NSString *)domainName;
/**
 Checks domain name, that it is included in user blacklist.
 */
- (BOOL)isUserBlacklistDomain:(NSString *)domainName;
/**
 Checks domain name, that it is included in trackers list.
 */
- (BOOL)isTrackerslistDomain:(NSString *)domainName;


/**
 Returns IP address of the whitelist DNS server for appropriate DNS server.
 */
- (APDnsServerAddress *)whitelistServerAddressForAddress:(NSString *)serverAddress;

/**
 Returns IP address of the DNS server for fake DNS server.
 */
- (APDnsServerAddress *)serverAddressForFakeDnsAddress:(NSString *)serverAddress;

/**
 Closes all existing connections, prevents to create new.
 Call this method before stop tunnel.

 @param completion code blocks, 
 which is performed on main queue, when all connections will be closed.
 */
- (void)closeAllConnections:(void (^)(void))completion;

@end
