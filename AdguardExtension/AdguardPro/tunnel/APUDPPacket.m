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

struct udph6_pseudo {
    
    struct in6_addr saddr;	/* source address */
    struct in6_addr daddr;	/* destination address */
    uint32_t   len;
    uint16_t zero0;
    uint8_t zero1;
    uint8_t proto;
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
    
    uint16_t port = [dstPort intValue];
    if (port) {
        
        _dstPort = dstPort;
        
        [self repareMutable];
        
        _udpHeader->uh_dport = htons(port);
        
        [self checksumUdp];
    }
    OSSpinLockUnlock(&_lock);
}

- (NSString *)srcPort{
    
    return _srcPort;
}

- (void)setSrcPort:(NSString *)srcPort {

    OSSpinLockLock(&_lock);
    
    int port = [srcPort intValue];
    if (port) {
        
        _srcPort = srcPort;
        
        [self repareMutable];
        
        _udpHeader->uh_sport = htons(port);
        
        [self checksumUdp];
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
    
    [self repareMutable];
    
    [_ipMPacket replaceBytesInRange:NSMakeRange(_udpHeaderLength, (_ipMPacket.length - _udpHeaderLength)) withBytes:payload.bytes length:payload.length];
    
    int af = [self.aFamily intValue];
    if (af == AF_INET) {
        
        
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _ipHeader->ip_len = htons(_ipMPacket.length);
        
        [self checksumIPv4];
        
    } else if (af == AF_INET6) {
        
        _ip6Header = (struct ip6_hdr *)_ipMPacket.mutableBytes;
        _ip6Header->ip6_plen = htons(_ipMPacket.length - APT_IPV6_FIXED_HEADER_LENGTH);
    }
    
    _udpHeader = (struct udphdr *)((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
    _udpHeader->uh_ulen = htons(_ipMPacket.length - _ipHeaderLength);
    
    [self checksumUdp];
    
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
    
    _udpHeader = (struct udphdr *)((Byte *)_ipPacket.bytes + _ipHeaderLength);
    _udpHeaderLength = _ipHeaderLength + sizeof(struct udphdr);
    
    _dstPort = [NSString stringWithFormat:@"%d", ntohs(_udpHeader->uh_dport)];
    _srcPort = [NSString stringWithFormat:@"%d", ntohs(_udpHeader->uh_sport)];
    
    return YES;
}

- (BOOL)setUdpData{
    
    _udpHeaderLength = _ipHeaderLength + sizeof(struct udphdr);
    _ipMPacket.length = _udpHeaderLength;
    
    _udpHeader = (struct udphdr *)((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
    _udpHeader->uh_ulen = htons(sizeof(struct udphdr));
    
    _srcPort = @"0";
    _dstPort = @"0";
    
    if (self.aFamily.intValue == AF_INET) {

        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _ipHeader->ip_len = htons(_udpHeaderLength);
        
        [self checksumIPv4];
    }
    else {// INET6
        
        _ip6Header = (struct ip6_hdr *)_ipMPacket.mutableBytes;
        _ip6Header->ip6_plen = htons(sizeof(struct udphdr));
    }
    
    [self checksumUdp];
    
    return YES;
    
}

- (void)checksumUdp {

    struct udph_pseudo ph;
    struct udph6_pseudo ph6;
    void *buffer = NULL;
    int size = 0;

    if (self.aFamily.intValue == AF_INET) {
        
        ph.saddr = _ipHeader->ip_src;
        ph.daddr = _ipHeader->ip_dst;
        ph.zero = 0;
        ph.proto = _ipHeader->ip_p;
        ph.len = htons((uint16_t)(_ipMPacket.length - _ipHeaderLength));
        
        _udpHeader->uh_sum = 0;
        
        buffer = (void *)&ph;
        size = sizeof(ph);
    }
    else { //INET6
        
        ph6.saddr = _ip6Header->ip6_src;
        ph6.daddr = _ip6Header->ip6_dst;
        ph6.len = ntohl((uint32_t)(_ipMPacket.length - _ipHeaderLength));
        ph6.zero0 = ph6.zero1 = 0;
        ph6.proto = self.protocol;
        
        _udpHeader->uh_sum = 0;
        
        buffer = (void *)&ph6;
        size = sizeof(ph6);
    }
    
    uint32_t sum = checksum_adder(0, buffer, size);


    buffer = ((Byte *)_ipMPacket.mutableBytes + _ipHeaderLength);
    size = (int) (_ipMPacket.length  - _ipHeaderLength);
    
    sum = checksum_adder(sum, buffer, size);

    _udpHeader->uh_sum = checksum_finalize(sum);
}

@end
