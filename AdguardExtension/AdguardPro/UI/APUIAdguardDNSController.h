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

#import "StaticDataTableViewController.h"
#import "APUIProSectionFooter.h"

@class AEUIMainController, APDnsServerObject;

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIProSectionController

@interface APUIAdguardDNSController : StaticDataTableViewController

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *dnsRequestsCell;
@property (strong, nonatomic) IBOutlet UISwitch *logSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *remoteDnsServerTemplateCell;

/////////////////////////////////////////////////////////////////////
#pragma mark Actions


- (IBAction)clickChooseServer:(id)sender;
- (IBAction)toggleSwitchStatus:(id)sender;
- (IBAction)toggleLogStatus:(id)sender;


/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)addDnsServer:(APDnsServerObject *)serverObject;

@end
