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

#import "AEAUIMainController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "ACommons/ACSystem.h"
#import "AEAUIDomainCell.h"
#import "AEUIUtils.h"
#import "AEWhitelistDomainObject.h"
#import "AEInvertedWhitelistDomainsObject.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "ASDFilterObjects.h"
#import "AESSupport.h"
#import "AESharedResources.h"
#import "ABECRequest.h"
#import "ADProductInfo.h"

#ifdef PRO
#import "APVPNManager.h"
#import "APDnsServerObject.h"
#endif

@implementation AEAUIMainController{
    
    BOOL _enabledHolder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.title = LocalizationNotNeeded(AE_PRODUCT_NAME);
    self.nameCell.longLabel.text = self.domainName;
    self.statusButton.on = self.domainEnabled;
    _enabledHolder = self.domainEnabled;
    
    self.blockElementLabel.textColor = self.blockElementLabel.tintColor;
    
    // tunning accessibility
    self.blockElementLabel.accessibilityTraits |= UIAccessibilityTraitButton;
    
    NSString *labelFormat = NSLocalizedString(@"Enable filtering on %@", @"(Action Extension - AEAUIMainController) Label on switcher. Example: 'Enable filtering on www.github.com'");
    self.enableOnCell.textLabel.accessibilityLabel = [NSString stringWithFormat:labelFormat, self.domainName];
    //--------------
    
    
    if (self.iconUrl) {
        [ACNNetworking dataWithURL:self.iconUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (error) {
                DDLogError(@"(AEAUIMainController) Error of obtaining of the site icon \"%@\":\n%@", self.iconUrl, [error localizedDescription]);
                return;
            }
            
            //check response code if this is HTTP protocol
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if ((httpResponse.statusCode / 100) != 2) {
                    
                    DDLogError(@"(AEAUIMainController) Error of obtaining of the site icon \"%@\": response status code = %lu", self.iconUrl, httpResponse.statusCode);
                    return;
                }
            }
            UIImage *icon = [UIImage imageWithData:data];
            if (icon) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.iconView.image = icon;
                });
            }
        }];
    }
    else{
        
        
    }
    
    [AEService.singleton checkStatusWithCallback:^(BOOL enabled) {
       
        if(!enabled) {
            
            [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Warning", @"(Action Extension - AEAUIMainController) Warning tile") message:NSLocalizedString(@"Note that the Content blocker is disabled. That means ads will not be filtered regardless of AdGuard settings. Please enable AdGuard Content blocker in Safari settings to start filtering.", @"(Action Extension - AEAUIMainController) error occurs when content blocker is disabled.")];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
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
        [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(Action Extension - AEAUIMainController) Error tile") message:NSLocalizedString(@"You have exceeded the maximum number of the filter rules.", @"(Action Extension - AEAUIMainController) error occurs when try turn off filtration on site.")];
        [self.statusButton setOn:self.domainEnabled animated:YES];
        return;
    }
    
    BOOL inverted = [AESharedResources.sharedDefaults boolForKey:AEDefaultsInvertedWhitelist];
    
    // disable filtering == remove from inverted whitelist
    if (inverted && self.domainEnabled) {
        
        AEInvertedWhitelistDomainsObject* invertedObj = [AESharedResources new].invertedWhitelistContentBlockingObject;
        
        __block NSMutableArray* newDomains = [NSMutableArray new];
        
        [invertedObj.domains enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj caseInsensitiveCompare:self.domainName] != NSOrderedSame) {
                [newDomains addObject:obj];
            }
        }];
        
        invertedObj.domains = newDomains;
        [AESharedResources new].invertedWhitelistContentBlockingObject = invertedObj;
        
        [AEUIUtils invalidateJsonWithController:self completionBlock:^{
            self.domainEnabled = NO;
        } rollbackBlock:^{
            
        }];
    }
    // enable filtering == add to inverted whitelist
    else if (inverted && !self.domainEnabled) {
        
        AEInvertedWhitelistDomainsObject* invertedObj = [AESharedResources new].invertedWhitelistContentBlockingObject;
        
        invertedObj.domains = [invertedObj.domains arrayByAddingObject:self.domainName];
        [AESharedResources new].invertedWhitelistContentBlockingObject = invertedObj;
        
        [AEUIUtils invalidateJsonWithController:self completionBlock:^{
            self.domainEnabled = YES;
        } rollbackBlock:^{
            
        }];
        
    }
    // disable filtering (add to whitelist)
    else if (self.domainEnabled) {
        
        AEWhitelistDomainObject *domainObject = [[AEWhitelistDomainObject alloc] initWithDomain:self.domainName];
        
        [[[AEService singleton] antibanner] beginTransaction];
        
        [AEUIUtils addWhitelistRule: domainObject.rule toJsonWithController:self completionBlock:^{
            
            self.domainEnabled = newEnabled;
            
            [[[AEService singleton] antibanner] endTransaction];
            
        } rollbackBlock:^{
            
            [[[AEService singleton] antibanner] rollbackTransaction];
            
            [self.statusButton setOn:self.domainEnabled animated:YES];
            
        }];
    }
    // enable filtering (remove from whitelist)
    else {
        
        AEWhitelistDomainObject *domainObject = [[AEWhitelistDomainObject alloc] initWithDomain:self.domainName];
        
        if (!domainObject) {
            [self.statusButton setOn:self.domainEnabled animated:YES];
            return;
        }
        
        [[[AEService singleton] antibanner] beginTransaction];
        
        [AEUIUtils removeWhitelistRule:domainObject.rule toJsonWithController:self completionBlock:^{
            
            self.domainEnabled = newEnabled;
            
            [[[AEService singleton] antibanner] endTransaction];
            
        } rollbackBlock:^{
            
            // enable rule (rollback)
            
            [[[AEService singleton] antibanner] rollbackTransaction];
            
            [self.statusButton setOn:self.domainEnabled animated:YES];
        }];
    }
    
}

- (IBAction)clickMissedAd:(id)sender {
    
    NSURL *url = [AESSupport.singleton composeWebReportUrlForSite:self.url];
    [self openUrl:url];
}

- (IBAction)clickIncorrectBlocking:(id)sender {
    
    NSString *subject = [NSString stringWithFormat:AESSupportSubjectPrefixFormat, AE_PRODUCT_NAME, NSLocalizedString(@"Report Incorrect Blocking", @"(Action Extension - AEAUIMainController) Mail subject to support team about incorrect blocking")];
    NSString *body = [NSString stringWithFormat:NSLocalizedString(@"Incorrect blocking on page:\n%@", @"(Action Extension - AEAUIMainController) Mail body to support team about incorrect blocking"), [self.url absoluteString]];

    [[AESSupport singleton] sendSimpleMailWithParentController:self subject:subject body:body];
}

- (IBAction)clickBlockElement:(id)sender {
    if (_injectScriptSupported) {
        
        NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
        NSDictionary *settings = @{
            @"urlScheme" : AE_URLSCHEME,
            @"i18n" : @{
                @"buttons" : @{
                    @"plus" : NSLocalizedString(
                        @"More", @"(Action Extension - Adguard Assistant) "
                                 @"Assistant UI. Title for 'plus' button"),
                    @"minus" : NSLocalizedString(
                        @"Less", @"(Action Extension - Adguard Assistant) "
                                 @"Assistant UI. Title for 'munus' button"),
                    @"accept" : NSLocalizedString(
                        @"Accept", @"(Action Extension - Adguard Assistant) "
                                   @"Assistant UI. Title for 'Adguard icon' "
                                   @"button"),
                    @"cancel" : NSLocalizedString(
                        @"Cancel", @"(Action Extension - Adguard Assistant) "
                                   @"Assistant UI. Title for 'close icon' "
                                   @"button"),
                    @"preview" : NSLocalizedString(
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
        
        [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(Action Extension - AEAUIMainController) Error tile") message:NSLocalizedString(@"This website security policy does not allow to launch Adguard Assistant.", @"(Action Extension - AEAUIMainController) error occurs when click on Block Element button.")];
        [self.statusButton setOn:self.domainEnabled animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // Fitting size of the filter name
        return [self heightForCell:self.nameCell];
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
    // tunning accessibility
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.isAccessibilityElement = NO;
    footer.textLabel.isAccessibilityElement = NO;
    footer.detailTextLabel.isAccessibilityElement = NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////

- (CGFloat)heightForCell:(AEAUIDomainCell *)longTextCell {
    
    [longTextCell setNeedsLayout];
    [longTextCell layoutIfNeeded];
    
    CGSize size = [longTextCell.contentView
                   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

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
