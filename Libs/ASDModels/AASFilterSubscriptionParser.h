//
//  AASFilterSubscriptionParser.h
//  Adguard
//
//  Created by Roman Sokolov on 09.10.17.
//  Copyright © 2017 Performix. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASDFilterMetadata, ASDFilterRule;

/////////////////////////////////////////////////////////////////////
#pragma mark - AASCustomFilterParserResult

/**
 Container for parsed custom filter.
 */
@interface AASCustomFilterParserResult : NSObject

@property (nonatomic) ASDFilterMetadata *meta;
@property (nonatomic) NSMutableArray <ASDFilterRule *> *rules;

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AASFilterSubscriptionParser

/**
 This parser instance already is used.
 */
extern NSString *AASFilterSubscriptionParserExceptionInUse;

extern NSString *AASFilterSubscriptionParserErrorDomain;

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

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Parsing custom filter from url asynchronously.
 
 @param url Url to custom filter file.
 @param completion The block which is called when processing completed.
 If parsing completed successful, `result` parameter contains parsing result and `error` is nil.
 Otherwise, `error` parameter contains corresponding error.
 */
- (void)parseFromUrl:(NSURL *)url
          completion:(void (^)(AASCustomFilterParserResult *result, NSError *error))completion;

/**
 Parsing custom filter from url.

 @param url Url to custom filter file.
 @param error On error returns error object.
 @return Result of nil if error occurs.
 */
- (AASCustomFilterParserResult *)parseFromUrl:(NSURL *)url error:(NSError **)error;

/**
 Cancels the asynchronous parsing.
 */
- (void)cancel;

@end
