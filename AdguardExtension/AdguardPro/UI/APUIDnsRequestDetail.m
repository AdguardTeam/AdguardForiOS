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
    ASDFilterRule *_appropriateRuleForDomain;
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

    _domainControllCellType = DomainControllNone;
    
    self.hideSectionsWithHiddenRows = YES;
    APDnsRequest *request = self.logRecord.requests[0];
    
    self.timeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [_timeFormatter stringFromDate:self.logRecord.recordDate],
                               DATE_FORMAT(self.logRecord.recordDate)];
    
    self.nameCell.longLabel.text = request.name;
    self.typeCell.detailTextLabel.text = [request.type description];
    self.serverCell.detailTextLabel.text = [[APVPNManager singleton] modeDescription:[self.logRecord.vpnMode intValue]];
    
    NSMutableAttributedString *sb = [NSMutableAttributedString new];
    
    NSDictionary *bold = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightBold] };
    NSDictionary *normal = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightRegular] };
    
    if (self.logRecord.responses.count) {
        
        // Set status cell
        if (self.logRecord.preferredResponse.blocked) {
           
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Blocked", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. If this DNS request was blocked. this will be shown as status text.");
        }
        else if (self.logRecord.isWhitelisted){
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Exception", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. If this DNS request was for domain from the whitelist, this will be shown as status text.");
        }
        else {
            
            self.statusCell.detailTextLabel.text = NSLocalizedString(@"Processed", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. If this DNS request was processed as normal, this will be shown as status text.");
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
        
        NSString *text =  NSLocalizedString(@"No response", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. It is the detailed text in RESPONSES section, if this DNS request do not have response.");
        self.responsesCell.longLabel.text = text;
        self.statusCell.detailTextLabel.text = text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    if (_domainControllCellType == DomainControllNone || !_appropriateRuleForDomain) {
        return;
    }
    
    [[[AEService singleton] antibanner] beginTransaction];

    dispatch_block_t completionBlock = ^(){
        
        [[[AEService singleton] antibanner] endTransaction];
        [[APVPNManager singleton] sendReloadUserfilterDataIfRule:_appropriateRuleForDomain];
        [self setupDomainControllCell];
    };
    

    if (_domainControllCellType == DomainControllAddToWhitelist) {
        
        [AEUIUtils addWhitelistRule:_appropriateRuleForDomain toJsonWithController:self completionBlock:completionBlock rollbackBlock:^{
            
            [[[AEService singleton] antibanner] rollbackTransaction];
        }];
    }
    else if (_domainControllCellType == DomainControllAddToBlacklist) {
    
        [AEUIUtils addRule:_appropriateRuleForDomain withController:self completionBlock:completionBlock rollbackBlock:^{
            
            [[[AEService singleton] antibanner] rollbackTransaction];
        }];
    }
    else if (_domainControllCellType == DomainControllRemoveFromWhitelist) {
        
        [AEUIUtils removeWhitelistRule:_appropriateRuleForDomain toJsonWithController:self completionBlock:completionBlock rollbackBlock:^{
            
            [[[AEService singleton] antibanner] rollbackTransaction];
        }];
       
    }
    else if (_domainControllCellType == DomainControllRemoveFromBlacklist) {
        
        [AEUIUtils removeRule:_appropriateRuleForDomain withController:self completionBlock:completionBlock rollbackBlock:^{
            
            [[[AEService singleton] antibanner] rollbackTransaction];
        }];
    }
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
        _appropriateRuleForDomain = nil;
        
        self.domainControllCell.textLabel.textColor = self.domainControllCell.textLabel.tintColor;

        APDnsRequest *request = self.logRecord.requests[0];

        NSArray *rules = [[[AEService singleton] antibanner]
            rulesForFilter:@(ASDF_USER_FILTER_ID)];
        rules = [rules
                 filteredArrayUsingPredicate:
                 [NSPredicate
                  predicateWithFormat:@"ruleText CONTAINS[cd] %@",
                  request.name]];
        
        AEWhitelistDomainObject *whitelistObject;
        AEBlacklistDomainObject *blacklistObject;
        
        if (rules.count) {
            
            
            
            AEWhitelistDomainObject *object;
            for (ASDFilterRule *item in rules) {
                
                object = [[AEWhitelistDomainObject alloc] initWithRule:item];
                if (object && [object.domain isEqualToString:request.name]) {
                    whitelistObject = object;
                }
                else {
                    
                    object = [[AEBlacklistDomainObject alloc] initWithRule:item];
                    if (object && [object.domain isEqualToString:request.name] ) {
                        blacklistObject = (AEBlacklistDomainObject *)object;
                    }
                }
            }
            
        }
        
        if (whitelistObject){
            self.domainControllCell.textLabel.text = NSLocalizedString(@"Remove from Whitelist", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. Text on button");
            _domainControllCellType = DomainControllRemoveFromWhitelist;
            _appropriateRuleForDomain = whitelistObject.rule;
        }
        else if (blacklistObject) {
            self.domainControllCell.textLabel.text = NSLocalizedString(@"Remove from Blacklist", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. Text on button");
            _domainControllCellType = DomainControllRemoveFromBlacklist;
            _appropriateRuleForDomain = blacklistObject.rule;
        }
        else {
            
            if (self.logRecord.preferredResponse.blocked) {
                self.domainControllCell.textLabel.text = NSLocalizedString(@"Add to Whitelist", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. Text on button");
                _domainControllCellType = DomainControllAddToWhitelist;
                _appropriateRuleForDomain = [[[AEWhitelistDomainObject alloc] initWithDomain:request.name] rule];
            }
            else {
                self.domainControllCell.textLabel.text = NSLocalizedString(@"Add to Blacklist", @"(APUIDnsRequestDetail) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. Text on button");
                _domainControllCellType = DomainControllAddToBlacklist;
                _appropriateRuleForDomain = [[[AEBlacklistDomainObject alloc] initWithDomain:request.name] rule];
            }
        }
        
        [self reloadDataAnimated:YES];
    }
}

@end
