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

#define PACKED_STRUCT_DEF struct __attribute__((packed))

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

        if(![self createWithAF:af protocol:protocol])
            return nil;
    }
    
    return self;
    
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSString *)dstAddress{
    
    return _dstAddress;
}

- (void)setDstAddress:(NSString *)dstAddress {

    OSSpinLockLock(&_lock);
    int af = [_aFamily intValue];
    if (af == AF_INET) {

        [self repareMutable];

        if (inet_pton(AF_INET, [dstAddress cStringUsingEncoding:NSUTF8StringEncoding], &(_ipHeader->ip_dst)) == 1) {

            _dstAddress = dstAddress;
            [self checksumIPv4];
        }
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
    }
    OSSpinLockUnlock(&_lock);
}

- (NSString *)srcAddress{
    
    return _srcAddress;
}

- (void)setSrcAddress:(NSString *)srcAddress {

    OSSpinLockLock(&_lock);
    int af = [_aFamily intValue];
    if (af == AF_INET) {

        [self repareMutable];

        if (inet_pton(AF_INET, [srcAddress cStringUsingEncoding:NSUTF8StringEncoding], &(_ipHeader->ip_src)) == 1) {

            _srcAddress = srcAddress;
            [self checksumIPv4];
        }
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
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
    if (af == AF_INET) {

        [self repareMutable];
        
        [_ipMPacket replaceBytesInRange:NSMakeRange(_ipHeaderLength, (_ipMPacket.length - _ipHeaderLength)) withBytes:payload.bytes length:payload.length];
        
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        _ipHeader->ip_len = htons(_ipMPacket.length);
        
        [self checksumIPv4];
        
    } else if (af == AF_INET6) {
        //TODO: Not implemented yet
    }
    OSSpinLockUnlock(&_lock);
 
}

/////////////////////////////////////////////////////////////////////
#pragma mark Protected methods

- (void)repareMutable{
    if (!_ipMPacket) {
        _ipMPacket = [_ipPacket mutableCopy];
        _ipPacket = nil;
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
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
        
        _dstAddress = [NSString stringWithUTF8String:inet_ntoa(_ipHeader->ip_dst)];
        _srcAddress = [NSString stringWithUTF8String:inet_ntoa(_ipHeader->ip_src)];
        
        return YES;
    }
    else if (aFamily == AF_INET6){
        //TODO: Not implemented yet
    }
    
    return NO;
}

- (BOOL)createWithAF:(NSNumber *)af protocol:(int)protocol{
    
    _aFamily = af;
    
    int aFamily = [af intValue];
    
    if (aFamily == AF_INET) {
        
        _ipMPacket = [NSMutableData dataWithLength:20];
        _ipHeaderLength = 20;
        _ipHeader = (struct iphdr *)_ipMPacket.mutableBytes;
        
        _ipHeader->ip_v = IPVERSION;
        _ipHeader->ip_hl = 5;
        _ipHeader->ip_id = 0;
        _ipHeader->ip_len = htons(_ipHeaderLength);
        _ipHeader->ip_off = 0;
        _ipHeader->ip_ttl = 255; //seconds
        _ipHeader->ip_p = protocol;
        
        [self checksumIPv4];
        
        return YES;
    }
    else if (aFamily == AF_INET6){
        //TODO: Not implemented yet
    }
    
    return NO;

}

//TODO: checksum calculation was not tested.
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
