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


#import "APUDPPacket.h"


#pragma pack(1)

struct udph_pseudo {

    struct	in_addr saddr;
    struct	in_addr daddr;
    uint8_t zero;
    uint8_t proto;
    uint16_t len;
};

@interface APIPPacket (internal)

- (void)repareMutable;
- (void)checksumIPv4;

@end

@implementation APUDPPacket {

    NSUInteger _udpHeaderLength;
    NSString *_dstPort, *_srcPort;
    
    struct udphdr *_udpHeader;
}

- (id)initWithData:(NSData *)data af:(NSNumber *)af {
    self = [super initWithData:data af:af];
    if (self && self.protocol == IPPROTO_UDP) {

        if (![self parseUdpData])
            return nil;

        return self;
    }

    return nil;
}

- (id)initWithAF:(NSNumber *)af protocol:(int)protocol{
    // here this method is not supported.
    return nil;
}

- (id)initWithAF:(NSNumber *)af{
    self = [super initWithAF:af protocol:IPPROTO_UDP];
    if (self) {
     
        if (![self setUdpData]) {
            return nil;
        }
        
        return self;
    }
    return nil;
}

- (id)init{
    
    return [self initWithAF:@(AF_INET)];
}
/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSString *)dstPort{
    
    return _dstPort;
}

- (void)setDstPort:(NSString *)dstPort {
    
    OSSpinLockLock(&_lock);
    int af = [self.aFamily intValue];
    if (af == AF_INET) {
        
        uint16_t port = [dstPort intValue];
        if (port) {
            
            _dstPort = dstPort;
            
            [self repareMutable];
            
            _udpHeader->uh_dport = htons(port);
            
            [self checksumUdpIPv4];
        }
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
    }
    OSSpinLockUnlock(&_lock);
}

- (NSString *)srcPort{
    
    return _srcPort;
}

- (void)setSrcPort:(NSString *)srcPort {

    OSSpinLockLock(&_lock);
    int af = [self.aFamily intValue];
    if (af == AF_INET) {
        
        int port = [srcPort intValue];
        if (port) {
            
            _srcPort = srcPort;
            
            [self repareMutable];
            
            _udpHeader->uh_sport = htons(port);
            
        }
        [self checksumUdpIPv4];
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
    }
    OSSpinLockUnlock(&_lock);
}

- (NSData *)payload{
    
    
    NSData *payload;
    OSSpinLockLock(&_lock);
    if (_ipMPacket) {
        payload = [NSData dataWithBytes:((Byte *)_ipMPacket.bytes + _udpHeaderLength) length:(_ipMPacket.length - _udpHeaderLength)];
    }
    else{
        
        payload = [NSData dataWithBytes:((Byte *)_ipPacket.bytes + _udpHeaderLength) length:(_ipPacket.length - _udpHeaderLength)];
    }
    OSSpinLockUnlock(&_lock);
    
    return payload;
}

- (void)setPayload:(NSData *)payload{
    
    OSSpinLockLock(&_lock);
    int af = [self.aFamily intValue];
    if (af == AF_INET) {
        
        [self repareMutable];
        
        [_ipMPacket replaceBytesInRange:NSMakeRange(_udpHeaderLength, (_ipMPacket.length - _udpHeaderLength)) withBytes:payload.bytes length:payload.length];
        
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _udpHeader = (struct udphdr *)((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
        
        _ipHeader->ip_len = htons(_ipMPacket.length);
        _udpHeader->uh_ulen = htons(_ipMPacket.length - _ipHeaderLength);
        
        [self checksumIPv4];
        [self checksumUdpIPv4];
        
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
    }
    OSSpinLockUnlock(&_lock);
    
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (void)repareMutable{
    if (!_ipMPacket) {
        
        [super repareMutable];
        _udpHeader = (struct udphdr *)((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
    }
}

- (BOOL)parseUdpData{
    
    int af = [self.aFamily intValue];
    if ( af == AF_INET) {
        
        _udpHeader = (struct udphdr *)((Byte *)_ipPacket.bytes + _ipHeaderLength);
        _udpHeaderLength = _ipHeaderLength + sizeof(struct udphdr);
        
        _dstPort = [NSString stringWithFormat:@"%d", ntohs(_udpHeader->uh_dport)];
        _srcPort = [NSString stringWithFormat:@"%d", ntohs(_udpHeader->uh_sport)];
        
        return YES;
    }
    else if (af == AF_INET6){
        //TODO: Not implemented yet
    }
    
    return NO;

}

- (BOOL)setUdpData{
    
    int aFamily = [self.aFamily intValue];
    
    if (aFamily == AF_INET) {

        _udpHeaderLength = _ipHeaderLength + sizeof(struct udphdr);
        _ipMPacket.length = _udpHeaderLength;

        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _udpHeader = (struct udphdr *)((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
        
        _ipHeader->ip_len = htons(_udpHeaderLength);
        _udpHeader->uh_ulen = htons(sizeof(struct udphdr));
        
        _srcPort = @"0";
        _dstPort = @"0";
        
        [self checksumIPv4];
        [self checksumUdpIPv4];
        
        return YES;
    }
    else if (aFamily == AF_INET6){
        //TODO: Not implemented yet
    }
    
    return NO;
    
}

//TODO: checksum calculation was not tested.
- (void)checksumUdpIPv4 {

    struct udph_pseudo ph;

    ph.saddr = _ipHeader->ip_src;
    ph.daddr = _ipHeader->ip_dst;
    ph.zero = 0;
    ph.proto = _ipHeader->ip_p;
    ph.len = htons((uint16_t)(_ipMPacket.length - _ipHeaderLength));

    _udpHeader->uh_sum = 0;

    void *buffer = (void *)&ph;
    int size = sizeof(ph);
    
    uint32_t sum = checksum_adder(0, buffer, size);


    buffer = ((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
    size = (int) (_ipMPacket.length  - _ipHeaderLength);
    
    sum = checksum_adder(sum, buffer, size);

    _udpHeader->uh_sum = checksum_finalize(sum);
}

@end
