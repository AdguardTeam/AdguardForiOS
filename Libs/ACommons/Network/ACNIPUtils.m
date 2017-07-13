//##implementation

/**
 This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
 Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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


#import "ACNIPUtils.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <net/if.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNIPUtils

@implementation ACNIPUtils

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods


+ (BOOL) isIpv6Available {
    __block BOOL ipv6Available = NO;
    
    [self enumerateNetorkInterfacesWithProcessingBlock:^(struct ifaddrs *addr, BOOL *stop) {
        NSString* address;
        if(addr->ifa_addr->sa_family == AF_INET6){
            char ip[INET6_ADDRSTRLEN];
            const char *str = inet_ntop(AF_INET6, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), ip, INET6_ADDRSTRLEN);
            
            address = [NSString stringWithUTF8String:str];
            NSArray* addressComponents = [address componentsSeparatedByString:@":"];
            if(![addressComponents.firstObject isEqualToString:@"fe80"]){ // fe80 prefix in link-local ip
                ipv6Available = YES;
                *stop = YES;
            }
        }
    }];
    
    return ipv6Available;
}

+ (BOOL) isIpv4Available {
    __block BOOL ipv4Available = NO;
    
    [self enumerateNetorkInterfacesWithProcessingBlock:^(struct ifaddrs *addr, BOOL *stop) {
        if(addr->ifa_addr->sa_family == AF_INET){
            ipv4Available = YES;
            *stop = YES;
        }
    }];
    
    return ipv4Available;
}

+ (void) enumerateNetorkInterfacesWithProcessingBlock:(void (^)(struct ifaddrs *addr, BOOL *stop))processingBlock {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        addr = interfaces;
        BOOL stop = NO;
        
        while(addr != NULL && !stop) {
            
            int32_t flags = addr->ifa_flags;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                processingBlock(addr, &stop);
            }
            
            addr = addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
}


@end
