
#import "ACDnsUtils.h"

#include <resolv.h>
#include <arpa/inet.h>
#include <string.h>
#include <netdb.h>


@implementation ACDnsUtils

+ (NSArray<NSData*> *)ipv4AddressesForHostname:(NSString *)hostname {
    return [self addressesForHostname:hostname ipv6: NO];
}

+ (NSArray<NSData*> *)ipv6AddressesForHostname:(NSString *)hostname {
    return [self addressesForHostname:hostname ipv6: YES];
}

+ (NSArray<NSData*> *)addressesForHostname:(NSString *)hostname ipv6:(BOOL) ipv6
{
    const char* hostnameC = [hostname UTF8String];
    
    struct addrinfo hints, *res;
    struct sockaddr_in *s4;
    struct sockaddr_in6 *s6;
    int retval;
    NSMutableArray *result; //the array which will be return
    NSMutableArray *result4; //the array of IPv4, to order them at the end
    
    memset (&hints, 0, sizeof (struct addrinfo));
    hints.ai_family = ipv6 ? AF_INET6 : AF_INET;
    hints.ai_flags = AI_CANONNAME;
    
    retval = getaddrinfo(hostnameC, NULL, &hints, &res);
    if (retval == 0)
    {
        
        if (res->ai_canonname)
        {
            result = [NSMutableArray new];
        }
        else
        {
            //it means the DNS didn't know this host
            return nil;
        }
        result4= [NSMutableArray array];
        while (res) {
            switch (res->ai_family){
                case AF_INET6:
                    s6 = (struct sockaddr_in6 *)res->ai_addr;
                    [result addObject:[NSData dataWithBytes:(void *)&(s6->sin6_addr) length:16]];
                    break;
                    
                case AF_INET:
                    s4 = (struct sockaddr_in *)res->ai_addr;
                    
                    [result addObject:[NSData dataWithBytes:(void *)&(s4->sin_addr) length:4]];
                    break;
                default:
                    NSLog(@"Neither IPv4 nor IPv6!");
                    
            }
            
            res = res->ai_next;
        }
    }else{
        NSLog(@"no IP found");
        return nil;
    }
    
    return [result arrayByAddingObjectsFromArray:result4];
}

@end
