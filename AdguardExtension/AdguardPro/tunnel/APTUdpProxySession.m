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
#import "APDnsDatagram.h"
#import "APDnsLogRecord.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "APSharedResources.h"
#import "APTUdpProxySession.h"
#import "APTunnelConnectionsHandler.h"
#import "APUDPPacket.h"
#import "PacketTunnelProvider.h"
#import "APDnsServerObject.h"

#define MAX_DATAGRAMS_RECEIVED 10
#define TTL_SESSION 10 //seconds

#define locLogError(fmt, ...) DDLogError(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogWarn(fmt, ...) DDLogWarn(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogInfo(fmt, ...) DDLogInfo(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerbose(fmt, ...) DDLogVerbose(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogDebug(fmt, ...) DDLogDebug(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerbose(fmt, ...) DDLogVerbose(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerboseTrace(fmt, ...) DDLogVerboseTrace(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogErrorTrace() DDLogErrorTrace(@"(ID:%@) " fmt, _basePacket.srcPort, ##__VA_ARGS__)
#define locLogTrace() DDLogVerboseTrace(@"(ID:%@)", _basePacket.srcPort)

@implementation APTUdpProxySession {

    dispatch_queue_t _workingQueue;
    NSMutableArray *_packetsForSend;
    ACLExecuteBlockDelayed *_timeoutExecution;
    BOOL _waitWrite;
    BOOL _sessionCreated;
    BOOL _closed;
    NSString *_key;
    APUDPPacket *_basePacket;
    APUDPPacket *_reversBasePacket;
    
    BOOL _dnsLoggingEnabled;
    ACLExecuteBlockDelayed *_saveLogExecution;
    NSMutableArray <APDnsLogRecord *> *_dnsRecords;
    NSMutableSet *_dnsRecordsSet;    
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithUDPPacket:(APUDPPacket *)udpPacket delegate:(APTunnelConnectionsHandler *)delegate {

    if (!(udpPacket && delegate)) {
        return nil;
    }

    self = [super init];
    if (self) {
        
        
        _dnsLoggingEnabled = NO;
        _dnsRecords = [NSMutableArray new];
        _dnsRecordsSet = [NSMutableSet new];
        
        _basePacket = udpPacket;
        _key = [NSString stringWithFormat:@"%@:%@|%@:%@", udpPacket.dstAddress, udpPacket.dstPort, udpPacket.srcAddress, udpPacket.srcPort];
        
        _reversBasePacket = [[APUDPPacket alloc] initWithAF:udpPacket.aFamily];
        _reversBasePacket.dstAddress = _basePacket.srcAddress;
        _reversBasePacket.srcAddress = _basePacket.dstAddress;
        _reversBasePacket.dstPort = _basePacket.srcPort;
        _reversBasePacket.srcPort = _basePacket.dstPort;
        
        _delegate = delegate;
        
        return self;
    }

    return nil;
}

- (BOOL)createSession {

    @autoreleasepool {
        
        locLogTrace();
        
        _workingQueue = dispatch_queue_create("APTUdpProxySession", DISPATCH_QUEUE_SERIAL);
        _packetsForSend = [NSMutableArray new];
        _waitWrite = _closed = NO;
        
        // Create session for whitelist
        NSString *serverIp = [self.delegate whitelistServerAddressForAddress:_basePacket.dstAddress];
        NWHostEndpoint *rEndpoint = [NWHostEndpoint endpointWithHostname:serverIp port:_basePacket.dstPort];
        NWUDPSession *session = [_delegate.provider createUDPSessionToEndpoint:rEndpoint fromEndpoint:nil];
        if (!session) {
            
            return NO;
        }
        
        [self setWhitelistSession:session];
        
        // Create main session
        
        // It is trick. If we have only local filtration, then normal remote DNS server is the same whitelist remote DNS server.
        if (_delegate.provider.isRemoteServer) {
            serverIp = _basePacket.dstAddress;
        }
        rEndpoint = [NWHostEndpoint endpointWithHostname:serverIp port:_basePacket.dstPort];
        
        session = [_delegate.provider createUDPSessionToEndpoint:rEndpoint fromEndpoint:nil];
        if (session) {
            
            [self setSession:session];
            _sessionCreated = YES;
            return YES;
        }
        
        return NO;
    }
}

- (void)dealloc {

    locLogTrace();

    [self saveLogRecord:YES];
    
    [self setWhitelistSession:nil];
    [self setSession:nil];
    
    _workingQueue = nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)setLoggingEnabled:(BOOL)enabled{
    
    _dnsLoggingEnabled = enabled;
}


- (void)appendPackets:(NSArray<NSData *> *)packets {

    if (_sessionCreated && !_closed && packets.count) {

        locLogTrace();
        dispatch_sync(_workingQueue, ^{

            [_packetsForSend addObjectsFromArray:packets];
            if (self.udpSession.state == NWUDPSessionStateReady
                && self.whitelistUdpSession.state == NWUDPSessionStateReady) {
                [self sendPackets];
            }
        });
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    dispatch_async(_workingQueue, ^{

        if ([keyPath isEqual:@"state"]) {

            locLogVerboseTrace(@"state");
            [self sessionStateChanged];
        } else if ([keyPath isEqual:@"hasBetterPath"]) {

            locLogVerboseTrace(@"hasBetterPath");
            NWUDPSession *session = object;
            if (session.hasBetterPath) {

                NWUDPSession *newSession = [[NWUDPSession alloc] initWithUpgradeForSession:session];
                if (newSession) {
                    
                    if ([session isEqual:self.udpSession]) {
                        
                        [self setSession:newSession];
                    }
                    else {
                        
                        [self setWhitelistSession:newSession];
                    }
                }
            }
        }
    });
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

- (NSString *)description {
    return _key;
}

- (BOOL)isEqual:(id)object {

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {
        __typeof__(self) obj = object;
        if ([self->_key isEqualToString:obj->_key]) {

            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return [_key hash];
}

- (id)copyWithZone:(NSZone *)zone {

    APTUdpProxySession *newSession = [[APTUdpProxySession alloc] initWithUDPPacket:_basePacket delegate:_delegate];

    return newSession;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Method (Private)

- (void)setSessionReaders:(NWUDPSession *)session {
    
    __weak __typeof__(self) wSelf = self;
    __weak __typeof__(session) wSession = session;
    
    [session addObserver:self forKeyPath:@"state" options:0 context:NULL];
    [session addObserver:self forKeyPath:@"hasBetterPath" options:0 context:NULL];
    
    // block for reading data from remote endpoint
    [session setReadHandler:^(NSArray<NSData *> *_Nullable datagrams, NSError *_Nullable error) {
        
        __typeof__(self) sSelf = wSelf;
        
        if (sSelf == nil) {
            return;
        }
        
        
        if (sSelf->_dnsLoggingEnabled) {
            
            __typeof__(session) sSession = wSession;
            
            dispatch_sync(sSelf->_workingQueue, ^{
                
                [sSelf settingDnsRecordsForIncomingPackets:datagrams session:sSession];
            });
            
            [sSelf->_saveLogExecution executeOnceForInterval];
        }
        
        // reset timeout timer
        [sSelf->_timeoutExecution executeOnceAfterCalm];
        
        NSMutableArray *protocols = [NSMutableArray new];
        
        NSArray *ipPackets = [sSelf ipPacketsWithDatagrams:datagrams];
        for (int i = 0; i < ipPackets.count; i++) {
            
            [protocols addObject:_basePacket.aFamily];
        }
        
        //write data from remote endpoint into local TUN interface
        [sSelf.delegate.provider.packetFlow writePackets:ipPackets withProtocols:protocols];
        
    }
                            maxDatagrams:MAX_DATAGRAMS_RECEIVED];

}
- (void)setSession:(NWUDPSession *)session {

    locLogTrace();

    NWUDPSession *oldSession = self.udpSession;
    if (oldSession) {

        locLogVerboseTrace(@"oldSession");

        dispatch_suspend(_workingQueue);
        [oldSession removeObserver:self forKeyPath:@"state"];
        [oldSession removeObserver:self forKeyPath:@"hasBetterPath"];
        [oldSession cancel];
    }

    if (session) {

        locLogVerboseTrace(@"newSession");

        __weak __typeof__(self) wSelf = self;
        
        // crete timeout timer
        _timeoutExecution = [[ACLExecuteBlockDelayed alloc] initWithTimeout:TTL_SESSION leeway:0.1 queue:_workingQueue block:^{

            __typeof__(self) sSelf = wSelf;
            [sSelf saveLogRecord:YES];
            [sSelf close];
        }];

        // crete save log timer
        _saveLogExecution = [[ACLExecuteBlockDelayed alloc] initWithTimeout:TTL_SESSION leeway:0.1 queue:_workingQueue block:^{
            
            __typeof__(self) sSelf = wSelf;
            [sSelf saveLogRecord:NO];
        }];
        
        _udpSession = session;
        
        [self setSessionReaders:_udpSession];

        //start timeout timer
        [_timeoutExecution executeOnceAfterCalm];
    }
    
    if (oldSession) {
        dispatch_resume(_workingQueue);
    }
    
}

- (void)setWhitelistSession:(NWUDPSession *)session {
    
    locLogTrace();
    
    NWUDPSession *oldSession = self.whitelistUdpSession;
    if (oldSession) {
        
        locLogVerboseTrace(@"oldWhitelistSession");
        
        dispatch_suspend(_workingQueue);
        [oldSession removeObserver:self forKeyPath:@"state"];
        [oldSession removeObserver:self forKeyPath:@"hasBetterPath"];
        [oldSession cancel];
    }
    
    if (session) {
        
        locLogVerboseTrace(@"newWhitelistSession");
        
        
        _whitelistUdpSession = session;
        
        [self setSessionReaders:_whitelistUdpSession];

    }
    
    if (oldSession) {
        dispatch_resume(_workingQueue);
    }
}

- (void)sessionStateChanged {

    NWUDPSession *session = self.udpSession;
    NWUDPSession *whitelistSession = self.whitelistUdpSession;
    
    if (session.state == NWUDPSessionStateReady
        && whitelistSession.state == NWUDPSessionStateReady) {

        locLogVerboseTrace(@"NWUDPSessionStateReady");
        [self sendPackets];
    } else if (session.state == NWUDPSessionStateFailed
               || whitelistSession.state == NWUDPSessionStateFailed) {

        locLogVerboseTrace(@"NWUDPSessionStateFailed");

        NWHostEndpoint *endpoint = (NWHostEndpoint *)session.resolvedEndpoint;
        locLogError(@"(APTUdpProxySession) Session state is \"Failed\" on: %@ port: %@.", endpoint.hostname, endpoint.port);
        [self close];
    } else if (session.state == NWUDPSessionStateCancelled) {

        locLogVerboseTrace(@"NWUDPSessionStateCancelled");
        if (_closed) {
            [self.delegate removeSession:self];
        }
    }
}

- (void)sendPackets {

    if (_packetsForSend.count) {

        if (_waitWrite || _closed) {
            return;
        }

        NSMutableArray *packets = [NSMutableArray arrayWithArray:_packetsForSend];
        [_packetsForSend removeAllObjects];
        _waitWrite = YES;

        NSArray *specialPackets = [self processingOutgoingPackets:packets];
        NSArray *whitelistPackets = specialPackets[0];
        NSArray *blacklistDatagrams = specialPackets[1];
        
        if (_dnsLoggingEnabled) {
            [_saveLogExecution executeOnceForInterval];
        }

        __typeof__(self) __weak wSelf = self;

        locLogVerboseTrace(@"before write packets");
        
        void (^completionForMainWrite)(NSError *_Nullable error) = ^(NSError *_Nullable error) {
            
            locLogVerboseTrace(@"completion handler");
            
            __typeof__(self) sSelf = wSelf;
            
            if (sSelf == nil) {
                return;
            }
            
            [sSelf->_timeoutExecution executeOnceAfterCalm];
            
            if (error) {
                
                NWHostEndpoint *endpoint = (NWHostEndpoint *)sSelf.udpSession.endpoint;
                locLogError(@"(APTUdpProxySession) Error occured when write packets to: %@ port: %@.\n%@", endpoint.hostname, endpoint.port, [error localizedDescription]);
                [sSelf close];
                return;
            }
            
            if (sSelf.udpSession.state == NWUDPSessionStateReady
                && sSelf.whitelistUdpSession.state == NWUDPSessionStateReady) {
                
                dispatch_async(sSelf->_workingQueue, ^{
                    if (sSelf) {
                        
                        _waitWrite = NO;
                        [sSelf sendPackets];
                    }
                });
            }
        };
        
        if (blacklistDatagrams.count) {
        
            [self sendBackBlacklistDnsDatagrams:blacklistDatagrams];
        }
        
        if (whitelistPackets.count) {
            
            // write packets to whitelist UDP session
            [_whitelistUdpSession writeMultipleDatagrams:whitelistPackets completionHandler:^(NSError * _Nullable error) {
                
                locLogVerboseTrace(@"whitelist completion handler");
                
                __typeof__(self) sSelf = wSelf;
                
                if (sSelf == nil) {
                    return;
                }
                
                if (error) {
                    
                    NWHostEndpoint *endpoint = (NWHostEndpoint *)sSelf->_whitelistUdpSession.endpoint;
                    locLogError(@"(APTUdpProxySession) Error occured when write packets to: %@ port: %@.\n%@", endpoint.hostname, endpoint.port, [error localizedDescription]);
                    [sSelf close];
                    return;
                }
                // write packets to main UDP session
                [_udpSession writeMultipleDatagrams:packets completionHandler:completionForMainWrite];
            }];
        }
        else
            // write packets to main UDP session
            [_udpSession writeMultipleDatagrams:packets completionHandler:completionForMainWrite];
    }
}

- (NSArray<NSData *> *)ipPacketsWithDatagrams:(NSArray<NSData *> *)datagrams {

    NSMutableArray *ipPackets = [NSMutableArray new];
    for (NSData *item in datagrams) {

        _reversBasePacket.payload = item;
        [ipPackets addObject:_reversBasePacket.packet];
    }

    return ipPackets;
}

- (void)close {

    locLogTrace();

    NWUDPSession *session = self.udpSession;
    if (session) {

        _closed = YES;
        [session cancel];
    }
}

/**
 Performs separating of the outgoing packets on whitelisted, blacklisted. 
 Creates log records if needs it.
 */
- (NSArray <NSArray *> *)processingOutgoingPackets:(NSMutableArray<NSData *> *)packets {

    NSMutableArray *whitelistPackets = [NSMutableArray array];
    NSMutableArray *blacklistDatagrams = [NSMutableArray array];
    for (NSData *packet in packets) {

        APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
        if (datagram.isRequest) {

            BOOL whitelisted = NO;
            BOOL blacklisted = NO;
            
            //Check that this is request to domain from whitelist or blacklist.
            NSString *name = [datagram.requests[0] name];
            if (! [NSString isNullOrEmpty:name]) {
                
                // whitelist is processed first
                if ([self.delegate isWhitelistDomain:name]) {

                    [whitelistPackets addObject:packet];
                    whitelisted = YES;
                    locLogVerboseTrace(@"Domain to whiltelist: %@", name);

                }
                else if ([self.delegate isBlacklistDomain:name]) {
                    
                    [blacklistDatagrams addObject:datagram];
                    
                    [packets removeObject:packet];
                    
                    blacklisted = YES;
                    
                    locLogVerboseTrace(@"Domain to blacklist: %@", name);
                }
            }
            
            //Create DNS log record, if logging is enabled.
            if (_dnsLoggingEnabled) {
                
                [self gettingDnsRecordForOutgoingDnsDatagram:datagram whitelist:whitelisted blacklist:blacklisted];
            }
            
        }
    }
    
    if (whitelistPackets.count) {
        [packets removeObjectsInArray:whitelistPackets];
    }
    
    return @[whitelistPackets, blacklistDatagrams];
}

- (void)sendBackBlacklistDnsDatagrams:(NSArray <APDnsDatagram *> *)dnsDatagrams {
    

    BOOL logUpdated = NO;
    NSMutableArray *datagrams = [NSMutableArray arrayWithCapacity:dnsDatagrams.count];
    for (APDnsDatagram *item in dnsDatagrams) {
        
        if ([item convertToBlockingResponse]) {
            
            if (_dnsLoggingEnabled) {
                [self settingDnsRecordForIncomingDnsDatagram:item session:_udpSession];
                logUpdated = YES;
            }
            
            NSData *datagram = [item generatePayload];
            if (datagram) {
                [datagrams addObject:datagram];
            }
        }
    }
    
    if (datagrams.count == 0) {
        return;
    }
    
    if (logUpdated) {
        [_saveLogExecution executeOnceForInterval];
    }
    
    NSMutableArray *protocols = [NSMutableArray new];
    
    NSArray *ipPackets = [self ipPacketsWithDatagrams:datagrams];
    for (int i = 0; i < ipPackets.count; i++) {
        
        [protocols addObject:_basePacket.aFamily];
    }
    
    //write data from remote endpoint into local TUN interface
    [self.delegate.provider.packetFlow writePackets:ipPackets withProtocols:protocols];

}

- (void)gettingDnsRecordForOutgoingDnsDatagram:(APDnsDatagram *)datagram whitelist:(BOOL)whitelist blacklist:(BOOL)blacklist {
    
    APDnsServerObject *dnsServer = _delegate.provider.currentDnsServer;
    BOOL localFiltering = _delegate.provider.localFiltering;
    
    APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort dnsServer:dnsServer localFiltering:localFiltering];
    record.requests = datagram.requests;
    
    
    record.isBlacklisted = blacklist;
    
    NSString *dstHost;
    NSString *dstPort;
    if (whitelist) {
        record.isWhitelisted = YES;
        
        NWHostEndpoint *endpoint = (NWHostEndpoint *)self.whitelistUdpSession.resolvedEndpoint;
        dstHost = endpoint.hostname;
        dstPort = endpoint.port;
    }
    else {
        
        dstHost = _basePacket.dstAddress;
        dstPort = _basePacket.dstPort;
    }
    
    if (![_dnsRecordsSet containsObject:record]) {
        
        [_dnsRecords addObject:record];
        [_dnsRecordsSet addObject:record];
    }
    
    NSMutableString *sb = [NSMutableString new];
    for (APDnsRequest *item in datagram.requests) {
        [sb appendFormat:@"(ID:%@) (DID:%@) \"%@\"\n", _basePacket.srcPort, datagram.ID, item];
    }
    
    #if DEBUG
                DDLogInfo(@"DNS Request (ID:%@) (DID:%@) (IPID:%@) from: %@:%@ mode: %@ localFiltering: %@ to server: %@:%@ requests:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.ipId, _basePacket.srcAddress, _basePacket.srcPort,dnsServer.serverName, (localFiltering ? @"YES" : @"NO"), dstHost, dstPort, (sb.length ? sb : @" None."));
    #else
    DDLogInfo(@"DNS Request (ID:%@) (DID:%@) srcPort: %@ mode: %@ localFiltering: %@ to server: %@:%@ requests:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcPort, dnsServer.serverName, (localFiltering ? @"YES" : @"NO"), dstHost, dstPort, (sb.length ? sb : @" None."));
    #endif
}

- (void)settingDnsRecordsForIncomingPackets:(NSArray<NSData *> *)packets session:(NWUDPSession *)session{
    
    for (NSData *packet in packets) {
        
        APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
        [self settingDnsRecordForIncomingDnsDatagram:datagram session:session];
    }
}

- (void)settingDnsRecordForIncomingDnsDatagram:(APDnsDatagram *)datagram session:(NWUDPSession *)session{
    
    if (datagram.isResponse) {
        
        NSMutableString *sb = [NSMutableString new];
        for (APDnsResponse *item in datagram.responses) {
            [sb appendFormat:@"(ID:%@) (DID:%@) \"%@\"\n", _basePacket.srcPort, datagram.ID, item];
        }
        
        APDnsServerObject *dnsServer = _delegate.provider.currentDnsServer;
        BOOL localFiltering = _delegate.provider.localFiltering;
        
        NWHostEndpoint *endpoint = (NWHostEndpoint *)session.resolvedEndpoint;
        #if DEBUG
                    DDLogInfo(@"DNS Response (ID:%@) (DID:%@) to: %@:%@ mode: %@ localFiltering: %@ from server: %@:%@ responses:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcAddress, _basePacket.srcPort, dnsServer.serverName, (localFiltering ? @"YES" : @"NO"), endpoint.hostname, endpoint.port, (sb.length ? sb : @" None."));
        #else
        DDLogInfo(@"DNS Response (ID:%@) (DID:%@) dstPort: %@ mode: %@ localFiltering: %@ from server: %@:%@ responses:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcPort, dnsServer.serverName, (localFiltering ? @"YES" : @"NO"), endpoint.hostname, endpoint.port, (sb.length ? sb : @" None."));
        #endif
        
        APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort dnsServer:dnsServer localFiltering:localFiltering];
        
        record = [_dnsRecordsSet member:record];
        if (record) {
            
            record.responses = datagram.responses;
        }
    }
}


- (void)saveLogRecord:(BOOL)flush {

    if (_dnsLoggingEnabled) {

        if (flush) {

            [APSharedResources writeToDnsLogRecords:_dnsRecords];
            [_dnsRecords removeAllObjects];
            [_dnsRecordsSet removeAllObjects];
        } else {

            NSMutableArray *records = [NSMutableArray new];
            NSDate *dateBefore = [NSDate dateWithTimeIntervalSinceNow:-(TTL_SESSION)];

            for (APDnsLogRecord *obj in _dnsRecords) {

                if ([obj.recordDate compare:dateBefore] == NSOrderedDescending) {
                    break;
                }

                [records addObject:obj];
                [_dnsRecordsSet removeObject:obj];
            }

            if (records.count) {

                [_dnsRecords removeObjectsInRange:NSMakeRange(0, records.count)];
                [APSharedResources writeToDnsLogRecords:records];
            }
        }
    }
}

@end
