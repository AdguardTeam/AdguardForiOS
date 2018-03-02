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
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AEUIAboutController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *howToEnableCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *howToAddRulesCell;

- (IBAction)clickAdguardWebsite:(id)sender;
- (IBAction)clickAdguardForum:(id)sender;
- (IBAction)clickAcknowledgments:(id)sender;

@end
