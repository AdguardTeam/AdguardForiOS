/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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
#import "APUIProStatusTableViewCell.h"

@class APDnsServerObject;

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIDnsServersController

@interface APUIDnsServersController  : StaticDataTableViewController

/////////////////////////////////////////////////////////////////////
#pragma mark init
+ (void)createDnsSercersControllerWithSegue:(UIStoryboardSegue *)segue status:(NSNumber*)status;

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (strong, nonatomic) IBOutlet UITableViewCell *remoteDnsServerTemplateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addCustomCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *systemDefaultCell;
@property (weak, nonatomic) IBOutlet UISwitch *proStatusSwitch;
@property (weak, nonatomic) IBOutlet APUIProStatusTableViewCell *proStatusCell;

@property (strong, nonatomic) IBOutlet UISwitch *logSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *whitelistCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *blacklistCell;


/////////////////////////////////////////////////////////////////////
#pragma mark Actions


/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)addDnsServer:(APDnsServerObject *)serverObject;
- (void)removeDnsServer:(APDnsServerObject *)serverObject;
- (void)modifyDnsServer:(APDnsServerObject *)serverObject;

@end
