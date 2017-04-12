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


#import "APIPPacket.h"

@implementation APIPPacket

- (id)init{

    return [self initWithAF:@(AF_INET) protocol:IPPROTO_UDP];
}

- (id)initWithData:(NSData *)data af:(NSNumber *)af{
    
    if (!(data && af)) {
        return nil;
    }
    self = [super init];
    if (self) {
        
        _lock = OS_SPINLOCK_INIT;
        
        _ipHeader = NULL;
        _ip6Header = NULL;
        
        if(![self parseData:data af:af])
            return nil;
    }
    
    return self;
}

- (id)initWithAF:(NSNumber *)af protocol:(int)protocol{
    
    if (!(af && protocol)) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        _lock = OS_SPINLOCK_INIT;

        _ipHeader = NULL;
        _ip6Header = NULL;
        
        if(![self createWithAF:af protocol:protocol])
            return nil;
    }
    
    return self;
    
}

- (void)dealloc {
    
    _ip6Header = NULL;
    _ipHeader = NULL;
}
/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSString *)dstAddress{
    
    return _dstAddress;
}

- (void)setDstAddress:(NSString *)dstAddress {

    OSSpinLockLock(&_lock);
    int af = [_aFamily intValue];
    
    [self repareMutable];
    
    void *dest;
    if (af == AF_INET) {

        dest = &(_ipHeader->ip_dst);
    } else if (af == AF_INET6) {
        
        dest = &(_ip6Header->ip6_dst);
    }
    else {
        
        OSSpinLockUnlock(&_lock);
        return;
    }
    
    if (inet_pton(af, [dstAddress cStringUsingEncoding:NSUTF8StringEncoding], dest) == 1) {
        
        _dstAddress = dstAddress;
    }
    
    if (af == AF_INET) {
        
        [self checksumIPv4];
    }
    
    OSSpinLockUnlock(&_lock);
}

- (NSString *)srcAddress{
    
    return _srcAddress;
}

- (void)setSrcAddress:(NSString *)srcAddress {

    OSSpinLockLock(&_lock);
    int af = [_aFamily intValue];
    
    [self repareMutable];
    
    void *dest;
    if (af == AF_INET) {
        
        dest = &(_ipHeader->ip_src);
    } else if (af == AF_INET6) {
        
        dest = &(_ip6Header->ip6_src);
    }
    else {
        OSSpinLockUnlock(&_lock);
        return;
    }
    
    if (inet_pton(af, [srcAddress cStringUsingEncoding:NSUTF8StringEncoding], dest) == 1) {
        
        _srcAddress = srcAddress;
    }
    
    if (af == AF_INET) {
        
        [self checksumIPv4];
    }
    
    OSSpinLockUnlock(&_lock);
}

- (NSData *)packet {

    NSData *packet;
    OSSpinLockLock(&_lock);
    if (_ipMPacket) {
        packet = [_ipMPacket copy];
    }
    else{
        packet = _ipPacket;
    }
    OSSpinLockUnlock(&_lock);

    return packet;
}

- (NSData *)payload{

    
    NSData *payload;
    OSSpinLockLock(&_lock);
    if (_ipMPacket) {
        payload = [NSData dataWithBytes:((Byte *)_ipMPacket.bytes + _ipHeaderLength) length:(_ipMPacket.length - _ipHeaderLength)];
    }
    else{
        
        payload = [NSData dataWithBytes:((Byte *)_ipPacket.bytes + _ipHeaderLength) length:(_ipPacket.length - _ipHeaderLength)];
    }
    OSSpinLockUnlock(&_lock);
    
    return payload;
}

- (void)setPayload:(NSData *)payload{
    
    OSSpinLockLock(&_lock);
    int af = [_aFamily intValue];
    
    [self repareMutable];
    
    [_ipMPacket replaceBytesInRange:NSMakeRange(_ipHeaderLength, (_ipMPacket.length - _ipHeaderLength)) withBytes:payload.bytes length:payload.length];
    
    if (af == AF_INET) {

        
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _ipHeader->ip_len = htons(_ipMPacket.length);
        
        [self checksumIPv4];
        
    } else if (af == AF_INET6) {
        
        _ip6Header = (struct ip6_hdr *)_ipMPacket.mutableBytes;
        _ip6Header->ip6_plen = htons(_ipMPacket.length - APT_IPV6_FIXED_HEADER_LENGTH);
    }
    OSSpinLockUnlock(&_lock);
 
}

/////////////////////////////////////////////////////////////////////
#pragma mark Protected methods

- (void)repareMutable{
    if (!_ipMPacket) {
        _ipMPacket = [_ipPacket mutableCopy];
        _ipPacket = nil;
        
        if (_aFamily.intValue == AF_INET) {
            _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        }
        else { // AF_INET6
            _ip6Header = (struct ip6_hdr *)_ipMPacket.mutableBytes;
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (BOOL)parseData:(NSData *)data af:(NSNumber *)af{
    
    _aFamily = af;
    
    int aFamily = [af intValue];
    
    if (aFamily == AF_INET) {
        
        _ipPacket = data;
        
        _ipHeader = (struct iphdr *)_ipPacket.bytes;
        _ipHeaderLength = _ipHeader->ip_hl * 4; //unit 32bit
        
        _protocol = _ipHeader->ip_p;
#if DEBUG
        _ipId = [NSString stringWithFormat:@"%d",_ipHeader->ip_id];
#endif
        _dstAddress = [NSString stringWithUTF8String:inet_ntoa(_ipHeader->ip_dst)];
        _srcAddress = [NSString stringWithUTF8String:inet_ntoa(_ipHeader->ip_src)];
        
        return YES;
    }
    else if (aFamily == AF_INET6){
        
        _ipPacket = data;
        
        _ip6Header = (struct ip6_hdr *)_ipPacket.bytes;
        
        u_int8_t next = _ip6Header->ip6_nxt;
        struct ip6_ext *extTest = (struct ip6_ext *)((void *)_ip6Header + APT_IPV6_FIXED_HEADER_LENGTH);
        u_int64_t extLen = 0;
        for (int i = 10; i > 0; i--) {
        
            switch (next) {
                case IPPROTO_HOPOPTS:
                case IPPROTO_DSTOPTS:
                case IPPROTO_ROUTING:
                case IPPROTO_FRAGMENT:
                case IPPROTO_AH:
                case IPPROTO_ESP:

                    extLen = extTest->ip6e_len * 8 + 8; // 64 bit + first 8 bytes
                    extTest = (struct ip6_ext *)(extTest + extLen);
                    next = extTest->ip6e_nxt;
                    break;
                    
                default:
                    i = 0;
                    
                    break;
            }
        }
        
        _ipHeaderLength = (void *)extTest - (void *)_ip6Header;
        
        _protocol = next;
        
#if DEBUG
        _ipId = [NSString stringWithFormat:@"%d",_ip6Header->ip6_flow];
#endif
        char addr[INET6_ADDRSTRLEN];

        // Note that routing header extention is ignored!
        // And destionation address may be wrong.
        // https://tools.ietf.org/html/rfc2460#section-4.4
        
        if (inet_ntop(AF_INET6, &(_ip6Header->ip6_dst),
                      addr, INET6_ADDRSTRLEN) == NULL) {
            return NO;
        }
        _dstAddress = [NSString stringWithUTF8String:addr];
        
        if (inet_ntop(AF_INET6, &(_ip6Header->ip6_src),
                      addr, INET6_ADDRSTRLEN) == NULL) {
            return NO;
        }
        _srcAddress = [NSString stringWithUTF8String:addr];
        
        return YES;
    }
    
    return NO;
}

- (BOOL)createWithAF:(NSNumber *)af protocol:(int)protocol{
    
    _aFamily = af;
    _protocol = protocol;
    
    int aFamily = [af intValue];
    
    if (aFamily == AF_INET) {
        
        _ipMPacket = [NSMutableData dataWithLength:APT_IPV4_HEADER_LENGTH];
        _ipHeaderLength = APT_IPV4_HEADER_LENGTH;
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        
        _ipHeader->ip_v = IPVERSION;
        _ipHeader->ip_hl = 5;
        
        _ipHeader->ip_id = 0;
#if DEBUG
        _ipId = @"0";
#endif
        _ipHeader->ip_len = htons(_ipHeaderLength);
        _ipHeader->ip_off = 0;
        _ipHeader->ip_ttl = 255; //seconds
        _ipHeader->ip_p = protocol;
        
        [self checksumIPv4];
        
        return YES;
    }
    else if (aFamily == AF_INET6){
        
        _ipMPacket = [NSMutableData dataWithLength:APT_IPV6_FIXED_HEADER_LENGTH];
        _ipHeaderLength = APT_IPV6_FIXED_HEADER_LENGTH;
        _ip6Header = (struct ip6_hdr *)_ipMPacket.mutableBytes;
        
        _ip6Header->ip6_vfc = IPV6_VERSION;
        
#if DEBUG
        _ipId = @"0";
#endif
        _ip6Header->ip6_plen = 0;
        _ip6Header->ip6_hops = 64;
        _ip6Header->ip6_nxt = protocol;
        
        return YES;
    }
    
    return NO;

}

- (void)checksumIPv4 {

    _ipHeader->ip_sum = 0;

    void *buffer = _ipMPacket.mutableBytes;
    int size = (int) _ipHeaderLength;

    uint32_t sum = checksum_adder(0, buffer, size);
    _ipHeader->ip_sum = checksum_finalize(sum);
}

@end


uint32_t checksum_adder(uint32_t sum, void *data, uint32_t len)
{
    uint16_t *buf = (uint16_t *)data;
    uint16_t *stop;
    
    if (len & 0x01) {
        --len;
#if BYTE_ORDER == BIG_ENDIAN
        sum += (((uint8_t *)data)[len]) << 8;
#else
        sum += ((uint8_t *)data)[len];
#endif
    }
    
    stop = (uint16_t *)(((uint8_t *)data) + len);
    
    while (buf < stop) {
        sum += *buf++;
    }
    return sum;
}

uint16_t checksum_finalize(uint32_t sum)
{
    while (sum >> 16) { /* a second carry is possible! */
        sum = (sum & 0x0000FFFF) + (sum >> 16);
    }
    return (uint16_t) ~sum; //htons((uint16_t) ~sum);
}
