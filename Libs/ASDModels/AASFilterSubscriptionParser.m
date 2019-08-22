//
//  AASFilterSubscriptionParser.m
//  Adguard
//
//  Created by Roman Sokolov on 09.10.17.
//  Copyright © 2017 Performix. All rights reserved.
//

#import "AASFilterSubscriptionParser.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "ASDFilterObjects.h"
#import "ACNNetworking.h"
#import "ACIOUtils.h"

#define AAS_EXECUTION_PERIOD_TIME                           3600 // 1 hours
#define AAS_EXECUTION_LEEWAY                                5 // 5 seconds
#define AAS_EXECUTION_DELAY                                 2 // 2 seconds

#define AAS_CHECK_FILTERS_UPDATES_PERIOD                    AAS_EXECUTION_PERIOD_TIME
#define AAS_CHECK_FILTERS_UPDATES_FROM_UI_DELAY             AAS_EXECUTION_DELAY
#define AAS_CHECK_FILTERS_UPDATES_LEEWAY                    AAS_EXECUTION_LEEWAY
#define AAS_CHECK_FILTERS_UPDATES_DEFAULT_PERIOD            AAS_EXECUTION_PERIOD_TIME*6

#define AAS_CHECK_CUSTOM_FILTERS_UPDATES_DEFAULT_PERIOD     AAS_EXECUTION_PERIOD_TIME*48


#define ADBLOCK_FIRST_LINE                          @"Adblock Plus"
#define PARSE_META_MAX_LINES                        100
#define LOADING_TIMEOUT                             30 //seconds

/////////////////////////////////////////////////////////////////////
#pragma mark - AASCustomFilterParserResult
@implementation AASCustomFilterParserResult
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - ParsingContext

/**
 Represents parsing context
 */
@interface ParsingContext : NSObject
/**
 If YES - we should download subscription from new url.
 Otherwise - just parse metadata.
 */
@property (nonatomic) BOOL redirect;
@property (nonatomic) BOOL afterTitleParsed;
/**
 Parsed subscription with rules.
 */
@property (nonatomic) AASCustomFilterParserResult *result;
@end
@implementation ParsingContext
@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AASFilterSubscriptionParser

NSString *AASFilterSubscriptionParserExceptionInUse = @"AASFilterSubscriptionParserExceptionInUse";
NSString *AASFilterSubscriptionParserErrorDomain = @"AASFilterSubscriptionParserErrorDomain";

typedef void (^ParserActionType)(ParsingContext *context, NSString *tag, NSString *value);

@implementation AASFilterSubscriptionParser {
    //NSURLSessionDataTask *_currentLoadingTask;
    BOOL _canceled;
}

static NSDictionary <NSString *, ParserActionType> *_parserActions;


/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

+ (void)initialize {
    if (self == [AASFilterSubscriptionParser class]) {
        _parserActions = @{
                          @"homepage": ^void(ParsingContext *context, NSString *tag, NSString *value){
                              context.result.meta.homepage = [value copy];
                          },
                          @"title": ^void(ParsingContext *context, NSString *tag, NSString *value){
                              context.result.meta.name = [value copy];
                              context.afterTitleParsed = YES;
                          },
                          @"expires": ^void(ParsingContext *context, NSString *tag, NSString *value){
                              context.result.meta.expires = [self convertExpiresFromString:value];
                          },
                          @"redirect": ^void(ParsingContext *context, NSString *tag, NSString *value){
                              context.redirect = YES;
                              context.result.meta.subscriptionUrl = [value copy];
                          },
                          @"version": ^void(ParsingContext *context, NSString *tag, NSString *value){
                              context.result.meta.version = [value copy];
                          }
                          };
    }
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _canceled = NO;
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)parseFromUrl:(NSURL *)url
          completion:(void (^)(AASCustomFilterParserResult *result, NSError *error))completion {
    
    @synchronized(self) {
        
        // aborting operation if cancel
        if (_canceled) {
            if (completion) {
                completion(nil, nil);
            }
//            _currentLoadingTask = nil;
            return;
        }

//        if (_currentLoadingTask) {
//            [NSException raise:AASFilterSubscriptionParserExceptionInUse format:@"This parser instance already is used."];
//        }
        DDLogInfo(@"(AASFilterSubscriptionParser) Begin parse custom filter for url:\n %@", url);
        ParsingContext *context = [ParsingContext new];
        context.redirect = NO;
        context.result = [AASCustomFilterParserResult new];
        context.result.meta = [ASDFilterMetadata new];
        context.result.rules = [NSMutableArray new];
        
        NSString *errorMessage = NSLocalizedString(@"Something went wrong, or the file with custom filtering rules is in the wrong format.",
                                                   @"(AASFilterSubscriptionParser) Error while processing the custom filter file.");
        
        
//        _currentLoadingTask =
//
        [[ACNNetworking new] dataWithURL:url
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                     do {
                         if (error) {
                             if (error.code == NSURLErrorCancelled) {
                                 error = nil;
                             }
                             else{
                                 DDLogError(@"(AASFilterSubscriptionParser) Can't load filter content:\n%@", error);
                             }
                             break;
                         }

                         //Response
                         if (response) {
                             NSString *content;
                             if (response.textEncodingName) {
                                 //Getting encoding
                                 CFStringEncoding enc = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)(response.textEncodingName));
                                 if (enc != kCFStringEncodingInvalidId) {
                                     NSStringEncoding sEnc = CFStringConvertEncodingToNSStringEncoding(enc);
                                     content = [[NSString alloc] initWithData:data encoding:sEnc];
                                 }
                             }
                             if (content == nil) {
                                 content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                 if (content == nil) {
                                     //Convert to string error
                                     DDLogWarn(@"(AASFilterSubscriptionParser) Can't convert url content to string.");
                                     error = [NSError errorWithDomain:AASFilterSubscriptionParserErrorDomain
                                                                 code:AASFilterSubscriptionParserErrorConvertToString
                                                             userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                                     break;
                                 }
                             }

                             // aborting operation if cancel
                             @synchronized(self) {
                                 if (_canceled) {
                                     break;
                                 }
                             }

                             // Checking contant validity
                             if (! [self isValidContent:content]) {
                                 DDLogWarn(@"(AASFilterSubscriptionParser) Can't parse filter, because of invalid filter content.");
                                 error = [NSError errorWithDomain:AASFilterSubscriptionParserErrorDomain
                                                             code:AASFilterSubscriptionParserErrorNotValidContent
                                                         userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
                                 break;
                             }

                             // aborting operation if cancel
                             @synchronized(self) {
                                 if (_canceled) {
                                     break;
                                 }
                             }
                             //Main work
                             [self parseMetaTagsWithContext:context content:content];

                             // aborting operation if cancel
                             @synchronized(self) {
                                 if (_canceled) {
                                     break;
                                 }
                             }

                             // URLs check to avoid redirect loop
                             if (context.redirect) {
                                 NSURL *subscriptionUrl = [NSURL URLWithString:context.result.meta.subscriptionUrl];
                                 if (subscriptionUrl
                                     && ! response.URL.fileURL
                                     && ! [subscriptionUrl isEqual:response.URL]) {
                                     DDLogInfo(@"(AASFilterSubscriptionParser) Custom filter redirection.");
                                     @synchronized(self) {
//                                         _currentLoadingTask = nil;
                                     }
                                     [self parseFromUrl:subscriptionUrl completion:completion];
                                     return;
                                 }
                             }

                             [self parseRulesWithContext:context content:content];
                             [self setPropertiesForContext:context filterPath:response.URL.absoluteString];

                             //Main return
                             @synchronized(self) {
                                 if (completion) {
                                     completion(context.result, error);
                                 }
//                                 _currentLoadingTask = nil;
                             }
                             DDLogInfo(@"(AASFilterSubscriptionParser) End parse custom filter for url:\n %@", response.URL);
                             return;
                         }
                         DDLogWarn(@"(AASFilterSubscriptionParser) Can't parse filter, because of no response object.");
                         error = [NSError errorWithDomain:AASFilterSubscriptionParserErrorDomain
                                                     code:AASFilterSubscriptionParserErrorNoResponse
                                                 userInfo:@{NSLocalizedDescriptionKey: errorMessage}];

                     } while (0);
                     //Return with error
                     @synchronized(self) {
                         if (completion) {
                             completion(nil, error);
                         }
//                         _currentLoadingTask = nil;
                     }
                     return;
                 }
         ];
    }
}

- (AASCustomFilterParserResult *)parseFromUrl:(NSURL *)url error:(NSError **)error {
    NSCondition *theLock = [NSCondition new];
    __block AASCustomFilterParserResult *theResult = nil;
    __block NSError *theError = nil;
    [theLock lock];
    [self parseFromUrl:url completion:^(AASCustomFilterParserResult *result, NSError *error) {
        [theLock lock];
        theResult = result;
        theError = error;
        [theLock broadcast];
        [theLock unlock];
    }];
    [theLock wait];
    [theLock unlock];
    if (error) {
        *error = theError;
    }
    return theResult;
}

- (void)cancel {
    @synchronized(self) {
//        [_currentLoadingTask cancel];
//        _currentLoadingTask = nil;
        _canceled = YES;
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/**
 If Expires more than default time use default
 */
+ (NSNumber *)convertExpiresFromString:(NSString *)value {
    NSTimeInterval timeToUpdate = AAS_CHECK_CUSTOM_FILTERS_UPDATES_DEFAULT_PERIOD;
    if (! [NSString isNullOrEmpty:value]) {
        NSArray *splited = [value splitByArray:@[@" "] count:2 omitEmpty:YES];
        if (splited.count == 2) {
            NSTimeInterval time = [splited[0] doubleValue];
            if (time > 0) {
                timeToUpdate = time;
                NSString *format = splited[1];
                if ([format contains:@"day" caseSensitive:NO]) {
                    timeToUpdate = time * 24 * 3600;
                }
                if ([format contains:@"hour" caseSensitive:NO]) {
                    timeToUpdate = time * 3600;
                }
                if (timeToUpdate < AAS_CHECK_CUSTOM_FILTERS_UPDATES_DEFAULT_PERIOD)
                    timeToUpdate = AAS_CHECK_CUSTOM_FILTERS_UPDATES_DEFAULT_PERIOD;

                return @(timeToUpdate);
            }
        }
    }
    
    DDLogWarn(@"(AASFilterSubscriptionParser) Can't transform Expires: %@ to valid time. Set default.", value);
    return @(timeToUpdate);
}

/**
 Set's default properties if we can't find them.
 */
- (void)setPropertiesForContext:(ParsingContext *)context filterPath:(NSString *)filterPath {
    
    context.result.meta.displayNumber = @(1);
    context.result.meta.subscriptionUrl = filterPath;
    context.result.meta.checkDate = [NSDate date];
    context.result.meta.checkDateString = [context.result.meta.checkDate iso8601String];
    context.result.meta.updateDate = [NSDate date];
    context.result.meta.updateDateString = [context.result.meta.updateDate iso8601String];
    context.result.meta.groupId = @(0);
    
    if ([NSString isNullOrEmpty:context.result.meta.name]) {
        NSURL *url = [NSURL URLWithString:filterPath];
        context.result.meta.name = url.lastPathComponent;
    }
}

- (void)parseMetaTagWithContext:(ParsingContext *)context tag:(NSString *)tag {
    NSArray *splited = [tag splitByArray:@[@":"] count:2 omitEmpty:YES];
    if (splited.count == 2) {
        NSString *tag = [splited[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *value = [splited[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *key = [tag lowercaseString];
        ParserActionType action = _parserActions[key];
        if (action) {
            context.afterTitleParsed = NO;
            action(context, tag, value);
            return;
        }
    }
    // Parse next comment line after `Title` tag as description, if it is not a parsed tag.
    if (context.afterTitleParsed) {
        context.result.meta.descr = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        context.afterTitleParsed = NO;
    }
}

- (void)parseMetaTagsWithContext:(ParsingContext *)context content:(NSString *)content {
    __block NSUInteger counter = 0;
    [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        counter++;
        if (counter == 1) {
            if ([line contains:ADBLOCK_FIRST_LINE caseSensitive:NO]) {
                return;
            }
        }
        if (counter > PARSE_META_MAX_LINES) {
            *stop = YES;
            return;
        }
        if (! [line hasPrefix:@"!"]) {
            return;
        }
        NSString *value = [[line componentsSeparatedByString:@"!"] lastObject];
        if ([NSString isNullOrWhiteSpace:value]) {
            return;
        }
        [self parseMetaTagWithContext:context tag:value];
        if (context.redirect) {
            *stop = YES;
            return;
        }
    }];
}

- (void)parseRulesWithContext:(ParsingContext *)context content:(NSString *)content {
    __block BOOL firstLine = YES;
    __block NSUInteger count = 0;
    
    __block NSNumber *affinityMask = NULL;
    
    [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if (firstLine) {
            firstLine = NO;
            if ([line contains:ADBLOCK_FIRST_LINE caseSensitive:NO]) {
                return;
            }
        }
        if ([NSString isNullOrWhiteSpace:line]) {
            return;
        }
        count++;
        
        ASDFilterRule *rule = [[ASDFilterRule alloc] initWithText:line enabled:YES];
        if (rule) {
            rule.ruleId = @(count);

            if ([line hasPrefix:@"!#safari_cb_affinity("]) {
                affinityMask = [self parseContentBlockerTypes:line];
            } else if ([line hasPrefix:@"!#safari_cb_affinity"]) {
                affinityMask = NULL;
            } else {
                
                rule.ruleText = line;
                rule.isEnabled = @(1);
                rule.affinity = affinityMask;
                
                [context.result.rules addObject:rule];
            }
            
        }
        
    }];
}

- (NSNumber *) parseContentBlockerTypes:(NSString *) ruleText {
    NSNumber *result = NULL;
    
    u_long startIndex = @"!#safari_cb_affinity".length + 1;
    NSString *stripped = [ruleText substringFromIndex:startIndex];
    stripped = [stripped substringToIndex:[stripped length] - 1];
    NSArray *list = [stripped componentsSeparatedByString:@","];
    
    for (id item in list) {
        NSString *trimmed = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSNumber *affinity = [self getAffinityFromString:trimmed];
        if (affinity != NULL) {
            result = [NSNumber numberWithInteger: [result intValue] + [affinity intValue]];
        }
    }
    
    return result;
}

- (NSNumber *) getAffinityFromString:(NSString *) item {
    
    // Should correspond to SafariServices.Affinity
    NSDictionary *stringToNumber = @{ @"general" : @(1 << 0),
                                      @"privacy" : @(1 << 1),
                                      @"social" : @(1 << 2),
                                      @"other" : @(1 << 3),
                                      @"custom" : @(1 << 4),
                                      @"security" : @(1 << 5),
                                      @"all" : @(0)
                                      
    };
    
    NSNumber *number = [stringToNumber objectForKey:item];
    if (number != nil) {
        return number;
    } else {
        return NULL;
    }
}

/**
 Returns false if first 256 chars of downloaded content is empty or contains some HTML's tags
 */
- (BOOL)isValidContent:(NSString *)content {
    NSString *beginWith = [content substringToIndex:(content.length > 256 ? 256 : content.length)];
    beginWith = [beginWith lowercaseString];
    if ([NSString isNullOrWhiteSpace:beginWith]
        || [beginWith containsAny:@[
                                    @"<!doctype",
                                    @"<html",
                                    @"<head"
                                    ]]) {
        return  NO;
    }
    return YES;
}

@end
