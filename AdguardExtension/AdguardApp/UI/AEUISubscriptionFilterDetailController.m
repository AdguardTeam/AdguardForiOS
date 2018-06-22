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
#import "AEUISubscriptionFilterDetailController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ASDModels/ASDFilterObjects.h"
#import "AEUISubscriptionController.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEUILoadingModal.h"
#import "AEUIUtils.h"
#import "AEUISubscriptionSectionObject.h"

@interface AEUISubscriptionFilterDetailController (){

    ACLJobController *subscribeJobController;
}

@end

@implementation AEUISubscriptionFilterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameCell.longLabel.text = self.meta.i18nName;
    self.descriptionCell.longLabel.text = self.meta.i18nDescription;
    self.filterVersion.text = self.meta.version;
    self.filterLastModified.text =
        [NSDateFormatter localizedStringFromDate:self.meta.updateDate
                                       dateStyle:NSDateFormatterShortStyle
                                       timeStyle:NSDateFormatterShortStyle];
    // tunning accessibility
    self.filterLastModified.accessibilityLabel =
    [NSDateFormatter localizedStringFromDate:self.meta.updateDate
                                   dateStyle:NSDateFormatterLongStyle
                                   timeStyle:NSDateFormatterShortStyle];
    //-----------------
    
    self.statusButton.on = [self.meta.enabled boolValue];

    if ([NSString isNullOrEmpty:self.meta.homepage]) {
        [self.homePageRow setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.parent.tableView reloadRowsAtIndexPaths:@[self.selectedFilterCellPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////
#pragma mark - Actions
/////////////////////////////////////////////////////////////////////


- (IBAction)cancelSubsrciption:(id)sender {
    
    [subscribeJobController cancel];
}

- (IBAction)toggleFilter:(id)sender {
    
    UISwitch *button = (UISwitch *)sender;
    ASDFilterMetadata *meta = self.meta;
    if (meta && ([meta.enabled boolValue] != button.on)) {
        
        meta.enabled = @(button.on);
        
        //BEGIN ANTIBANNER TRANSACTION
        [[[AEService singleton] antibanner] beginTransaction];
        
        NSArray *filters = [[[AEService singleton] antibanner] filters];
        if ([filters containsObject:meta]) {
            
            // Set enabled/disabled
            [[[AEService singleton] antibanner]
             setFilter:meta.filterId
             enabled:[meta.enabled boolValue]
             fromUI:YES];
            
            //Perform reloading JSON
            [self reloadJSON:button filterMeta:meta];
            
        } else if ([button isOn]) {
            
            // Subscribe
            AEUILoadingModal *modal = [AEUILoadingModal singleton];
            [modal loadingModalShowWithParent:self message:ACLocalizedString(@"loading_filter_caption", @"(AEUISubscriptionController) When toggling filter button and subscription process goes.") cancelAction:@selector(cancelSubsrciption:) completion:^{
                
                dispatch_async(
                               dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^{
                                   @autoreleasepool {
                                       
                                       subscribeJobController = [ACLJobController new];
                                       [subscribeJobController start];
                                       
                                       meta.enabled = @(YES);
                                       BOOL result = [[[AEService singleton] antibanner]
                                                      subscribeFilters:@[meta]
                                                      jobController:subscribeJobController];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [subscribeJobController stop];
                                           
                                           if (subscribeJobController.state == ACLJCCancelSate) {
                                               
                                               // user pressed cancel button, rollback
                                               [button setOn:NO animated:YES];
                                               meta.enabled = @(NO);
                                               [[[AEService singleton] antibanner] rollbackTransaction];
                                               
                                           }
                                           else if (!result){
                                               
                                               //rollback
                                               [button setOn:NO animated:YES];
                                               meta.enabled = @(NO);
                                               [[[AEService singleton] antibanner] rollbackTransaction];
                                               
                                               
                                               [ACSSystemUtils showSimpleAlertForController:self withTitle:ACLocalizedString(@"common_error_title", @"(AEUISubscriptionController) Alert title. When subscription process failed.") message:ACLocalizedString(@"filter_loading_error", @"(AEUISubscriptionController) Alert message. When subscription process failed.")];
                                               
                                           }
                                           else{
                                               
                                               //Perform reloading JSON
                                               [self reloadJSON:button filterMeta:meta];
                                           }
                                           
                                       });
                                   }
                               });
            }];
        }
    }
}


/////////////////////////////////////////////////////////////////////
#pragma mark Table View Delegates
/////////////////////////////////////////////////////////////////////

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0) {

        // Fitting size of the filter name
        return [self.nameCell fitHeight];
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        
        // Fitting size of the filter description
        return [self.descriptionCell fitHeight];
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Selected Home Page
    if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            
            NSURL *theURL = [NSURL URLWithString:self.meta.homepage];
            [[UIApplication sharedApplication] openURL:theURL options:@{} completionHandler:nil];
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////

- (void)reloadJSON:(UISwitch *)sender filterMeta:(ASDFilterMetadata *)meta{
    
    //Perform reloading JSON
    [AEUIUtils invalidateJsonWithController:self completionBlock:^{
        
        [[[AEService singleton] antibanner] endTransaction];
        
        [self.parent updateStatusInfo];
        
    } rollbackBlock:^{
        
        [[[AEService singleton] antibanner] rollbackTransaction];
        
        BOOL enabled = ![meta.enabled boolValue];
        meta.enabled = @(enabled);
        [sender setOn:enabled animated:YES];
    }];
}

@end
