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

#import "APDnsServerObject.h"
#import "ACommons/ACNetwork.h"
#import "ACommons/ACSystem.h"

NSString *APDnsServerTagLocal = @"APDnsServerTagLocal";

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsServerObject

@implementation APDnsServerObject {
    
    NSString *_uuid;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

static NSMutableCharacterSet *delimCharSet;

+ (void)initialize {

    if (self == [APDnsServerObject class]) {
        
        delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
        [delimCharSet addCharactersInString:@","];
        
        [super initialize];
    }

}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        _serverName = [NSString new];
        _serverDescription = [NSString new];
        _ipv4Addresses = [NSArray new];
        _ipv6Addresses = [NSArray new];
        _editable = YES;
        _uuid = [ACSSystemUtils createUUID];
    }
    
    return self;
}

- (id)initWithUUID:(NSString *)uuid
              name:(NSString *)serverName
       description:(NSString *)serverDescription
       ipAddresses:(NSString *)ipAddresses {
    
    if (! (uuid && serverName && serverDescription && ipAddresses) ) {
        
        return nil;
    }
    
    self = [self init]; // [super _init_];
    if (self)
    {
        _uuid = uuid;
        _serverName = serverName;
        _serverDescription = serverDescription;
        
        [self setIpAddressesFromString:ipAddresses];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSString *)ipAddressesAsString {
    
    NSArray *ips = self.ipv4Addresses;
    
    NSMutableString* result = [NSMutableString new];
    
    for (APDnsServerAddress* ipv4 in ips) {
        
        if(ipv4.port) {
            [result appendFormat:@"%@:%@\n", ipv4.ip, ipv4.port];
        }
        else {
            [result appendFormat:@"%@\n", ipv4.ip];
        }
    }
    
    ips = self.ipv6Addresses;
    
    for (APDnsServerAddress* ipv6 in ips) {
        
        if(ipv6.port) {
            [result appendFormat:@"[%@]:%@\n", ipv6.ip, ipv6.port];
        }
        else {
            [result appendFormat:@"%@\n", ipv6.ip];
        }
    }
    
    return [result copy];
}

- (void)setIpAddressesFromString:(NSString *)ipAddresses {

    NSArray *parts = [ipAddresses componentsSeparatedByCharactersInSet:delimCharSet];
    
    NSMutableArray *ipV4 = [NSMutableArray array];
    NSMutableArray *ipV6 = [NSMutableArray array];
    
    for (NSString *item in parts) {
        
        NSString *candidate = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (candidate.length) {
            
            NSString* ip;
            NSString* port;
            
            if ([ACNUrlUtils isIPv4:candidate]) {
                [ipV4 addObject:[[APDnsServerAddress alloc] initWithIp:candidate port:nil]];
            }
            else if ([ACNUrlUtils isIPv6:candidate]){
                [ipV6 addObject:[[APDnsServerAddress alloc] initWithIp:candidate port:nil]];
            }
            else if ([ACNUrlUtils checkIpv4WithPort:candidate ip:&ip port:&port]) {
                [ipV4 addObject:[[APDnsServerAddress alloc] initWithIp:ip port:port]];
            }
            else if ([ACNUrlUtils checkIpv6WithPort:candidate ip:&ip port:&port]) {
                [ipV6 addObject:[[APDnsServerAddress alloc] initWithIp:ip port:port]];
            }
        }
    }
    
    self.ipv4Addresses = [ipV4 copy];
    self.ipv6Addresses = [ipV6 copy];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:@(_editable) forKey:@"editable"];
    [aCoder encodeObject:_uuid forKey:@"uuid"];

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {

        _editable = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"editable"] boolValue];
        _uuid = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"uuid"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    
    APDnsServerObject *result = [super copyWithZone:zone];
    result.editable = self.editable;
    result->_uuid = [_uuid copyWithZone:zone];
    
    return result;
}

- (void)setIpv4Addresses:(NSArray<APDnsServerAddress *> *)ipv4Addresses {
    _ipv4Addresses = [self migrateIpsIfNeeded:ipv4Addresses];
}

- (void)setIpv6Addresses:(NSArray<APDnsServerAddress *> *)ipv6Addresses {
    _ipv6Addresses = [self migrateIpsIfNeeded:ipv6Addresses];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

- (NSString *)description
{
    return [NSString stringWithFormat:@"[UUID: %@ serverName: \"%@\"\nserverDescription: \"%@\"\nips:\n%@]", _uuid, self.serverName, self.serverDescription, [self ipAddressesAsString]];
}

- (BOOL)isEqual:(id)object{

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {
        
        if ([object hash] == [self hash]) {
            
            __typeof__(self) obj = object;
            if ([obj->_uuid isEqualToString:_uuid]) {
                
                return YES;
            }
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return [_uuid hash];
}

/////////////////////////////////////////////////////////////////////
#pragma mark private methods

- (NSArray*) migrateIpsIfNeeded:(NSArray*) ips {
   
    // In older versions of the application NSString arrays were used, rather than arrays of APDnsServerAddress objects
    if(!ips.count || [ips.firstObject isKindOfClass:[APDnsServerAddress class]])
        return ips;
    
    NSMutableArray* migrated = [NSMutableArray array];
    
    for(NSString* ip in ips) {
        [migrated addObject:[[APDnsServerAddress alloc] initWithIp:ip port:nil]];
    }
    
    return [migrated copy];
}


@end
