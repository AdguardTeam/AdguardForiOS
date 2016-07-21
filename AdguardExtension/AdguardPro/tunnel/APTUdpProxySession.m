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
#import "APTUdpProxySession.h"
#import "APTunnelConnectionsHandler.h"
#import "APUDPPacket.h"
#import "PacketTunnelProvider.h"

#define MAX_DATAGRAMS_RECEIVED 10
#define TTL_SESSION 5 //seconds

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

        if ([self checkHost:udpPacket.dstAddress]) {
            
            _dnsLoggingEnabled = NO;
            _dnsRecords = [NSMutableArray new];
            _dnsRecordsSet = [NSMutableSet new];

            _basePacket = udpPacket;
            _key = [NSString stringWithFormat:@"%@:%@|%@:%@", udpPacket.dstAddress, udpPacket.dstPort, udpPacket.srcAddress, udpPacket.srcPort];

            _reversBasePacket = [APUDPPacket new];
            _reversBasePacket.dstAddress = _basePacket.srcAddress;
            _reversBasePacket.srcAddress = _basePacket.dstAddress;
            _reversBasePacket.dstPort = _basePacket.srcPort;
            _reversBasePacket.srcPort = _basePacket.dstPort;

            _delegate = delegate;

            return self;
        }
    }

    return nil;
}

- (BOOL)createSession {

    locLogTrace();

    _workingQueue = dispatch_queue_create("APTUdpProxySession", DISPATCH_QUEUE_SERIAL);
    _packetsForSend = [NSMutableArray new];
    _waitWrite = _closed = NO;

    NWHostEndpoint *rEndpoint = [NWHostEndpoint endpointWithHostname:_basePacket.dstAddress port:_basePacket.dstPort];
    NWUDPSession *session = [_delegate.provider createUDPSessionToEndpoint:rEndpoint fromEndpoint:nil];
    if (session) {

        [self setSession:session];
        _sessionCreated = YES;
        return YES;
    }

    return NO;
}

- (void)dealloc {

    locLogTrace();

    [self setSession:nil];
    if (_workingQueue) {
        dispatch_resume(_workingQueue);
    }
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
            if (self.udpSession.state == NWUDPSessionStateReady) {
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
            if (self.udpSession.hasBetterPath) {

                NWUDPSession *session = [[NWUDPSession alloc] initWithUpgradeForSession:self.udpSession];
                if (session) {
                    [self setSession:session];
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

- (BOOL)checkHost:(NSString *)host {

    // Check that this is IPv4 address
    struct in_addr addr;
    return (inet_pton(AF_INET, [host cStringUsingEncoding:NSUTF8StringEncoding], &(addr)) == 1);
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
        [_udpSession addObserver:self forKeyPath:@"state" options:0 context:NULL];
        [_udpSession addObserver:self forKeyPath:@"hasBetterPath" options:0 context:NULL];

        // block for reading data from remote endpoint
        [_udpSession setReadHandler:^(NSArray<NSData *> *_Nullable datagrams, NSError *_Nullable error) {

            __typeof__(self) sSelf = wSelf;

            if (sSelf == nil) {
                return;
            }

            DDLogVerbose(@"(APTUdpProxySession _udpSession setReadHandler) (ID:%@) receive data", sSelf->_basePacket.srcPort);

            if (sSelf->_dnsLoggingEnabled) {
                dispatch_sync(sSelf->_workingQueue, ^{
                   
                    [sSelf settingDnsRecordsForIncomingPackets:datagrams];
                });
                
                [sSelf->_saveLogExecution executeOnceForInterval];
            }
            
            // reset timeout timer
            [sSelf->_timeoutExecution executeOnceAfterCalm];

            NSMutableArray *protocols = [NSMutableArray new];

            //TODO: ONLY IPv4 is supported

            NSArray *ipPackets = [sSelf ipPacketsWithDatagrams:datagrams];
            for (int i = 0; i < ipPackets.count; i++) {

                [protocols addObject:@(AF_INET)];
            }

            DDLogVerbose(@"(APTUdpProxySession _udpSession setReadHandler) (ID:%@) before write to packetflow. Packets count: %lu", sSelf->_basePacket.srcPort, ipPackets.count);

            //write data from remote endpoint into local TUN interface
            [sSelf.delegate.provider.packetFlow writePackets:ipPackets withProtocols:protocols];

        }
                       maxDatagrams:MAX_DATAGRAMS_RECEIVED];

        if (oldSession) {
            dispatch_resume(_workingQueue);
        }

        //start timeout timer
        [_timeoutExecution executeOnceAfterCalm];
    }
}

- (void)sessionStateChanged {

    NWUDPSession *session = self.udpSession;
    if (session.state == NWUDPSessionStateReady) {

        locLogVerboseTrace(@"NWUDPSessionStateReady");
        [self sendPackets];
    } else if (session.state == NWUDPSessionStateFailed) {

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

        NSArray *packets = [NSArray arrayWithArray:_packetsForSend];
        [_packetsForSend removeAllObjects];
        _waitWrite = YES;

        if (_dnsLoggingEnabled) {
            [self gettingDnsRecordsForOutgoingPackets:packets];
            [_saveLogExecution executeOnceForInterval];
        }

        __typeof__(self) __weak wSelf = self;

        locLogVerboseTrace(@"before write packets");
        [_udpSession writeMultipleDatagrams:packets completionHandler:^(NSError *_Nullable error) {

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

            if (sSelf.udpSession.state == NWUDPSessionStateReady) {

                dispatch_async(sSelf->_workingQueue, ^{
                    if (sSelf) {

                        _waitWrite = NO;
                        [sSelf sendPackets];
                    }
                });
            }
        }];
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

- (void)gettingDnsRecordsForOutgoingPackets:(NSArray<NSData *> *)packets {

    for (NSData *packet in packets) {

        APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
        if (datagram.isRequest) {

            NSMutableString *sb = [NSMutableString new];
            for (APDnsRequest *item in datagram.requests) {
                [sb appendFormat:@"(ID:%@) \"%@\"\n", datagram.ID, item];
            }
            
            DDLogInfo(@"DNS Request (ID:%@) srcPort: %@ mode: %d to server: %@:%@ requests:\n%@", datagram.ID, _basePacket.srcPort, [_delegate.provider vpnMode], _basePacket.dstAddress, _basePacket.dstPort, (sb.length ? sb : @" None."));
            
            APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort vpnMode:@([_delegate.provider vpnMode])];

            record.requests = datagram.requests;

            [_dnsRecords addObject:record];
            [_dnsRecordsSet addObject:record];
        }
    }
}

- (void)settingDnsRecordsForIncomingPackets:(NSArray<NSData *> *)packets {
    
    for (NSData *packet in packets) {
        
        APDnsDatagram *datagram = [[APDnsDatagram alloc] initWithData:packet];
        if (datagram.isResponse) {
            
            NSMutableString *sb = [NSMutableString new];
            for (APDnsResponse *item in datagram.responses) {
                [sb appendFormat:@"(ID:%@) \"%@\"\n", datagram.ID, item];
            }
            
            DDLogInfo(@"DNS Response (ID:%@) srcPort: %@ mode: %d from server: %@:%@ responses:\n%@", datagram.ID, _basePacket.srcPort, [_delegate.provider vpnMode], _basePacket.dstAddress, _basePacket.dstPort, (sb.length ? sb : @" None."));
            
            APDnsLogRecord *record = [[APDnsLogRecord alloc] initWithID:datagram.ID srcPort:_basePacket.srcPort vpnMode:@([_delegate.provider vpnMode])];
            
            record = [_dnsRecordsSet member:record];
            if (record) {
                
                record.responses = datagram.responses;
            }
        }
    }
}

- (void)saveLogRecord:(BOOL)flush {

    if (_dnsLoggingEnabled) {

        if (flush) {

            [self.delegate writeToDnsActivityLog:_dnsRecords];
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
                [self.delegate writeToDnsActivityLog:records];
            }
        }
    }
}

@end
