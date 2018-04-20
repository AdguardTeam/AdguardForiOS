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


#import "APDnsResourceClass.h"

@implementation APDnsResourceClass

static NSDictionary *_classes;

+ (void)initialize{
    
    if (self == [APDnsResourceClass class]) {
        
       _classes = @{
                   @(0) : @{@"name" : @"INVALID", @"descr" : @"Cookie."},
                   @(1) : @{@"name" : @"IN", @"descr" : @"Internet."},
                   @(3) : @{@"name" : @"CHAOS", @"descr" : @"MIT Chaos-net."},
                   @(4) : @{@"name" : @"HS", @"descr" : @"MIT Hesiod."},
                   /* Query class values which do not appear in resource records */
                   @(254) : @{@"name" : @"NONE", @"descr" : @"None - for prereq. sections in update requests."},
                   @(255) : @{@"name" : @"ANY", @"descr" : @"Wildcard match."},
                   @(65536) : @{@"name" : @"MAX", @"descr" : @"Max value."}
                   };
    }
}

+ (APDnsResourceClass *)class:(uint16_t)value{
    
    APDnsResourceClass *theClass = [APDnsResourceClass new];
    theClass.intValue = value;
    
    return theClass;
}

+ (APDnsResourceClass *)internetClass{
    
    return [APDnsResourceClass class:1];
}


- (NSString *)description{
    
    return _classes[@(self.intValue)][@"name"];
}

- (NSString *)humanReadable{
    
    return _classes[@(self.intValue)][@"descr"];
}

@end
