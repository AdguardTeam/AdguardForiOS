//##implementation

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


#import "ACNIPUtils.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>
#include <net/if.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNIPUtils

@implementation ACNIPUtils

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods


+ (BOOL) isIpv6Available {
    __block BOOL ipv6Available = NO;
    
    [self enumerateNetworkInterfacesWithProcessingBlock:^(struct ifaddrs *addr, BOOL *stop) {
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
    
    [self enumerateNetworkInterfacesWithProcessingBlock:^(struct ifaddrs *addr, BOOL *stop) {
        if(addr->ifa_addr->sa_family == AF_INET){
            ipv4Available = YES;
            *stop = YES;
        }
    }];
    
    return ipv4Available;
}

+ (void) enumerateNetworkInterfacesWithProcessingBlock:(void (^)(struct ifaddrs *addr, BOOL *stop))processingBlock {
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

+ (void)enumerateSystemDnsWithProcessingBlock:(void (^)(NSString *, NSString *, BOOL, BOOL *))processingBlock {
    
    @autoreleasepool {
        
        res_state res = malloc(sizeof(struct __res_state));
        int result = res_ninit(res);
        if (result == 0) {
            union res_9_sockaddr_union *addr_union = malloc(res->nscount * sizeof(union res_9_sockaddr_union));
            res_getservers(res, addr_union, res->nscount);
            
            const char *ipStr;
            for (int i = 0; i < res->nscount; i++) {
                if (addr_union[i].sin.sin_family == AF_INET) {
                    char ip[INET_ADDRSTRLEN];
                    ipStr = inet_ntop(AF_INET, &(addr_union[i].sin.sin_addr), ip, INET_ADDRSTRLEN);
                    NSString* ipStringObject = ipStr ?[NSString stringWithUTF8String:ipStr] : nil;
                    
                    int port = (int)ntohs(addr_union[i].sin.sin_port);
                    NSString* portStringObject = port ? [NSString stringWithFormat:@"%d", port] : nil;
                    
                    if (ipStr) {
                        BOOL stop;
                        processingBlock(ipStringObject, portStringObject, YES, &stop);
                        if (stop) break;
                    }
                } else if (addr_union[i].sin6.sin6_family == AF_INET6) {
                    char ip[INET6_ADDRSTRLEN];
                    ipStr = inet_ntop(AF_INET6, &(addr_union[i].sin6.sin6_addr), ip, INET6_ADDRSTRLEN);
                    NSString* ipStringObject = ipStr ?[NSString stringWithUTF8String:ipStr] : nil;
                    
                    int port = (int) ntohs(addr_union[i].sin6.sin6_port);
                    NSString* portStringObject = port ? [NSString stringWithFormat:@"%d", port] : nil;
                    
                    if (ipStr) {
                        BOOL stop = NO;
                        processingBlock(ipStringObject, portStringObject, NO, &stop);
                        if (stop) break;
                    }
                } else {
                    ipStr = NULL;
                }
            }
        }
        res_nclose(res);
        free(res);
    }
    
    return;
}

+ (NSData *)ipv4StringToData:(NSString *)ipv4String {
    
    struct    in_addr addr;
    
    if(!inet_pton(AF_INET, [ipv4String UTF8String], &addr)) {
        return nil;
    }
    
    return [NSData dataWithBytes:&(addr.s_addr) length:4];
}

+ (NSData *)ipv6StringToData:(NSString *)ipv6String {
    
    struct    in6_addr addr;
    
    if(!inet_pton(AF_INET6, [ipv6String UTF8String], &addr)) {
        return nil;
    }
    
    return [NSData dataWithBytes:&(addr) length:16];
}

+ (NSString *)ipv6DataToString:(NSData *)ipv6Data {
    char buf [64];
    if(!inet_ntop(AF_INET6, ipv6Data.bytes, buf, 64)) {
        return nil;
    }
    
    return [NSString stringWithCString:buf encoding:kCFStringEncodingUTF8];
}

+ (NSString *)ipv4DataToString:(NSData *)ipv4Data {
    char buf [64];
    if(!inet_ntop(AF_INET6, ipv4Data.bytes, buf, 64)) {
        return nil;
    }
    
    return [NSString stringWithCString:buf encoding:kCFStringEncodingUTF8];
}


@end
