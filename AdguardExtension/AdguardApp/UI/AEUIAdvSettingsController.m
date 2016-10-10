/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
#import "AEUIAdvSettingsController.h"
#import "ACommons/ACLang.h"
#import "AESharedResources.h"
#import "AEUIUtils.h"

@interface AEUIAdvSettingsController ()

@end

@implementation AEUIAdvSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.simplifiedButton.on = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize];
    self.wifiButton.on = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsWifiOnlyUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(nonnull UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    
    footer.isAccessibilityElement = NO;
    footer.textLabel.isAccessibilityElement = NO;
    footer.detailTextLabel.isAccessibilityElement = NO;
    
    if (section == 0) {
        self.autoUpdateCell.accessibilityHint = footer.textLabel.text;
    }
    else if (section == 1) {
        
        self.useSimplifiedCell.accessibilityHint = footer.textLabel.text;
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Actions
/////////////////////////////////////////////////////////////////////

- (IBAction)toggleSimplified:(id)sender {

    BOOL oldValue = [[AESharedResources sharedDefaults] boolForKey:AEDefaultsJSONConverterOptimize];
    BOOL newValue = [sender isOn];
    
    if (oldValue != newValue) {
        
        [AESharedResources sharedDefaultsSetTempKey:AEDefaultsJSONConverterOptimize value:@(newValue)];
        [AEUIUtils invalidateJsonWithController:self completionBlock:^{
           
            [[AESharedResources sharedDefaults] setBool:newValue forKey:AEDefaultsJSONConverterOptimize];
            [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONConverterOptimize];
            
        } rollbackBlock:^{
            
            [AESharedResources sharedDefaultsRemoveTempKey:AEDefaultsJSONConverterOptimize];
            [sender setOn:oldValue animated:YES];
        }];
    }
}

- (IBAction)toggleWifiOnly:(id)sender {
    
    [[AESharedResources sharedDefaults] setBool:[sender isOn] forKey:AEDefaultsWifiOnlyUpdates];
}


@end
