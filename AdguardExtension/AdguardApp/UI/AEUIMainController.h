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
#import "StaticDataTableViewController.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController Constants
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIMainController
/////////////////////////////////////////////////////////////////////

@interface AEUIMainController : StaticDataTableViewController < MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UITableViewCell *shareCell;

@property (weak, nonatomic) IBOutlet UISwitch *enableAdguardSwitch;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIButton *mailButton;
@property (weak, nonatomic) IBOutlet UILabel *whitelistLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastUpdated;
@property (weak, nonatomic) IBOutlet UITableViewCell *checkFiltersCell;

@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *proSectionCells;
@property (weak, nonatomic) IBOutlet UITableViewCell *proDnsSettingsCell;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *getProButton;

@property (nonatomic) NSNumber *startStatus;

- (IBAction)toggleAdguard:(id)sender;
- (IBAction)clickTwitter:(id)sender;
- (IBAction)clickFacebook:(id)sender;
- (IBAction)clickMessage:(id)sender;
- (IBAction)clickMail:(id)sender;
- (IBAction)clickViewOnGitHub:(id)sender;
- (IBAction)clickCheckForUpdates:(id)sender;
- (IBAction)clickRateThisApp:(id)sender;
- (IBAction)clickSendBugReport:(id)sender;
- (IBAction)clickGetPro:(id)sender;

/**
 Adds rule to User filter.
 This method is used for adding rule from "open URL" command.
 */
- (void)addRuleToUserFilter:(NSString *)ruleText;

@end
