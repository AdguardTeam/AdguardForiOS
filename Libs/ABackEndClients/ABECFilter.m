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
#import "ACommons/ACLang.h"
#import "ABECFilter.h"
#import "ABECConstants.h"
#import "ASDFilterObjects.h"
#import "ABECRequest.h"
#import "ABECFilterParsers.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClient Constants
/////////////////////////////////////////////////////////////////////

#define FILTERID_PARAM                  @"filterid"

NSString *ABECPlatformKey               = @"ABECPlatformKey";

NSString *ABECFilterParserKey           = @"ABECFilterParserKey";
NSString *ABECFilterVersionParserKey    = @"ABECFIlterVersionParserKey";
NSString *ABECFilterMetaParserKey       = @"ABECFilterMetaParserKey";
NSString *ABECFilterGroupMetaParserKey  = @"ABECFilterGroupMetaParserKey";

NSString *ABECFilterUrlKey              = @"ABECFilterUrlKey";
NSString *ABECFIlterVersionUrlKey       = @"ABECFIlterVersionUrlKey";
NSString *ABECFilterMetaUrlKey          = @"ABECFILTERMetaUrlKey";
NSString *ABECFilterGroupMetaUrlKey     = @"ABECFilterGroupMetaUrlKey";

NSString *ABECFilterError = @"ABECFilterError";

static NSDictionary *ABECFilterSettings;

void settings(){
    
    ABECFilterSettings = @{
                           
                           // Settings for iOS
                           ABEC_PLATFORM_IOS:
                               @{
                                   ABECPlatformKey: ABEC_PLATFORM_IOS,
                                   
                                   ABECFilterParserKey:          [PlainFilterParser class],
                                   ABECFilterVersionParserKey:   [JSONVersionParser class],
                                   ABECFilterMetaParserKey:      [JSONMetadataParser class],
                                   ABECFilterGroupMetaParserKey: [JSONGroupParser class],
                                   
#if DEBUG
                                   ABECFilterUrlKey:            @"http://testmobile.adtidy.org/api/1.0/getiosfilter.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFIlterVersionUrlKey:     @"http://testmobile.adtidy.org/api/1.0/checkfilterversions.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFilterMetaUrlKey:        @"http://testmobile.adtidy.org/api/1.0/getfiltersmeta.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFilterGroupMetaUrlKey:   @"http://testmobile.adtidy.org/api/1.0/getgroupsmeta.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S"
#else
                                   ABECFilterUrlKey:            @"http://mobile.adtidy.org/api/1.0/getiosfilter.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFIlterVersionUrlKey:     @"http://mobile.adtidy.org/api/1.0/checkfilterversions.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFilterMetaUrlKey:        @"http://mobile.adtidy.org/api/1.0/getfiltersmeta.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S",
                                   ABECFilterGroupMetaUrlKey:   @"http://mobile.adtidy.org/api/1.0/getgroupsmeta.html?key=KPQ8695OH49KFCWC9EMX95OH49KFF50S"
#endif
                                   }
                           };

}

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECFilterClient
/////////////////////////////////////////////////////////////////////

@implementation ABECFilterClient{
    
    NSString *_platform;
    NSURL *filterMetaUrl;
    NSURL *groupMetaUrl;
    NSURL *filterVersionUrl;
    NSURL *filterUrl;
    
    BOOL _handleBackground;
    BOOL _asyncInProgress;
    NSMutableArray <NSURLSessionDownloadTask *> *_obtainFilterTasks;
    NSMutableDictionary <NSNumber *, id> *_filterResults;
    
    void (^_responseBlock)(void);
}

static ABECFilterClient *ABECFilterSingleton;

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+ (ABECFilterClient *)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ABECFilterSingleton = [ABECFilterClient alloc];
        ABECFilterSingleton = [ABECFilterSingleton init];
    });
    
    return ABECFilterSingleton;
    
}

- (id)init{
    
    return [self initWithPlatform:ABEC_DEFAULT_PLATFORM];
}

- (id)initWithPlatform:(NSString *)platform{
    
    self = [super init];
    if (self) {

        _platform = platform;
        NSDictionary *settings = ABECFilterSettings[_platform];
        
        filterUrl = [NSURL URLWithString:settings[ABECFilterUrlKey]];
        filterVersionUrl = [NSURL URLWithString:settings[ABECFIlterVersionUrlKey]];
        filterMetaUrl = [NSURL URLWithString:settings[ABECFilterMetaUrlKey]];
        groupMetaUrl = [NSURL URLWithString:settings[ABECFilterGroupMetaUrlKey]];
        
        _asyncInProgress = YES;
        _handleBackground = NO;
        _responseBlock = nil;
    }
    
    return self;
}

+ (void)initialize{
    
    if (self == [ABECFilterClient class]) {
        
        settings();
    }
}

+ (NSString *)reachabilityHost:(NSString *)platform{
    
    NSDictionary *settings = ABECFilterSettings[platform];

    // we will be use host from "get filter url" for checking reachability
    return [[NSURL URLWithString:settings[ABECFilterUrlKey]] host];
}

+ (NSString *)reachabilityHost{
    
    return [ABECFilterClient reachabilityHost:ABEC_DEFAULT_PLATFORM];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

- (NSArray *)filterVersionListForApp:(NSString *)applicationId filterIds:(id<NSFastEnumeration>)filterIds{

    
    ABECRequest *sURLRequest = [self requestForFilterVersionListForApp:applicationId filterIds:filterIds];
    if (!sURLRequest) {
        return nil;
    }
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];

    return [self filterVersionFromData:data response:response error:error];
}

- (ABECRequest *)requestForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId{
    
    if (!applicationId || !affiliateId)
        return nil;
    
    return [ABECRequest
            getRequestForURL:filterUrl
            parameters:@{
                         @"app_id": applicationId,
                         @"webmaster_id": affiliateId,
                         FILTERID_PARAM: [NSString stringWithFormat:@"%lu", (unsigned long)filterId]
                         }];

}

- (ASDFilter *)filterForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId{

    if (!applicationId || !affiliateId)
        return nil;
    
    ABECRequest *sURLRequest = [self requestForApp:applicationId affiliateId:affiliateId filterId:filterId];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];
    
    return [self filterForData:data response:response filterId:@(filterId) error:error];
}

- (NSArray *)filterMetadataListForApp:(NSString *)applicationId {
    
    if (!applicationId)
        return nil;
    
    ABECRequest *sURLRequest = [ABECRequest getRequestForURL:filterMetaUrl parameters:nil];
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil)
        DDLogError(@"Error loading filters metadata info:%@", [error localizedDescription]);
    
    else {
        // check for any response errors
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((([httpResponse statusCode]/100) == 2)) {
            
            
            // parse response data
            id<MetadataParserProtocol> metadataParser = [self parserForKey:ABECFilterMetaParserKey];
            
            if (![metadataParser parseWithData:data]) {
                
                DDLogError(@"Error when loading filters metadata info. Can't parse XML.");
                DDLogErrorTrace();
                return nil;
            }
            
            return [metadataParser metadataList];
        }
        else {
            
            DDLogError(@"Http Error when loading filters metadata info. Http Status:%li", (long)[httpResponse statusCode]);
            DDLogErrorTrace();
        }
    }
    
    return nil;
}


- (NSArray *)groupMetadataListForApp:(NSString *)applicationId {
    
    if (!applicationId)
        return nil;
    
    ABECRequest *sURLRequest = [ABECRequest getRequestForURL:groupMetaUrl parameters:nil];
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil)
        DDLogError(@"Error loading filter groups metadata info:%@", [error localizedDescription]);
        
        else {
            // check for any response errors
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((([httpResponse statusCode]/100) == 2)) {
                
                
                // parse response data
                id<GroupParserProtocol> groupParser = [self parserForKey:ABECFilterGroupMetaParserKey];
                
                if (![groupParser parseWithData:data]) {
                    
                    DDLogError(@"Error when loading filter groups info. Can't parse XML.");
                    DDLogErrorTrace();
                    return nil;
                }
                
                return [groupParser groupList];
            }
            else{
             
                DDLogError(@"Http Error when loading filter groups info. Http Status:%li", (long)[httpResponse statusCode]);
                DDLogErrorTrace();
            }
        }
    
    return nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Async support methods

- (void)setupWithSessionId:(NSString *)sessionId delegate:(id <ABECFilterAsyncDelegateProtocol>)delegate{
    
    self.sessionId = sessionId;
    self.delegate = delegate;
}

- (void)handleBackgroundWithSessionId:(NSString *)sessionId delegate:(id <ABECFilterAsyncDelegateProtocol>)delegate{
    
    @synchronized (ABECFilterSingleton) {
        _handleBackground = YES;
        _asyncInProgress = YES;
        [self setupWithSessionId:sessionId delegate:delegate];
        return;
    }
}

- (NSError *)asyncFilterVersionListForApp:(NSString *)applicationId filterIds:(id<NSFastEnumeration>)filterIds {

    @synchronized (ABECFilterSingleton) {
        
        if (_asyncInProgress) {
            
            return [NSError errorWithDomain:ABECFilterError code:ABECFILTER_ERROR_ASYNC_INPROGRESS userInfo:nil];
        }
        
        ABECRequest *sURLRequest = [self requestForFilterVersionListForApp:applicationId filterIds:filterIds];
        if (!sURLRequest) {
            return [NSError errorWithDomain:ABECFilterError code:ABECFILTER_ERROR_PARAMETERS userInfo:nil];
        }
        
        NSURLSessionDownloadTask *currentTask = [[self backgroundSession] downloadTaskWithRequest:sURLRequest];
        [currentTask resume];
        _asyncInProgress = YES;
        
        return nil;
    }
}

- (NSError *)asyncFilterForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterIds:(NSArray <NSNumber *>*)filterIds {

    @synchronized (ABECFilterSingleton) {
        
        if (_asyncInProgress) {
            
            return [NSError errorWithDomain:ABECFilterError code:ABECFILTER_ERROR_ASYNC_INPROGRESS userInfo:nil];
        }
        
        if (!_obtainFilterTasks) {
            _obtainFilterTasks = [NSMutableArray array];
        }
        
        for (NSNumber *filterId in filterIds) {
            ABECRequest *sURLRequest = [self requestForApp:applicationId affiliateId:affiliateId filterId:[filterId integerValue]];
            if (!sURLRequest) {
                return [NSError errorWithDomain:ABECFilterError code:ABECFILTER_ERROR_PARAMETERS userInfo:nil];
            }
            
            NSURLSessionDownloadTask *currentTask = [[self backgroundSession] downloadTaskWithRequest:sURLRequest];
            [currentTask resume];
            [_obtainFilterTasks addObject:currentTask];
        }
        _asyncInProgress = YES;
        
        return nil;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Download session delegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL {

    [self processDownloadTask:downloadTask error:nil downloadURL:downloadURL];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

    [self processDownloadTask:(NSURLSessionDownloadTask *)task error:error downloadURL:nil];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
    if (_responseBlock) {
        _responseBlock();
    }
    
    _responseBlock = nil;
}
/////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////

- (id)parserForKey:(NSString *)key{
    
    NSDictionary *settings = ABECFilterSettings[_platform];
    id theClass = settings[key];
    if (!theClass) {
        
        [[NSException argumentException:key] raise];
    }
    
    return [theClass new];
}

- (ABECRequest *)requestForFilterVersionListForApp:(NSString *)applicationId filterIds:(id<NSFastEnumeration>)filterIds {
    
    if (!(applicationId && filterIds))
        return nil;
    
    NSMutableString *parameters = [NSMutableString
                                   stringWithFormat:@"%@app_id=%@",
                                   ([NSString isNullOrEmpty:[filterVersionUrl query]]
                                    ? @"?"
                                    : @"&"),
                                   applicationId];
    BOOL emptyFilterIds = YES;
    for (NSNumber *filterId in filterIds) {
        
        [parameters appendFormat:@"&filterid=%@", filterId];
        emptyFilterIds = NO;
    }
    if (emptyFilterIds) return nil;
    
    NSURL *url = [NSURL URLWithString:[[filterVersionUrl absoluteString] stringByAppendingString:parameters]];
    
    return [ABECRequest getRequestForURL:url parameters:nil];
}

- (NSArray *)filterVersionFromData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil)
        DDLogError(@"Error loading filters version info:%@", [error localizedDescription]);
    
    else {
        // check for any response errors
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((([httpResponse statusCode]/100) == 2)) {
            
            // parse response data
            id<VersionParserProtocol> versionParser = [self parserForKey:ABECFilterVersionParserKey];
            
            if ([versionParser parseWithData:data]) {
                
                return [versionParser versionList];
            }
            else{
                
                DDLogError(@"Error loading filters version info: Can't parse XML.");
                DDLogErrorTrace();
                return nil;
            }
        }
        else {
            
            DDLogError(@"Http Error when loading filter version info. Http Status:%li", (long)[httpResponse statusCode]);
            DDLogErrorTrace();
        }
    }
    
    return nil;
}

- (ASDFilter *)filterForData:(NSData *)data response:(NSURLResponse *)response filterId:(NSNumber *)filterId error:(NSError *)error{
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil)
        DDLogError(@"Error loading filter rules:%@", [error localizedDescription]);
    
    else {
        // check for any response errors
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((([httpResponse statusCode]/100) == 2)) {
            
            
            id<FilterParserProtocol> filterParser = [self parserForKey:ABECFilterParserKey];
            
            filterParser.filterId = filterId;
            
            if (![filterParser parseWithData:data]) {
                
                DDLogError(@"Error when loading filter rules (filterId = %lu). Can't parse XML.", [filterId unsignedLongValue]);
                DDLogErrorTrace();
                return nil;
            }
            
            ASDFilter *filter = [filterParser filter];
            
            return filter;
        }
        else {
            
            DDLogError(@"Http Error when loading filter rules (filterId = %lu). Http Status:%li", (unsigned long)filterId, [httpResponse statusCode]);
            DDLogErrorTrace();
        }
    }
    
    return nil;
    
}

- (NSURLSession *)backgroundSession
{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    if ([NSString isNullOrEmpty:self.sessionId]) {
        return nil;
    }
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:self.sessionId];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    return session;
}

- (void)unlockAsync {
    @synchronized(ABECFilterSingleton) {
        
        _asyncInProgress = NO;
        _filterResults = nil;
    }
}

- (void)processDownloadTask:(NSURLSessionDownloadTask *)downloadTask error:(NSError *)error downloadURL:(NSURL *)downloadURL {
    
    __typeof__(self) __weak wSelf = self;
    
    NSURL *requestUrl = [[downloadTask originalRequest] URL];
    if ([[requestUrl absoluteString] hasPrefix:[filterVersionUrl absoluteString]]) {
        
        // was filter version request
        
        NSData *data;
        if (error || (data = [NSData dataWithContentsOfURL:downloadURL]) == nil) {
            _responseBlock = ^() {
                __typeof__(self) sSelf = wSelf;
                
                [sSelf unlockAsync];
                [sSelf.delegate filterClient:sSelf filterVersionList:nil];
            };
        } else {
            NSArray *filterVersions = [self filterVersionFromData:data response:[downloadTask response] error:nil];
            _responseBlock = ^() {
                __typeof__(self) sSelf = wSelf;
                
                [sSelf unlockAsync];
                [sSelf.delegate filterClient:sSelf filterVersionList:filterVersions];
            };
        }
        
        if (!_handleBackground) {
            _responseBlock(); // if app in active mode, we call block for transferring of the result to delegate
        }
        
    } else if ([[requestUrl absoluteString] hasPrefix:[filterUrl absoluteString]]) {
        
        //was filter request
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:requestUrl resolvingAgainstBaseURL:NO];
        NSNumber *filterId;
        for (NSURLQueryItem *item in components.queryItems) {
            
            if ([item.name isEqualToString:FILTERID_PARAM]) {
                filterId = @([item.value integerValue]);
                break;
            }
        }
        if (!filterId) {
            return;
        }
        
        _responseBlock = ^() {
            __typeof__(self) sSelf = wSelf;
            
            NSDictionary *filterResults = [sSelf->_filterResults copy];
            [sSelf unlockAsync];
            [sSelf.delegate filterClient:sSelf filters:filterResults];
        };
        
        if (!_filterResults) {
            _filterResults = [NSMutableDictionary dictionary];
        }
        
        NSData *data;
        if (error || (data = [NSData dataWithContentsOfURL:downloadURL]) == nil) {
            
            _filterResults[filterId] = [NSNull null];
        } else {
            
            ASDFilter *filter = [self filterForData:data response:[downloadTask response] filterId:filterId error:nil];
            _filterResults[filterId] = filter;
        }
        
        if (!_handleBackground && _filterResults.count == _obtainFilterTasks.count) {
            _responseBlock(); // if app in active mode, we call block for transferring of the result to delegate
        }
    }
}

@end
