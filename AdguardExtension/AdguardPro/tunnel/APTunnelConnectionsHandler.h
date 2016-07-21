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

@class APTUdpProxySession, PacketTunnelProvider, APDnsLogRecord;

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
 Make the initial readPacketsWithCompletionHandler call.
 */
- (void)startHandlingPackets;

/**
 Removes session for endpont if it exists.
 */
- (void)removeSession:(APTUdpProxySession *)endpoint;

/**
 Sets that sessions will be create log of the DNS activity.
 */
- (void)setDnsActivityLoggingEnabled:(BOOL)enabled;

/**
 Removes all records from log of the DNS activity.
 */
- (void)clearDnsActivityLog;
/**
 Returns log records of the DNS activity.
 */
- (NSArray <APDnsLogRecord *> *)dnsActivityLogRecords;

/**
 Endpoints sessions use this method for writing log records.
 */
- (void)writeToDnsActivityLog:(NSArray <APDnsLogRecord *> *)records;

@end
