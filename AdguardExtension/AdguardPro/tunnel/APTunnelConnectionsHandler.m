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

#import "ACommons/ACLang.h"
#import "APTUdpProxySession.h"
#import "APTunnelConnectionsHandler.h"
#import "PacketTunnelProvider.h"
#import "APUDPPacket.h"
#include <netinet/ip.h>
#import <sys/socket.h>

#import "APDnsResourceType.h"
#import "APDnsRequest.h"
#import "APDnsDatagram.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

@implementation APTunnelConnectionsHandler {

    NSMutableSet<APTUdpProxySession *> *_sessions;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithProvider:(PacketTunnelProvider *)provider {

    if (!provider) {
        return nil;
    }

    self = [super init];
    if (self) {

        _provider = provider;
        _sessions = [NSMutableSet set];
    }
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)startHandlingPackets {
    [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {

      [self handlePackets:packets protocols:protocols];
    }];
}

- (void)removeSession:(APTUdpProxySession *)session{
    
    @synchronized (self) {
        
        [_sessions removeObject:session];
    }
}
/////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

/// Handle packets coming from the packet flow.
- (void)handlePackets:(NSArray<NSData *> *_Nonnull)packets protocols:(NSArray<NSNumber *> *_Nonnull)protocols {

    // Work here

    //    DDLogInfo(@"----------- Packets %lu ---------------", packets.count);
    //    [packets enumerateObjectsUsingBlock:^(NSData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //
    //        DDLogInfo(@"Packet %lu length %lu protocol %@", idx, obj.length, protocols[idx]);
    //        NSMutableString *out = [NSMutableString string];
    //        Byte *bytes = (Byte *)[obj bytes];
    //        for (int i = 0; i < obj.length; i++) {
    //
    //            if (i > 0) {
    //                [out appendFormat:@",%d", *(bytes+i)];
    //            }
    //            else{
    //                [out appendFormat:@"%d", *(bytes+i)];
    //            }
    //        }
    //        DDLogInfo(@"Data:\n%@", out);
    //    }];
    //
    //    DDLogInfo(@"---- End Packets -------------");

    NSMutableDictionary *packetsBySessions = [NSMutableDictionary dictionary];
    [packets enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {

        APUDPPacket *udpPacket = [[APUDPPacket alloc] initWithData:obj af:protocols[idx]];
        if (udpPacket) {
            //performs only PIv4 UPD packets

            APTUdpProxySession *session = [[APTUdpProxySession alloc] initWithUDPPacket:udpPacket delegate:self];

            if (session) {

                NSMutableArray *packetForSession = packetsBySessions[session];
                if (!packetForSession) {
                    packetForSession = [NSMutableArray new];
                    packetsBySessions[session] = packetForSession;
                }

                [packetForSession addObject:udpPacket.payload];
            }
        }
    }];

    //Create remote endpoint sessions if neeed it and send data to remote endpoint
    [self performSend:packetsBySessions];

    // Read more

    [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {

      [self handlePackets:packets protocols:protocols];
    }];
}

- (void)performSend:(NSDictionary<APTUdpProxySession *, NSArray *> *)packetsBySessions {

    @synchronized(self) {

        [packetsBySessions enumerateKeysAndObjectsUsingBlock:^(APTUdpProxySession *_Nonnull key, NSArray *_Nonnull obj, BOOL *_Nonnull stop) {

          APTUdpProxySession *session = [_sessions member:key];
          if (!session) {
              //create session
              session = key;
              if ([session createSession]) {
                  
                  [session setLoggingEnabled:YES];
                  [_sessions addObject:session];
              }
              else
                  session = nil;
          }

          [session appendPackets:obj];
        }];
    }
}

@end
