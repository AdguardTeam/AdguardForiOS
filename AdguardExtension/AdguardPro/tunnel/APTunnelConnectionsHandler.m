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

#define DEFAULT_DNS_SERVER_IP           @"208.67.222.222" // opendns.com

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

@implementation APTunnelConnectionsHandler {

    NSMutableSet<APTUdpProxySession *> *_sessions;
    
    BOOL _loggingEnabled;
    
    OSSpinLock _dnsAddressLock;
    OSSpinLock _whitelistDomainLock;
    OSSpinLock _blacklistDomainLock;
    
    NSDictionary *_dnsAddresses;
    NSString *_deviceDnsAddressForAny;
    
    NSArray <NSString *> *_whitelistDomains;
    NSArray <NSString *> *_blacklistDomains;
    
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
        _whitelistDomainLock = _blacklistDomainLock =_dnsAddressLock = OS_SPINLOCK_INIT;
        _loggingEnabled = NO;
    }
    return self;
}

- (void)dealloc {

    if (_packetFlowObserver) {
        [_provider removeObserver:self forKeyPath:@"packetFlow"];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)setDeviceDnsAddresses:(NSArray <NSString *> *)deviceDnsAddresses
          adguardDnsAddresses:(NSArray <NSString *> *)adguardDnsAddresses {

    if (!(deviceDnsAddresses.count && adguardDnsAddresses.count)) {
        
        OSSpinLockLock(&_dnsAddressLock);
        
        //set default device DNS to first address.
        _deviceDnsAddressForAny = DEFAULT_DNS_SERVER_IP;
        
        OSSpinLockUnlock(&_dnsAddressLock);
        return;
    }
    
    @autoreleasepool {
        
        NSUInteger devicesLastIndex = deviceDnsAddresses.count - 1;
        NSMutableDictionary *dnsCache = [NSMutableDictionary dictionary];
        [adguardDnsAddresses enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx > devicesLastIndex) {
                *stop = YES;
                return;
            }
            
            dnsCache[obj] = deviceDnsAddresses[idx];
        }];
        
        OSSpinLockLock(&_dnsAddressLock);
        
        _dnsAddresses = [dnsCache copy];
        //set default device DNS to first address.
        _deviceDnsAddressForAny = deviceDnsAddresses[0];
        
        OSSpinLockUnlock(&_dnsAddressLock);
    }
}

- (void)setWhitelistDomains:(NSArray <NSString *> *)domains {
    
    OSSpinLockLock(&_whitelistDomainLock);
    
    _whitelistDomains = nil;
    
    if (domains.count) {
        
        _whitelistDomains = [domains copy];
    }

    OSSpinLockUnlock(&_whitelistDomainLock);
}

- (void)setBlacklistDomains:(NSArray <NSString *> *)domains {
    
    OSSpinLockLock(&_blacklistDomainLock);
    
    _blacklistDomains = nil;
    
    if (domains.count) {
        
        _blacklistDomains = [domains copy];
    }
    
    OSSpinLockUnlock(&_blacklistDomainLock);
}

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

- (void)setDnsActivityLoggingEnabled:(BOOL)enabled {

    _loggingEnabled = enabled;
}

- (BOOL)isWhitelistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    OSSpinLockLock(&_whitelistDomainLock);
    
    result = [self checkDomain:domainName withList:_whitelistDomains];
    
    OSSpinLockUnlock(&_whitelistDomainLock);
    
    return result;
}

- (BOOL)isBlacklistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    OSSpinLockLock(&_blacklistDomainLock);
    
    result = [self checkDomain:domainName withList:_blacklistDomains];
    
    OSSpinLockUnlock(&_blacklistDomainLock);
    
    return result;
}

- (NSString *)whitelistServerAddressForAddress:(NSString *)serverAddress {
    
    if (!serverAddress) {
        serverAddress = [NSString new];
    }
    
    OSSpinLockLock(&_dnsAddressLock);

    NSString *address = _dnsAddresses[serverAddress];
    
    if (!address) {
        address = _deviceDnsAddressForAny;
    }
    
    OSSpinLockUnlock(&_dnsAddressLock);

    return address;
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

- (BOOL)checkDomain:(__unsafe_unretained NSString *)domainName withList:(__unsafe_unretained NSArray <NSString *> *)domainList {
    
    BOOL result = NO;
    
    for (NSString *item in domainList) {
        
        if ([item hash] == [domainName hash]) {
            if ([domainName isEqualToString:item]) {
                result = YES;
                break;
            }
        }
        
        NSString *domain = [@"." stringByAppendingString:item];
        if ([domainName hasSuffix:domain]) {
            result = YES;
            break;
        }
    }

    return result;
}

@end
