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

#import <SafariServices/SafariServices.h>
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ACommons/ACNetwork.h"
#import "ADomain/ADomain.h"
#import "AppDelegate.h"
#import "ASDatabase/ASDatabase.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AESFilterConverter.h"
#import "AEUIWelcomePagerDataSource.h"
#import "AEUIMainController.h"

#import "AESharedResources.h"

#define AE_AD_FETCH_UPDATE_STATUS_COUNT         3
#define SAFARI_BUNDLE_ID                        @"com.apple.mobilesafari"
#define SAFARI_VC_BUNDLE_ID                     @"com.apple.SafariViewService"

NSString *AppDelegateStartedUpdateNotification = @"AppDelegateStartedUpdateNotification";
NSString *AppDelegateFinishedUpdateNotification = @"AppDelegateFinishedUpdateNotification";
NSString *AppDelegateFailuredUpdateNotification = @"AppDelegateFailuredUpdateNotification";
NSString *AppDelegateUpdatedFiltersKey = @"AppDelegateUpdatedFiltersKey";

typedef void (^AETFetchCompletionBlock)(UIBackgroundFetchResult);

@interface AppDelegate (){
    
    AETFetchCompletionBlock _fetchCompletion;
    AEUIWelcomePagerDataSource *_welcomePageSource;
    NSArray *_updatedFilters;
}

@end

@implementation AppDelegate

/////////////////////////////////////////////////////////////////////
#pragma mark Application Init
/////////////////////////////////////////////////////////////////////

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
    
    @autoreleasepool {
        
        //------------- Preparing for start application. Stage 1. -----------------
        
        // Registering standart Defaults
        NSDictionary * defs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"]];
        if (defs)
            [[AESharedResources sharedDefaults] registerDefaults:defs];
        
        // Init Logger
        [[ACLLogger singleton] initLogger:[AESharedResources sharedAppLogsURL]];
        
#if DEBUG
        [[ACLLogger singleton] setLogLevel:ACLLDebugLevel];
#endif
        
        DDLogInfo(@"Application started. Version: %@", [ADProductInfo buildVersion]);
        
        DDLogInfo(@"(AppDelegate) Preparing for start application. Stage 1.");
        
        _fetchCompletion = nil;
        self.userDefaultsInitialized = NO;
        
        // Init database
        [[ASDatabase singleton] initDbWithURL:[[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:AE_PRODUCTION_DB]];
        
        //------------ Interface Tuning -----------------------------------
        self.window.backgroundColor = [UIColor whiteColor];
        
        UIPageControl *pageControl = [UIPageControl appearance];
        pageControl.backgroundColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        //----------- Set main navigation controller -----------------------
        if ([[AEService singleton] firstRunInProgress]) {
            
            [[AEService singleton] onReady:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self loadMainNavigationController];
                });
            }];
        }
        else{
            
            [self loadMainNavigationController];
        }
        
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //------------- Preparing for start application. Stage 2. -----------------
    DDLogInfo(@"(AppDelegate) Preparing for start application. Stage 2.");
    
    //------------- If running in interactive mode, then Init/Update User Defaults system and other preparing ------------------
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
        
        
        [self updateDefaultsOnSuccess:^{
            
            DDLogInfo(@"(AAAppDelegate) User Defaults up to date.");
            
            [self launchStageThree];
            
        } onFailure:^{
            
            DDLogError(@"(AAAppDelegate) User Defaults failed on updating.");
            
        }];
    }
    else
        [self launchStageThree];
    
    
    return YES;
}


- (void)launchStageThree{
    
    //------------- Preparing for start application. Stage 3. -----------------
    DDLogInfo(@"(AppDelegate) Preparing for start application. Stage 3.");
    
    
    //------------ Subscribe to Antibanner notification -----------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibannerNotify:) name:ASAntibannerFailuredUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibannerNotify:) name:ASAntibannerFinishedUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibannerNotify:) name:ASAntibannerStartedUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(antibannerNotify:) name:ASAntibannerUpdateFilterRulesNotification object:nil];
    
    //------------ Subscribe to Service notification -----------------------------
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serviceNotify:) name:AEServiceUserFilterRulesChangedNotification object:nil];
    
    
    //------------ Checking DB status -----------------------------
    ASDatabase *dbService = [ASDatabase singleton];
    if (dbService.error) {
        
        DDLogWarn(@"(AppDelegate) Stage 3. DB Error. Panic!");
        //        [self dbFailure];
    }
    else if (!dbService.ready){
        
        DDLogWarn(@"(AppDelegate) Stage 3. DB not ready.");
        [dbService addObserver:self forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
    }
    //--------------------- Start Services ---------------------------
    else{
        
        [[AEService singleton] start];
        DDLogInfo(@"(AppDelegate) Stage 3. Main service started.");
    }
    
    //--------------------- Processing User Notification Action ---------
    //        NSUserNotification *userNotification =
    //        aNotification.userInfo[NSApplicationLaunchUserNotificationKey];
    //        if (userNotification) {
    //            [self userNotificationCenter:nil
    //                 didActivateNotification:userNotification];
    //        }
    
    //---------------------- Set period for checking filters ---------------------
    [self setPeriodForCheckingFilters];
    DDLogInfo(@"(AppDelegate) Stage 3 completed.");
}

- (void)setPeriodForCheckingFilters{
    
    NSTimeInterval interval = (AS_CHECK_FILTERS_UPDATES_PERIOD)/AE_AD_FETCH_UPDATE_STATUS_COUNT;
    if (interval < UIApplicationBackgroundFetchIntervalMinimum) {
        interval = UIApplicationBackgroundFetchIntervalMinimum;
    }
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:interval];
    
}

/////////////////////////////////////////////////////////////////////
#pragma mark Application Delegate Methods
/////////////////////////////////////////////////////////////////////


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    DDLogInfo(@"(AppDelegate) applicationWillResignActive.");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    DDLogInfo(@"(AppDelegate) applicationDidEnterBackground.");
    [AESharedResources synchronizeSharedDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    DDLogInfo(@"(AppDelegate) applicationWillEnterForeground.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    DDLogInfo(@"(AppDelegate) applicationDidBecomeActive.");
    
    [[AEService singleton] onReady:^{
        
        //Entry point for updating of the filters
        [self invalidateAntibanner:NO];
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    DDLogInfo(@"(AppDelegate) applicationWillTerminate.");
    [AESharedResources synchronizeSharedDefaults];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    @autoreleasepool {
        
        DDLogInfo(@"(AppDelegate) application perform Fetch.");
        //Entry point for updating of the filters
        _fetchCompletion = completionHandler;
        
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        
        BOOL viaWiFi = [reach isReachableViaWiFi];
        
        if (!viaWiFi) {
            
            DDLogInfo(@"(AppDelegate - Background Fetch) Cancel fetch. Not via WiFi.");
        }
        
        [[AEService singleton] onReady:^{
            
            if (!(viaWiFi && [self invalidateAntibanner:NO])){
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    if (_fetchCompletion) {
                        
                        DDLogInfo(@"(AppDelegate - Background Fetch) Call fetch Completion.");
                        
                        _fetchCompletion(UIBackgroundFetchResultNoData);
                        _fetchCompletion = nil;
                    }
                });
            }
        }];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    DDLogError(@"(AppDelegate) application Open URL.");
    NSString *appBundleId = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    if (([appBundleId isEqualToString:SAFARI_BUNDLE_ID]
         || [appBundleId isEqualToString:SAFARI_VC_BUNDLE_ID])
        && [url.scheme isEqualToString:ADGUARD_URL_SCHEME]) {
        
        [[AEService singleton] onReady:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    
                    NSString *command = url.host;
                    NSString *path = [url.path substringFromIndex:1];
                    
                    if ([command isEqualToString:AE_URLSCHEME_COMMAND_ADD]) {
                        
                        UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
                        if (nav.viewControllers.count) {
                            AEUIMainController *main = nav.viewControllers[0];
                            if ([main isKindOfClass:[AEUIMainController class]]) {
                                
                                [main addRuleToUserFilter:path];
                            }
                            else{
                                
                                DDLogError(@"(AppDelegate) Can't add rule because mainController is not found.");
                            }
                        }
                    }
                }
                //
            });
        }];
        
        return YES;
    }
    return NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Preferences Updater Methods
/////////////////////////////////////////////////////////////////////

/// Updates User Defaults, and after that runns blocks.
- (void)updateDefaultsOnSuccess:(dispatch_block_t)successBlock onFailure:(dispatch_block_t)failureBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        if (YES){
            
            self.userDefaultsInitialized = YES;
            dispatch_async(dispatch_get_main_queue(), successBlock);
        }
        //        else{
        //
        //            self.userDefaultsInitialized = NO;
        //            dispatch_async(dispatch_get_main_queue(), failureBlock);
        //        }
    });
}

/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods
/////////////////////////////////////////////////////////////////////

- (BOOL)invalidateAntibanner:(BOOL)fromUI {
    
    @synchronized(self) {
        
        // Begin update process (Downloading step)
        
        NSDate *lastCheck = [[AESharedResources sharedDefaults]
                             objectForKey:AEDefaultsCheckFiltersLastDate];
        if (fromUI || !lastCheck ||
            ([lastCheck timeIntervalSinceNow] * -1) >=
            AS_CHECK_FILTERS_UPDATES_PERIOD) {
            
            [self updateStartedNotify];
            
            if (fromUI) {
                DDLogInfo(@"(AppDelegate) Update process started from UI.");
            }
            else{
                DDLogInfo(@"(AppDelegate) Update process started by timer.");
            }
            
            [[[AEService singleton] antibanner] beginTransaction];
            DDLogInfo(@"(AppDelegate) Begin of the Update Transaction from - invalidateAntibanner.");
            
            [[[AEService singleton] antibanner] startUpdating];
            return YES;
        }
        
        DDLogInfo(@"(AppDelegate) Update process NOT started by timer. Time period from previous update too small.");
        
        
        return NO;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Observing notifications
/////////////////////////////////////////////////////////////////////

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    // DB DELAYED READY
    ASDatabase * dbService = [ASDatabase singleton];
    if ([object isEqual:dbService]
        && [keyPath isEqualToString:@"ready"]
        && dbService.ready) {
        
        [dbService removeObserver:self forKeyPath:@"ready"];
        
        //--------------------- Start Services ---------------------------
        [[AEService singleton] start];
        DDLogInfo(@"(AppDelegate) DB service ready. Main service started.");
        
        return;
    }
    
    // Default processing
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Notifications observers
/////////////////////////////////////////////////////////////////////

- (void)antibannerNotify:(NSNotification *)notification {
    
    // Update filter rule
    if ([notification.name isEqualToString:ASAntibannerUpdateFilterRulesNotification]){
        
        [[AEService singleton] reloadContentBlockingJsonASyncWithBackgroundUpdate:(_fetchCompletion != nil) completionBlock:^(NSError *error) {
            
            if (error) {
                
                [[[AEService singleton] antibanner] rollbackTransaction];
                DDLogInfo(@"(AppDelegate) Rollback of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.");
                
                [self updateFailuredNotify];
                
                if (self.navigation.topViewController && [[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [ACSSystemUtils showSimpleAlertForController:self.navigation.topViewController withTitle: NSLocalizedString(@"Error", @"(AEUISubscriptionController) Alert title. When converting rules process finished in foreground updating.") message:NSLocalizedString(@"Filters cannot be loaded into Safari. Try to clear your rules and the whitelist, or change the set of used filters.", @"(AppDegelate) Alert message. When converting rules process finished in foreground updating.")];
                    });
                }
            }
            else{
                
                // Success antibanner updated from backend
                
                [[AESharedResources sharedDefaults] setObject:[NSDate date] forKey:AEDefaultsCheckFiltersLastDate];
                
                [[[AEService singleton] antibanner] endTransaction];
                DDLogInfo(@"(AppDelegate) End of the Update Transaction from ASAntibannerUpdateFilterRulesNotification.");
                
                [self updateFinishedNotify];
            }
        }];
    }
    // Update started
    else if ([notification.name
              isEqualToString:ASAntibannerStartedUpdateNotification]) {
        
        // turn on network activity indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    // Update performed
    else if ([notification.name
              isEqualToString:ASAntibannerFinishedUpdateNotification]) {
        
        _updatedFilters = [notification userInfo][ASAntibannerUpdatedFiltersKey];
        
        [[AEService singleton] onReloadContentBlockingJsonComplete:^{
            
            if ([[[AEService singleton] antibanner] inTransaction]) {
                // Success antibanner updated from backend
                [[AESharedResources sharedDefaults] setObject:[NSDate date] forKey:AEDefaultsCheckFiltersLastDate];
                [[[AEService singleton] antibanner] endTransaction];
                DDLogInfo(@"(AppDelegate) End of the Update Transaction from ASAntibannerFinishedUpdateNotification.");
                
                [self updateFinishedNotify];
            }
            
            
            // Special update case (in background).
            [self callCompletionHandler:UIBackgroundFetchResultNewData];
        }];
        
        // turn off network activity indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    // Update failed
    else if ([notification.name
              isEqualToString:ASAntibannerFailuredUpdateNotification]) {
        
        if ([[[AEService singleton] antibanner] inTransaction]) {
            
            [[[AEService singleton] antibanner] rollbackTransaction];
            DDLogInfo(@"(AppDelegate) Rollback of the Update Transaction from ASAntibannerFailuredUpdateNotification.");
        }
        
        [self updateFailuredNotify];
        
        // Special update case.
        [self callCompletionHandler:UIBackgroundFetchResultNewData];
        
        // turn off network activity indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Update Manager methods (private)
/////////////////////////////////////////////////////////////////////

- (void)updateStartedNotify{
    
    [self callOnMainQueue:^{
        
        DDLogDebug(@"(AppDelegate) Started update process.");
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateStartedUpdateNotification object:self];
    }];
}

- (void)updateFailuredNotify{
    
    
    [self callOnMainQueue:^{
        
        DDLogDebug(@"(AppDelegate) Failured update process.");
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateFailuredUpdateNotification object:self];
        
    }];
    
}

- (void)updateFinishedNotify{
    
    [self callOnMainQueue:^{
        
        DDLogDebug(@"(AppDelegate) Finished update process.");
        NSArray *metas = @[];
        
        if (_updatedFilters) {
            metas = _updatedFilters;
            _updatedFilters = nil;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AppDelegateFinishedUpdateNotification object:self userInfo:@{AppDelegateUpdatedFiltersKey: metas}];
    }];
}

- (void)callCompletionHandler:(UIBackgroundFetchResult)result{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_fetchCompletion) {
            DDLogInfo(@"(AppDelegate - Background Fetch) Call fetch Completion.");
            _fetchCompletion(result);
            _fetchCompletion = nil;
        }
        
    });
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helpper Methods (private)
/////////////////////////////////////////////////////////////////////

- (void)loadMainNavigationController {
    
    UIViewController *nav = [[self mainStoryborad]
                             instantiateViewControllerWithIdentifier:@"mainNavigationController"];
    
    if (nav) {
        
        [UIView transitionWithView:self.window
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.window.rootViewController = nav;
                        }
                        completion:nil];
        return;
    }
    
    DDLogError(@"(AppDelegate) Can't load main navigation controller");
}

- (UIStoryboard *)mainStoryborad{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *storyboardName = [bundle objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
    return [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
}

- (void)callOnMainQueue:(dispatch_block_t)block{
    
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (currentQueue == mainQueue) {
        block();
    }
    else{
        dispatch_sync(mainQueue, block);
    }
    
}

@end
