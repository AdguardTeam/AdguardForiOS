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

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNNetworking Constants
/////////////////////////////////////////////////////////////////////

#if TARGET_OS_IPHONE
#define ACN_DEFAULT_READ_TIMEOUT        10 //seconds
#else
#define ACN_DEFAULT_READ_TIMEOUT        60 //seconds
#endif


/**
 NSError domain for errors from ACNNetworking object.
 */
extern NSString * _Nonnull ACNNetworkingErrorDomain;

#define ACN_ERROR_BAD_REQUEST                           1

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNNetworking
/////////////////////////////////////////////////////////////////////

/**
 Various utilities for asynchronously downloading data on modern manner.
 (> OS X 10.9 / iOS 7)
 */

@protocol ACNNetworkingProtocol

/**
 Creates an HTTP GET request for the specified URL with default read timeout,
 then calls a handler upon completion.
 */
- (void)dataWithURL:(nonnull NSURL *)url
  completionHandler:(nullable void (^)(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error))completionHandler;

/**
 Creates an HTTP GET request for the specified URL with specified read timeout,
 then calls a handler upon completion.
 */
- (void)dataWithURL:(nonnull NSURL *)url timeoutInterval:(NSTimeInterval)timeoutInterval
  completionHandler:(nullable void (^)(NSData * _Nullable data,
                              NSURLResponse * _Nullable response,
                              NSError * _Nullable error))completionHandler;

/** Sends an HTTP request then calls a handler upon completion */
- (void)dataWithURLRequest: (nonnull NSURLRequest*)URLrequest
         completionHandler: (nonnull void (^)(NSData * _Nullable data,
                                              NSURLResponse * _Nullable response,
                                              NSError * _Nullable error))completionHandler;

@end

@interface ACNNetworking : NSObject<ACNNetworkingProtocol>

@end
