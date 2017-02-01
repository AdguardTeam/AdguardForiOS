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
#import "APUIDomainListController.h"


#define SEGUE_BLACKLIST         @"blacklist"
#define SEGUE_WHITELIST         @"whitelist"

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
                                                             @"(APUIAdguardDNSController) PRO version. Title of the 'Back' button on cancel operation.")
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
#pragma mark Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


/////////////////////////////////////////////////////////////////////
#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BOOL toWhitelist = [segue.identifier isEqualToString:SEGUE_WHITELIST];
    BOOL toBlacklist = [segue.identifier isEqualToString:SEGUE_BLACKLIST];
    
    if (toBlacklist || toWhitelist) {
    
        APUIDomainListController *domainList = segue.destinationViewController;
        
        domainList.navigationItem.title = toWhitelist
        ? NSLocalizedString(@"Whitelist", @"(APUIAdguardDNSController) PRO version. Title of the system-wide whitelist screen.")
        : NSLocalizedString(@"Blacklist", @"(APUIAdguardDNSController) PRO version. Title of the system-wide blacklist screen.");
        self.navigationItem.backBarButtonItem = _cancelNavigationItem;
        
    }
    else {
        
        self.navigationItem.backBarButtonItem = nil;
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
