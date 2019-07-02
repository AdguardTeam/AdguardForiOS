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

#import <Foundation/Foundation.h>

#define ACNURL_SCHEME_HTTP          @"http"
#define ACNURL_SCHEME_HTTPS         @"https"

@class ACLURL;

@interface ACNUrlUtils : NSObject

/// Convert string to url parameter.
/// Escapes characters, which not allowed for url.
/// Method uses UTF8 encoding for input string
/// and also escapes ?/+= characters.
+ (nonnull NSString *)percentEncodeUrlParameter:(nonnull NSString *)parameter;

/**
 Create parameter string from dictionary.
 Parameters values is converted using percent escaping.
 
 @param xmlStrict   If YES then parameters are concatenated through '&amp;'
 */
+ (nonnull NSString *)createStringFromParameters:(nonnull NSDictionary *)parameters xmlStrict:(BOOL)xmlStrict;

/**
 Creates parameter dictionary from query string.
 */
+ (nonnull NSDictionary<NSString*, NSString*> *)parametersFromQueryString:(nonnull NSString*) query;

/// Converts url string to NSURL object with escaping characters,
/// which not conforms.
+ (nullable NSURL *)URLWithString:(nonnull NSString *)URLString;

/// Converts url string, relatively of base url string to NSURL object with escaping characters,
/// which not conforms.
+ (nullable NSURL *)URLWithString:(nonnull NSString *)URLString relativeToURL:(nonnull NSURL *)baseURL;

/// Gets host name
+ (nullable NSString *)host:(nonnull NSString *)url;

/// Gets port or default port for url scheme
+ (int16_t)port:(nonnull NSString *)url;

/// Gets port or default port for url scheme
+ (int16_t)portForUrl:(nonnull NSURL *)url;

/// Gets domain name from the url
+ (nullable NSString *)domainNameFor:(nonnull NSString *)url cropWWW:(BOOL)cropWWW;

/// Checks "candidate" that it contains IPv4 address
+ (BOOL)isIPv4:(nonnull NSString *)candidate;

/// Checks "candidate" that it contains IPv6 address
/// @warning May work incorrectly because it taken from internet
+ (BOOL)isIPv6:(nonnull NSString *)candidate;

+ (BOOL) checkIpv6WithPort:(nonnull NSString*) candidate ip:(NSString *  _Nonnull * _Nullable)ip port: (NSString *  _Nonnull * _Nullable)port;

+ (BOOL) checkIpv4WithPort:(nonnull NSString*) candidate ip:(NSString *  _Nonnull * _Nullable)ip port:(NSString *  _Nonnull * _Nullable)port;

+ (BOOL) checkHostsLine:(nonnull NSString*) candidate ip:(NSString *  _Nonnull * _Nullable)ip domain:(NSString *  _Nonnull * _Nullable)domain;

+ (BOOL) isValidIpWithPort:(nonnull NSString*) candidate;

+ (BOOL) isValidUrl:(nonnull NSString*)candidate;

+ (nonnull NSString*) ipv4StringFromIP:(uint32_t)ip;

@end
