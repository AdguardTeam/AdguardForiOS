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

#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "APTUdpProxySession.h"
#import "APTunnelConnectionsHandler.h"
#import "PacketTunnelProvider.h"
#import "APUDPPacket.h"
#include <netinet/ip.h>
#import <sys/socket.h>
#import <os/lock.h>

#import "APDnsResourceType.h"
#import "APDnsRequest.h"
#import "APDnsDatagram.h"
#import "APSharedResources.h"
#import "AERDomainFilter.h"

#define DEFAULT_DNS_SERVER_IP           @"208.67.222.222" // opendns.com

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

@implementation APTunnelConnectionsHandler {

    NSMutableSet<APTUdpProxySession *> *_sessions;
    
    BOOL _loggingEnabled;
    
    os_unfair_lock _dnsAddressLock;
    os_unfair_lock _globalWhitelistLock;
    os_unfair_lock _globalBlacklistLock;
    os_unfair_lock _userWhitelistLock;
    os_unfair_lock _userBlacklistLock;
    os_unfair_lock _trackersLock;
    os_unfair_lock _hostsLock;
    
    NSDictionary <NSString*, APDnsServerAddress*> *_whitelistDnsAddresses;
    NSDictionary <NSString*, APDnsServerAddress*> *_remoteDnsAddresses;
    
    AERDomainFilter *_globalWhitelist;
    
    AERDomainFilter *_userWhitelist;
    AERDomainFilter *_userBlacklist;
    AERDomainFilter *_trackersList;
    NSDictionary *_hosts;
    NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*> *_subscriptionsHosts;
    NSDictionary<NSString*, AERDomainFilter*> *_subscriptionsFilters;
    
    BOOL _packetFlowObserver;
    
    dispatch_queue_t _readQueue;
    dispatch_block_t _closeCompletion;
    
    dispatch_queue_t _sessionsQueue;
    
    dispatch_queue_t _countersQueue;
    
    BOOL _packetHandling;
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
        _globalWhitelistLock = _globalBlacklistLock = _userWhitelistLock = _userBlacklistLock = _trackersLock = _hostsLock = OS_UNFAIR_LOCK_INIT;
        _loggingEnabled = NO;
        
        _closeCompletion = nil;
        
        _readQueue = dispatch_queue_create("com.adguard.AdguardPro.tunnel.read", DISPATCH_QUEUE_SERIAL);
        _sessionsQueue = dispatch_queue_create("com.adguard.AdguardPro.tunnel.sessions", DISPATCH_QUEUE_SERIAL);
        _countersQueue = dispatch_queue_create("com.adguard.AdguardPro.tunnel.counters", DISPATCH_QUEUE_SERIAL);
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

- (void)fillDnsDictionary:(NSMutableDictionary<NSString*, APDnsServerAddress*> *)dnsDictionary sourceDnsArray:(NSArray<NSString*> *) sourceDns dstDnsArray: (NSArray<APDnsServerAddress*> *) dstDns defaultDns:(APDnsServerAddress*)defaultDns {
    
    NSUInteger dstIndex = 0;
    
    for(NSString* dns in sourceDns) {
        if(dstDns.count) {
            dnsDictionary[dns] = dstDns[dstIndex];
            
            ++dstIndex;
            if(dstIndex >= dstDns.count)
                dstIndex = 0;
            
        }
        else {
            dnsDictionary[dns] = defaultDns;
        }
    }
}

-(void)setDeviceDnsAddressesIpv4:(NSArray<APDnsServerAddress *> *)deviceDnsAddressesIpv4
          deviceDnsAddressesIpv6:(NSArray<APDnsServerAddress *> *)deviceDnsAddressesIpv6
   adguardRemoteDnsAddressesIpv4:(NSArray<APDnsServerAddress *> *)remoteDnsAddressesIpv4
   adguardRemoteDnsAddressesIpv6:(NSArray<APDnsServerAddress *> *)remoteDnsAddressesIpv6
     adguardFakeDnsAddressesIpv4:(NSArray<NSString *> *)fakeDnsAddressesIpv4
     adguardFakeDnsAddressesIpv6:(NSArray<NSString *> *)fakeDnsAddressesIpv6
{
    
    DDLogInfo(@"(APTunnelConnectionsHandler) set device DNS addresses ipv4:\n%@device DNS addresses ipv6:\n%@remote DNS addresses ipv4:\n%@remote DNS addresses ipv6:\n%@Adguard internal DNS addresses ipv4:\n%@Adguard internal DNS addresses ipv6:\n%@",
              deviceDnsAddressesIpv4, deviceDnsAddressesIpv6, remoteDnsAddressesIpv4, remoteDnsAddressesIpv6, fakeDnsAddressesIpv4, fakeDnsAddressesIpv6);
    
    @autoreleasepool {
    
        NSMutableDictionary* whiteListDnsDictionary = [NSMutableDictionary dictionary];
        
        APDnsServerAddress* defaultWhiteListDnsIpv4 = deviceDnsAddressesIpv4.firstObject ?: [[APDnsServerAddress alloc] initWithIp:DEFAULT_DNS_SERVER_IP port:nil];
        APDnsServerAddress* defaultWhiteListDnsIpv6 = deviceDnsAddressesIpv6.firstObject ?: defaultWhiteListDnsIpv4;
        
        [self fillDnsDictionary:whiteListDnsDictionary sourceDnsArray:fakeDnsAddressesIpv4 dstDnsArray:deviceDnsAddressesIpv4 defaultDns:defaultWhiteListDnsIpv4];
        [self fillDnsDictionary:whiteListDnsDictionary sourceDnsArray:fakeDnsAddressesIpv6 dstDnsArray:deviceDnsAddressesIpv6 defaultDns:defaultWhiteListDnsIpv6];
        
        NSMutableDictionary *remoteDnsDictionary = [NSMutableDictionary dictionary];
        
        APDnsServerAddress* defaultRemoteDnsIpv4 = [[APDnsServerAddress alloc] initWithIp:DEFAULT_DNS_SERVER_IP port:nil];
        APDnsServerAddress* defaultRemoteDnsIpv6 = remoteDnsAddressesIpv4.firstObject ?: [[APDnsServerAddress alloc] initWithIp:DEFAULT_DNS_SERVER_IP port:nil];
        
        [self fillDnsDictionary:remoteDnsDictionary sourceDnsArray:fakeDnsAddressesIpv4 dstDnsArray:remoteDnsAddressesIpv4 defaultDns:defaultRemoteDnsIpv4];
        [self fillDnsDictionary:remoteDnsDictionary sourceDnsArray:fakeDnsAddressesIpv6 dstDnsArray:remoteDnsAddressesIpv6 defaultDns:defaultRemoteDnsIpv6];
        
        DDLogInfo(@"(APTunnelConnectionsHandler) whiteListDnsDictionary %@", whiteListDnsDictionary);
        DDLogInfo(@"(APTunnelConnectionsHandler) remoteDnsDictionary %@", remoteDnsDictionary);
        
        os_unfair_lock_lock(&_dnsAddressLock);
        
        _whitelistDnsAddresses = [whiteListDnsDictionary copy];
        _remoteDnsAddresses = [remoteDnsDictionary copy];
        
        os_unfair_lock_unlock(&_dnsAddressLock);
    }
}

- (void)setGlobalWhitelistFilter:(AERDomainFilter *)filter {
    
    os_unfair_lock_lock(&_globalWhitelistLock);
        _globalWhitelist = filter;
    os_unfair_lock_unlock(&_globalWhitelistLock);
}

- (void)setSubscriptionsFilters:(NSDictionary<NSString *,AERDomainFilter *> *)filters {
    
    os_unfair_lock_lock(&_globalBlacklistLock);
    _subscriptionsFilters = filters;
    os_unfair_lock_unlock(&_globalBlacklistLock);
}

- (void)setUserWhitelistFilter:(AERDomainFilter *)filter {
    
    os_unfair_lock_lock(&_userWhitelistLock);
    _userWhitelist = filter;
    os_unfair_lock_unlock(&_userWhitelistLock);
}

- (void)setUserBlacklistFilter:(AERDomainFilter *)filter {
    
    os_unfair_lock_lock(&_userBlacklistLock);
    _userBlacklist = filter;
    os_unfair_lock_unlock(&_userBlacklistLock);
}

- (void)setTrackersFilter:(AERDomainFilter *)filter {
    
    os_unfair_lock_lock(&_trackersLock);
    _trackersList = filter;
    os_unfair_lock_unlock(&_trackersLock);
}

- (void)setHostsFilter:(NSDictionary *)filter {
    
    os_unfair_lock_lock(&_hostsLock);
    _hosts = filter;
    os_unfair_lock_unlock(&_hostsLock);
}

- (void)setSubscriptionsHostsFilter:(NSDictionary *)filter {
    
    os_unfair_lock_lock(&_hostsLock);
    _subscriptionsHosts = filter;
    os_unfair_lock_unlock(&_hostsLock);
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

- (void)stopHandlingPackets {
    
    _packetHandling = NO;
}

- (void)removeSession:(APTUdpProxySession *)session {
    
    ASSIGN_WEAK(self);

    dispatch_async(_sessionsQueue, ^{
        
        ASSIGN_STRONG(self);
        
        if(!USE_STRONG(self))
            return;
        
        dispatch_block_t closeCompletion = nil;
        
        [session removeObservers];
        
        [_sessions removeObject:session];
        
        if (USE_STRONG(self)->_closeCompletion && USE_STRONG(self)->_sessions.count == 0) {
            closeCompletion = USE_STRONG(self)->_closeCompletion;
            USE_STRONG(self)->_closeCompletion = nil;
        }
        
        if (closeCompletion) {
            DDLogInfo(@"(APTunnelConnectionsHandler) closeAllConnections completion will be run.");
            [ACSSystemUtils callOnMainQueue:closeCompletion];
        }
    });
}

- (void)sessionWorkDoneWithTime:(float)workTime tracker:(BOOL)tracker {
    
    dispatch_async(_countersQueue, ^{
        
        NSNumber* count = [AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalRequestsCount];
        int countValue = count.intValue + 1;
        count = [NSNumber numberWithInt:countValue];
        
        [AESharedResources.sharedDefaults setValue:count forKey:AEDefaultsTotalRequestsCount];
        
        NSNumber* time = [AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalRequestsTime];
        float timeValue = time.floatValue + workTime;
        time = [NSNumber numberWithFloat:timeValue];
        
        [AESharedResources.sharedDefaults setValue:time forKey:AEDefaultsTotalRequestsTime];
        
        if(tracker) {
            
            NSNumber* countTrackers = [AESharedResources.sharedDefaults valueForKey:AEDefaultsTotalTrackersCount];
            int countTrackersValue = countTrackers.intValue + 1;
            countTrackers = [NSNumber numberWithInt:countTrackersValue];
            
            [AESharedResources.sharedDefaults setValue:countTrackers forKey:AEDefaultsTotalTrackersCount];
        }
    });
}

- (void)setDnsActivityLoggingEnabled:(BOOL)enabled {

    _loggingEnabled = enabled;
}

- (BOOL)isGlobalWhitelistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    os_unfair_lock_lock(&_globalWhitelistLock);
    
    result = [_globalWhitelist filteredDomain:domainName];
    
    os_unfair_lock_unlock(&_globalWhitelistLock);
    
    return result;
}

- (BOOL)checkSubscriptionBlacklistDomain:(NSString *)domainName subscriptionUUID:(NSString *__autoreleasing *)uuid{
    
    __block BOOL result = NO;
    __block NSString* foundUUID;
    os_unfair_lock_lock(&_globalBlacklistLock);

    [_subscriptionsFilters enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull subscriptionUUID, AERDomainFilter * _Nonnull filter, BOOL * _Nonnull stop) {
        
        if([filter filteredDomain:domainName]) {
            result = YES;
            foundUUID = subscriptionUUID;
            *stop = YES;
        }
    }];
    
    *uuid = foundUUID;
    
    os_unfair_lock_unlock(&_globalBlacklistLock);
    
    return result;
}

- (BOOL)isUserWhitelistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    os_unfair_lock_lock(&_userWhitelistLock);
    
    result = [_userWhitelist filteredDomain:domainName];
    
    os_unfair_lock_unlock(&_userWhitelistLock);
    
    return result;
}

- (BOOL)isUserBlacklistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    os_unfair_lock_lock(&_userBlacklistLock);
    
    result = [_userBlacklist filteredDomain:domainName];
    
    os_unfair_lock_unlock(&_userBlacklistLock);
    
    return result;
}

- (BOOL)isTrackerslistDomain:(NSString *)domainName {
    
    BOOL result = NO;
    os_unfair_lock_lock(&_trackersLock);
    
    result = [_trackersList filteredDomain:domainName];
    
    os_unfair_lock_unlock(&_trackersLock);
    
    return result;
}

- (BOOL)checkHostsDomain:(NSString *)domainName ip:(NSString *__autoreleasing *)ip subscriptionUUID:(NSString *__autoreleasing *)subscriptionUUID{
    
    BOOL result = NO;
    os_unfair_lock_lock(&_hostsLock);
    
    __block NSString* foundIp = _hosts[domainName];
    __block NSString* foundUUID = nil;
    
    if(foundIp) {
        result = YES;
        *ip = foundIp;
    }
    else {
        [_subscriptionsHosts enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull uuid, NSDictionary* _Nonnull hosts, BOOL * _Nonnull stop) {
            
            foundIp = hosts[domainName];
            if(foundIp) {
                foundUUID = uuid;
                *stop = YES;
            }
        }];
        
        if(foundIp) {
            result = YES;
            *ip = foundIp;
            *subscriptionUUID = foundUUID;
        }
    }
    
    os_unfair_lock_unlock(&_hostsLock);
    
    return result;
}

- (APDnsServerAddress *)whitelistServerAddressForAddress:(NSString *)serverAddress {
    
    if (!serverAddress) {
        serverAddress = [NSString new];
    }
    
    os_unfair_lock_lock(&_dnsAddressLock);

    APDnsServerAddress *address = _whitelistDnsAddresses[serverAddress];
    
    if (!address) {
        address = [[APDnsServerAddress alloc] initWithIp:DEFAULT_DNS_SERVER_IP port:nil];
    }
    
    os_unfair_lock_unlock(&_dnsAddressLock);

    return address;
}

- (APDnsServerAddress *)serverAddressForFakeDnsAddress:(NSString *)serverAddress {
    
    if (!serverAddress) {
        serverAddress = [NSString new];
    }
    
    os_unfair_lock_lock(&_dnsAddressLock);
    
    APDnsServerAddress *address = _remoteDnsAddresses[serverAddress];
    
    if (!address) {
        address = [[APDnsServerAddress alloc] initWithIp:DEFAULT_DNS_SERVER_IP port:nil];
    }
    
    os_unfair_lock_unlock(&_dnsAddressLock);
    
    return address;
}

- (void)closeAllConnections:(void (^)(void))completion {
    
    ASSIGN_WEAK(self);
    
    dispatch_async(_sessionsQueue, ^{
        
        ASSIGN_STRONG(self);
        
        if(!USE_STRONG(self))
            return;
        
        [USE_STRONG(self) stopHandlingPackets];
        
        NSArray <APTUdpProxySession *> *sessions = [USE_STRONG(self)->_sessions allObjects];
        if(USE_STRONG(self)->_sessions.count == 0) {
            
            if (completion) {
                DDLogInfo(@"(APTunnelConnectionsHandler) no open sessions. closeAllConnections completion will be run.");
                [ACSSystemUtils callOnMainQueue:completion];
            }
        }
        else {
            
            USE_STRONG(self)->_closeCompletion = completion;
            
            for (APTUdpProxySession *item in sessions) {
                
                [item close];
            }
        }
        DDLogInfo(@"(APTunnelConnectionsHandler) closeAllConnections method completed.");
    });
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
    
    dispatch_async(_readQueue, ^{
        
        if(!_packetHandling) {
            _packetHandling = YES;
            
            [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {
                
                __typeof__(self) sSelf = wSelf;
                
    #ifdef DEBUG
                [sSelf handlePackets:packets protocols:protocols counter:0];
    #else
                [sSelf handlePackets:packets protocols:protocols];
    #endif
                
            }];
        }
    });

}

/// Handle packets coming from the packet flow.
#ifdef DEBUG

- (void)handlePackets:(NSArray<NSData *> *_Nonnull)packets protocols:(NSArray<NSNumber *> *_Nonnull)protocols counter:(NSUInteger)packetCounter{
#else
- (void)handlePackets:(NSArray<NSData *> *_Nonnull)packets protocols:(NSArray<NSNumber *> *_Nonnull)protocols {
#endif

    DDLogTrace();

#ifdef DEBUG
    packetCounter++;
#endif
    
    // Work here

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
            
            session = nil;
        }
    }];

    //Create remote endpoint sessions if neeed it and send data to remote endpoint
    [self performSend:packetsBySessions];

#ifdef DEBUG
    DDLogDebug(@"Before readPacketsWithCompletionHandler: %lu", packetCounter);
#endif
    // Read more
    __typeof__(self) __weak wSelf = self;
    
    dispatch_async(_readQueue, ^{
        
        [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {
            
            __typeof__(self) sSelf = wSelf;
            
            if(!sSelf || !sSelf->_packetHandling){
                
                DDLogDebug(@"In readPacketsWithCompletionHandler stop handle");
                
                return;
            }
#ifdef DEBUG
            DDLogDebug(@"In readPacketsWithCompletionHandler (before handlePackets): %lu", packetCounter);
            
            [sSelf handlePackets:packets protocols:protocols counter:packetCounter];
#else
            [sSelf handlePackets:packets protocols:protocols];
            
#endif
#ifdef DEBUG
            DDLogDebug(@"In readPacketsWithCompletionHandler (after handlePackets): %lu", packetCounter);
#endif
            
        }];
    });
    
#ifdef DEBUG
    DDLogDebug(@"After readPacketsWithCompletionHandler : %lu", packetCounter);
#endif
}

- (void)performSend:(NSDictionary<APTUdpProxySession *, NSArray *> *)packetsBySessions {

    ASSIGN_WEAK(self);
    
    dispatch_sync(_sessionsQueue, ^{
        
        ASSIGN_STRONG(self);
        
        if(!USE_STRONG(self))
            return;
        
        DDLogTrace();
        [packetsBySessions enumerateKeysAndObjectsUsingBlock:^(APTUdpProxySession *_Nonnull key, NSArray *_Nonnull obj, BOOL *_Nonnull stop) {
            
            APTUdpProxySession *session = [USE_STRONG(self)->_sessions member:key];
            if (!session) {
                //create session
                session = key;
                if ([session createSession]) {
                    
                    [session setLoggingEnabled:USE_STRONG(self)->_loggingEnabled];
                    [USE_STRONG(self)->_sessions addObject:session];
                }
                else
                    session = nil;
            }
            
            [session appendPackets:obj];
        }];
    });
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
