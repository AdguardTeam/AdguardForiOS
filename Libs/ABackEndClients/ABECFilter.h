/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
#import "ABECConstants.h"

@class ASDFilter, ASDFilterMetadata, ABECRequest, ABECFilterClient;

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterAsyncProtocol

@protocol ABECFilterAsyncDelegateProtocol <NSObject>

/**
 Calls this method when downloding filter versions complated.
 @param versions Array of ASDFilterMetadata objects or nil if error occurs. 
 */
- (void)filterClient:(ABECFilterClient *)client filterVersionList:(NSArray <ASDFilterMetadata *>*)versions;

- (void)filterClient:(ABECFilterClient *)client filters:(NSDictionary <NSNumber *, ASDFilter *> *)filters;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClient
/////////////////////////////////////////////////////////////////////

extern NSString *ABECFilterError;
#define ABECFILTER_ERROR_PARAMETERS             100
#define ABECFILTER_ERROR_ASYNC_INPROGRESS       200
#define ABECFILTER_ERROR_ASYNC_NOTINIT          300


/**
    Backend client for retrieve filters data
 */
@interface ABECFilterClient : NSObject <NSURLSessionDownloadDelegate>

/////////////////////////////////////////////////////////////////////
#pragma mark  Init and class methods
/////////////////////////////////////////////////////////////////////

+ (ABECFilterClient *)singleton;

/**
 Initializes object for platform.

 @param platform Defines for what platform object is created.
 Accepted values: ABEC_PLATFORM_OSX, ABEC_PLATFORM_IOS
 */
- (id)initWithPlatform:(NSString *)platform;

/**
 Returns hostname for checking of connection to backend service.
 
 @param platform Defines for what platform obtain hostname.
 Accepted values: ABEC_PLATFORM_OSX, ABEC_PLATFORM_IOS
 */
+ (NSString *)reachabilityHost:(NSString *)platform;

/**
 Returns hostname for checking of connection to backend service.
 */
+ (NSString *)reachabilityHost;

/////////////////////////////////////////////////////////////////////
#pragma mark  Properties and public methods
/////////////////////////////////////////////////////////////////////

/**
    Returns list of filter versions.
    Request to backend is performed synchronous.
    @param filterIds list of NSNumber objects, each object represents filter Id as integer number.
    @return Array of ASDFilterMetadata objects or nil if error occurs.
    In ASDFilterMetadata object, fields filled, which represent context of updating filter version.
 */
- (NSArray *)filterVersionListForApp:(NSString *)applicationId filterIds:(id<NSFastEnumeration>)filterIds;


/**
    Returns request object for obtaining the filter data with rules list.
 */
- (ABECRequest *)requestForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId;

/**
    Returns last version of filter from backend.
    Request to backend is performed synchronous.
 
    @return ASDFilter object or nil if error occurs
 */
- (ASDFilter *)filterForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId;

/**
    Retuns list of metadata filters.
    Request to backend is performed synchronous.
    @return Array of ASDFilterMetadata objects or nil if error occurs.
 */
- (NSArray *)filterMetadataListForApp:(NSString *)applicationId;

/**
 Retuns list of metadata filter groups.
 Request to backend is performed synchronous.
 @return Array of ASDFilterGroup objects or nil if error occurs.
 */
- (NSArray *)groupMetadataListForApp:(NSString *)applicationId;

/////////////////////////////////////////////////////////////////////
#pragma mark  Async support methods

@property NSString *sessionId;
@property NSTimeInterval updateTimeout;
@property (weak) id <ABECFilterAsyncDelegateProtocol> delegate;

- (void)setupWithSessionId:(NSString *)sessionId updateTimeout:(NSTimeInterval)updateTimeout delegate:(id <ABECFilterAsyncDelegateProtocol>)delegate inProgress:(BOOL)inProgress;

- (void)handleBackgroundWithSessionId:(NSString *)sessionId updateTimeout:(NSTimeInterval)updateTimeout delegate:(id <ABECFilterAsyncDelegateProtocol>)delegate;


/**
 Add download task for obtaining list of filter versions.
 @return Returns nil on success.
 */
- (NSError *)asyncFilterVersionListForApp:(NSString *)applicationId filterIds:(id<NSFastEnumeration>)filterIds;


/**
 Add download tasks for obtaining last version of filters from backend.
 @return Returns nil on success.
 */
- (NSError *)asyncFilterForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterIds:(NSArray <NSNumber *>*)filterIds;


@end
