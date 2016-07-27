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


@import Foundation;
@import Darwin.libkern;

#include <netinet/ip.h>
#include <arpa/inet.h>

/*
 * Structure of an internet header, naked of options.
 */
#pragma pack(push,1)
struct iphdr {
#if BYTE_ORDER == LITTLE_ENDIAN
    u_int	ip_hl:4,		/* header length */
ip_v:4;			/* version */
#endif
#if BYTE_ORDER == BIG_ENDIAN
    u_int	ip_v:4,			/* version */
ip_hl:4;		/* header length */
#endif
    uint8_t	ip_tos;			/* type of service */
    uint16_t	ip_len;			/* total length */
    uint16_t	ip_id;			/* identification */
    uint16_t	ip_off;			/* fragment offset field */
    uint8_t	ip_ttl;			/* time to live */
    uint8_t	ip_p;			/* protocol */
    uint16_t	ip_sum;			/* checksum */
    struct	in_addr ip_src;
    struct	in_addr ip_dst;	/* source and dest address */
};
#pragma pack(pop)

uint32_t checksum_adder(uint32_t sum, void *data, uint32_t len);
uint16_t checksum_finalize(uint32_t sum);


@interface APIPPacket : NSObject {

    @protected
    NSString *_dstAddress;
    NSString *_srcAddress;
    NSData *_ipPacket;
    NSMutableData *_ipMPacket;
    struct iphdr *_ipHeader;
    NSUInteger _ipHeaderLength;
    
    OSSpinLock _lock;
}

- (id)initWithData:(NSData *)data af:(NSNumber *)af;
- (id)initWithAF:(NSNumber *)af protocol:(int)protocol;


@property (readonly, nonatomic) NSData *packet;
@property (readonly, nonatomic) NSNumber *aFamily;
@property (readonly, nonatomic) int protocol;

#if DEBUG
@property (readonly, nonatomic) NSString *ipId;
#endif

@property NSData *payload;
@property NSString *srcAddress;
@property NSString *dstAddress;

@end
