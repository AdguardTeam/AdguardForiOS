/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

#import "APUISystemWideController.h"
#import "APVPNManager.h"
#import "ACommons/ACSystem.h"
#import "ACommons/ACLang.h"
#import "AEUICustomTextEditorController.h"
#import "APSharedResources.h"


#define SEGUE_BLACKLIST                     @"blacklist"
#define SEGUE_WHITELIST                     @"whitelist"
#define STATUS_SECTION_INDEX                0

/////////////////////////////////////////////////////////////////////
#pragma mark - APUISystemWideController

@implementation APUISystemWideController {
    
    UIBarButtonItem *_cancelNavigationItem;
    id _observer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cancelNavigationItem = [[UIBarButtonItem alloc]
                             initWithTitle:NSLocalizedString(@"Cancel",
                                                             @"(APUIAdguardDNSController) PRO version. Text on the button that cancels an operation.")
                                                             style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self attachToNotifications];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self updateStatuses];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    if (_observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)toggleLocalFiltering:(id)sender {
    
    APVPNManager.singleton.localFiltering = self.statusSwitch.isOn;
    if (APVPNManager.singleton.lastError) {
        
        [self.statusSwitch setOn:APVPNManager.singleton.localFiltering animated:YES];
    }
}

- (IBAction)toggleLogStatus:(id)sender {
    
    APVPNManager *manager = [APVPNManager singleton];
    manager.dnsRequestsLogging = self.logSwitch.isOn;
    if (manager.lastError) {
        
        [self.logSwitch setOn:manager.dnsRequestsLogging animated:YES];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BOOL toWhitelist = [segue.identifier isEqualToString:SEGUE_WHITELIST];
    BOOL toBlacklist = [segue.identifier isEqualToString:SEGUE_BLACKLIST];
    
    if (toBlacklist || toWhitelist) {
    
        AEUICustomTextEditorController *domainList = segue.destinationViewController;
    
        domainList.textForPlaceholder = NSLocalizedString(@"List the domain names here. Separate different domain names by commas or line breaks.",
                                                          @"(APUIAdguardDNSController) PRO version. On the System-wide Ad Blocking -> Blacklist(Whitelist) screen. The placeholder text.");
        
        domainList.navigationItem.title = toWhitelist
        ? NSLocalizedString(@"Whitelist", @"(APUIAdguardDNSController) PRO version. Title of the system-wide whitelist screen.")
        : NSLocalizedString(@"Blacklist", @"(APUIAdguardDNSController) PRO version. On the System-wide Ad Blocking -> Blacklist screen. The title of that screen.");
        self.navigationItem.backBarButtonItem = _cancelNavigationItem;
        
        domainList.done = ^BOOL(AEUICustomTextEditorController *editor, NSString *text) {

            NSMutableArray *domains = [NSMutableArray array];
            @autoreleasepool {
                
                NSMutableCharacterSet *delimCharSet;
                
                delimCharSet = [NSMutableCharacterSet newlineCharacterSet];
                [delimCharSet addCharactersInString:@","];

                for (NSString *item in  [text componentsSeparatedByCharactersInSet:delimCharSet]) {
                    
                    NSString *candidate = [item stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    if (candidate.length) {
                        [domains addObject:candidate];
                    }
                }
            }
            
            @autoreleasepool {
                
                NSArray *propertyHolder;
                
                if (toBlacklist) {
                    
                    propertyHolder = APSharedResources.blacklistDomains;
                    APSharedResources.blacklistDomains = domains;
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
            
            return YES;

        };
        domainList.replaceText = ^BOOL(NSString *text, UITextView *textView, NSRange range) {
            
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
        
        if (toBlacklist) {
            
            domainList.textForEditing = [APSharedResources.blacklistDomains componentsJoinedByString:@"\n"];
        }
        else {
            
            domainList.textForEditing = [APSharedResources.whitelistDomains componentsJoinedByString:@"\n"];
        }
        
    }
    else {
        
        self.navigationItem.backBarButtonItem = nil;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Table Delegate

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    
    // tunning accessibility
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.isAccessibilityElement = NO;
    footer.textLabel.isAccessibilityElement = NO;
    footer.detailTextLabel.isAccessibilityElement = NO;
    
    if (section == STATUS_SECTION_INDEX) {
        self.statusSwitchCell.accessibilityHint = footer.textLabel.text;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Helper Methods (Private)

- (void)attachToNotifications{
    
    _observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:APVpnChangedNotification
                 object: nil
                 queue:nil
                 usingBlock:^(NSNotification *_Nonnull note) {
                     
                     // When configuration is changed
                     
                     [self updateStatuses];
                 }];
}

- (void)updateStatuses{
    APVPNManager *manager = [APVPNManager singleton];
    
    [self.statusSwitch setOn:manager.localFiltering animated:YES];
    [self.logSwitch setOn:manager.dnsRequestsLogging animated:YES];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        
        self.blacklistCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",APSharedResources.blacklistDomains.count];
        self.whitelistCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",APSharedResources.whitelistDomains.count];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    });
    
    if (manager.lastError) {
        [ACSSystemUtils
         showSimpleAlertForController:self
         withTitle:NSLocalizedString(@"Error",
                                     @"(APUIAdguardDNSCon"
                                     @"troller) PRO "
                                     @"version. Alert "
                                     @"title. On error.")
         message:manager.lastError.localizedDescription];
    }
}

@end
