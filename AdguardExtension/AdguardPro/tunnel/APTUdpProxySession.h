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

@class APTunnelConnectionsHandler, APUDPPacket;

/////////////////////////////////////////////////////////////////////
#pragma mark - APTUdpProxySession

/**
 Description of _newCalass_
 */
@interface APTUdpProxySession  : NSObject <NSCopying>

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

/**
 Creates object. If error occurs, returns nil.
 
 @param udpPacket    Base UDP packet (template). 
 Created object obtains remote and local endpoints from this packet.
 Must contain IPv4 address and port, becouse we support only IPv4 at this moment.
 */
- (id)initWithUDPPacket:(APUDPPacket *)udpPacket delegate:(APTunnelConnectionsHandler *)delegate;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@property (nonatomic, readonly) NWUDPSession *udpSession;
@property (nonatomic, readonly) NWUDPSession *whitelistUdpSession;

@property (nonatomic, readonly, weak) APTunnelConnectionsHandler *delegate;

/**
 Creates udp session.
 You must call this method before appending packets for processing.
 */
- (BOOL)createSession;

/**
 Sets that session will be create log of the DNS activity.
 */
- (void)setLoggingEnabled:(BOOL)enabled;

/**
 Appending of the packets into this proxy object, for sending to endpoint asynchroniously.
 */
- (void)appendPackets:(NSArray<NSData *> *)packets;

@end
