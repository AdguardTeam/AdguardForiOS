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

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ACommons/ACLang.h"
#import "ASDatabase/ASDatabase.h"
#import "AESharedResources.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AEWhitelistDomainObject.h"
#import "ASDFilterObjects.h"
#import "AEInvertedWhitelistDomainsObject.h"
#import "Adguard-Swift.h"

#define USER_FRIENDLY_DELAY     0.5

NSString *AEActionErrorDomain = @"AEActionErrorDomain";
#define AE_ACTION_ERROR_NODEFAULTS     100
#define AE_ACTION_ERROR_NODB           200


@interface ActionViewController (){
    
    AESharedResources *_sharedResources;
    AEService *_aeService;
    SafariService *_safariService;
    ContentBlockerService *_contentBlockerService;
    AESSupport *_support;
    
    NSURL *_url;
    BOOL _injectScriptSupported;
    NSString *_host;
    NSURL *_iconUrl;
    BOOL _enabled;
    NSMutableArray *_observerObjects;
    ActionExtensionMainController __weak *_mainController;
}

//@property(strong,nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ActionViewController

/////////////////////////////////////////////////////////////////////
#pragma mark Class Methods
/////////////////////////////////////////////////////////////////////

+ (BOOL) isHostInInvertedWhitelist:(NSString *)host {
    
    @autoreleasepool {
        
        AEInvertedWhitelistDomainsObject *invertedDomainsObj = [AESharedResources new].invertedWhitelistContentBlockingObject;
        
        __block BOOL found = NO;
        
        [invertedDomainsObj.domains enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj caseInsensitiveCompare:host] == NSOrderedSame) {
                found = YES;
                *stop = YES;
            }
        }];
        
        return found;
    }
}

+ (AEWhitelistDomainObject *)domainObjectIfExistsFromContentBlockingWhitelistFor:(NSString *)host{
    
    @autoreleasepool {
        
        DDLogDebug(@"(ActionViewController) domainObjectIfExistsFromContentBlockingWhitelistFor:\"%@\"", host);
        NSArray *rules = [[AESharedResources new] whitelistContentBlockingRules];
        
        return [self domainObjectIfExists:host inRules:rules];
    }
}

+ (AEWhitelistDomainObject *)domainObjectIfExists:(NSString *)host inRules:(NSArray*) rules {
    
    rules = [rules
             filteredArrayUsingPredicate:
             [NSPredicate
              predicateWithFormat:@"ruleText CONTAINS[cd] %@",
              host]];
    
    if (rules.count) {
        
        AEWhitelistDomainObject *obj;
        for (ASDFilterRule *rule in rules) {
            obj = [[AEWhitelistDomainObject alloc] initWithRule:rule];
            if (obj) {
                break;
            }
        }
        
        return obj;
    }
    
    return nil;
}


/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods
/////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self startProcessing];

    // Get the item[s] we're handling from the extension context.

    self.navigationController.navigationBar.shadowImage = [UIImage new];

    _sharedResources = [AESharedResources new];
    _safariService = [[SafariService alloc] initWithResources:_sharedResources];
    _contentBlockerService = [[ContentBlockerService alloc] initWithResources:_sharedResources safariService:_safariService];
    _aeService = [[AEService alloc] initWithContentBlocker:_contentBlockerService resources:_sharedResources];
    
    _support = [[AESSupport alloc] initWithResources:_sharedResources safariSevice:_safariService aeService:_aeService];

    self.title = LocalizationNotNeeded(AE_PRODUCT_NAME);

    __block NSString *errorMessage = ACLocalizedString(@"support_error_safari_extension", @"(Action Extension - ActionViewController) Some errors when starting.");

    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;

    ASSIGN_WEAK(self);

    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *results, NSError *error) {

            ASSIGN_STRONG(self);

            NSDictionary *theDict = results[NSExtensionJavaScriptPreprocessingResultsKey];
            NSString *urlString = theDict[@"urlString"];
            if (urlString) {
                USE_STRONG(self)->_url = [NSURL URLWithString:urlString];
            }
            USE_STRONG(self)->_host = [USE_STRONG(self)->_url hostWithPort];
            //            _host = url.host;x

            USE_STRONG(self)->_injectScriptSupported = [theDict[@"injectScriptSupported"] boolValue];

            if (error) {

                DDLogError(@"(ActionViewController) Error of obtaining page url from Safari:\n%@", [error localizedDescription]);
            }
            else if ([NSString isNullOrEmpty:_host]) {

                DDLogError(@"(ActionViewController) Error of obtaining page url from Safari: url is empty.");
                errorMessage = ACLocalizedString(@"hostname_obtaining_error", @"(Action Extension - ActionViewController) Can't obtain hostname when starting.");
            }
            else {

                NSError *error = [USE_STRONG(self) prepareDataModel];
                if (error) {

                    if (error.code == AE_ACTION_ERROR_NODB) {
                        errorMessage = error.localizedDescription;
                    }
                }
                else {
                    
                    [USE_STRONG(self)->_aeService onReady:^{

                        // Add observers for application notifications
                        USE_STRONG(self)->_observerObjects = [NSMutableArray arrayWithCapacity:2];

                        id observerObject = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

                            [AESharedResources synchronizeSharedDefaults];
                        }];
                        if (observerObject) {
                            [USE_STRONG(self)->_observerObjects addObject:observerObject];
                        }
                        observerObject = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

                            [AESharedResources synchronizeSharedDefaults];
                        }];
                        if (observerObject) {
                            [USE_STRONG(self)->_observerObjects addObject:observerObject];
                        }
                        //--------------------------------------------

                        USE_STRONG(self)->_iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/favicon.ico", USE_STRONG(self)->_url.scheme, [USE_STRONG(self)->_url hostWithPort]]];

                        [USE_STRONG(self) startProcessing];

                    }];

                    return;
                }
            }
            //done on error
            [USE_STRONG(self) stopProcessingWithMessage:errorMessage];
        }];

        return;
    }

    //done on error
    [self stopProcessingWithMessage:errorMessage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    
    DDLogDebug(@"(ActionViewController) run dealloc.");
    
    for (id observer in _observerObjects) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

- (NSError *)prepareDataModel{
    
    // Init Logger
    [[ACLLogger singleton] initLogger:[AESharedResources sharedAppLogsURL]];
    
#if DEBUG
    [[ACLLogger singleton] setLogLevel:ACLLDebugLevel];
#endif
    
    // Registering standart Defaults
    NSString *appPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"../../"];
    NSDictionary * defs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:appPath] pathForResource:@"defaults" ofType:@"plist"]];
    if (defs){
        
        DDLogInfo(@"(ActionViewController) default.plist loaded!");
        
        [[_sharedResources sharedDefaults] registerDefaults:defs];
    }
    else{
        
        DDLogError(@"(ActionViewController) default.plist was not loaded.");
        return [NSError errorWithDomain:AEActionErrorDomain
                                   code:AE_ACTION_ERROR_NODEFAULTS
                               userInfo:nil];
    }
    //-------------------------------
    
    // Init database
    NSURL *dbURL = [[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:AE_PRODUCTION_DB];

    [[ASDatabase singleton] initDbWithURL:dbURL upgradeDefaultDb:NO];

    if ([[ASDatabase singleton] error]) {
        
        DDLogError(@"(ActionViewController) production DB was not created before.");
        NSString *messageFormat =
        ACLocalizedString(@"action_extension_no_configuration_message_format",
                          @"(Action Extension - ActionViewController) An error which occurs if the action extension is launched before the main Adguard app.");
        return [NSError errorWithDomain:AEActionErrorDomain
                                   code:AE_ACTION_ERROR_NODB
                               userInfo:@{NSLocalizedDescriptionKey : [NSString stringWithFormat:messageFormat, AE_PRODUCT_NAME, AE_PRODUCT_NAME]
                                          }];
    }
    
    ASSIGN_WEAK(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ASSIGN_STRONG(self);
        
        //------------ Checking DB status -----------------------------
        ASDatabase *dbService = [ASDatabase singleton];
        if (dbService.error) {
            
            //        [self dbFailure];
        }
        else if (!dbService.ready){
            
            [dbService addObserver:USE_STRONG(self) forKeyPath:@"ready" options:NSKeyValueObservingOptionNew context:nil];
        }
        //--------------------- Start Services ---------------------------
        else
            [USE_STRONG(self)->_aeService start];
        
    });
    
    return nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Navigations
/////////////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"loader"]) {
        
        _mainController = (ActionExtensionMainController *)segue.destinationViewController;
        
        _mainController.resources = _sharedResources;
        _mainController.safariService = _safariService;
        _mainController.contentBlockerService = _contentBlockerService;
        _mainController.support = _support;
        
        _mainController.domainName = _host;
        _mainController.url = _url;
        _mainController.iconUrl = _iconUrl;
        _mainController.domainEnabled = _enabled;
        _mainController.injectScriptSupported = _injectScriptSupported;
        
        _mainController.enableChangeDomainFilteringStatus = YES;
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
        [_aeService start];
        
        return;
    }
    
    // Default processing
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (Private)
/////////////////////////////////////////////////////////////////////

- (void)stopProcessingWithMessage:(NSString *)message{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadIndicator stopAnimating];
        [self.loadIndicator setHidden:YES];
        if (message) {
            self.messageLabel.text = message;
        }
        [self.messageLabel setHidden:NO];
    });
}

- (void)startProcessing{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.loadIndicator startAnimating];
        [self.loadIndicator setHidden:NO];
        self.messageLabel.text = @"";
        [self.messageLabel setHidden:YES];
    });
    
    BOOL inverted = [_sharedResources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist];
    
    if(inverted) {
        
        _enabled = [ActionViewController isHostInInvertedWhitelist:_host];
    }
    else {
       
        _enabled = [ActionViewController domainObjectIfExistsFromContentBlockingWhitelistFor:_host] == nil;
    }
    
    ASSIGN_WEAK(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        ASSIGN_STRONG(self);
        [USE_STRONG(self).actionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    });
    
}

@end
