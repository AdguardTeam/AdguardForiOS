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


- (void)setIpAddressesFromString:(NSString *)ipAddresses {

//    NSMutableArray *
    
    [self willChangeValueForKey:@"ipv4Addresses"];
    [self willChangeValueForKey:@"ipv6Addresses"];
    
    @synchronized (self) {

        
    }
    [self didChangeValueForKey:@"ipv6Addresses"];
    [self didChangeValueForKey:@"ipv4Addresses"];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

//- (NSString *)description
//{
//    return [self stringValue];
//}

//- (BOOL)isEqual:(id)object{
//
//    if (object == self)
//        return YES;
//    if ([object isKindOfClass:[self class]])
//        return YES;
//
//    else
//        return NO;
//}

//- (NSUInteger)hash
//{
//    return 0
//}


@end
