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
#define DNS_SERVER_SECTION_INDEX        2

#define DNS_SERVER_DETAIL_SEGUE         @"dnsServerDetailSegue"

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIAdguardDNSController

@implementation APUIAdguardDNSController {
    
    APUIProSectionFooter *_proFooter;
    id _observer;
    
    NSArray <APDnsServerObject *> *_dnsServers;
    BOOL _localFiltering;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.reloadTableViewRowAnimation = UITableViewRowAnimationAutomatic;
    
    [self attachToNotifications];
    
    APVPNManager *manager = [APVPNManager singleton];
    
    _dnsServers = manager.remoteDnsServers;
    [_dnsServers enumerateObjectsUsingBlock:^(APDnsServerObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self internalInsertDnsServer:obj atIndex:idx];
    }];
    
    self.statusLabel.accessibilityHint = [self shortStatusDescription];
    
    [self updateStatuses];
    
    [self.logSwitch setOn:manager.dnsRequestsLogging];

    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self reloadDataAnimated:NO];
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
#pragma mark Properties and public methods


- (void)addDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        if ([[APVPNManager singleton] addRemoteDnsServer:serverObject]) {
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            [self internalInsertDnsServer:serverObject atIndex:(_dnsServers.count - 1)];
            
            [self updateStatuses];
        }
    }
}

- (void)removeDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {

        NSUInteger index = [_dnsServers indexOfObject:serverObject];
        if (index == NSNotFound) {
            return;
        }
        
        if ([[APVPNManager singleton] removeRemoteDnsServer:serverObject]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
            [self removeCellAtIndexPath:indexPath];
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            
            [self updateStatuses];
        }
    }
}

- (void)modifyDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        NSUInteger index = [_dnsServers indexOfObject:serverObject];
        if (index == NSNotFound) {
            return;
        }
        
        if ([[APVPNManager singleton] resetRemoteDnsServer:serverObject]) {
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = [serverObject.serverName capitalizedString];
            cell.detailTextLabel.text = [serverObject.serverDescription lowercaseString];
            
            [self updateCell:cell];
            
            [self updateStatuses];
        }
    }
}


/////////////////////////////////////////////////////////////////////
#pragma mark  Actions
/////////////////////////////////////////////////////////////////////

- (IBAction)toggleLocalFiltering:(id)sender {
    
    APVPNManager.singleton.localFiltering = ! _localFiltering;
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
}

/////////////////////////////////////////////////////////////////////
#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:DNS_SERVER_DETAIL_SEGUE]) {
        
        APUIDnsServerDetailController *destination = (APUIDnsServerDetailController *)[(UINavigationController *)[segue destinationViewController]
                                         topViewController];
        
        destination.delegate = self;
        
        if ([sender isKindOfClass:[APDnsServerObject class]]) {
            
            APDnsServerObject *server = sender;
            
            destination.serverObject = server;
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Table Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    APDnsServerObject *selectedServer = [self remoteDnsServerAtIndexPath:indexPath];
    
    if (selectedServer) {
        
        APVPNManager.singleton.activeRemoteDnsServer = selectedServer;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(nonnull NSIndexPath *)indexPath {
    
    APDnsServerObject *selectedServer = [self remoteDnsServerAtIndexPath:indexPath];
    
    if (selectedServer) {
        
        [self performSegueWithIdentifier:DNS_SERVER_DETAIL_SEGUE sender:selectedServer];
    }
}

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
    
    _localFiltering = manager.localFiltering;
    
    self.localFilteringCell.imageView.image = _localFiltering ?
    [UIImage imageNamed:CHECKMARK_NORMAL_ENABLE] :
    [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];

    APDnsServerObject *activeDnsServer = manager.activeRemoteDnsServer;
    
    for (int i = 0; i < _dnsServers.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:DNS_SERVER_SECTION_INDEX];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        cell.imageView.image = [activeDnsServer isEqual:_dnsServers[i]] ?
        [UIImage imageNamed:CHECKMARK_NORMAL_ENABLE] :
        [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];
    }
    
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
    
    if (_dnsServers.count < manager.maxCountOfRemoteDnsServers) {

        self.addCustomCell.userInteractionEnabled = YES;
        self.addCustomCell.textLabel.enabled = YES;
    }
    else {
        
        self.addCustomCell.userInteractionEnabled = NO;
        self.addCustomCell.textLabel.enabled = NO;
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

- (void)internalInsertDnsServer:(APDnsServerObject *)serverObject atIndex:(NSUInteger)index{
    
    UITableViewCell *templateCell = self.remoteDnsServerTemplateCell;
    UITableViewCell *newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    newCell.tag = index;
    
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
    [self insertCell:newCell atIndexPath:indexPath];
}

- (APDnsServerObject *)remoteDnsServerAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != DNS_SERVER_SECTION_INDEX) {
        return nil;
    }
    
    NSUInteger index = indexPath.row;
    if (index < _dnsServers.count) {
        
        return _dnsServers[index];
    }
    
    return nil;
}

@end
