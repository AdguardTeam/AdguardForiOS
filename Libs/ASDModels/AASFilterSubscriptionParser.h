//
//  AASFilterSubscriptionParser.h
//  Adguard
//
//  Created by Roman Sokolov on 09.10.17.
//  Copyright © 2017 Performix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASDFilterMetadata, ASDFilterRule;
@protocol ACNNetworkingProtocol;

/////////////////////////////////////////////////////////////////////
#pragma mark - AASCustomFilterParserResult

/**
 Container for parsed custom filter.
 */
@interface AASCustomFilterParserResult : NSObject

@property (nonatomic, nonnull) ASDFilterMetadata *meta;
@property (nonatomic, nonnull) NSMutableArray <ASDFilterRule *> *rules;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AASFilterSubscriptionParser

/**
 This parser instance already is used.
 */
extern NSString * _Nonnull AASFilterSubscriptionParserExceptionInUse;

extern NSString * _Nonnull AASFilterSubscriptionParserErrorDomain;

#define AASFilterSubscriptionParserErrorConvertToString                             100
#define AASFilterSubscriptionParserErrorNotValidContent                             200
#define AASFilterSubscriptionParserErrorNoResponse                                  300

/**
 Metadata parser for filter rules file,
 which contains metadata as comments in beginning.
 */
@interface AASFilterSubscriptionParser  : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

/**
 init parser
 */
- (nonnull instancetype) initWithNetworking:(nonnull id<ACNNetworkingProtocol>) networking;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Parsing custom filter from url asynchronously.
 
 @param url Url to custom filter file.
 @param completion The block which is called when processing completed.
 If parsing completed successful, `result` parameter contains parsing result and `error` is nil.
 Otherwise, `error` parameter contains corresponding error.
 */
- (void)parseFromUrl:(nonnull NSURL *)url
          completion:(nullable void (^)(AASCustomFilterParserResult * _Nullable result, NSError * _Nullable error))completion;

/**
 Parsing custom filter from url.

 @param url Url to custom filter file.
 @param error On error returns error object.
 @return Result of nil if error occurs.
 */
- (nullable AASCustomFilterParserResult *)parseFromUrl:(NSURL * _Nonnull)url error:(NSError *_Nullable * _Nonnull)error;

/**
 Cancels the asynchronous parsing.
 */
- (void)cancel;

@end
