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
#include <sys/types.h>		/* uint16_t */

/*
 * Udp protocol header.
 * Per RFC 768, September, 1981.
 */
#pragma pack(push,1)
struct udphdr {
    uint16_t	uh_sport;		/* source port */
    uint16_t	uh_dport;		/* destination port */
    uint16_t	uh_ulen;		/* udp length */
    uint16_t	uh_sum;			/* udp checksum */
};
#pragma pack(pop)


@interface APUDPPacket : APIPPacket

- (id)initWithAF:(NSNumber *)af;

@property NSString *srcPort;
@property NSString *dstPort;

@end
