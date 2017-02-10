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

#import "APUIDnsRequestDetail.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "APDnsLogRecord.h"
#import "AEUILongLabelViewCell.h"
#import "APDnsResourceType.h"
#import "APVPNManager.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "ASDFilterObjects.h"
#import "AEBlacklistDomainObject.h"
#import "ACommons/ACSystem.h"
#import "AEUIUtils.h"
#import "APDnsServerObject.h"
#import "APSharedResources.h"

#define DATE_FORMAT(DATE)   [NSDateFormatter localizedStringFromDate:DATE dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]

typedef enum {

    DomainControllNone = 0,
    DomainControllAddToWhitelist,
    DomainControllRemoveFromWhitelist,
    DomainControllAddToBlacklist,
    DomainControllRemoveFromBlacklist
} TDomainControllCellType;

@interface APUIDnsRequestDetail ()

@end



@implementation APUIDnsRequestDetail {
    
    TDomainControllCellType _domainControllCellType;
    NSString *_domainName;
    
    id _observer;
}

static NSDateFormatter *_timeFormatter;

+ (void)initialize{
    
    if (self == [APUIDnsRequestDetail class]) {
        _timeFormatter = [NSDateFormatter new];
        _timeFormatter.dateFormat = @"HH:mm:ss.SSS ";
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self attachToNotifications];
    
    _domainControllCellType = DomainControllNone;
    
    self.hideSectionsWithHiddenRows = YES;
    APDnsRequest *request = self.logRecord.requests[0];
    
    self.timeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [_timeFormatter stringFromDate:self.logRecord.recordDate],
                               DATE_FORMAT(self.logRecord.recordDate)];
    
    self.nameCell.longLabel.text = request.name;
    self.typeCell.detailTextLabel.text = [request.type description];
    self.serverCell.detailTextLabel.text = self.logRecord.dnsServer.serverName;
    self.localFilteringCell.detailTextLabel.text = self.logRecord.localFiltering ?
    NSLocalizedString(@"On", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Local Filtering is ON.")
    : NSLocalizedString(@"Off", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Local Filtering is OFF.");

    
    NSMutableAttributedString *sb = [NSMutableAttributedString new];
    
    NSDictionary *bold = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightBold] };
    NSDictionary *normal = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightRegular] };
    
    if (self.logRecord.responses.count) {
        
        // Set status cell
        if (self.logRecord.isBlacklisted){
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Blocked by Local Filtering", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. If this DNS request was blocked be rule in User Filter or in 'Simplified Domain Names Filter', this will be shown as status text.");
        }
        else if (self.logRecord.isWhitelisted){
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Exception", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. If this DNS request was for domain from the whitelist, this will be shown as status text.");
        }
        else if (self.logRecord.preferredResponse.blocked) {
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Blocked by DNS", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. If this DNS request was blocked be DNS server, this will be shown as status text.");
        }
        else {
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Processed", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. If this DNS request was processed as normal, this will be shown as status text.");
        }
        //set response cell
        for (APDnsResponse *item in self.logRecord.responses) {
            
            NSString *str;
            if (sb.length) {
                str = [NSString stringWithFormat:@"\n\n%@\n", item.type];
            }
            else{
                str = [NSString stringWithFormat:@"%@\n", item.type];
            }
            [sb appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:bold]];
            [sb appendAttributedString:[[NSAttributedString alloc] initWithString:item.stringValue attributes:normal]];
        }
        
        self.responsesCell.longLabel.attributedText = sb;
    }
    else{
        
        NSString *text =  NSLocalizedString(@"No response", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. It is the detailed text in RESPONSES section, if this DNS request do not have response.");
        self.responsesCell.longLabel.text = text;
        self.statusCell.detailTextLabel.text = text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    if (_observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:_observer];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////
#pragma mark Table View Delegates

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        // Fitting size of the request name
        return [self.nameCell fitHeight];
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        
        // Fitting size of the responses
        return [self.responsesCell fitHeight];
    }
    return UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupDomainControllCell];
}
/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDomainControll:(id)sender {

    if (_domainControllCellType == DomainControllNone) {
        return;
    }
    
    @autoreleasepool {
        
        if (_domainControllCellType == DomainControllAddToWhitelist) {
            
            APSharedResources.whitelistDomains = [APSharedResources.whitelistDomains arrayByAddingObject:_domainName];
            [self enableLocalFilteringIfNeedIt];
        }
        else if (_domainControllCellType == DomainControllAddToBlacklist) {
            
            APSharedResources.blacklistDomains = [APSharedResources.blacklistDomains arrayByAddingObject:_domainName];
            [self enableLocalFilteringIfNeedIt];
        }
        else if (_domainControllCellType == DomainControllRemoveFromWhitelist) {
            
            NSMutableArray *domains = [APSharedResources.whitelistDomains mutableCopy];
            [domains removeObject:_domainName];
            APSharedResources.whitelistDomains = [domains copy];
        }
        else if (_domainControllCellType == DomainControllRemoveFromBlacklist) {
            
            NSMutableArray *domains = [APSharedResources.blacklistDomains mutableCopy];
            [domains removeObject:_domainName];
            APSharedResources.blacklistDomains = [domains copy];
        }
    }
    
    [[APVPNManager singleton] sendReloadSystemWideDomainLists];
    [self setupDomainControllCell];
}

- (IBAction)longPressOnName:(id)sender {

    UIGestureRecognizer *req = sender;
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:req.view.frame inView:req.view.superview];
    [menu setMenuVisible:YES animated:YES];
    
    [req.view becomeFirstResponder];
}


/////////////////////////////////////////////////////////////////////
#pragma mark Helper methods

- (void)setupDomainControllCell {

    @autoreleasepool {
        
        _domainControllCellType = DomainControllNone;
        
        self.domainControllCell.textLabel.textColor = self.domainControllCell.textLabel.tintColor;

        APDnsRequest *request = self.logRecord.requests[0];

        _domainName = request.name;
        
        NSArray *domainslist = APSharedResources.whitelistDomains;
        
        // We check on equal
        if ([domainslist containsObject:_domainName]) {
            
            self.domainControllCell.textLabel.text = NSLocalizedString(@"Remove from Whitelist", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Text on button");
            _domainControllCellType = DomainControllRemoveFromWhitelist;
        }
        else {
            
            domainslist = APSharedResources.blacklistDomains;
            if ([domainslist containsObject:_domainName]) {
                
                self.domainControllCell.textLabel.text = NSLocalizedString(@"Remove from Blacklist", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Text on button");
                _domainControllCellType = DomainControllRemoveFromBlacklist;
            }
            else {
                
                if (self.logRecord.preferredResponse.blocked) {
                    self.domainControllCell.textLabel.text = NSLocalizedString(@"Add to Whitelist", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Text on button");
                    _domainControllCellType = DomainControllAddToWhitelist;
                }
                else {
                    self.domainControllCell.textLabel.text = NSLocalizedString(@"Add to Blacklist", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Detail. Text on button");
                    _domainControllCellType = DomainControllAddToBlacklist;
                }
            }
            
        }
        
        [self reloadDataAnimated:YES];
    }
}

- (void)enableLocalFilteringIfNeedIt {
    
    if (APVPNManager.singleton.localFiltering) {
        return;
    }
    
    UIAlertController* sheet = [UIAlertController alertControllerWithTitle:nil
                                                                   message:NSLocalizedString(@"Blacklist or whitelist work only if you enable system-wide ad blocking.", @"(APUIDnsRequestDetail) PRO version. DNS request log. Message in the alert action when user attempts to add domain in black/white list.")
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Enable", @"(APUIDnsRequestDetail) PRO version. DNS request log. Button text for enabling system-wide filtering.")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {

                                                        [[APVPNManager singleton] setLocalFiltering:YES];
                                                    }];
    
    [sheet addAction:action];
    
    action = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"(APUIDnsRequestDetail) PRO version. DNS request log. Text on the button that cancels enabling system-wide filtering.")
                                      style:UIAlertActionStyleCancel
                                    handler:nil];
    
    [sheet addAction:action];
    
    [self presentViewController:sheet animated:YES completion:nil];

}

- (void)attachToNotifications{
    
    _observer = [[NSNotificationCenter defaultCenter]
                 addObserverForName:APVpnChangedNotification
                 object: nil
                 queue:nil
                 usingBlock:^(NSNotification *_Nonnull note) {
                     
                     // When configuration is changed
                     
                     APVPNManager *manager = [APVPNManager singleton];
                     
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
                 }];
}

@end
