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

#import "ABECSubscription.h"
#import "ACNUrlUtils.h"
#import "AERDomainFilterRule.h"

#define ABECSubscriptionErrorDomain @"ABECSubscriptionErrorDomain"

@interface ABECSubscription()
    
    @property (nonatomic) dispatch_queue_t workingQueue;
@end

@implementation ABECSubscription

+ (ABECSubscription *)singleton{
    
    static ABECSubscription *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singleton = [ABECSubscription new];
        singleton.workingQueue = dispatch_queue_create("subscription_download_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return singleton;
}

- (void)downloadSubscription:(NSString *)url completionBlock:(void (^)(NSArray *, NSDictionary *))completionBlock errorBlock:(void (^)(NSError *))errorBlock {
    
    dispatch_async(self.workingQueue, ^{
        
        NSError* error = nil;
        
        NSString *fullText =  [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:&error];
        
        if(error) {
            errorBlock([[NSError alloc] initWithDomain:ABECSubscriptionErrorDomain code:ABECSubscriptionErrorCodeNetworkError userInfo:error.userInfo]);
            return;
        }
        
        NSArray* rules;
        NSDictionary* hosts;
        
        if(![self parseText:fullText rules:&rules hosts:&hosts]) {
            
            errorBlock([[NSError alloc] initWithDomain:ABECSubscriptionErrorDomain code:ABECSubscriptionErrorCodeParseError userInfo:nil]);
            return;
        }
        
        completionBlock(rules, hosts);
    });
}


#pragma mark private methods

- (BOOL) parseText:(NSString*) text rules:(NSArray**) rules hosts:(NSDictionary**) hosts {
    
    NSMutableArray *resultRules = [NSMutableArray new];
    NSMutableDictionary *resultHosts = [NSMutableDictionary new];
    
    NSArray* components = [text componentsSeparatedByCharactersInSet: NSCharacterSet.newlineCharacterSet];
    
    for (NSString *item in components) {
        
        @autoreleasepool {
            NSString *candidate = [item stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
            if (candidate.length && ![candidate hasPrefix:@"!"] && ![candidate hasPrefix:@"#"]) {
                
                NSString* ip;
                NSString* domain;

                if ([ACNUrlUtils checkHostsLine:candidate ip:&ip domain:&domain]) {
                    resultHosts[domain] = ip;
                    continue;
                }
                else if([AERDomainFilterRule isValidRuleText:candidate]) {
                    [resultRules addObject:candidate];
                    continue;
                }
            }
        }
        
    }
    
    if(resultRules.count)
        *rules = [resultRules copy];
    
    if(resultHosts.count)
        *hosts = [resultHosts copy];
    
    return (*rules).count || (*hosts).count;
}

@end
