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


#import "APUIDnsServersController.h"
#import "APVPNManager.h"
#import "ACommons/ACSystem.h"
#import "APDnsServerObject.h"
#import "APUIDnsServerDetailController.h"

#define CHECKMARK_NORMAL_DISABLE        @"table-empty"
#define CHECKMARK_NORMAL_ENABLE         @"table-checkmark"

#define DNS_SERVER_SECTION_INDEX        1
#define DNS_DESCRIPTION_SECTION_INDEX   0

#define DNS_SERVER_DETAIL_SEGUE         @"dnsServerDetailSegue"

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIDnsServersController

@implementation APUIDnsServersController {
    
    id _observer;
    
    NSArray <APDnsServerObject *> *_dnsServers;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.reloadTableViewRowAnimation = UITableViewRowAnimationAutomatic;
    
    self.addCustomCell.accessibilityTraits |= UIAccessibilityTraitButton;
    self.systemDefaultCell.accessibilityTraits |= UIAccessibilityTraitButton;
    
    [self attachToNotifications];
    
    APVPNManager *manager = [APVPNManager singleton];
    
    _dnsServers = manager.remoteDnsServers;
    
    APDnsServerObject *systemDefault = _dnsServers[0];
    self.systemDefaultCell.textLabel.text = systemDefault.serverName;
    self.systemDefaultCell.detailTextLabel.text = systemDefault.serverDescription;
    [_dnsServers enumerateObjectsUsingBlock:^(APDnsServerObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx) {
            [self internalInsertDnsServer:obj atIndex:idx];
        }
    }];
    
    [self reloadDataAnimated:NO];
    
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


/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods


- (void)addDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        if ([[APVPNManager singleton] addRemoteDnsServer:serverObject]) {
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            [self internalInsertDnsServer:serverObject atIndex:(_dnsServers.count - 1)];
            
            [self reloadDataAnimated:YES];
        }
    }
}

- (void)removeDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        NSUInteger index = [_dnsServers indexOfObject:serverObject];
        if (index == NSNotFound) {
            return;
        }
        
        // because from second server
        index --;
        
        if ([[APVPNManager singleton] removeRemoteDnsServer:serverObject]) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
            [self removeCellAtIndexPath:indexPath];
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            
            [self reloadDataAnimated:YES];
        }
    }
}

- (void)modifyDnsServer:(APDnsServerObject *)serverObject {
    
    if (serverObject) {
        
        NSUInteger index = [_dnsServers indexOfObject:serverObject];
        if (index == NSNotFound) {
            return;
        }
        
        // because from second server
        index --;
        
        if ([[APVPNManager singleton] resetRemoteDnsServer:serverObject]) {
            
            _dnsServers = APVPNManager.singleton.remoteDnsServers;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = serverObject.serverName;
            cell.detailTextLabel.text = serverObject.serverDescription;
            
            [self updateCell:cell];
            
            [self reloadDataAnimated:YES];
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Navigation

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

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    
    // tunning accessibility
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.isAccessibilityElement = NO;
    footer.textLabel.isAccessibilityElement = NO;
    footer.detailTextLabel.isAccessibilityElement = NO;
    
    if (section == DNS_DESCRIPTION_SECTION_INDEX) {
        self.systemDefaultCell.accessibilityHint = footer.textLabel.text;
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
    
    APDnsServerObject *activeDnsServer = manager.activeRemoteDnsServer;
    
    if ([activeDnsServer.tag isEqualToString:APDnsServerTagLocal]) {
        
        self.systemDefaultCell.imageView.image = [UIImage imageNamed:CHECKMARK_NORMAL_ENABLE];
        self.systemDefaultCell.accessibilityTraits |= UIAccessibilityTraitSelected;
    }
    else {
        
        self.systemDefaultCell.imageView.image = [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];
        self.systemDefaultCell.accessibilityTraits &= ~UIAccessibilityTraitSelected;
    }
    
    for (int i = 1; i < _dnsServers.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(i - 1) inSection:DNS_SERVER_SECTION_INDEX];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([activeDnsServer isEqual:_dnsServers[i]]) {
            
            cell.imageView.image = [UIImage imageNamed:CHECKMARK_NORMAL_ENABLE];
            cell.accessibilityTraits |= UIAccessibilityTraitSelected;
        }
        else {
            
            cell.imageView.image = [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];
            cell.accessibilityTraits &= ~UIAccessibilityTraitSelected;
        }
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
                                     @"(APUIAdguardDNSController) PRO version. Alert title. On error.")
         message:manager.lastError.localizedDescription];
    }
    
    [self reloadDataAnimated:YES];
}

- (void)internalInsertDnsServer:(APDnsServerObject *)serverObject atIndex:(NSUInteger)index{
    
    // because from second server
    index--;
    
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
    
    newCell.textLabel.text = serverObject.serverName;
    newCell.detailTextLabel.text = serverObject.serverDescription;
    newCell.imageView.image= [UIImage imageNamed:CHECKMARK_NORMAL_DISABLE];
    if (serverObject.editable) {
        newCell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    newCell.accessibilityTraits |= UIAccessibilityTraitButton;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:DNS_SERVER_SECTION_INDEX];
    [self insertCell:newCell atIndexPath:indexPath];
}

- (APDnsServerObject *)remoteDnsServerAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    
    if (indexPath.section == DNS_SERVER_SECTION_INDEX) {
        // because from second server
        index ++;
    }
    
    if (index < _dnsServers.count) {
        
        return _dnsServers[index];
    }
    
    return nil;
}

@end
