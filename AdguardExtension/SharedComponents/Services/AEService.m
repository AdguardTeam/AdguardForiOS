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
#import <SafariServices/SafariServices.h>
#import "AEService.h"
#import "ACommons/ACLang.h"
#import "AppDelegate.h"
#import "AESAntibanner.h"
#import "ASDFilterObjects.h"
#import "AESFilterConverter.h"
#import "AESharedResources.h"
#import "AEFilterRuleSyntaxConstants.h"
#import "AEWhitelistDomainObject.h"
#import "AEInvertedWhitelistDomainsObject.h"
#import <mach/mach.h>

#import "Adguard-Swift.h"

NSString *AEServiceErrorDomain = @"AEServiceErrorDomain";
NSString *AESUserInfoRuleObject = @"AESUserInfoRuleObject";

/////////////////////////////////////////////////////////////////////
#pragma mark - AEServices
/////////////////////////////////////////////////////////////////////

typedef enum {
    
    RFNotReadyType = 0,
    RFAntibannerInstalledType = 1,
    RFAntibannerReadyType = 2,
    
    RFAllReadyType = RFAntibannerInstalledType | RFAntibannerReadyType
    
} ReadyFlagType;

@interface AEService (){
    
    dispatch_queue_t workQueue;
    AESAntibanner *antibanner;
    id<AESharedResourcesProtocol> _sharedResources;
    ContentBlockerService *_contentBlockerService;
    
    NSMutableArray *_onReadyBlocks;
    ReadyFlagType _readyFlags;
    NSLock *_readyLock;
    
    NSMutableArray *_onReloadContentBlockingJsonBlocks;
    BOOL _reloadContentBlockingJsonComplete;
    NSLock *_reloadContentBlockingJsonLock;
    
    BOOL started;
    
    NSString *_unexpectedErrorMessage;
    
    BOOL _firstRunInProgress;
}

@end

@implementation AEService

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithContentBlocker: (ContentBlockerService*) contentBlockerService
                   resources:(id<AESharedResourcesProtocol>)resources
                  networking:(id)networking{
    
    
    self = [super init];
    if (self) {
        
        workQueue = dispatch_queue_create("AAService", DISPATCH_QUEUE_SERIAL);
        
        _contentBlockerService = contentBlockerService;
        _sharedResources = resources;
        
        _unexpectedErrorMessage = ACLocalizedString(@"support_unexpected_error", @"(AEService) The default message for an unknown error.");
        
        //------------ Checking First Running -----------------------------
        [self checkFirstRunning];
        
        // Subscribing to Antibanner notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibanNotify:) name:ASAntibannerReadyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibanNotify:) name:ASAntibannerInstalledNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibanNotify:) name:ASAntibannerNotInstalledNotification object:nil];
        
        
        antibanner = [[AESAntibanner alloc] initWithNetworking: networking];
        _readyLock = [NSLock new];
        _reloadContentBlockingJsonLock = [NSLock new];
        _reloadContentBlockingJsonComplete = YES;
        _contentBlockerService.antibanner = antibanner;
    }
    
    return self;
}

- (void)dealloc{
    
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (BOOL)firstRunInProgress {
    return _firstRunInProgress;
}

- (void)start{
    
    @synchronized(self){
        
        if (started) return;
        
        // Enabling antibanner service
        if (_firstRunInProgress) {
            [antibanner beginTransaction];
        }
        antibanner.enabled = YES;
        
        started = YES;
    }
}

- (void)stop{
    
    @synchronized(self){
        
        if (!started) return;
        
        _sharedResources = nil;
        
        // Disabling antibanner service
        antibanner.enabled = NO;
        
        _readyFlags = RFNotReadyType;
        
        started = NO;
    }
}

- (AESAntibanner *)antibanner{

    return antibanner;
}

- (void)onReady:(void (^)(void))block{
    
//    DDLogDebugTrace();
    [_readyLock lock];

    if (_readyFlags == RFAllReadyType) {

        DDLogDebug(@"dispatch onReady block");
        dispatch_async(workQueue, block);
    }
    else {
        
        if (!_onReadyBlocks) {
            _onReadyBlocks = [NSMutableArray new];
        }
        
        DDLogDebug(@"delay onReady block");
        [_onReadyBlocks addObject:[block copy]];
    }
    [_readyLock unlock];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Notifications observers
/////////////////////////////////////////////////////////////////////////

- (void)antibanNotify:(NSNotification *)notification{
    
    // Success antibanner installed (first run)
    if ([notification.name isEqualToString:ASAntibannerInstalledNotification]){
        
        DDLogDebug(@"(AEService) ASAntibannerInstalledNotification received");
        
#ifndef APP_EXTENSION
        UIBackgroundTaskIdentifier backroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
#endif
            
        [_contentBlockerService reloadJsonsWithBackgroundUpdate:NO completion:^(NSError * _Nullable error) {
            
            // If error then disable all installed filters
            if (error) {

                for (ASDFilterMetadata *item in [antibanner filters]) {
                    if ([item.filterId integerValue] != ASDF_USER_FILTER_ID && [item.enabled boolValue]) {
                        [antibanner setFilter:item.filterId enabled:NO fromUI:NO];
                    }
                }

                [_contentBlockerService reloadJsonsWithBackgroundUpdate:NO completion:^(NSError * _Nullable error) {
                    // we hope that no errors in this place. :)
                    if (error){
                        [antibanner rollbackTransaction];
                    }
                    else{
                        [self checkForServiceReady:RFAntibannerInstalledType];
                    }
                    
#ifndef APP_EXTENSION
                    [[UIApplication sharedApplication] endBackgroundTask:backroundTaskID];
#endif
                }];
                
                return;
            }

            // If no errors
            [self checkForServiceReady:RFAntibannerInstalledType];
        }];
    }
    // Antibanner ready
    else if ([notification.name isEqualToString:ASAntibannerReadyNotification]){
        
        DDLogDebug(@"(AEService) ASAntibannerReadyNotification received");
        // if this is not first running of the application we simulate antibanner "installed" notification
        if (!self.firstRunInProgress) {
            [self checkForServiceReady:RFAntibannerInstalledType];
        }
         
        [self checkForServiceReady:RFAntibannerReadyType];
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////////

- (void)savePermanentlyCountersOfConversion{

    //Permanently save current converted rules in user defaults
    
    DDLogInfo(@"(AEService) Permanently saving current converted rules in user defaults.");
    NSNumber *value = [AESharedResources sharedDefaultsValueOfTempKey:AEDefaultsJSONConvertedRules];
    if (value) {
        [[_sharedResources sharedDefaults] setObject:value forKey:AEDefaultsJSONConvertedRules];
        DDLogInfo(@"Rules: %@", value);
    }
    value = [AESharedResources sharedDefaultsValueOfTempKey:AEDefaultsJSONRulesForConvertion];
    if (value) {
        [[_sharedResources sharedDefaults] setObject:value forKey:AEDefaultsJSONRulesForConvertion];
        DDLogInfo(@"From rules: %@", value);
    }
    
    value = [AESharedResources sharedDefaultsValueOfTempKey:AEDefaultsJSONRulesOverlimitReached];
    if (value) {
        [[_sharedResources sharedDefaults] setBool:[value boolValue] forKey:AEDefaultsJSONRulesOverlimitReached ];
    }
}

- (void)removeTempCountersOfConversion {
    
    [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONConvertedRules];
    [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONRulesForConvertion];
    [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONRulesOverlimitReached];
}

- (void)checkForServiceReady:(ReadyFlagType)readyFlag{

    [_readyLock lock];
    
    _readyFlags |= readyFlag;
    if (_readyFlags == RFAllReadyType) {

        if (_firstRunInProgress) {
            // Set first run to NO
            [[_sharedResources sharedDefaults]
             setBool:NO
             forKey:AEDefaultsFirstRunKey];
            [antibanner endTransaction];
        }
        
        [self pushReadyBlocksToWorkingQueue];
    }
    [_readyLock unlock];
}

- (void)pushReadyBlocksToWorkingQueue{

//    DDLogDebugTrace();
    
    for (void (^ block)() in _onReadyBlocks) {
       
        dispatch_async(workQueue, block);
    }
    
    [_onReadyBlocks removeAllObjects];
    _onReadyBlocks = nil;
}

// If application is launched first time.
- (void)checkFirstRunning {
    @autoreleasepool {
        // check app first run
        BOOL firstRun = [[_sharedResources sharedDefaults]
                         boolForKey:AEDefaultsFirstRunKey];
        
        if (firstRun) {
            _firstRunInProgress = YES;
        }
    }
}

- (AESFilterConverter *)createConverterToJsonWithError:(NSError **)error {
    
    AESFilterConverter *converterToJSON = [AESFilterConverter new];
    if (!converterToJSON) {
        DDLogError(@"(AEService) Can't initialize converter to JSON format!");
        NSString *errorDescription = ACLocalizedString(@"json_converting_error", @"(AEService) Service errors descriptions");
        if (error != nil) {
            *error = [NSError errorWithDomain:AEServiceErrorDomain code:AES_ERROR_UNSUPPORTED_RULE userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
        }
    }
    return converterToJSON;
}

@end
