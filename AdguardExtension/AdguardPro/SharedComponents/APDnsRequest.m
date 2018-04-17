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



#import "APDnsRequest.h"
#import "APDnsResourceType.h"
#import "APDnsResourceClass.h"

@implementation APDnsRequest

- (id)initWithRR:(ns_rr)rr{

    self = [super init];
    if (self) {
        uint16_t type = ns_rr_type(rr);
        _name = [NSString stringWithUTF8String:ns_rr_name(rr)];
        _type = [APDnsResourceType type:type];
        _qClass = [APDnsResourceClass class:ns_rr_class(rr)];
        
        [self setAddressRequestValue];
    }
    
    return self;
}

- (id)initWithName:(NSString *)name type:(APDnsResourceType *)type class:(APDnsResourceClass *)class {

    self = [super init];
    if (self) {
        
        _name = name;
        _type = type;
        _qClass = class;
        
        [self setAddressRequestValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        
        _name = [aDecoder decodeObjectForKey:@"name"];
        NSNumber *val = [aDecoder decodeObjectForKey:@"type"];
        if (!val) {
            val = @(0);
        }
        _type = [APDnsResourceType type:[val intValue]];
        
        val = [aDecoder decodeObjectForKey:@"addressRequest"];
        _addressRequest = [val boolValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:@(self.type.intValue) forKey:@"type"];
    [aCoder encodeObject:@(self.addressRequest) forKey:@"addressRequest"];
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"host: %@, type: %@", self.name, self.type];
}

- (id)copyWithZone:(NSZone *)zone {

    return [[APDnsRequest alloc] initWithName:_name type:_type class:_qClass];
}


- (void)setAddressRequestValue {
    
    int type = [_type intValue];
    if (type == ns_t_a || type == ns_t_aaaa || type == ns_t_a6) {
        _addressRequest = YES;
    }
    else{
        _addressRequest = NO;
    }

}

@end
