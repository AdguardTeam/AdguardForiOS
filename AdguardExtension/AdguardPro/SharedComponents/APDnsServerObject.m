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

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsServerObject

@implementation APDnsServerObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

static NSMutableCharacterSet *delimCharSet;

+ (void)initialize {

    if (self == [APDnsServerObject class]) {
        
        delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
        [delimCharSet addCharactersInString:@","];
    }

}

- (id)init {
    
    self = [super init];
    if (self) {
        
        _serverName = [NSString new];
        _serverDescription = [NSString new];
        _ipv4Addresses = [NSArray new];
        _ipv6Addresses = [NSArray new];
    }
    
    return self;
}

- (id)initWithName:(NSString *)serverName
       description:(NSString *)serverDescription
       ipAddresses:(NSString *)ipAddresses {
    
    if (! (serverName && serverDescription && ipAddresses) ) {
        
        return nil;
    }
    
    self = [super init]; // [super _init_];
    if (self)
    {
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
    NSString *result = [ips componentsJoinedByString:@"\n"];
    
    ips = self.ipv6Addresses;
    if (ips.count) {
        if (result.length) {
            result = [NSString stringWithFormat:@"%@\n%@", result,
                      [ips componentsJoinedByString:@"\n"]];
        }
        else {
            result = [ips componentsJoinedByString:@"\n"];
        }
    }
    
    return result;
}

- (void)setIpAddressesFromString:(NSString *)ipAddresses {

    NSArray *parts = [ipAddresses componentsSeparatedByCharactersInSet:delimCharSet];
    
    NSMutableArray *ipV4 = [NSMutableArray array];
    NSMutableArray *ipV6 = [NSMutableArray array];
    for (NSString *item in parts) {
        
        NSString *candidate = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (candidate.length) {
            if ([ACNUrlUtils isIPv4:candidate]) {
                [ipV4 addObject:candidate];
            }
            else if ([ACNUrlUtils isIPv6:candidate]){
                [ipV6 addObject:candidate];
            }
        }
    }
    
    self.ipv4Addresses = [ipV4 copy];
    self.ipv6Addresses = [ipV6  copy];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

- (NSString *)description
{
    return [NSString stringWithFormat:@"[serverName: \"%@\"\nserverDescription: \"%@\"\nips:\n%@]", self.serverName, self.serverDescription, [self ipAddressesAsString]];
}

- (BOOL)isEqual:(id)object{

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {
        
        if ([object hash] == [self hash]) {
            
            if ([[object serverName] isEqualToString:self.serverName]) {
                
                return YES;
            }
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.serverName hash];
}


@end
