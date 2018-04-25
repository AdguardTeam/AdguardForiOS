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

typedef NS_ENUM(NSInteger, ABECSubscriptionErrorCode) {
    /**
     *  Indicates that the file can not be downloaded.
     */
    ABECSubscriptionErrorCodeNetworkError = 1,
    
    /**
     *  Indicates that the rules can not be parsed.
     */
    ABECSubscriptionErrorCodeParseError,
};

/**
 Backend client for retrieve subscripitons data
 */
@interface ABECSubscription : NSObject

+ (ABECSubscription *)singleton;

- (void) downloadSubscription:(NSString*) url completionBlock: (void (^)(NSArray* rules, NSDictionary* hosts))completionBlock errorBlock:(void(^)(NSError* error))errorBlock;

- (BOOL) parseText:(NSString*) text rules:(NSArray**) rules hosts:(NSDictionary**) hosts;

@end
