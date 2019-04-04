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

#import "AEAUIMainController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "ACommons/ACSystem.h"
#import "AEAUIDomainCell.h"
#import "AEUIUtils.h"
#import "AEWhitelistDomainObject.h"
#import "AEInvertedWhitelistDomainsObject.h"
#import "AESAntibanner.h"
#import "ASDFilterObjects.h"
#import "AESSupport.h"
#import "ABECRequest.h"
#import "ADProductInfo.h"
#import "Adguard-Swift.h"

#ifdef PRO
#import "APVPNManager.h"
#import "APDnsServerObject.h"
#endif

@interface SimpleConfiguration : NSObject<ConfigurationServiceProtocol>

@property id<AESharedResourcesProtocol> resources;
@end

@implementation SimpleConfiguration

- (instancetype)initWithResources:(id<AESharedResourcesProtocol>)resources{
    self = [super init];
    self.resources = resources;
    return self;
}

- (BOOL)darkTheme {
    return [self.resources.sharedDefaults boolForKey:AEDefaultsDarkTheme];
}

@synthesize proStatus;
@synthesize purchasedThroughLogin;

@end

@interface AEAUIMainController()

@property BOOL enabledHolder;
@property id<ThemeServiceProtocol> theme;
@property ContentBlockerService* contentBlocker;

@property IBOutlet UISwitch *enabledSwitch;
@property IBOutlet ThemableLabel *domainLabel;

@property (strong, nonatomic) IBOutletCollection(ThemableLabel) NSArray *themableLabels;


@end

@implementation AEAUIMainController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resources = [AESharedResources new];
    SimpleConfiguration* configuration = [[SimpleConfiguration alloc] initWithResources:self.resources];
    self.theme = [[ThemeService alloc] init:configuration];
    self.safariService = [[SafariService alloc] initWithResources:self.resources];
    self.contentBlocker = [[ContentBlockerService alloc] initWithResources:_resources safariService:_safariService];
    
    self.title = LocalizationNotNeeded(AE_PRODUCT_NAME);
    
    self.enabledSwitch.on = self.domainEnabled;
    _enabledHolder = self.domainEnabled;
    
    self.domainLabel.text = self.domainName;
    
    [_safariService checkStatusWithCompletion:^(BOOL enabled) {
        
        if(!enabled) {
            
            [ACSSystemUtils showSimpleAlertForController:self withTitle:ACLocalizedString(@"common_warning_title", @"(Action Extension - AEAUIMainController) Warning tile") message:ACLocalizedString(@"content_blocker_disabled_format", @"(Action Extension - AEAUIMainController) error occurs when content blocker is disabled.")];
        }
    }];
    
    [_resources.sharedDefaults setBool:YES forKey:AEDefaultsActionExtensionUsed];
    
    [self.theme setupTable:self.tableView];
    [self.theme setupSwitch:self.enabledSwitch];
    [self.theme setupNavigationBar:self.navigationController.navigationBar];
    [self.theme setupLabels:self.themableLabels];
    self.view.backgroundColor = self.theme.backgroundColor;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    DDLogDebug(@"(AEAUIMainController) run dealloc.");
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)toggleStatus:(id)sender {
    
    BOOL newEnabled = [(UISwitch *)sender isOn];
    
    if (newEnabled == self.domainEnabled) {
        
        return;
    }
    
    //check rule overlimit
    if (!self.enableChangeDomainFilteringStatus) {
        [ACSSystemUtils showSimpleAlertForController:self withTitle:ACLocalizedString(@"common_error_title", @"(Action Extension - AEAUIMainController) Error tile") message:ACLocalizedString(@"filter_rules_maximum", @"(Action Extension - AEAUIMainController) error occurs when try turn off filtration on site.")];
        [self.enabledSwitch setOn:self.domainEnabled animated:YES];
        return;
    }
    
    BOOL inverted = [_resources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist];
    
    // disable filtering == remove from inverted whitelist
    if (inverted && self.domainEnabled) {

        ASSIGN_WEAK(self);
        [_contentBlocker removeInvertedWhitelistDomain: _domainName completion:^(NSError * _Nullable error) {
            ASSIGN_STRONG(self);
            [USE_STRONG(self).safariService invalidateBlockingJsonsWithCompletion:^(NSError * _Nullable error) {
                USE_STRONG(self).domainEnabled = NO;
            }];
        }];
    }
    // enable filtering == add to inverted whitelist
    else if (inverted && !self.domainEnabled) {
        
        ASSIGN_WEAK(self);
        [_contentBlocker addInvertedWhitelistDomain: _domainName completion:^(NSError * _Nullable error) {
            ASSIGN_STRONG(self);
            [USE_STRONG(self).safariService invalidateBlockingJsonsWithCompletion:^(NSError * _Nullable error) {
                USE_STRONG(self).domainEnabled = YES;
            }];
        }];
    }
    // disable filtering (add to whitelist)
    else if (self.domainEnabled) {
        
        AEWhitelistDomainObject *domainObject = [[AEWhitelistDomainObject alloc] initWithDomain:self.domainName];
        
        ASSIGN_WEAK(self);
        [self.contentBlocker addWhitelistRule:domainObject.rule completion:^(NSError * _Nullable error) {
            ASSIGN_STRONG(self);
            if (error) {
                [USE_STRONG(self).enabledSwitch setOn:USE_STRONG(self).domainEnabled animated:YES];
            }
            else {
                USE_STRONG(self).domainEnabled = newEnabled;
            }
        }];
    }
    // enable filtering (remove from whitelist)
    else {
        
        AEWhitelistDomainObject *domainObject = [[AEWhitelistDomainObject alloc] initWithDomain:self.domainName];
        
        if (!domainObject) {
            [self.enabledSwitch setOn:self.domainEnabled animated:YES];
            return;
        }
        
        ASSIGN_WEAK(self);
        [self.contentBlocker removeWhitelistRule:domainObject.rule completion:^(NSError * _Nullable error) {
            ASSIGN_STRONG(self);
            if (error) {
                [USE_STRONG(self).enabledSwitch setOn:USE_STRONG(self).domainEnabled animated:YES];
            }
            else {
                USE_STRONG(self).domainEnabled = newEnabled;
            }
        }];
    }
}

- (IBAction)clickMissedAd:(id)sender {
    
    NSURL *url = [AESSupport.singleton composeWebReportUrlForSite:self.url];
    [self openUrl:url];
}

- (IBAction)clickBlockElement:(id)sender {
    if (_injectScriptSupported) {
        
        NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
        NSDictionary *settings = @{
            @"urlScheme" : AE_URLSCHEME,
            @"i18n" : @{
                @"buttons" : @{
                    @"plus" : ACLocalizedString(
                        @"More", @"(Action Extension - Adguard Assistant) "
                                 @"Assistant UI. Title for 'plus' button"),
                    @"minus" : ACLocalizedString(
                        @"Less", @"(Action Extension - Adguard Assistant) "
                                 @"Assistant UI. Title for 'munus' button"),
                    @"accept" : ACLocalizedString(
                        @"Accept", @"(Action Extension - Adguard Assistant) "
                                   @"Assistant UI. Title for 'Adguard icon' "
                                   @"button"),
                    @"cancel" : ACLocalizedString(
                        @"Cancel", @"(Action Extension - Adguard Assistant) "
                                   @"Assistant UI. Title for 'close icon' "
                                   @"button"),
                    @"preview" : ACLocalizedString(
                        @"Preview", @"(Action Extension - Adguard Assistant) "
                                    @"Assistant UI. Title for 'eye icon' "
                                    @"button")
                }
            }
        };
        extensionItem.attachments = @[[[NSItemProvider alloc] initWithItem: @{NSExtensionJavaScriptFinalizeArgumentKey: @{@"blockElement":@(1), @"settings": settings}} typeIdentifier:(NSString *)kUTTypePropertyList]];
        [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
    }
    else{
        
        [ACSSystemUtils showSimpleAlertForController:self withTitle:ACLocalizedString(@"common_error_title", @"(Action Extension - AEAUIMainController) Error tile") message:ACLocalizedString(@"assistant_launching_unable", @"(Action Extension - AEAUIMainController) error occurs when click on Block Element button.")];
        [self.enabledSwitch setOn:self.domainEnabled animated:YES];
    }
}

- (IBAction)done:(id)sender {
    
    NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
    extensionItem.attachments = @[[[NSItemProvider alloc] initWithItem: @{NSExtensionJavaScriptFinalizeArgumentKey: @{@"needReload":@(_enabledHolder != self.domainEnabled)}} typeIdentifier:(NSString *)kUTTypePropertyList]];
    [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Table View Delegates
/////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [self.theme setupTableCell:cell];
    return cell;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////

- (void)openUrl:(NSURL *)url {
    UIResponder *responder = self;
    while(responder){
        if ([responder respondsToSelector: @selector(openURL:)]){
            [responder performSelector: @selector(openURL:) withObject: url];
        }
        responder = [responder nextResponder];
    }
}

@end
