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

#import "ACNUrlUtils.h"
#import "ACLang.h"

@interface ACNUrlUtils()

@end

@implementation ACNUrlUtils

static NSMutableCharacterSet *urlAllowedCharset;
static NSMutableCharacterSet *urlQueryParameterAllowedCharset;

+ (void)initialize {
    
    if (self == [ACNUrlUtils class]) {
        
        urlAllowedCharset = [NSMutableCharacterSet new];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [urlAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        [urlAllowedCharset addCharactersInString:@"#"];
        
        urlQueryParameterAllowedCharset = [NSMutableCharacterSet new];
        [urlQueryParameterAllowedCharset formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urlQueryParameterAllowedCharset  removeCharactersInString:@"?/+=&"];
    }
}

+ (NSStringEncoding)defaultUrlEscapeEncoding{

    return NSUTF8StringEncoding;
}

+ (NSString *)percentEncodeUrlParameter:(NSString *)parameter{

    return [parameter stringByAddingPercentEncodingWithAllowedCharacters:urlQueryParameterAllowedCharset];
}

+ (NSString *)createStringFromParameters:(NSDictionary *)parameters xmlStrict:(BOOL)xmlStrict {
    
    NSMutableArray *parametersArray = [NSMutableArray arrayWithCapacity:parameters.count];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", [key description], [ACNUrlUtils percentEncodeUrlParameter:[obj description]]]];
    }];
    
    if (xmlStrict) {
        // NOTE: &amp; - is a necessary parameter see: https://github.com/AdguardTeam/AdguardForMac/issues/162 for more info
        return [parametersArray componentsJoinedByString:@"&amp;"];
    }
    
    return [parametersArray componentsJoinedByString:@"&"];
    
}

/// Gets host name
+ (NSString *)host:(NSString *)url {
    if ([NSString isNullOrEmpty:url])
        return nil;

    NSInteger firstIdx = [url indexOf:@"//"];
    if (firstIdx == -1) {
        return nil;
    }
    firstIdx += 2;
    NSInteger nextSlashIdx = [url indexOf:@"/" fromIndex:firstIdx];
    NSInteger startParamsIdx = [url indexOf:@"?" fromIndex:firstIdx];
    NSInteger sharpIdx = [url indexOf:@"#" fromIndex:firstIdx];
    NSInteger colonIdx = [url indexOf:@":" fromIndex:firstIdx];

    NSInteger lastIdx = nextSlashIdx;
    if (startParamsIdx > 0 &&
        (startParamsIdx < nextSlashIdx || lastIdx == -1)) {
        lastIdx = startParamsIdx;
    }

    if (sharpIdx > 0 && (sharpIdx < lastIdx || lastIdx == -1)) {
        lastIdx = sharpIdx;
    }
    if (colonIdx > 0 && (colonIdx < lastIdx || lastIdx == -1)) {
        lastIdx = colonIdx;
    }

    return (lastIdx == -1
                ? [url substringFromIndex:firstIdx]
                : [url substringWithRange:NSMakeRange(firstIdx,
                                                      (lastIdx - firstIdx))]);

    //    NSURL *nsUrl = [NSURL URLWithString:[url
    //    stringByAddingPercentEscapesUsingEncoding:[ACNUrlUtils
    //    defaultUrlEscapeEncoding]]];
    //    return [nsUrl host];
}

/// Gets port or default port for url scheme
+ (int16_t)port:(NSString *)url{
    
    if (!url)
        return 80;

    NSURL *uri = [self URLWithString:url];
    
    return [ACNUrlUtils portForUrl:uri];
}

/// Gets port or default port for url scheme
+ (int16_t)portForUrl:(NSURL *)url{

    NSNumber *port = [url port];
    if (port && [port intValue] > 0) {
        
        return [port intValue];
    }
    
    if ([url.scheme isEqualToString:@"https"])
        return 443;
    
    return 80;
}

/// Checks "candidate" that it contains IPv4 address
+ (BOOL)isIPv4:(NSString *)candidate
{
    NSString *regex = @"^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    
    return [test evaluateWithObject:candidate];
}

/// Checks "candidate" that it contains IPv6 address
/// @warning May work incorrectly because it taken from internet
+ (BOOL)isIPv6:(NSString *)candidate
{
    /*
     fe80:0000:0000:0000:0204:61ff:fe9d:f156        // full form of IPv6
     fe80:0:0:0:204:61ff:fe9d:f156                  // drop leading zeroes
     fe80::204:61ff:fe9d:f156                       // collapse multiple zeroes to :: in the IPv6 address
     fe80:0000:0000:0000:0204:61ff:254.157.241.86   // IPv4 dotted quad at the end
     fe80:0:0:0:0204:61ff:254.157.241.86            // drop leading zeroes, IPv4 dotted quad at the end
     fe80::204:61ff:254.157.241.86                  // dotted quad at the end, multiple zeroes collapsed
     
     In addition, the regular expression matches these IPv6 forms:
     
     ::1        // localhost
     fe80::     // link-local prefix
     2001::     // global unicast prefix
     */
    
    NSString *regex = @"^\\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)(\\.(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)){3}))|:)))\\s*$";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    
    return [test evaluateWithObject:candidate];
}

+ (BOOL) checkIpv6WithPort:(NSString*) candidate ip:(NSString**)ip port:(NSString**)port {
    
    return [self checkIpvWithPort:candidate ip:ip port:port ipv6:YES];
}

+ (BOOL) checkIpv4WithPort:(NSString*) candidate ip:(NSString**)ip port:(NSString**)port {
    
    return [self checkIpvWithPort:candidate ip:ip port:port ipv6:NO];
}

+ (BOOL) checkIpvWithPort:(NSString*) candidate ip:(NSString**)ip port:(NSString**)port ipv6:(BOOL)ipv6 {
    
    NSString* regexString = ipv6 ? @"^\\[(.*)\\]:(\\d+)$" :  @"^([0-9.]*):(\\d+)$";
    
    NSError *regexError;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    NSArray* results = [regex matchesInString:candidate options:0 range:NSMakeRange(0, candidate.length)];
    
    if(results.count != 1)
        return NO;
    
    NSTextCheckingResult *match = results.firstObject;
    
    if([match numberOfRanges] != 3)
        return NO;
    
    NSRange ipRange = [match rangeAtIndex:1];
    NSRange portRange = [match rangeAtIndex:2];
    
    NSString* ipCandidate = [candidate substringWithRange:ipRange];
    NSString* portCandidate = [candidate substringWithRange:portRange];
    
    BOOL validIp = ipv6 ? [self isIPv6:ipCandidate] : [self isIPv4:ipCandidate];
    if(validIp) {
        *ip = ipCandidate;
        *port = portCandidate;
        
        return YES;
    }
    
    return NO;
}

/// Gets domain name from the url
+ (NSString *)domainNameFor:(NSString *)url cropWWW:(BOOL)cropWWW
{
    NSString *host = [ACNUrlUtils host:url];
    
    if (!cropWWW)
        return host;
    
    return [host hasPrefix:@"www."] ? [host substringFromIndex:4] : host;
}


+ (NSURL *)URLWithString:(NSString *)URLString{
    
    return [NSURL URLWithString:[ACNUrlUtils rightUrlEscaping:URLString]];
}

+ (NSURL *)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL{
    
    return [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:urlAllowedCharset] relativeToURL:baseURL];
}

+ (BOOL)isDomain:(NSString*) candidate {
    
    NSString *regex = @"^(((?!-))(xn--)?[a-z0-9-_]{0,61}[a-z0-9]{1,1}\\.)*(xn--)?([a-z0-9\\-]{1,61}|[a-z0-9-]{1,30}\\.[a-z]{2,})$";
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", regex];
    
    return [test evaluateWithObject:candidate];
}

+ (BOOL)checkHostsLine:(NSString *)candidate ip:(NSString *__autoreleasing *)ip domain:(NSString *__autoreleasing *)domain {
    
    NSArray* parts = [candidate componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(parts.count != 2)
        return NO;
    
    if (![self isIPv4:parts[0]] && ![self isIPv6:parts[0]])
        return NO;
    
    if(![self isDomain:parts[1]])
        return NO;
    
    *ip = parts[0];
    *domain = parts[1];
    
    return YES;
}

+ (BOOL)isValidUrl:(NSString *)candidate {
    
    NSURL* url = [NSURL URLWithString:candidate];
    
    return (url && url.scheme && url.host);
}

#pragma mark - Private Methods

+ (NSString *)rightUrlEscaping:(NSString *)urlString{
    
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:urlAllowedCharset];
}

+(NSString *)ipv4StringFromIP:(uint32_t)ip {
    
    NSString *ipString = [NSString stringWithFormat:@"%u.%u.%u.%u",
                          ((ip >> 24) & 0xFF),
                          ((ip >> 16) & 0xFF),
                          ((ip >> 8) & 0xFF),
                          ((ip >> 0) & 0xFF)];
    
    return ipString;
}

@end
