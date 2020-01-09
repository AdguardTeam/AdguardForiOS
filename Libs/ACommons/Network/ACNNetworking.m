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
#import "ACNNetworking.h"
#import "ACLang.h"

NSString *ACNNetworkingErrorDomain = @"ACNNetworkingErrorDomain";


#define CACHE_NAME          @"/ANCNetworkingCache"

/////////////////////////////////////////////////////////////////////
#pragma mark - ACNNetworking
/////////////////////////////////////////////////////////////////////

@interface ACNNetworking() {

    NSURLSessionConfiguration *_defaultConfigObject;
    NSURLSession *_defaultSession;
}

@end

@implementation ACNNetworking

- (instancetype)init{
    
    if (self = [super init]) {
        
        _defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        /* Configure caching behavior for the default session.
         Note that iOS requires the cache path to be a path relative
         to the ~/Library/Caches directory, but OS X expects an
         absolute path.
         */
#if TARGET_OS_IPHONE
        
        NSArray *myPathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *myPath    = [myPathList  objectAtIndex:0];
        
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        NSString *cachePath = [[myPath stringByAppendingPathComponent:bundleIdentifier] stringByAppendingPathComponent:CACHE_NAME];
        DDLogDebug(@"(ANCNetworking) Cache path: %@", cachePath);
#else
        NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:CACHE_NAME];
        
        DDLogDebug(@"(ANCNetworking) Cache path: %@", cachePath);
#endif
        
        NSURLCache *myCache = [[NSURLCache alloc] initWithMemoryCapacity: 16384 diskCapacity: 10000000 diskPath: cachePath];
        _defaultConfigObject.URLCache = myCache;
        _defaultConfigObject.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        /* Create a session. */
        _defaultSession = [NSURLSession sessionWithConfiguration: _defaultConfigObject delegate:nil delegateQueue:nil] ;
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Class methods
/////////////////////////////////////////////////////////////////////

- (void)dataWithURL:(NSURL *)url timeoutInterval:(NSTimeInterval)timeoutInterval
      completionHandler:(void (^)(NSData *data,
                                  NSURLResponse *response,
                                  NSError *error))completionHandler{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
    
    if (!request) {
        NSOperationQueue *queue = [_defaultSession delegateQueue];
        [queue addOperationWithBlock:^{
           
            NSError *error = [NSError errorWithDomain:ACNNetworkingErrorDomain code:ACN_ERROR_BAD_REQUEST userInfo:@{NSLocalizedDescriptionKey: @"Can't create request object."}];
            completionHandler(nil, nil, error);
        }];
        return;
    }
    
    [[_defaultSession dataTaskWithRequest:request completionHandler:completionHandler] resume];
}

- (void)dataWithURL:(NSURL *)url
  completionHandler:(void (^)(NSData *data,
                              NSURLResponse *response,
                              NSError *error))completionHandler{

 
    [self dataWithURL:url timeoutInterval:ACN_DEFAULT_READ_TIMEOUT completionHandler:completionHandler];
}

- (void)dataWithURLRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    
    [[_defaultSession dataTaskWithRequest:request completionHandler:completionHandler] resume];
}


@end
