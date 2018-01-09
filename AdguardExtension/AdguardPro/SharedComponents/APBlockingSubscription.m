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

#import "APBlockingSubscription.h"
#import "ACSSystemUtils.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APBlockingSubscription
@implementation APBlockingSubscription

- (instancetype)init {
    
    self = [super init];
    if(self) {
        self.uuid = [ACSSystemUtils createUUID];
    }
    
    return self;
}

- (void)setHosts:(NSDictionary<NSString *,NSString *> *)hosts {
    _hosts = hosts;
    self.rulesCount = self.rules.count + self.hosts.count;
}

- (void)setRules:(NSArray<NSString *> *)rules {
    _rules = rules;
    self.rulesCount = self.rules.count + self.hosts.count;
}

- (NSInteger)rulesCount {
    return self.hosts.count + self.rules.count;
}

- (instancetype)meta {
    
    APBlockingSubscription *meta = [[[self class] alloc] init];
    
    meta.uuid = self.uuid;
    meta.name = self.name;
    meta.subscriptionDescription = self.subscriptionDescription;
    meta.url = self.url;
    meta.rulesCount = self.rulesCount;

    return meta;
}

#pragma mark NSCoding protocol methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        @autoreleasepool {
            self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
            self.name = [aDecoder decodeObjectForKey:@"name"];
            self.subscriptionDescription = [aDecoder decodeObjectForKey:@"description"];
            self.url = [aDecoder decodeObjectForKey:@"url"];
            self.rules = [aDecoder decodeObjectForKey:@"rules"];
            self.hosts = [aDecoder decodeObjectForKey:@"hosts"];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    @autoreleasepool {
        [aCoder encodeObject:self.uuid forKey:@"uuid"];
        [aCoder encodeObject:self.name forKey:@"name"];
        [aCoder encodeObject:self.subscriptionDescription forKey:@"description"];
        [aCoder encodeObject:self.url forKey:@"url"];
        [aCoder encodeObject:self.rules forKey:@"rules"];
        [aCoder encodeObject:self.hosts forKey:@"hosts"];
    }
}

#pragma mark equal, hash

- (BOOL)isEqual:(id)object{
    
    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {
        
        if ([object hash] == [self hash]) {
            
            __typeof__(self) obj = object;
            if ([obj.uuid isEqualToString:self.uuid]) {
                
                return YES;
            }
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return [self.uuid hash];
}

@end
