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



#import "APDnsRequest.h"
#import "APDnsResourceType.h"

@implementation APDnsRequest

- (id)initWithRR:(ns_rr)rr{

    self = [super init];
    if (self) {
     
        _name = [NSString stringWithUTF8String:ns_rr_name(rr)];
        _type = [APDnsResourceType type:ns_rr_type(rr)];

    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        
        _name = [aDecoder decodeObjectForKey:@"name"];
        NSNumber *type = [aDecoder decodeObjectForKey:@"type"];
        if (!type) {
            type = @(0);
        }
        _type = [APDnsResourceType type:[type intValue]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:@(self.type.intValue) forKey:@"type"];
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"host: %@, type: %@", self.name, self.type];
}
@end
