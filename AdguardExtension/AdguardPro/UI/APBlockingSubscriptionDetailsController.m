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

#import "APBlockingSubscriptionDetailsController.h"
#import "AEUILongLabelViewCell.h"
#import "AEUILabelWithCopy.h"

@interface APBlockingSubscriptionDetailsController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;
@property (weak, nonatomic) IBOutlet AEUILongLabelViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet AEUILabelWithCopy *descriptionLabel;


@end

@implementation APBlockingSubscriptionDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.subscription.name;
    
    if(self.subscription.rulesCount) {
        NSString* format = NSLocalizedString(@"%d rules", @"(APBlockingSubscriptionDetailsController.h) rules count format");
        self.rulesCountLabel.text = [NSString stringWithFormat:format, self.subscription.rulesCount];
    }
    
    self.descriptionLabel.text = self.subscription.subscriptionDescription;
    
    self.lastModifiedLabel.text = [NSDateFormatter
                                   localizedStringFromDate: self.subscription.updateDate
                                   dateStyle: NSDateFormatterShortStyle
                                   timeStyle: NSDateFormatterShortStyle];
}

#pragma mark table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 2 && indexPath.row == 0) {
        
        // Fitting size of the filter name
        return [self.descriptionCell fitHeight];
    }
   
    return UITableViewAutomaticDimension;
}

#pragma mark actions

- (IBAction)deleteAction:(id)sender {
    
    if(self.removeBlock) {
        self.removeBlock(self.subscription);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
