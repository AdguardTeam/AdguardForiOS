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
#import "AESharedResources.h"
#import "ACommons/ACLang.h"

NSString *AEDefaultsAdguardEnabled = @"AEDefaultsAdguardEnabled";
NSString *AEDefaultsFirstRunKey = @"AEDefaultsFirstRunKey";

NSString *AEDefaultsCheckFiltersLastDate = @"AEDefaultsCheckFiltersLastDate";
NSString *AEDefaultsJSONMaximumConvertedRules = @"AEDefaultsJSONMaximumConvertedRules";
NSString *AEDefaultsJSONConvertedRules = @"AEDefaultsJSONConvertedRules";
NSString *AEDefaultsJSONRulesForConvertion = @"AEDefaultsJSONRulesForConvertion";
NSString *AEDefaultsJSONRulesOverlimitReached = @"AEDefaultsJSONRulesOverlimitReached";
NSString *AEDefaultsJSONConverterOptimize = @"AEDefaultsJSONConverterOptimize";

#define AES_BLOCKING_CONTENT_RULES_RESOURCE     @"blocking-content-rules.json"
#define AES_HOST_APP_USERDEFAULTS               @"host-app-userdefaults.data"

/////////////////////////////////////////////////////////////////////
#pragma mark - AESharedResources
/////////////////////////////////////////////////////////////////////

@implementation AESharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize
/////////////////////////////////////////////////////////////////////

static NSURL *_containerFolderUrl;
static NSUserDefaults *_sharedUserDefaults;

+ (void)initialize{
    
    if (self == [AESharedResources class]) {
        
        _containerFolderUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:AE_SHARED_RESOURCES_GROUP];
        _sharedUserDefaults = [[NSUserDefaults alloc] initWithSuiteName:AE_SHARED_RESOURCES_GROUP];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

+ (NSURL *)sharedResuorcesURL{
    
    return _containerFolderUrl;
}

+ (NSURL *)sharedAppLogsURL{
    
    NSString *ident = [[NSBundle bundleForClass:[self class]] bundleIdentifier];
    
    NSURL *logsUrl = [AESharedResources sharedLogsURL];
    if (ident) {
        logsUrl = [logsUrl URLByAppendingPathComponent:ident];
    }
    
    return logsUrl;
}

+ (NSURL *)sharedLogsURL{
    
    return [_containerFolderUrl URLByAppendingPathComponent:@"Logs"];
}

- (NSData *)blockingContentRules{
    
    return [self loadDataFromFileRelativePath:AES_BLOCKING_CONTENT_RULES_RESOURCE];
}

- (void)setBlockingContentRules:(NSData *)blockingContentRules{

    [self saveData:blockingContentRules toFileRelativePath:AES_BLOCKING_CONTENT_RULES_RESOURCE];
}

+ (NSUserDefaults *)sharedDefaults{
    
    return _sharedUserDefaults;
}

+ (void)synchronizeSharedDefaults{
    
    [_sharedUserDefaults synchronize];
}

+ (void)sharedDefaultsSetTempKey:(NSString *)key value:(id)value{
    
    if (!(key && value)) {
        [[NSException argumentException:@"key or value - nil"] raise];
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSMutableDictionary *dict = [[_sharedUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
            if (dict) {
                
                dict[key] = value;
                [_sharedUserDefaults setVolatileDomain:dict forName:NSArgumentDomain];
            }
        }
    }
    
}

+ (id)sharedDefaultsValueOfTempKey:(NSString *)key{
    
    if (!key) {
        return nil;
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSDictionary *dict = [_sharedUserDefaults volatileDomainForName:NSArgumentDomain];
            if (dict) {

                return dict[key];
            }
        }
    }
    
    return nil;
}

+ (void)sharedDefaultsRemoveTempKey:(NSString *)key{

    if (!key) {
        return;
    }
    
    @synchronized(_sharedUserDefaults) {
        @autoreleasepool {
            
            NSMutableDictionary *dict = [[_sharedUserDefaults volatileDomainForName:NSArgumentDomain] mutableCopy];
            if (dict) {
                
                [dict removeObjectForKey:key];
                [_sharedUserDefaults setVolatileDomain:dict forName:NSArgumentDomain];
            }
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Storage methods (private)
/////////////////////////////////////////////////////////////////////


- (NSData *)loadDataFromFileRelativePath:(NSString *)relativePath{
    
    if (!relativePath) {
        [[NSException argumentException:@"relativePath"] raise];
    }
    
    @autoreleasepool {
        if (_containerFolderUrl) {
            
            NSURL *dataUrl = [_containerFolderUrl URLByAppendingPathComponent:relativePath];
            if (dataUrl) {
                ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:[dataUrl path]];
                if ([locker lock]) {
                    
                    NSData *data = [NSData dataWithContentsOfURL:dataUrl];
                    
                    [locker unlock];
                    
                    return data;
                }
            }
        }
        
        return nil;
    }
}

- (BOOL)saveData:(NSData *)data toFileRelativePath:(NSString *)relativePath{

    if (!(data && relativePath)) {
        [[NSException argumentException:@"data/relativePath"] raise];
    }
    
    @autoreleasepool {
        if (_containerFolderUrl) {
            
            NSURL *dataUrl = [_containerFolderUrl URLByAppendingPathComponent:relativePath];
            if (dataUrl) {
                ACLFileLocker *locker = [[ACLFileLocker alloc] initWithPath:[dataUrl path]];
                if ([locker lock]) {
                    
                    BOOL result = [data writeToURL:dataUrl atomically:YES];
                    
                    [locker unlock];
                    
                    return result;
                }
            }
        }
        
        return NO;;
    }
}

@end

