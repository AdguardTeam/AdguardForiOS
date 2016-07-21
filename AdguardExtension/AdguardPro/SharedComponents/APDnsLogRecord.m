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


#import "APDnsLogRecord.h"
#import "APDnsResponse.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsLogRecord

@implementation APDnsLogRecord{
    
    NSUInteger _hash;
    APDnsResponse *_preferredResponse;
    NSArray <APDnsResponse *> *_responses;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithID:(NSNumber *)ID srcPort:(NSString *)srcPort vpnMode:(NSNumber *)vpnMode{
    if (!(ID && srcPort)) {
        return nil;
    }
    
    self = [super init]; // [super _init_];
    if (self)
    {
        _recordDate = [NSDate date];
        _ID = ID;
        _srcPort = srcPort;
        _vpnMode = vpnMode;
        _hash = [srcPort longLongValue] * 100000 + [ID unsignedIntegerValue];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (NSArray <APDnsResponse *> *)responses{
    
    return _responses;
}

- (void)setResponses:(NSArray<APDnsResponse *> *)responses{
    
    _responses = responses;
    _preferredResponse = nil;
}

- (APDnsResponse *)preferredResponse{
    
    if (_preferredResponse) {
        return _preferredResponse;
    }
    
    if (_responses.count) {
        
        _preferredResponse = _responses[0];
        BOOL foundA = NO;
        for (APDnsResponse *item in _responses) {
            if (!foundA && item.addressResponse) {
                foundA = YES;
                _preferredResponse = item;
            }
            
            if (item.blocked) {
                _preferredResponse = item;
                break;
            }
        }
    }
    
    return _preferredResponse;
}

/////////////////////////////////////////////////////////////////////
#pragma mark NSCoding protocol

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super init];
    if (self) {
        
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _recordDate = [aDecoder decodeObjectForKey:@"recordDate"];
        _srcPort = [aDecoder decodeObjectForKey:@"srcPort"];
        _vpnMode = [aDecoder decodeObjectForKey:@"vpnMode"];
        _requests = [aDecoder decodeObjectForKey:@"requests"];
        _responses = [aDecoder decodeObjectForKey:@"responses"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.recordDate forKey:@"recordDate"];
    [aCoder encodeObject:self.srcPort forKey:@"srcPort"];
    [aCoder encodeObject:self.vpnMode forKey:@"vpnMode"];
    [aCoder encodeObject:self.requests forKey:@"requests"];
    [aCoder encodeObject:self.responses forKey:@"responses"];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

//- (NSString *)description
//{
//    return [self stringValue];
//}

- (BOOL)isEqual:(id)object {

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {

        if (self.hash == [object hash]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return _hash;
}


@end
