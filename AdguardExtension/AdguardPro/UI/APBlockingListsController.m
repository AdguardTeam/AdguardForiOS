/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "APBlockingListsController.h"
#import "AEUISelectableTableViewCell.h"
#import "APBlockingSubscriptionsManager.h"
#import "AEUIUtils.h"
#import "APNewBlockingSubscriptionController.h"
#import "APBlockingSubscriptionDetailsController.h"
#import "ACommons/ACLang.h"
#import "ABECSubscription.h"
#import "AEUILoadingModal.h"
#import "AEUICustomTextEditorController.h"
#import "APSharedResources.h"
#import "APVPNManager.h"
#import "APUIProSectionFooter.h"

#define SUBSCRIPTIONS_SECTION 1

#define TO_SUBSCRIPTION_DETAILS_SEGUE_ID @"toSubscriptionDetails"
#define TO_NEW_SUBSCRIPTION_SEGUE_ID @"toNewSubscription"
#define TO_DNS_BLACKLIST_SEGUE_ID   @"toDnsBlacklist"
#define TO_DNS_WHITELIST_SEGUE_ID   @"toDnsWhitelist"

@interface APBlockingListsController ()

@property (weak, nonatomic) IBOutlet UILabel *blackListCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *whitelistCountLabel;
@property (weak, nonatomic) IBOutlet AEUISelectableTableViewCell *checkUpdatesCell;

@property (strong, nonatomic) IBOutlet AEUISelectableTableViewCell *subscriptionTemplateCell;
@property (nonatomic) APBlockingSubscription* selectedSubscription;
@property (nonatomic) APUIProSectionFooter* footer;

@end

@implementation APBlockingListsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateSubscriptionCells];
    [self updateCounters];
    [self prepareUpdateCell];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BOOL toWhitelist = [segue.identifier isEqualToString:TO_DNS_WHITELIST_SEGUE_ID];
    BOOL toBlacklist = [segue.identifier isEqualToString:TO_DNS_BLACKLIST_SEGUE_ID];
    
    if([segue.identifier isEqualToString:TO_NEW_SUBSCRIPTION_SEGUE_ID]) {
        APNewBlockingSubscriptionController* controller = (APNewBlockingSubscriptionController*)[(UINavigationController *)[segue destinationViewController]
                                                           topViewController];
        
        ASSIGN_WEAK(self);
        
        controller.done = ^(UIViewController* _Nonnull sender, APBlockingSubscription * _Nonnull subscription) {
            
            NSString *message = NSLocalizedString(@"Loading filter subscription. Please do not turn off AdGuard, this will take no more than 30 seconds.", @"(APBlockingListsController) blocking list loading message");
            [AEUILoadingModal.singleton loadingModalShowWithParent:sender message:message cancelAction:nil completion:^{
                
                [ABECSubscription.singleton downloadSubscription:subscription.url completionBlock:^(NSArray *rules, NSDictionary *hosts) {
                    
                    ASSIGN_STRONG(self);
                    
                    subscription.hosts = hosts;
                    subscription.rules = rules;
                    
                    subscription.updateDate = [NSDate new];
                    
                    NSArray* subscriptions = APBlockingSubscriptionsManager.subscriptions;
                    if(!subscriptions)
                        subscriptions = [NSArray new];
                    
                    subscriptions = [subscriptions arrayByAddingObject:subscription];
                    APBlockingSubscriptionsManager.subscriptions = subscriptions;
                    
                    APVPNManager *manager = [APVPNManager singleton];
                    [manager sendReloadSystemWideDomainLists];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [USE_STRONG(self) updateSubscriptionCells];
                        
                        [AEUILoadingModal.singleton loadingModalHide];
                        
                        [USE_STRONG(self) dismissViewControllerAnimated:YES completion:nil];
                    });
                    
                } errorBlock:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AEUILoadingModal.singleton loadingModalHide];
                    });
                }];
            }];
        };
    }
    else if([segue.identifier isEqualToString:TO_SUBSCRIPTION_DETAILS_SEGUE_ID]) {
        
        APBlockingSubscriptionDetailsController* controller = [segue destinationViewController];
        
        controller.subscription = self.selectedSubscription;
        
        ASSIGN_WEAK(self);
        controller.removeBlock = ^(APBlockingSubscription * _Nonnull subscription) {
            
            ASSIGN_STRONG(self);
            
            NSMutableArray* subscriptions = [NSMutableArray arrayWithArray: APBlockingSubscriptionsManager.subscriptions];
            
            [subscriptions removeObject:subscription];
            
            APBlockingSubscriptionsManager.subscriptions = subscriptions.copy;
            
            APVPNManager *manager = [APVPNManager singleton];
            [manager sendReloadSystemWideDomainLists];
            
            [USE_STRONG(self) updateSubscriptionCells];
        };
    }
    else if (toBlacklist || toWhitelist) {
        
        AEUICustomTextEditorController *domainList = segue.destinationViewController;
        
        domainList.attributedTextForPlaceholder = [[NSAttributedString alloc] initWithString:
                                                   NSLocalizedString(@"List the domain names here. Separate different domain names with line breaks.",
                                                                     @"(APUIAdguardDNSController) PRO version. On the Privacy Settings -> Blacklist (Whitelist) screen. The placeholder text.")];
        
        domainList.keyboardType = toWhitelist ? UIKeyboardTypeURL : UIKeyboardTypeDefault;
        
        domainList.navigationItem.title = toWhitelist
        ? NSLocalizedString(@"Whitelist", @"(APUIAdguardDNSController) PRO version. Title of the system-wide whitelist screen.")
        : NSLocalizedString(@"Blacklist", @"(APUIAdguardDNSController) PRO version. On the System-wide Ad Blocking -> Blacklist screen. The title of that screen.");
        //self.navigationItem.backBarButtonItem = _cancelNavigationItem;
        
        ASSIGN_WEAK(self);
        
        domainList.done = ^BOOL(AEUICustomTextEditorController *editor, NSString *text) {
            
            NSMutableArray *domains = [NSMutableArray array];
            NSMutableDictionary *hosts = [NSMutableDictionary new];
            
            @autoreleasepool {
                
                NSMutableCharacterSet *delimCharSet;
                
                delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
                
                for (NSString *item in  [text componentsSeparatedByCharactersInSet:delimCharSet]) {
                    
                    NSString *candidate = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (candidate.length) {
                        
                        if(toBlacklist) {
                            
                            NSString* ip;
                            NSString* domain;
                            
                            if ([ACNUrlUtils checkHostsLine:candidate ip:&ip domain:&domain]) {
                                
                                hosts[domain] = ip;
                            }
                            else if(![AERDomainFilterRule isValidRuleText:candidate]) {
                                
                                [editor selectWithType:AETESelectionTypeError text:candidate];
                                return NO;
                            }
                            else {
                                [domains addObject:candidate];
                            }
                        }
                        else {
                            [domains addObject:candidate];
                        }
                    }
                }
            }
            
            @autoreleasepool {
                
                NSArray *propertyHolder;
                
                if (toBlacklist) {
                    
                    propertyHolder = APSharedResources.blacklistDomains;
                    APSharedResources.blacklistDomains = domains;
                    APSharedResources.hosts = hosts;
                }
                else {
                    
                    propertyHolder = APSharedResources.whitelistDomains;
                    APSharedResources.whitelistDomains = domains;
                }
                
                APVPNManager *manager = [APVPNManager singleton];
                [manager sendReloadSystemWideDomainLists];
                
                if (manager.lastError) {
                    
                    //processing of the error
                    if (toBlacklist) {
                        APSharedResources.blacklistDomains = propertyHolder;
                    }
                    else {
                        
                        APSharedResources.whitelistDomains = propertyHolder;
                    }
                    
                    return NO;
                }
            }
            
            ASSIGN_STRONG(self);
            [USE_STRONG(self) updateCounters];
            
            return YES;
            
        };
        domainList.replaceText = ^BOOL(NSString *text, UITextView *textView, NSRange range) {
            
            // copy-paste multiline text from file
            NSMutableCharacterSet* delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
            if ([text rangeOfCharacterFromSet:delimCharSet].location != NSNotFound) {
                return YES;
            }
            
            // copy-paste single line address from safari address bar
            if ([text contains:@"/"]) {
                if (text.length > 1) {
                    
                    NSURL *url = [NSURL URLWithString:text];
                    text = [[url hostWithPort] stringByAppendingString:@"\n"];
                    if (text) {
                        
                        [textView replaceRange:[textView textRangeFromNSRange:range] withText:text];
                    }
                }
                return NO;
            }
            
            return YES;
            
        };
        
        NSString *text;
        if (toBlacklist) {
            
            NSMutableString *resultText = [NSMutableString new];
            
            NSArray* storedDomains = APSharedResources.blacklistDomains;
            if(storedDomains.count) {
                [resultText appendString: [APSharedResources.blacklistDomains componentsJoinedByString:@"\n"]];
                [resultText appendString:@"\n"];
            }
            
            NSDictionary <NSString *, NSString*> *storedHosts = APSharedResources.hosts;
            
            if(storedHosts.count) {
                [storedHosts enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
                    [resultText appendFormat:@"%@ %@\n", obj, key];
                }];
            }
            
            text = resultText.copy;
        }
        else {
            
            text = [APSharedResources.whitelistDomains componentsJoinedByString:@"\n"];
        }
        if (! [NSString isNullOrEmpty:text]) {
            
            domainList.attributedTextForEditing = [[NSAttributedString alloc] initWithString:text
                                                                                  attributes:AEUICustomTextEditorController.defaultTextAttributes];
        }        
    }
}

#pragma mark UITableView methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == SUBSCRIPTIONS_SECTION) {
        
        NSInteger row = indexPath.row;
        
        NSArray* subscriptions = APBlockingSubscriptionsManager.subscriptions;
        if(row >= subscriptions.count)
            return;
        
        self.selectedSubscription = subscriptions[row];
        [self performSegueWithIdentifier:TO_SUBSCRIPTION_DETAILS_SEGUE_ID sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == SUBSCRIPTIONS_SECTION) {
        return [[self sectionFooter] heightForWidth:self.view.frame.size.width];
    }
    
    return [super tableView:tableView heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if(section == SUBSCRIPTIONS_SECTION) {
        return [self sectionFooter];
    }
    
    return [super tableView:tableView viewForFooterInSection:section];
}

#pragma mark aktions

- (IBAction)checkUpdatesAction:(id)sender {
    
    ASSIGN_WEAK(self);
    
    self.checkUpdatesCell.accessoryView.hidden = NO;
    self.checkUpdatesCell.detailTextLabel.hidden = YES;
    self.checkUpdatesCell.textLabel.enabled = NO;
    [((UIActivityIndicatorView*)self.checkUpdatesCell.accessoryView) startAnimating];
    
    [APBlockingSubscriptionsManager updateSubscriptionsWithSuccessBlock:^{
        
        ASSIGN_STRONG(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [USE_STRONG(self) updateSubscriptionCells];
        });
    } errorBlock:^(NSError * error) {
        
    } completionBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            ASSIGN_STRONG(self);
            [((UIActivityIndicatorView*)USE_STRONG(self).checkUpdatesCell.accessoryView) stopAnimating];
            USE_STRONG(self).checkUpdatesCell.detailTextLabel.hidden = NO;
            USE_STRONG(self).checkUpdatesCell.textLabel.enabled = YES;
            USE_STRONG(self).checkUpdatesCell.accessoryView.hidden = YES;
        });
    }];
}

#pragma mark private methods

- (void) updateSubscriptionCells {
    
    NSArray* subscriptions = APBlockingSubscriptionsManager.subscriptions;
    
    BOOL showUpdateCell = subscriptions.count > 0;
    BOOL wasHidden = [self cellIsHidden:self.checkUpdatesCell];
    
    [self cell:self.checkUpdatesCell setHidden:!showUpdateCell];
    
    int nonSubscriptionsCellsCount = wasHidden ? 1 : 2;
    
    for (int i = 0; i < [self.tableView numberOfRowsInSection:1] - nonSubscriptionsCellsCount; ++i) {
        [self removeCellAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
    }
    
    [self reloadDataAnimated:NO];
    
    int row = 0;
    
    NSTimeInterval minUpdateTimestamp = FLT_MAX;
    for (APBlockingSubscription* subscription in subscriptions) {
    
        UITableViewCell *newCell = [AEUIUtils createCellByTemplate:self.subscriptionTemplateCell style:UITableViewCellStyleValue1];
        
        newCell.textLabel.text = subscription.name;
        
        if(subscription.rulesCount) {
            NSString* countFormat = NSLocalizedString(@"%d rules", @"(APBlockingListsController) blocking list rules count format");
            newCell.detailTextLabel.text = [NSString stringWithFormat:countFormat, subscription.rulesCount];
        }
        
        [self insertCell:newCell atIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
        
        minUpdateTimestamp = MIN(minUpdateTimestamp, subscription.updateDate.timeIntervalSince1970);
        
        ++row;
    }
    
    NSDate *checkDate = [NSDate dateWithTimeIntervalSince1970: minUpdateTimestamp];
    
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:checkDate];
    
    self.checkUpdatesCell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:checkDate dateStyle: today ? NSDateFormatterNoStyle : NSDateFormatterShortStyle timeStyle: today ? NSDateFormatterShortStyle : NSDateFormatterNoStyle];
    
    [self reloadDataAnimated:NO];
}

- (void) updateCounters {
    
    self.whitelistCountLabel.text = [NSString stringWithFormat:@"%lu", APSharedResources.whitelistDomains.count];
    self.blackListCountLabel.text = [NSString stringWithFormat:@"%lu", APSharedResources.blacklistDomains.count + APSharedResources.hosts.count];
}

- (void) prepareUpdateCell {
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]
                                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.hidesWhenStopped = YES;
    activity.hidden = YES;
    activity.color = self.checkUpdatesCell.detailTextLabel.textColor;
    
    self.checkUpdatesCell.accessoryView = activity;
}

- (APUIProSectionFooter*) sectionFooter {
    
    if(!self.footer) {
        
        self.footer = [[APUIProSectionFooter alloc] initWithFrame:self.view.frame];
        [self.footer setText:[self footerText]];
    }
    
    return self.footer;
}

- (NSAttributedString*) footerText {
    
    NSString *htmlString = NSLocalizedString(@"Privacy module allows you to extend its functionality by adding custom rules subscriptions. It supports both <a href=\"https://wikipedia.org/wiki/Hosts_(file)\">hosts files</a> and also a limited set of AdGuard rules syntax. Click <a href=\"https://kb.adguard.com/ios/features\">here</a> to learn more about it.", @"(APBlockingListsController) Blocking subscriptions footer text");
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
    
    NSAttributedString* string = [[NSAttributedString alloc] initWithData:data
                                                                             options:options
                                                                  documentAttributes:nil error:&error];
    
    return string;
}

@end
