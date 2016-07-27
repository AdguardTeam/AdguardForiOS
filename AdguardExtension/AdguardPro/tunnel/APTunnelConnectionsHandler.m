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
#import "APSharedResources.h"

#define APT_DNS_LOG_MAX_COUNT           5000
#define LOGGING_DATA_FILENAME           @"dnsRequestLoggingData.dat"

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

@implementation APTunnelConnectionsHandler {

    NSMutableSet<APTUdpProxySession *> *_sessions;
    
    BOOL _loggingEnabled;
    OSSpinLock _loggingLock;
    NSMutableArray <APDnsLogRecord *> *_loggingCache;
    
    BOOL _packetFlowObserver;
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
        _loggingLock = OS_SPINLOCK_INIT;
        _loggingEnabled = NO;
    }
    return self;
}

- (void)dealloc {

    if (_packetFlowObserver) {
        [_provider removeObserver:self forKeyPath:@"packetFlow"];
    }
    [self saveLoggingCache];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)startHandlingPackets {

    if (_provider.packetFlow) {

        [self startHandlingPacketsInternal];
    } else {

        DDLogWarn(@"(APTunnelConnectionsHandler) - startHandlingPackets PacketFlow empty!");

        [_provider addObserver:self forKeyPath:@"packetFlow" options:0 context:NULL];
        _packetFlowObserver = YES;
    }
}

- (void)removeSession:(APTUdpProxySession *)session {

    @synchronized(self) {

        [_sessions removeObject:session];
    }
}

- (void)writeToDnsActivityLog:(NSArray<APDnsLogRecord *> *)records {

    if (_loggingEnabled && records.count) {

        OSSpinLockLock(&_loggingLock);

        NSInteger count = records.count;
        if (count >= APT_DNS_LOG_MAX_COUNT) {
            [_loggingCache setArray:[records subarrayWithRange:NSMakeRange((count - APT_DNS_LOG_MAX_COUNT), APT_DNS_LOG_MAX_COUNT)]];
        } else {
            count = count - APT_DNS_LOG_MAX_COUNT + _loggingCache.count;
            if (count > 0) {
                [_loggingCache removeObjectsInRange:NSMakeRange(0, count)];
            }
            [_loggingCache addObjectsFromArray:records];
        }
        OSSpinLockUnlock(&_loggingLock);
    }
}

- (void)setDnsActivityLoggingEnabled:(BOOL)enabled {

    if (enabled != _loggingEnabled) {

        OSSpinLockLock(&_loggingLock);

        if (enabled) {

            if (_loggingCache == nil) {
                _loggingCache = [NSMutableArray new];
                
                // restore logging data from file (synchronously)
                NSURL *dataUrl = [[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:LOGGING_DATA_FILENAME];
                if ([dataUrl checkResourceIsReachableAndReturnError:NULL]) {
                    
                    NSData *loggingCacheDataFromDisk = [NSData dataWithContentsOfURL:dataUrl];
                    NSArray *savedLoggingCache = [NSKeyedUnarchiver unarchiveObjectWithData:loggingCacheDataFromDisk];
                    if (savedLoggingCache && [savedLoggingCache isKindOfClass:[NSArray class]]) {
                        
                        [_loggingCache addObjectsFromArray:savedLoggingCache];
                    }
                }
            }
        }

        _loggingEnabled = enabled;

        OSSpinLockUnlock(&_loggingLock);
    }
}

- (void)clearDnsActivityLog {

    OSSpinLockLock(&_loggingLock);

    [_loggingCache removeAllObjects];

    OSSpinLockUnlock(&_loggingLock);
}

- (NSArray <APDnsLogRecord *> *)dnsActivityLogRecords{
    
    NSArray <APDnsLogRecord *> *result;
    OSSpinLockLock(&_loggingLock);
    
    result = [_loggingCache copy];
    
    OSSpinLockUnlock(&_loggingLock);
    
    return (result ?: @[]);
}

/////////////////////////////////////////////////////////////////////
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqual:@"packetFlow"]) {

        DDLogDebug(@"(APTunnelConnectionsHandler) KVO _provider.packetFlow: %@", _provider.packetFlow);
        if (_provider.packetFlow) {

            if (_packetFlowObserver) {
                
                [_provider removeObserver:self forKeyPath:@"packetFlow"];
                _packetFlowObserver = NO;
            }
            [self startHandlingPacketsInternal];
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

- (void)startHandlingPacketsInternal {
    
    __typeof__(self) __weak wSelf = self;

    DDLogDebug(@"(APTunnelConnectionsHandler) startHandlingPacketsInternal");
    [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {
        
        __typeof__(self) sSelf = wSelf;
        [sSelf handlePackets:packets protocols:protocols];
    }];

}

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

    __typeof__(self) __weak wSelf = self;
    [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {

        __typeof__(self) sSelf = wSelf;
      [sSelf handlePackets:packets protocols:protocols];
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
                  
                  [session setLoggingEnabled:_loggingEnabled];
                  [_sessions addObject:session];
              }
              else
                  session = nil;
          }

          [session appendPackets:obj];
        }];
    }
}

- (void)saveLoggingCache {

    NSURL *dataUrl = [[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:LOGGING_DATA_FILENAME];

    NSData *dataToSave;
    if (_loggingCache) {
        
        dataToSave = [NSKeyedArchiver archivedDataWithRootObject:_loggingCache];
    }
    else {
        dataToSave = [NSKeyedArchiver archivedDataWithRootObject:@[]];
    }
    
    if (dataToSave) {

        [dataToSave writeToURL:dataUrl atomically:YES];
    }
}

@end
