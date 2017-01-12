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
#import "APDnsServerObject.h"
#import "APUIDnsServerDetailController.h"

#define PRO_SECTION_INDEX               0
#define NBSP_CODE                       @"\u00A0"
#define LINK_URL_STRING                 @"https://adguard.com/adguard-dns/overview.html#overview"

#define CHECKMARK_NORMAL_DISABLE        @"table-empty"
#define CHECKMARK_NORMAL_ENABLE         @"table-checkmark"

#define DNS_SERVER_CELL_TEMPLATE_TAG    111
#define DNS_SERVER_SECTION              2

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIAdguardDNSController

@implementation APUIAdguardDNSController {
    
    APUIProSectionFooter *_proFooter;
    id _observer;
    
    NSMutableArray <APDnsServerObject *> *_dnsServers;
    BOOL _dnsServersChanged;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self attachToNotifications];
    
    APVPNManager *manager = [APVPNManager singleton];
    
    _dnsServers = [NSMutableArray new];
    _dnsServersChanged = YES;
    
//    self.defaultDnsCell.textLabel.text = [manager modeDescription:APVpnModeDNS];
//    self.familyDnsCell.textLabel.text = [manager modeDescription:APVpnModeFamilyDNS];
//    
//    self.defaultDnsCell.accessibilityTraits |= UIAccessibilityTraitButton;
//    self.familyDnsCell.accessibilityTraits |= UIAccessibilityTraitButton;
    
    self.statusLabel.accessibilityHint = [self shortStatusDescription];
    
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


- (void)addDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        UITableViewCell *templateCell = self.remoteDnsServerTemplateCell;
        UITableViewCell *newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        newCell.textLabel.textColor = templateCell.textLabel.textColor;
        newCell.textLabel.font = templateCell.textLabel.font;
        newCell.detailTextLabel.textColor = templateCell.detailTextLabel.textColor;
        newCell.detailTextLabel.font = templateCell.detailTextLabel.font;
        newCell.indentationLevel = templateCell.indentationLevel;
        newCell.indentationWidth = templateCell.indentationWidth;
        newCell.selectionStyle = templateCell.selectionStyle;
        
        newCell.textLabel.text = [serverObject.serverName capitalizedString];
        newCell.detailTextLabel.text = [serverObject.serverDescription lowercaseString];
        newCell.imageView.image= [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];
        if (serverObject.editable) {
            newCell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
        
        newCell.accessibilityTraits |= UIAccessibilityTraitButton;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dnsServers.count inSection:DNS_SERVER_SECTION];
        [self insertCell:newCell atIndexPath:indexPath];
        
        _dnsServersChanged = YES;
        
        [_dnsServers addObject:serverObject];
    }
}

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
#pragma mark Navigation

//- (void)viewWillAppear:(BOOL)animated{
//    
//    if (_dnsServersChanged) {
//        _dnsServersChanged = NO;
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//            [self reloadDataAnimated:YES];
//        });
//    }
//}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"dnsServerDetailSegue"]) {
        
        APUIDnsServerDetailController *destination = (APUIDnsServerDetailController *)[(UINavigationController *)[segue destinationViewController]
                                         topViewController];
        
        destination.delegate = self;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
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

- (NSString *)shortStatusDescription {
    
    return NSLocalizedString(@"To make system use Adguard DNS, app establishes a fake VPN connection. Please note that your traffic is not routed through any remote server.", @"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. It is the description under Adguard DNS switch.");
}

- (NSAttributedString *)textForProSectionFooter{
    
    NSString *message = [self shortStatusDescription];
    
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
    //TODO:
    /*
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
*/
    self.statusSwitch.on = self.logSwitch.enabled = manager.enabled;
    if (!manager.enabled) {
        
        [self.logSwitch setOn:NO animated:YES];
        [self toggleLogStatus:nil];
    }
    
    switch (manager.connectionStatus) {
            
        case APVpnConnectionStatusReconnecting:
        case APVpnConnectionStatusConnecting:
        case APVpnConnectionStatusDisconnecting:
            self.statusLabel.text = NSLocalizedString(@"In Progress",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is 'In Progress'.");
            break;
            
        case APVpnConnectionStatusConnected:
            self.statusLabel.text = NSLocalizedString(@"Connected",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is Connected.");
            break;
            
        default:
            self.statusLabel.text = NSLocalizedString(@"Not Connected",@"(APUIAdguardDNSController) PRO version. On the Adguard DNS settings screen. Current status title. When status is Not Connected.");
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
