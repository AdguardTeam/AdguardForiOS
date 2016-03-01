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

NSString *ABECPlatformKey               = @"ABECPlatformKey";

NSString *ABECFilterParserKey           = @"ABECFilterParserKey";
NSString *ABECFilterVersionParserKey    = @"ABECFIlterVersionParserKey";
NSString *ABECFilterMetaParserKey       = @"ABECFilterMetaParserKey";
NSString *ABECFilterGroupMetaParserKey  = @"ABECFilterGroupMetaParserKey";

NSString *ABECFilterUrlKey              = @"ABECFilterUrlKey";
NSString *ABECFIlterVersionUrlKey       = @"ABECFIlterVersionUrlKey";
NSString *ABECFilterMetaUrlKey          = @"ABECFILTERMetaUrlKey";
NSString *ABECFilterGroupMetaUrlKey     = @"ABECFilterGroupMetaUrlKey";


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
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

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
    
    ABECRequest *sURLRequest = [ABECRequest getRequestForURL:url parameters:nil];
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];
    
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

- (ABECRequest *)requestForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId{
    
    if (!applicationId || !affiliateId)
        return nil;
    
    return [ABECRequest
            getRequestForURL:filterUrl
            parameters:@{
                         @"app_id": applicationId,
                         @"webmaster_id": affiliateId,
                         @"filterid": [NSString stringWithFormat:@"%lu", (unsigned long)filterId]
                         }];

}

- (ASDFilter *)filterForApp:(NSString *)applicationId affiliateId:(NSString *)affiliateId filterId:(NSUInteger)filterId{

    if (!applicationId || !affiliateId)
        return nil;
    
    ABECRequest *sURLRequest = [self requestForApp:applicationId affiliateId:affiliateId filterId:filterId];
    
    NSURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:sURLRequest returningResponse:&response error:&error];
    
    // here we check for any returned NSError from the server, "and" we also check for any http response errors
    if (error != nil)
        DDLogError(@"Error loading filter rules:%@", [error localizedDescription]);
    
    else {
        // check for any response errors
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if ((([httpResponse statusCode]/100) == 2)) {
            
            
            id<FilterParserProtocol> filterParser = [self parserForKey:ABECFilterParserKey];
            
            filterParser.filterId = @(filterId);
            
            if (![filterParser parseWithData:data]) {
                
                DDLogError(@"Error when loading filter rules (filterId = %lu). Can't parse XML.", (unsigned long)filterId);
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

@end
