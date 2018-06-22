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

#import "ACNCidrRange.h"

#import "NSString+Utils.h"

@interface ACNCidrRange(){
    NSArray<NSNumber*>* address;
    NSArray<NSNumber*>* mask;
    int prefixLen;
}

@end

@implementation ACNCidrRange

- (instancetype)initWithAddress:(NSArray<NSNumber *> *)addr prefixLength:(int)prefixLength {
    
    self = [super init];
    if(self) {
        if (prefixLen < 0 || prefixLen > addr.count * 8) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid prefix length" userInfo:nil];
        }
        
        NSMutableArray<NSNumber*> *newAddress = [NSMutableArray<NSNumber*> new];
        NSMutableArray<NSNumber*> *newMask = [NSMutableArray<NSNumber*> new];
        
        for(int i = 0; i < addr.count; ++i){
            [newMask addObject:@(0)];
        }
        
        prefixLen = prefixLength;
        
        int prefixLenSignificantByte = (prefixLen - 1) / 8;
        for (int i = 0; i < prefixLenSignificantByte; i++) {
            newMask[i] = @(0xff);
        }
        
        if (prefixLenSignificantByte < 16) {
            int shift = 8 - (prefixLen - prefixLenSignificantByte * 8);
            newMask[prefixLenSignificantByte] = @((0xff << shift) & 0xff);
        }
        for (int i = 0; i < addr.count; i++) {
            [newAddress addObject: @([addr[i] intValue] & [newMask[i] intValue])];
        }
        
        address = [newAddress copy];
        mask = [newMask copy];
    }
    return self;
}

- (instancetype)initWithCidrString:(NSString *)cidrString {
    
    cidrString = [cidrString stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    NSArray<NSString*> *cidrParts = [cidrString componentsSeparatedByString:@"/"];
    Boolean hasPrefixLen = cidrParts.count > 1;
    NSString *addressString = cidrParts[0];
    
    NSArray<NSNumber*> *newAddress = [ACNCidrRange getAddressFromString:addressString];
    if (!newAddress) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid address format" userInfo:nil];
    }
    int prefixLen = hasPrefixLen ? [cidrParts[1] intValue] : (int)newAddress.count * 8;
    
    self = [self initWithAddress:newAddress.copy prefixLength: prefixLen];
    
    return self;
}

+ (NSArray<ACNCidrRange *> *)excludeFrom:(ACNCidrRange *) originalRange excludedRange: (ACNCidrRange *) excludedRange {
    
    return [self excludeFrom:@[originalRange] excludedRanges:@[excludedRange]];
}

+ (NSArray<ACNCidrRange *> *)excludeFrom:(NSArray<ACNCidrRange *> *)originalRanges excludedRanges:(NSArray<ACNCidrRange *> *)excludedRanges {
    
    NSMutableArray<ACNCidrRange *> *done = [NSMutableArray new];
    NSMutableArray<ACNCidrRange *> *stack = [[NSMutableArray alloc] initWithArray:originalRanges];
    [stack sortUsingSelector:@selector(compare:)];
    
    while (stack.count) {
        
        ACNCidrRange *range = stack.lastObject;
        [stack removeLastObject];
        Boolean split = NO;
        Boolean skip = NO;
        for (ACNCidrRange *excludedRange in excludedRanges) {
            
            if ([excludedRange contains:range]) {
                skip = YES;
                break;
            }
            if ([range contains:excludedRange]) {
                split = YES;
                break;
            }
        }
        if (skip) {
            continue;
        }
        if (split) {

            NSArray<ACNCidrRange*> *splittedRange = [range split];
            if (splittedRange != nil) {
                [stack addObject:splittedRange[1]];
                [stack addObject:splittedRange[0]];
            }
        } else {
            [done addObject:range];
        }
    }
    return [done copy];
}

- (NSString *)toString {
    
    return [NSString stringWithFormat:@"%@/%d", [self getAddressAsString], prefixLen];
}

- (NSArray<ACNCidrRange *> *)split {
    
    if (prefixLen == address.count * 8) {
        // Can't split single IP
        return nil;
    }
    
    int newPrefixLen = prefixLen + 1;
    NSMutableArray<NSNumber*> *addrLeft = [NSMutableArray new];
    NSMutableArray<NSNumber*> *addrRight = [NSMutableArray new];
    
    int prefixLenSignificantByte = (newPrefixLen - 1) / 8;
    
    for (int i = 0; i < address.count; i++) {
        [addrLeft addObject: address[i]];
        [addrRight addObject: address[i]];
        
        if (i == prefixLenSignificantByte) {
            int shift = 8 - (newPrefixLen - prefixLenSignificantByte * 8);
            
            addrRight[i] = [NSNumber numberWithInt: ([addrRight[i] intValue] | (0x1 << shift))];
        }
    }
    
    ACNCidrRange *cidrLeft = [[ACNCidrRange alloc] initWithAddress:addrLeft prefixLength:newPrefixLen];
    ACNCidrRange *cidrRight = [[ACNCidrRange alloc] initWithAddress:addrRight prefixLength:newPrefixLen];
    
    return @[cidrLeft, cidrRight];
}

- (Boolean)contains:(ACNCidrRange *)range {
    
    if (range->address.count != address.count) {
        return NO;
    }
    for (int i = 0; i < address.count; i++) {
        if ([mask[i] intValue] != ([range->mask[i] intValue] & [mask[i] intValue])) {
            return NO;
        }
        if (([address[i] intValue] & [mask[i] intValue]) != ([range->address[i] intValue] & [mask[i] intValue])) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isEqual:(id)object {
    
    if (!([object isKindOfClass: ACNCidrRange.class])) {
        return false;
    }
    ACNCidrRange *range = (ACNCidrRange*) object;
    if (range->address.count != address.count) {
        return NO;
    }
    if (range->prefixLen != prefixLen) {
        return NO;
    }
    for (int i = 0; i < address.count; i++) {
        if ([address[i] intValue] != [range->address[i] intValue]) {
            return false;
        }
    }
    return true;
}

- (NSComparisonResult)compare:(ACNCidrRange *)range {
    
    if (address.count != range->address.count) {
        return address.count < range->address.count ? NSOrderedAscending : NSOrderedDescending;
    }
    for (int i = 0; i < address.count; i++) {
        if (address[i] != range->address[i]) {
            return ([address[i] intValue] & 0xff) < ([range->address[i] intValue] & 0xff) ? NSOrderedAscending : NSOrderedDescending;
        }
    }
    return prefixLen < range->prefixLen ? NSOrderedAscending : NSOrderedDescending;
}

+ (NSArray<NSNumber*>*) getAddressFromString:(NSString*) addressString{
    
    if ([addressString containsString:@"."]) {
        
        if (![addressString containsString:@":"]) {
            return [self getIpv4AddressFromString: addressString];
        } else {
            NSUInteger lastIndex = [addressString rangeOfString:@":" options:NSBackwardsSearch].location;
            NSString *addressStringIPv4 = [addressString substringFromIndex:lastIndex + 1];
            NSArray<NSNumber*> *address = [self getIpv4AddressFromString:addressStringIPv4];
            NSString *addressStringPartBeforeIPv4 = [addressString substringToIndex:lastIndex + 1];

            NSString *ipv6AddressString = [addressStringPartBeforeIPv4 stringByAppendingString:[NSString stringWithFormat:@"%x:%x",
                                        (([address[0] intValue] & 0xff) << 8) + ([address[1] intValue] & 0xff),
                                        (([address[2] intValue] & 0xff) << 8) + ([address[3] intValue] & 0xff)]];
            
            return [self getIpv6AddressFromString: ipv6AddressString];
        }
    } else {
        return [self getIpv6AddressFromString:addressString];
    }
}

+ (NSArray<NSNumber*>*) getIpv4AddressFromString:(NSString*) addressString {
    
    NSMutableArray<NSNumber*> *address = [NSMutableArray new];
    NSArray<NSString*> *ipSec = [addressString componentsSeparatedByString:@"."];
    
    for (int k = 0; k < 4; k++) {
        @try{
            [address addObject: @([ipSec[k] intValue])];
        }
        @catch(NSException* exception){
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Can't parse IPv4 address" userInfo:nil];
        }
        
    }
    return [address copy];
}

+ (NSArray<NSNumber*>*) getIpv6AddressFromString:(NSString*) addressString {
    
    addressString = [self expandIPv6String: addressString];
    if ([addressString countOccurencesOfString:@":"] != 7) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Can't parse IPv6 address: bad colon count" userInfo:nil];
    }
    
    NSMutableArray<NSNumber*>* address = [NSMutableArray new];
    NSArray<NSString*>* ipSec = [addressString componentsSeparatedByString:@":"];
    for (int k = 0; k < 8; k++) {
        
        NSScanner* scanner = [NSScanner scannerWithString:ipSec[k]];
        unsigned int twoBytes;
        [scanner scanHexInt: &twoBytes];
        [address addObject: @((twoBytes >> 8) & 0xff)];
        [address addObject: @(twoBytes & 0xff)];
    }
    return address;
}

/**
  Utility method for expanding IPv6 address from short form
  @param addressString IPv6 address string (may be in short form)
  @return Expanded IPv6 address string
  @throws IllegalArgumentException If error is occurred
 */
+ (NSString*) expandIPv6String:(NSString*) addressString {
    
    NSRange fourDotsRange = [addressString rangeOfString:@"::"];
    if (fourDotsRange.length)
    {
        if (addressString.length == 2) {
            return [NSString repeat:@"0" separator:@":" repeat:8];
        }
        
        NSUInteger count = [addressString countOccurencesOfString:@":"];
        
        if (fourDotsRange.location == 0) {
            NSString *zeros = [NSString repeat:@"0" separator:@":" repeat:8 - count + 1];
            addressString = [zeros stringByAppendingString: [addressString substringFromIndex:1]];
        } else if (fourDotsRange.location == addressString.length - 2) {
            NSString * zeros = [NSString repeat:@"0" separator:@":" repeat: 8 - count + 1];
            addressString = [[addressString substringToIndex: fourDotsRange.location + 1] stringByAppendingString: zeros];
        } else {
            NSString * zeros = [NSString repeat:@"0" separator:@":" repeat: 8 - count];
            NSString* left = [addressString substringToIndex: fourDotsRange.location + 1];
            NSString* right = [addressString substringFromIndex:fourDotsRange.location + 1];
            
            addressString = [NSString stringWithFormat:@"%@%@%@", left, zeros, right];
        }
    }
    if ([addressString rangeOfString:@"::"].length) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Can't parse IPv6 address: ambiguous short address" userInfo:nil];
    }
    
    return addressString;
}

- (NSString*) getAddressAsString {
    
    if (address.count == 4) {
        return [NSString stringWithFormat:@"%d.%d.%d.%d",
                address[0].intValue,
                address[1].intValue,
                address[2].intValue,
                address[3].intValue];
    } else {
        return [ACNCidrRange shortenIPv6String: [NSString stringWithFormat: @"%x:%x:%x:%x:%x:%x:%x:%x",
                                                 (([address[0] intValue] & 0xff) << 8) + ([address[1] intValue] & 0xff),
                                                 (([address[2] intValue] & 0xff) << 8) + ([address[3] intValue] & 0xff),
                                                 (([address[4] intValue] & 0xff) << 8) + ([address[5] intValue] & 0xff),
                                                 (([address[6] intValue] & 0xff) << 8) + ([address[7] intValue] & 0xff),
                                                 (([address[8] intValue] & 0xff) << 8) + ([address[9] intValue] & 0xff),
                                                 (([address[10] intValue ]& 0xff) << 8) + ([address[11] intValue ] & 0xff),
                                                 (([address[12] intValue] & 0xff) << 8) + ([address[13] intValue] & 0xff),
                                                 (([address[14] intValue] & 0xff) << 8) + ([address[15] intValue] & 0xff)]];
    }
}

/**
  Utility method for converting IPv6 address string to short form
  @param addressString Address string
  @return Address string in short form
 */
+ (NSString*) shortenIPv6String:(NSString*) addressString {
    // Expand string
    addressString = [self expandIPv6String:addressString];
    
    // Find start and end of the series
    NSMutableArray<NSString*>* addressStringParts = [NSMutableArray arrayWithArray:[addressString componentsSeparatedByString:@":"]];
    
    for (int i = 0; i < 8; i++) {
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^0+(?!$)" options:NSRegularExpressionCaseInsensitive error:&error];
        addressStringParts[i] = [regex stringByReplacingMatchesInString:addressStringParts[i] options:0 range:NSMakeRange(0, [addressStringParts[i] length]) withTemplate:@""];
    }
    
    int seriesCandidate = 8;
    int seriesCandidateLen = 0;
    
    int maxSeriesStart = 8;
    int maxSeriesLen = 0;
    BOOL inSeries = NO;
    for (int i = 0; i < 8; ++i) {
        
        if ([addressStringParts[i] isEqualToString:@"0"]) {
            if(inSeries) {
                seriesCandidateLen++;
            }
            else{
                seriesCandidate = i;
                seriesCandidateLen = 1;
                inSeries = YES;
            }
        }
        else {
            if(inSeries) {
                inSeries = NO;
                if(seriesCandidateLen > maxSeriesLen){
                    maxSeriesStart = seriesCandidate;
                    maxSeriesLen = seriesCandidateLen;
                }
            }
        }
    }
    
    if(seriesCandidateLen > maxSeriesLen){
        maxSeriesStart = seriesCandidate;
        maxSeriesLen = seriesCandidateLen;
    }
    
    int startSeries = 8;
    int endSeries = 8;
    if(maxSeriesLen > 1) {
        startSeries = maxSeriesStart;
        endSeries = maxSeriesStart + maxSeriesLen - 1;
    }
    
    // Build result
    NSMutableArray<NSString*> *parts = [NSMutableArray new];
    [parts addObjectsFromArray:[addressStringParts subarrayWithRange:NSMakeRange(0, startSeries)]];
    
    if (startSeries < 8) {
        [parts addObject:@""];
    }
    if (endSeries < 8) {
        [parts addObjectsFromArray:[addressStringParts subarrayWithRange:NSMakeRange(endSeries + 1, 8 - (endSeries + 1))]];
    }
    
    NSMutableString *shortenString = [NSMutableString new];
    if(startSeries == 0)
        [shortenString appendString:@":"];
    
    [shortenString appendString:[parts componentsJoinedByString:@":"]];
    
    if(endSeries == 7)
        [shortenString appendString:@":"];
    
    return shortenString.copy;
}

@end
