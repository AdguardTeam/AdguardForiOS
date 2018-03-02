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

#import <UIKit/UIKit.h>
#import "StaticDataTableViewController.h"

@class APDnsServerObject, APUIDnsServersController;

/////////////////////////////////////////////////////////////////////
#pragma mark - APUIDnsServerDetailController
@interface APUIDnsServerDetailController : StaticDataTableViewController <UITextViewDelegate>

/////////////////////////////////////////////////////////////////////
#pragma mark Public Methods and Properties


@property APDnsServerObject *serverObject;
@property (weak, nonatomic) APUIDnsServersController *delegate;
@property (nonatomic) BOOL dnsCrypt;

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextView *ipAddressesTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *removeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *ipaddressesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resolverNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *resolverAddressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *publicKeyCell;

@property (weak, nonatomic) IBOutlet UITextField *resolverNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *resolverAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *publicKeyTextField;

/////////////////////////////////////////////////////////////////////
#pragma mark Actions

- (IBAction)clickOnTableView:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickDone:(id)sender;
- (IBAction)clickRemove:(id)sender;

- (IBAction)nameChanged:(id)sender;
- (IBAction)descriptionChanged:(id)sender;

@end
