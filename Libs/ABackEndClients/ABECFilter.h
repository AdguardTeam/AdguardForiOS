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
#import "ACommons/ACLang.h"
#import "ABECConstants.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
#import <UIKit/UIKit.h>
#endif


@class ASDFilter, ASDFilterMetadata, ASDFilterGroup, ASDFiltersI18n, ASDGroupsI18n, ABECFilterClientMetadata, ABECFilterClientLocalization, ABECFilterClient;

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterAsyncProtocol

@protocol ABECFilterAsyncDelegateProtocol <NSObject>

/**
 Calls this method when downloading filters/groups metadata completed.
 
 @param client Object of the client for backend server
 @param metadata Metadata object
 */
- (void)filterClient:(nonnull ABECFilterClient *)client metadata:(nonnull ABECFilterClientMetadata *)metadata;

/**
 Calls this method when downloading filters/groups localizations completed

 @param client Object of the client for backend server
 @param i18n Localizations
 */
- (void)filterClient:(nonnull ABECFilterClient *)client localizations:(nonnull ABECFilterClientLocalization *)i18n;

/**
 Calls this method when downloading filter rules completed.
 
 @param client Object of the client for backend server.
 @param filterId Filter id of the downloaded filter.
 @param filter Filter object, may be nil if error occurs.
 
 @return Must return YES when all requested filter rules were obtained, otherwise NO.
 */
- (BOOL)filterClient:(nonnull ABECFilterClient *)client filterId:(nonnull NSNumber *)filterId filter:(nullable ASDFilter *)filter;


/**
 Calls this method when all background downloading tasks were completed.
 
 @param client Object of the client for backend server.
 @param error If error occurs, contains error object, otherwise nil.
 */
- (void)filterClientFinishedDownloading:(nonnull ABECFilterClient *)client error:(nullable NSError *)error;

@end


/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClientMetadata

/**
 Metadata representation.
 */
@interface ABECFilterClientMetadata : ACObject

/**
 List of filters metadata.
 */
@property (nonatomic, nullable) NSArray <ASDFilterMetadata *> *filters;
/**
 List of groups metadata.
 */
@property (nonatomic, nullable) NSArray <ASDFilterGroup *> *groups;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClientLocalization

/**
 Localizations representation.
 */
@interface ABECFilterClientLocalization : ACObject

/**
 Filters localizations object.
 */
@property (nonatomic, nullable) ASDFiltersI18n *filters;
/**
 Groups localizations object
 */
@property (nonatomic, nullable) ASDGroupsI18n *groups;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClient
/////////////////////////////////////////////////////////////////////

extern NSString * _Nonnull ABECFilterError;
#define ABECFILTER_ERROR_ASYNC_NOTINIT          300


/**
    Backend client for retrieve filters data
 */
@interface ABECFilterClient : NSObject <NSURLSessionDownloadDelegate>

/////////////////////////////////////////////////////////////////////
#pragma mark  Init and Class methods

/**
 This class has singleton object.
 */
+ (nonnull ABECFilterClient *)singleton;

/**
 Returns hostname for checking of connection to backend service.
 */
+ (nonnull NSString *)reachabilityHost;

/////////////////////////////////////////////////////////////////////
#pragma mark  Properties and public methods

/**
 Add download tasks for obtaining last version of filters from backend.
 
 @param filterIds List of the filter ids for downloading.
 @return Returns nil on success.
 */
- (nullable NSError *)filtersRequestWithFilterIds:(nonnull NSArray <NSNumber *>*)filterIds;

/**
 Add download task for obtaining filters/groups metadata.
 
 @return Returns nil on success.
 */
- (nullable NSError *)metadataRequest;

/**
 Add download task for obtaining filters/groups localizations.
 
 @return Returns nil on success.
 */
- (nullable NSError *)i18nRequest;

/**
 Returns last version of filter from backend.
 Request to backend is performed synchronous.
 
 @return ASDFilter object or nil if error occurs
 */
- (nullable ASDFilter *)filterWithFilterId:(nonnull NSNumber *)filterId;

/**
 Retuns metadata for filters and groups from backend.
 Request to backend is performed synchronous.
 
 @return ABECFilterClientMetadata object or nil if error occurs
 */
- (nullable ABECFilterClientMetadata *)loadMetadataWithTimeoutInterval:(nullable NSNumber*)timeoutInterval;

/**
 Retuns localizations for filters and groups from backend.
 Request to backend is performed synchronous.
 
 @return ABECFilterClientLocalization object or nil if error occurs
 */
- (nullable ABECFilterClientLocalization *)loadI18nWithTimeoutInterval:(nullable NSNumber*)timeoutInterval;

/////////////////////////////////////////////////////////////////////
#pragma mark  Async support methods

@property (weak, nullable) id <ABECFilterAsyncDelegateProtocol> delegate;

/**
 Resets async session.

 @param sessionId Session id.
 @param updateTimeout Timeout for download tasks.
 @param block Completion block, which is called on session serial queue. 
 */
- (void)resetSession:(nonnull NSString *)sessionId
       updateTimeout:(NSTimeInterval)updateTimeout
            delegate:(nullable id<ABECFilterAsyncDelegateProtocol>)delegate
     completionBlock:(nullable void (^)(BOOL updateInProgress))block;

/**
 This method needs call when App is launched from background downloads event.

 @param sessionId Session id.
 @param updateTimeout Timeout for download tasks.
 @param delegate Delegate object, which will be notifed about new data.
 */
- (void)handleBackgroundWithSessionId:(nonnull NSString *)sessionId
                        updateTimeout:(NSTimeInterval)updateTimeout
                             delegate:(nullable id<ABECFilterAsyncDelegateProtocol>)delegate;

@end
