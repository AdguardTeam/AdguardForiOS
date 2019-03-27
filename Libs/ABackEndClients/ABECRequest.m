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
#import "ABECRequest.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ADomain/ADomain.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECRequest
/////////////////////////////////////////////////////////////////////

@interface ABECRequest()

@end

@implementation ABECRequest

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval{
    
    self = [super initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval]; // [super _init_];
    if (self)
    {
        // Marking of request, that request is from Adguard.
        [self setValue:[ADProductInfo userAgentString] forHTTPHeaderField:@"User-Agent"];
    }
    
    return self;
}

+ (NSURLRequest*)postRequestForURL:(NSURL *)theURL parameters:(NSDictionary *)parameters{
    
    @autoreleasepool {
        
        ABECRequest *request = [[ABECRequest alloc] initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:ABEC_BACKEND_READ_TIMEOUT];
        
        if (request) {
            
            [request setHTTPMethod:@"POST"];
            
            if (parameters.count){
                
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setHTTPBody:[[ABECRequest createStringFromParameters:parameters] dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        
        return request;
    }
}

+ (id)getRequestForURL:(NSURL *)theURL parameters:(NSDictionary *)parameters{
    
    @autoreleasepool {
        
        if (parameters.count){
            
            NSString *paramString = [NSString isNullOrEmpty:[theURL query]] ? @"?" : @"&";
            paramString = [paramString stringByAppendingString:[ABECRequest createStringFromParameters:parameters]];
            
            theURL = [NSURL URLWithString:[[theURL absoluteString] stringByAppendingString:paramString]];
        }
        
        ABECRequest *request = [[ABECRequest alloc] initWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:ABEC_BACKEND_READ_TIMEOUT];
        
        if (request) {
            
            [request setHTTPMethod:@"GET"];
        }
        
        return request;
    }
}

+ (NSString *)createStringFromParameters:(NSDictionary *)parameters{
    
    static NSCharacterSet *queryCharset;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        NSMutableCharacterSet *newSet = [NSMutableCharacterSet characterSetWithRange:NSMakeRange(0, 32)];
        [newSet addCharactersInRange:NSMakeRange(127, 1)];
        [newSet addCharactersInString:@" \"#%<>[\\]^`{|}/+=&"];
        queryCharset = [[newSet copy] invertedSet];
    });
    
    NSMutableArray *parametersArray = [NSMutableArray arrayWithCapacity:parameters.count];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *value = [[obj description] stringByAddingPercentEncodingWithAllowedCharacters:queryCharset];      
        [parametersArray addObject:[NSString stringWithFormat:@"%@=%@", [key description], value]];
    }];
    
    
    return [parametersArray componentsJoinedByString:@"&"];
    
}

@end
