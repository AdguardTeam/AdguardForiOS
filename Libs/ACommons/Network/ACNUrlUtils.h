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

#import <Foundation/Foundation.h>

#define ACNURL_SCHEME_HTTP          @"http"
#define ACNURL_SCHEME_HTTPS         @"https"

@class ACLURL;

@interface ACNUrlUtils : NSObject

/// Convert string to url parameter.
/// Escapes characters, which not allowed for url.
/// Method uses UTF8 encoding for input string
/// and also escapes ?/+= characters.
+ (NSString *)percentEncodeUrlParameter:(NSString *)parameter;

/**
 Create parameter string from dictionary.
 Parameters values is converted using percent escaping.
 
 @param xmlStrict   If YES then parameters are concatenated through '&amp;'
 */
+ (NSString *)createStringFromParameters:(NSDictionary *)parameters xmlStrict:(BOOL)xmlStrict;

/// Converts url string to NSURL object with escaping characters,
/// which not conforms.
+ (NSURL *)URLWithString:(NSString *)URLString;

/// Converts url string, relatively of base url string to NSURL object with escaping characters,
/// which not conforms.
+ (NSURL *)URLWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL;

/// Gets host name
+ (NSString *)host:(NSString *)url;

/// Gets port or default port for url scheme
+ (int16_t)port:(NSString *)url;

/// Gets port or default port for url scheme
+ (int16_t)portForUrl:(NSURL *)url;

/// Gets domain name from the url
+ (NSString *)domainNameFor:(NSString *)url cropWWW:(BOOL)cropWWW;

/// Checks "candidate" that it contains IPv4 address
+ (BOOL)isIPv4:(NSString *)candidate;

/// Checks "candidate" that it contains IPv6 address
/// @warning May work incorrectly because it taken from internet
+ (BOOL)isIPv6:(NSString *)candidate;

+ (BOOL) checkIpv6WithPort:(NSString*) candidate ip:(NSString**)ip port:(NSString**)port;

+ (BOOL) checkIpv4WithPort:(NSString*) candidate ip:(NSString**)ip port:(NSString**)port;

@end
