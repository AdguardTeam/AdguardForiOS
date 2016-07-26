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

#import "APUIAdguardDNSController.h"
#import "APVPNManager.h"
#import "ACommons/ACSystem.h"

#define PRO_SECTION_INDEX               0
#define NBSP_CODE                       @"\u00A0"
#define LINK_URL_STRING                 @"https://adguard.com/adguard-dns/overview.html#overview"

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIAdguardDNSController

@implementation APUIAdguardDNSController {
    
    APUIProSectionFooter *_proFooter;
    id _observer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self attachToNotifications];
    
    APVPNManager *manager = [APVPNManager singleton];
    
    self.defaultDnsCell.textLabel.text = [manager modeDescription:APVpnModeDNS];
    self.familyDnsCell.textLabel.text = [manager modeDescription:APVpnModeFamilyDNS];
    
    [self updateStatuses];
    
    [self.logSwitch setOn:manager.dnsRequestsLogging];

    [self updateLogStatus];
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
#pragma mark Properties and public methods


/////////////////////////////////////////////////////////////////////
#pragma mark  Actions
/////////////////////////////////////////////////////////////////////

- (IBAction)clickChooseServer:(id)sender {
    
    UITableViewCell *cell = (UITableViewCell *) [sender view];
    
    [[APVPNManager singleton] setMode:(APVpnMode)cell.tag];
}

- (IBAction)toggleSwitchStatus:(id)sender {
    
    BOOL enabled = [(UISwitch *)sender isOn];
    [[APVPNManager singleton] setEnabled:enabled];
}

- (IBAction)toggleLogStatus:(id)sender {
    
    APVPNManager *manager = [APVPNManager singleton];
    manager.dnsRequestsLogging = self.logSwitch.isOn;
    if (manager.lastError) {
        
        [self.logSwitch setOn:manager.dnsRequestsLogging animated:YES];
    }
    [self updateLogStatus];
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Table Delegate Methods


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == PRO_SECTION_INDEX) {
        
        return [self proSectionFooter];
    }
    
    return [super tableView:tableView viewForFooterInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == PRO_SECTION_INDEX) {
        
        APUIProSectionFooter *footer = [self proSectionFooter];
        return footer.height;
    }
    
    return [super tableView:tableView heightForFooterInSection:section];
}


/////////////////////////////////////////////////////////////////////
#pragma mark  Helper Methods (Private)
/////////////////////////////////////////////////////////////////////

- (APUIProSectionFooter *)proSectionFooter{
    
    if (_proFooter) {
        return _proFooter;
    }
    
    _proFooter = [[APUIProSectionFooter alloc] initWithFrame:self.view.bounds];
    _proFooter.text = [self textForProSectionFooter];
    
    return _proFooter;
}



- (NSAttributedString *)textForProSectionFooter{
    
    NSString *message = NSLocalizedString(@"To make system use Adguard DNS, app establishes a fake VPN connection. Please note that your traffic is not routed through any remote server.", @"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. It is the description under Adguard DNS switch.");
    
    NSString *linkFormat = NSLocalizedString(@"Learn more about[nbsp]Adguard[nbsp]DNS.", @"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Link text of the website with the decription.  Where '[nbsp]' stands for 'non-breakable space'.");
    
    NSString *linkText = [@" " stringByAppendingString:
                          [linkFormat stringByReplacingOccurrencesOfString:@"[nbsp]"
                                                                withString:NBSP_CODE]
                          ];
    
    NSAttributedString *link = [[NSAttributedString alloc]
                                initWithString: linkText
                                attributes:@{NSLinkAttributeName: [NSURL URLWithString:LINK_URL_STRING]}];
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:message];
    
    [textString appendAttributedString:link];
    
    return textString;
}

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
    
    self.defaultDnsCell.accessoryType =
    self.familyDnsCell.accessoryType = UITableViewCellAccessoryNone;
    
    switch (manager.vpnMode) {
            
        case APVpnModeDNS:
            self.defaultDnsCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
            
        case APVpnModeFamilyDNS:
            self.familyDnsCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
            
        default:
            break;
    }
    
    switch (manager.connectionStatus) {
            
        case APVpnConnectionStatusReconnecting:
            self.statusSwitch.on = YES;

            self.logSwitch.enabled = YES;
            
        case APVpnConnectionStatusConnecting:
        case APVpnConnectionStatusDisconnecting:
            self.statusLabel.text = NSLocalizedString(@"In Progress",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is 'In Progress'.");
            break;
            
        case APVpnConnectionStatusConnected:
            self.statusLabel.text = NSLocalizedString(@"On",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is On.");
            self.statusSwitch.on = YES;
            
            self.logSwitch.enabled = YES;
            break;
            
        default:
            self.statusLabel.text = NSLocalizedString(@"Off",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is Off.");
            self.statusSwitch.on = NO;
            
            [self.logSwitch setOn:NO animated:YES];
            self.logSwitch.enabled = NO;
            [self toggleLogStatus:nil];
            break;
    }
    
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

- (void)updateLogStatus{
    
    BOOL logEnabled = [[APVPNManager singleton] dnsRequestsLogging];
    self.dnsRequestsCell.textLabel.enabled
    = self.dnsRequestsCell.userInteractionEnabled
    = logEnabled;
}

@end
