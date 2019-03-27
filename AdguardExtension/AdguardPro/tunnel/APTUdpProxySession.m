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
#import "APDnsDatagram.h"
#import "APDnsLogRecord.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "APSharedResources.h"
#import "APTUdpProxySession.h"
#import "APTunnelConnectionsHandler.h"
#import "APUDPPacket.h"
#import "PacketTunnelProvider.h"
#import "APVPNManager.h"
#import "ACNIPUtils.h"

#import <QuartzCore/CAAnimation.h>

#import "Adguard-Swift.h"


#define MAX_DATAGRAMS_RECEIVED                      10
#define TTL_SESSION                                 3 //seconds
#define DOMAIN_URL_FORMAT                           @"http://%@/"

#define locLogError(logself, fmt, ...) DDLogError(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogWarn(logself, fmt, ...) DDLogWarn(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogInfo(logself, fmt, ...) DDLogInfo(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerbose(logself, fmt, ...) DDLogVerbose(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogDebug(logself, fmt, ...) DDLogDebug(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerbose(logself, fmt, ...) DDLogVerbose(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogVerboseTrace(logself, fmt, ...) DDLogVerboseTrace(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogErrorTrace(logself) DDLogErrorTrace(@"(ID:%@) " fmt, logself->_basePacket.srcPort, ##__VA_ARGS__)
#define locLogTrace(logself) DDLogVerboseTrace(@"(ID:%@)", logself->_basePacket.srcPort)

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
    DnsServerInfo *_currentDnsServer;
    
    ACLExecuteBlockDelayed *_saveLogExecution;
    NSMutableArray <APDnsLogRecord *> *_dnsRecords;
    NSMutableSet *_dnsRecordsSet;
    
    double startSendingTime;
    BOOL tracker;
    
    NSMutableArray <APDnsDatagram*>* _outgoingDnsDatagrams;
    NSMutableArray <NSData*>* _dns64MappedOutgoingPackets;
    
    BOOL _resendMappedDns64Request;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithUDPPacket:(APUDPPacket *)udpPacket delegate:(APTunnelConnectionsHandler *)delegate {

    if (!(udpPacket && delegate)) {
        return nil;
    }

    self = [super init];
    if (self) {
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
        _resendMappedDns64Request = NO;
        
        _outgoingDnsDatagrams = [NSMutableArray new];
        _dns64MappedOutgoingPackets = [NSMutableArray new];
        
        return self;
    }

    return nil;
}

- (BOOL)createSession {

    @autoreleasepool {
        
        locLogTrace(self);
        
        _workingQueue = dispatch_queue_create("APTUdpProxySession", DISPATCH_QUEUE_SERIAL);
        _packetsForSend = [NSMutableArray new];
        _waitWrite = _closed = NO;
        
        _currentDnsServer = _delegate.provider.currentDnsServer;
        
        // Create main session
        
        APDnsServerAddress *serverAddress = [self.delegate serverAddressForFakeDnsAddress:_basePacket.dstAddress];
        
        NWHostEndpoint *rEndpoint = [NWHostEndpoint endpointWithHostname:serverAddress.ip port: serverAddress.port ?: _basePacket.dstPort];
        
        
        NWUDPSession * session = [_delegate.provider createUDPSessionToEndpoint:rEndpoint fromEndpoint:nil];
        if (session) {
            
            [self setSession:session];
            _sessionCreated = YES;
            return YES;
        }
        
        return NO;
    }
}

- (void) removeObservers {
    @try {
        [self.udpSession removeObserver:self forKeyPath:@"state"];
        [self.udpSession removeObserver:self forKeyPath:@"hasBetterPath"];
    }
    @catch(id exception) {
        locLogWarn(self, @"removeObservers failed");
    }
}

- (void)dealloc {
    locLogTrace(self);
    _workingQueue = nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)appendPackets:(NSArray<NSData *> *)packets {

    if (_sessionCreated && !_closed && packets.count) {

        locLogTrace(self);
        dispatch_sync(_workingQueue, ^{

            [_packetsForSend addObjectsFromArray:packets];
            
            if (self.udpSession.state == NWUDPSessionStateReady) {
                [self sendPackets];
            }
        });
    }
}

- (void)close {
    
    ASSIGN_WEAK(self);
    dispatch_sync(_workingQueue, ^{
        
        ASSIGN_STRONG(self);
        [USE_STRONG(self) internalClose];
    });
}

/////////////////////////////////////////////////////////////////////
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    ASSIGN_WEAK(self);
    ASSIGN_WEAK(object);
    
    dispatch_async(_workingQueue, ^{

        ASSIGN_STRONG(self);
        ASSIGN_STRONG(object);
        
        if (USE_STRONG(self) == nil) {
            return;
        }
        
        if ([keyPath isEqual:@"state"]) {

            locLogVerboseTrace(USE_STRONG(self), @"state");
            [USE_STRONG(self) sessionStateChanged];
        } else if ([keyPath isEqual:@"hasBetterPath"]) {
            
            if(USE_STRONG(self)->_closed) {
                DDLogInfo(@"hasBetterPath called for closed session. Skip it");
                return;
            }

            locLogVerboseTrace(USE_STRONG(self) ,@"hasBetterPath");
            NWUDPSession *session = USE_STRONG(object);
            if (session.hasBetterPath) {

                NWUDPSession *newSession = [[NWUDPSession alloc] initWithUpgradeForSession:session];
                if (newSession) {
                    [USE_STRONG(self) setSession:newSession];
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
    
    ASSIGN_WEAK(self);
    ASSIGN_WEAK(session);
    
    [session addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    [session addObserver:self forKeyPath:@"hasBetterPath" options:NSKeyValueObservingOptionNew context:NULL];
    
    // block for reading data from remote endpoint
    [session setReadHandler:^(NSArray<NSData *> *_Nullable datagrams, NSError *_Nullable error) {
        
        ASSIGN_STRONG(self);
        
        if (USE_STRONG(self) == nil) {
            return;
        }
        
        if (error && !USE_STRONG(self)->_closed) {

            locLogError(USE_STRONG(self), @"Error when reading data for \"%@\":%@", USE_STRONG(self), error.description);
            return;
        }
        
        dispatch_sync(USE_STRONG(self)->_workingQueue, ^{
            
            ASSIGN_STRONG(session);
            ASSIGN_STRONG(self);
            [USE_STRONG(self) settingDnsRecordsForIncomingPackets:datagrams session:USE_STRONG(session)];
        });
        
        
        
        // reset timeout timer
        [USE_STRONG(self)->_timeoutExecution executeOnceAfterCalm];
        
        if(USE_STRONG(self)->_closed) {
            locLogInfo(USE_STRONG(self), @"got response for closed session. break.");
            return;
        }
        
        NSMutableArray *protocols = [NSMutableArray new];
        
        NSArray *ipPackets = [USE_STRONG(self) ipPacketsWithDatagrams:datagrams];
        for (int i = 0; i < ipPackets.count; i++) {
            [protocols addObject:USE_STRONG(self)->_basePacket.aFamily];
        }
        
        if(_delegate.provider.dns64Prefix.length && _outgoingDnsDatagrams.firstObject.requests.firstObject.type.intValue == APDnsResourceType.aaaaType.intValue && [self isEmptyResponse]) {
            _resendMappedDns64Request = YES;
            [self sendModifiedRequest];
        }
        else {
            //write data from remote endpoint into local TUN interface
            locLogInfo(USE_STRONG(self), @"write data from remote endpoint into local TUN interface");
            [USE_STRONG(self).delegate.provider.packetFlow writePackets:ipPackets withProtocols:protocols];
            
            [USE_STRONG(self).delegate sessionWorkDoneWithTime:CACurrentMediaTime() - USE_STRONG(self)->startSendingTime tracker: USE_STRONG(self)->tracker];
        }
    }
                            maxDatagrams:MAX_DATAGRAMS_RECEIVED];

}
- (void)setSession:(NWUDPSession *)session {

    locLogTrace(self);

    NWUDPSession *oldSession = self.udpSession;
    if (oldSession) {

        locLogVerboseTrace(self, @"oldSession");

        dispatch_suspend(_workingQueue);
        [oldSession removeObserver:self forKeyPath:@"state"];
        [oldSession removeObserver:self forKeyPath:@"hasBetterPath"];
        [oldSession cancel];
        
        _udpSession = nil;
    }

    if (session) {

        locLogVerboseTrace(self, @"newSession");

        ASSIGN_WEAK(self);
        
        // crete timeout timer
        if (! _timeoutExecution) {

            _timeoutExecution = [[ACLExecuteBlockDelayed alloc] initWithTimeout:TTL_SESSION leeway:0.1 queue:_workingQueue block:^{
                @autoreleasepool {
                    ASSIGN_STRONG(self);
                    [USE_STRONG(self) saveLogRecord:YES];
                    [USE_STRONG(self) internalClose];
                }
            }];
        }

        // crete save log timer
        if (! _saveLogExecution) {

            _saveLogExecution = [[ACLExecuteBlockDelayed alloc] initWithTimeout:TTL_SESSION leeway:0.1 queue:_workingQueue block:^{

                @autoreleasepool {
                    ASSIGN_STRONG(self);
                    [USE_STRONG(self) saveLogRecord:NO];
                }
            }];
        }
        
        _udpSession = session;
        
        [self setSessionReaders:_udpSession];

        //start timeout timer
        [_timeoutExecution executeOnceAfterCalm];
    }
    
    if (oldSession) {
        dispatch_resume(_workingQueue);
    }
    
}

- (void)sessionStateChanged {

    NWUDPSession *session = self.udpSession;
    
    if (session.state == NWUDPSessionStateReady) {

        locLogVerboseTrace(self, @"NWUDPSessionStateReady");
        [self sendPackets];
    } else if (session.state == NWUDPSessionStateFailed) {
        
        if(_closed)
            return;

        locLogVerboseTrace(self, @"NWUDPSessionStateFailed");

        NWHostEndpoint *endpoint = (NWHostEndpoint *)session.resolvedEndpoint;
        locLogError(self, @"(APTUdpProxySession) Session state is \"Failed\" on: %@ port: %@ endpoint: %@", endpoint.hostname, endpoint.port, session.endpoint);
        
        _closed = YES;
        [self saveLogRecord:YES];
        [self.delegate removeSession:self];
        
    } else if (session.state == NWUDPSessionStateCancelled) {

        locLogVerboseTrace(self, @"NWUDPSessionStateCancelled");
        
        if (_closed) {
            [self saveLogRecord:YES];
            [self.delegate removeSession:self];
        }
    }
}

/**
 special method for dns64 compatibility
 if device is used in nat64 network we must change dns responses. 'A' records are mapped to 'AAAA' with special nat64 prefix
 */
- (NSArray<NSData*>*)mappedIncomingPackets:(NSArray<NSData*>*)packets {
    
    if(!_delegate.provider.dns64Prefix.length || !_resendMappedDns64Request) {
        return packets;
    }
    
    NSMutableArray<NSData*>* mappedPackets = [NSMutableArray new];
    
    for (NSData* packet in packets) {
        APDnsDatagram* datagram = [[APDnsDatagram alloc] initWithData:packet];
        if (!datagram) {
            [mappedPackets addObject:packet];
            continue;
        }
        
        NSMutableArray<APDnsResponse* >* modifiedResponses = [NSMutableArray new];
        for (APDnsResponse* response in datagram.responses) {
            if(response.type.intValue != APDnsResourceType.aType.intValue) {
                [modifiedResponses addObject:response];
                continue;
            }
            
            // modify to AAAA
            NSData* ipv6AddressData = [[Dns64Utils new] dns64MappedIpDataWithIpv4Data:response.rdata prefix:_delegate.provider.dns64Prefix];
            
            NSString* ipv6Address = [ACNIPUtils ipv6DataToString:ipv6AddressData];
            APDnsResponse* modifiedResponse = [APDnsResponse createResponseWithName:response.name type:APDnsResourceType.aaaaType ip:ipv6Address];
            
            [modifiedResponses addObject:modifiedResponse];
        }
        
        datagram.responses = modifiedResponses;
        
        [mappedPackets addObject:datagram.generatePayload];
    }
    
    return mappedPackets;
}

/**
 special method for dns64 compatibility
 if device is used in nat64 network we must change dns responses. 'AAAA' records are mapped to 'A'
 */
- (NSArray<NSData*>*)mappedOutgoingPackets:(NSArray<NSData*>*)packets {
    
    if(!_delegate.provider.dns64Prefix.length) {
        return packets;
    }
    
    NSMutableArray<NSData*>* mappedPackets = [NSMutableArray new];
    
    for (NSData* packet in packets) {
        APDnsDatagram* datagram = [[APDnsDatagram alloc] initWithData:packet];
        if (!datagram) {
            [mappedPackets addObject:packet];
            continue;
        }
        
        NSMutableArray<APDnsRequest* >* modifiedRequests = [NSMutableArray new];
        for (APDnsRequest* request in datagram.requests) {
            if(request.type.intValue != APDnsResourceType.aaaaType.intValue) {
                [modifiedRequests addObject:request];
                continue;
            }
            
            // modify to A
            
            APDnsRequest* modifiedRequest = [[APDnsRequest alloc] initWithName:request.name type:APDnsResourceType.aType class:request.qClass];
            
            [modifiedRequests addObject:modifiedRequest];
        }
        
        datagram.requests = modifiedRequests;
        
        [mappedPackets addObject:datagram.generatePayload];
    }
    
    return mappedPackets;
}

- (void)sendPackets {

    if (_packetsForSend.count) {
        
        startSendingTime = CACurrentMediaTime();

        if (_waitWrite || _closed) {
            return;
        }

        NSMutableArray *packets = [NSMutableArray arrayWithArray:_packetsForSend];
        [_packetsForSend removeAllObjects];
        _waitWrite = YES;

        [self processingOutgoingPackets:packets];
        
        [_saveLogExecution executeOnceForInterval];
    
        ASSIGN_WEAK(self);

        
        void (^completionForMainWrite)(NSError *_Nullable error) = ^(NSError *_Nullable error) {
            
           ASSIGN_STRONG(self);
            
            if (USE_STRONG(self) == nil) {
                return;
            }
            
            if (error) {
                
                NWHostEndpoint *endpoint = (NWHostEndpoint *)USE_STRONG(self).udpSession.endpoint;
                locLogError(USE_STRONG(self), @"(APTUdpProxySession) Error occured when write packets to: %@ port: %@.\n%@", endpoint.hostname, endpoint.port, [error localizedDescription]);
                [USE_STRONG(self) internalClose];
                return;
            }
            
            [USE_STRONG(self)->_timeoutExecution executeOnceAfterCalm];
            
            if (USE_STRONG(self).udpSession.state == NWUDPSessionStateReady) {
                
                dispatch_async(USE_STRONG(self)->_workingQueue, ^{
                    
                    ASSIGN_STRONG(self);
                    
                    if (USE_STRONG(self)) {
                        
                        USE_STRONG(self)->_waitWrite = NO;
                        [USE_STRONG(self) sendPackets];
                    }
                });
            }
        };
        
        // write packets to main UDP session
        [self.udpSession writeMultipleDatagrams:packets completionHandler:completionForMainWrite];
    }
}

- (NSArray<NSData *> *)ipPacketsWithDatagrams:(NSArray<NSData *> *)datagrams {

    datagrams = [self mappedIncomingPackets: datagrams];
    NSMutableArray *ipPackets = [NSMutableArray new];
    for (NSData *item in datagrams) {

        self->_reversBasePacket.payload = item;
        [ipPackets addObject:_reversBasePacket.packet];
    }

    return ipPackets;
}

- (void)internalClose {

    locLogTrace(self);
    
    if (! _closed) {
        _closed = YES;
        [self.udpSession cancel];
    }
}

/**
 Performs separating of the outgoing packets on whitelisted, blacklisted. 
 Creates log records if needs it.
 */
- (void)processingOutgoingPackets:(NSMutableArray<NSData *> *)packets {
    
    @autoreleasepool {
        
        for (NSData *packet in packets) {
            
            APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
            
            if(!datagram) {
                DDLogError(@"(APTUdpProxySession) Outgoing datagram parsing error. Base packet dst address: %@ port: %@", _basePacket.dstAddress, _basePacket.dstPort);
            }
            
            if (datagram.isRequest) {
                
                //Check that this is request to domain from whitelist or blacklist.
                NSString *name = [datagram.requests[0] name];
                
                if (! [NSString isNullOrEmpty:name]) {
                    
                    // user filter lists are processed first
                   
                    [_outgoingDnsDatagrams addObject:datagram];
                    
                    if(_delegate.provider.dns64Prefix.length && datagram.requests.firstObject.type.intValue == APDnsResourceType.aaaaType.intValue) {
                        [_dns64MappedOutgoingPackets addObjectsFromArray:[self mappedOutgoingPackets:@[packet]]];
                    }
                    
                    tracker = [self.delegate isTrackerslistDomain:name];
                }
                
                //Create DNS log record, if logging is enabled.
                [self gettingDnsRecordForOutgoingDnsDatagram:datagram];
            }
        }
    }
}


- (void)gettingDnsRecordForOutgoingDnsDatagram:(APDnsDatagram *)datagram {
    
    [self logDnsRecordForOutgoingDnsDatagram:datagram];
    
    APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort dnsServer:_currentDnsServer];
    record.requests = datagram.requests;
    
    record.isTracker = tracker;
    
    if (![_dnsRecordsSet containsObject:record]) {
        
        [_dnsRecords addObject:record];
        [_dnsRecordsSet addObject:record];
    }
}

- (void)logDnsRecordForOutgoingDnsDatagram:(APDnsDatagram *)datagram {
    
    NSString *dstHost;
    NSString *dstPort;
    
    NWHostEndpoint *endpoint = (NWHostEndpoint *)self.udpSession.resolvedEndpoint;
    dstHost = endpoint.hostname;
    dstPort = endpoint.port;
    
    NSMutableString *sb = [NSMutableString new];
    for (APDnsRequest *item in datagram.requests) {
        [sb appendFormat:@"(ID:%@) (DID:%@) \"%@\"\n", _basePacket.srcPort, datagram.ID, item];
    }

    APVpnManagerTunnelMode tunnelMode = [_delegate.provider tunnelMode];
    NSString* mode = tunnelMode == APVpnManagerTunnelModeSplit ? @"split" :
                     tunnelMode == APVpnManagerTunnelModeFull  ? @"full" :
                                                                 @"full (without VPN icon)";
    
#if DEBUG
    DDLogInfo(@"DNS Request (ID:%@) (DID:%@) (IPID:%@) from: %@:%@ DNS: %@ mode: %@ to server: %@:%@ requests:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.ipId, _basePacket.srcAddress, _basePacket.srcPort, _currentDnsServer.name, mode, dstHost, dstPort, (sb.length ? sb : @" None."));
#else
    DDLogInfo(@"DNS Request (ID:%@) (DID:%@) srcPort: %@ DNS: %@ mode: %@ to server: %@:%@ requests:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcPort, _currentDnsServer.name, mode, dstHost, dstPort, (sb.length ? sb : @" None."));
#endif
}


- (void)settingDnsRecordsForIncomingPackets:(NSArray<NSData *> *)packets session:(NWUDPSession *)session{
    
    for (NSData *packet in packets) {
        
        APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
        
        if(!datagram) {
            DDLogError(@"(APTUdpProxySession) Incoming datagram parsing error. Base packet dst address: %@ port: %@", _basePacket.dstAddress, _basePacket.dstPort);
        }
        
        [self settingDnsRecordForIncomingDnsDatagram:datagram session:session];
    }
    
    [self->_saveLogExecution executeOnceForInterval];
}

- (void)settingDnsRecordForIncomingDnsDatagram:(APDnsDatagram *)datagram session:(NWUDPSession *)session{
    
    if (datagram.isResponse) {
        
        [self logDnsRecordForIncomingDnsDatagram:datagram session:session];
        
        APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort dnsServer:_currentDnsServer];
        
        record = [_dnsRecordsSet member:record];
        if (record) {
            
            record.responses = datagram.responses;
        }
    }
}

- (void) logDnsRecordForIncomingDnsDatagram:(__unsafe_unretained APDnsDatagram *)datagram session:(__unsafe_unretained NWUDPSession *)session {
    
    NSMutableString *sb = [NSMutableString new];
    for (APDnsResponse *item in datagram.responses) {
        [sb appendFormat:@"(ID:%@) (DID:%@) \"%@\"\n", _basePacket.srcPort, datagram.ID, item];
    }
    
    NWHostEndpoint *endpoint = (NWHostEndpoint *)session.resolvedEndpoint;
#if DEBUG
    DDLogInfo(@"DNS Response (ID:%@) (DID:%@) to: %@:%@ mode: %@ from server: %@:%@ responses:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcAddress, _basePacket.srcPort, _currentDnsServer.name, endpoint.hostname, endpoint.port, (sb.length ? sb : @" None."));
#else
    DDLogInfo(@"DNS Response (ID:%@) (DID:%@) dstPort: %@ mode: %@ from server: %@:%@ responses:\n%@", _basePacket.srcPort, datagram.ID, _basePacket.srcPort, _currentDnsServer.name, endpoint.hostname, endpoint.port, (sb.length ? sb : @" None."));
#endif
}


- (void)saveLogRecord:(BOOL)flush {

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

- (BOOL) isEmptyResponse {
    return YES;
}

- (void) sendModifiedRequest {
    _packetsForSend = _dns64MappedOutgoingPackets;
    [_outgoingDnsDatagrams removeAllObjects];
    [self sendPackets];
}

@end
