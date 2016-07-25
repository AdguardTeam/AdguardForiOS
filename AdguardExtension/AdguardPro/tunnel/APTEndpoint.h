//
//  APTEndpoint.h
//  Adguard
//
//  Created by Roman Sokolov on 09/07/16.
//  Copyright © 2016 Performiks. All rights reserved.
//

@import NetworkExtension;
@import Darwin.POSIX.netinet;

#include <arpa/inet.h>

@interface APTEndpoint : NSObject <NSCopying>

+ (instancetype)endpointWithHostEndpoint:(NWHostEndpoint *)hostEndpoint;
+ (instancetype) endpointWithHostname:(NSString *)hostname port:(NSString *)port;

@property (readonly, nonatomic) NWHostEndpoint *hostEndpoint;
@property (readonly, nonatomic) NSString *host;
@property (readonly, nonatomic) NSString *port;

@end
