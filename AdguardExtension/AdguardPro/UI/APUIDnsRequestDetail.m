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
#import "ACommons/ACSystem.h"
#import "AEUIUtils.h"
#import "APDnsServerObject.h"
#import "APSharedResources.h"
#import "APBlockingSubscriptionsManager.h"

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
    NSLocalizedString(@"On", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests screen -> Request Details. System-wide Ad Blocking is ON.")
    : NSLocalizedString(@"Off", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests screen -> Request Details. System-wide Ad Blocking is OFF.");

    ABECService *service = APSharedResources.trackerslistDomains[request.name];
    self.serviceNameCell.detailTextLabel.text = service.name;
    self.serviceDescriptionCell.detailTextLabel.text = service.serviceDescription;
    self.servideCategoriesCell.detailTextLabel.text = [service.categories componentsJoinedByString:@", "];
    self.serviceNotesCell.detailTextLabel.text = [service.notes componentsJoinedByString:@", "];
    
    [self cell: self.serviceNameCell setHidden:!self.serviceNameCell.detailTextLabel.text.length];
    [self cell: self.serviceDescriptionCell setHidden:!self.serviceDescriptionCell.detailTextLabel.text.length];
    [self cell: self.servideCategoriesCell setHidden:!self.servideCategoriesCell.detailTextLabel.text.length];
    [self cell: self.serviceNotesCell setHidden:!self.serviceNotesCell.detailTextLabel.text.length];
    
    [self reloadDataAnimated:NO];
    
    NSMutableAttributedString *sb = [NSMutableAttributedString new];
    
    NSDictionary *bold = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightBold] };
    NSDictionary *normal = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightRegular] };
    
    if (self.logRecord.responses.count) {
        
        // Set status cell
        if (self.logRecord.isBlacklisted){
            
            NSString* statusText;
            
            NSString* domain = self.logRecord.requests[0].name;
            
            APBlockingSubscription* subscription = [APBlockingSubscriptionsManager checkDomain:domain];
            if(subscription) {
                statusText = [NSString stringWithFormat:@"Blocked by subscription: %@", subscription.name];
            }
            else {
                statusText = NSLocalizedString(@"Blocked by blacklist", @"(APUIDnsRequestDetail) PRO version. On the DNS Settigs -> View Filtering Log -> Request Details screen. Status text shown when a DNS request was blocked by the blacklist.");
            }
            
            self.statusCell.detailTextLabel.text = statusText;
        }
        else if (self.logRecord.isWhitelisted){
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Exception", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Details. If this DNS request was whitelisted, this will be shown as status text.");
        }
        else if (self.logRecord.preferredResponse.blocked) {
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Blocked by DNS", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests -> Request Details screen. Status text shown in case when a DNS request was blocked by the DNS server.");
        }
        else {
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Processed", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests screen -> Request Details. If this DNS request was processed as normal, this will be shown as status text.");
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
        
        NSString *text =  NSLocalizedString(@"No response", @"(APUIDnsRequestDetail) PRO version. On the DNS Filtering -> DNS Requests screen -> Request Details. It is the detailed text in the RESPONSES section, if this DNS request does not have a response.");
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
    
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
    
        [self setupDomainControllCell];
    });
}
/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickDomainControll:(id)sender {

    if (_domainControllCellType == DomainControllNone || [NSString isNullOrEmpty:_domainName]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        
        @autoreleasepool {
            
            if (_domainControllCellType == DomainControllAddToWhitelist) {
                
                NSArray *domainList = APSharedResources.whitelistDomains;
                if (domainList) {
                    APSharedResources.whitelistDomains = [domainList arrayByAddingObject:_domainName];
                }
                else {
                    APSharedResources.whitelistDomains = @[_domainName];
                }
            }
            else if (_domainControllCellType == DomainControllAddToBlacklist) {
                
                NSArray *domainList = APSharedResources.blacklistDomains;
                if (domainList) {
                    APSharedResources.blacklistDomains = [domainList arrayByAddingObject:_domainName];
                }
                else {
                    APSharedResources.blacklistDomains = @[_domainName];
                }
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
    });
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
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.domainControllCell.textLabel.textColor = self.domainControllCell.tintColor;
        });

        APDnsRequest *request = self.logRecord.requests[0];

        _domainName = request.name;
        
        NSArray *domainslist = APSharedResources.whitelistDomains;
        
        NSString *labelText;
        
        // We check on equal
        if ([domainslist containsObject:_domainName]) {
            
             labelText = NSLocalizedString(@"Remove from Whitelist", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests -> Request Details screen. Text on the button.");
            _domainControllCellType = DomainControllRemoveFromWhitelist;
        }
        else {
            
            domainslist = APSharedResources.blacklistDomains;
            if ([domainslist containsObject:_domainName]) {
                
                labelText = NSLocalizedString(@"Remove from Blacklist", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests -> Request Details screen. Text on the button.");
                _domainControllCellType = DomainControllRemoveFromBlacklist;
            }
            else {
                
                if (self.logRecord.preferredResponse.blocked) {
                    labelText = NSLocalizedString(@"Add to Whitelist", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests -> Request Details screen. Text on the button.");
                    _domainControllCellType = DomainControllAddToWhitelist;
                }
                else {
                    labelText = NSLocalizedString(@"Add to Blacklist", @"(APUIDnsRequestDetail) PRO version. On the System-wide Ad Blocking -> DNS Requests -> Request Details screen. Text on the button.");
                    _domainControllCellType = DomainControllAddToBlacklist;
                }
            }
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            self.domainControllCell.textLabel.text = labelText;
            [self reloadDataAnimated:YES];
        });
    }
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
