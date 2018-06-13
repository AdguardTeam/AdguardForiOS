/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

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
#import "AEUIAboutController.h"
#import "ADomain/ADomain.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ACommons/ACFiles.h"
#import "ASDModels/ASDFilterObjects.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AESharedResources.h"
#import "NSData+GZIP.h"

#define ADGUARD_WEBSITE_LINK        @"http://adguard.com/"
#define ADGUARD_FORUM_LINK          @"http://forum.adguard.com/"
#define ADGUARD_ACKNOWLEDGEMENTS    @"http://adguard.com/acknowledgements.html#ios-acknowledgments"

#define VIDEO_IMAGE_MAX_HEIGHT 200

@interface AEUIAboutController ()

@end

@implementation AEUIAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.versionLabel.text = [ADProductInfo versionWithBuildNumber];
    
    // remove cell separator
    for (UIView *view in self.manageContentBlockerCell.subviews){
        
        if(view != self.manageContentBlockerCell.contentView) {
            [view removeFromSuperview];
        }
    }
    for (UIView *view in self.managePrivacySettingsCell.subviews){
        
        if(view != self.managePrivacySettingsCell.contentView) {
            [view removeFromSuperview];
        }
    }
    
#ifndef PRO
    [self cell: self.managePrivacySettingsCell setHidden:YES];
    [self reloadDataAnimated:NO];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)clickAdguardWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ADGUARD_WEBSITE_LINK] options:@{} completionHandler:nil];
}

- (IBAction)clickAdguardForum:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ADGUARD_FORUM_LINK] options:@{} completionHandler:nil];
}

- (IBAction)clickAcknowledgments:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ADGUARD_ACKNOWLEDGEMENTS] options:@{} completionHandler:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0) {
        
        UIImage *image = [UIImage imageNamed:@"video-image"];
        CGFloat desiredHeight = [UIScreen mainScreen].bounds.size.width * image.size.height / image.size.width;
        
        return MIN(desiredHeight, VIDEO_IMAGE_MAX_HEIGHT);
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end
