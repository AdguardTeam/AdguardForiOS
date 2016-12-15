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
#import "AEUIWhitelistController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEWhitelistDomainObject.h"
#import "AEUIEditDomainController.h"
#import "AEUIUtils.h"

#ifdef PRO
#import "APVPNManager.h"
#endif

@interface AEUIWhitelistController (){
    
    AEUIEditDomainController *_editRuleController;
    NSString *_domainHolder;
}

@property NSMutableArray *rules;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation AEUIWhitelistController

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doaminCellView" forIndexPath:indexPath];
    
    
    AEWhitelistDomainObject *object = self.rules[[indexPath row]];
    if (object) {
        cell.textLabel.text = object.domain;
        return cell;
    }
    
    return nil;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AEWhitelistDomainObject *object = self.rules[[indexPath row]];
        
        if (!object) {
            return;
        }
        
        [[[AEService singleton] antibanner] beginTransaction];
        
        [AEUIUtils removeWhitelistRule:object.rule toJsonWithController:self completionBlock:^{
            
            [self.rules removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            _newRuleCount++;
            
            [[[AEService singleton] antibanner] endTransaction];
#ifdef PRO
            [[APVPNManager singleton] sendReloadUserfilterDataIfRule:object.rule];
#endif
            
        } rollbackBlock:^{
            
            // enable rule (rollback)
            
            [[[AEService singleton] antibanner] rollbackTransaction];
            
            [tableView setEditing:NO animated:YES];
        }];
    }
}


#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    return YES;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    _editRuleController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"newRule"]){
        
        _editRuleController.navigationItem.title = NSLocalizedString(@"Enter Domain", @"(AEUIWhitelistController) New domain title");
    }
    else if ([segue.identifier isEqualToString:@"editRule"]) {
        _editRuleController.navigationItem.title = NSLocalizedString(@"Edit Domain", @"(AEUIWhitelistController) Edit domain title");
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        AEWhitelistDomainObject *object = self.rules[[path row]];
        if (object) {
            _editRuleController.domain = object;
            _ruleHolder = [object.rule copy];
            _domainHolder = object.domain;
        }
    }
    // Pass the selected object to the new view controller.
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (_editRuleController && _editRuleController.done) {

        AEWhitelistDomainObject *domain = _editRuleController.domain;
        if ([domain.rule.ruleId unsignedIntegerValue] == 0) {

            // New rule
            
            [[[AEService singleton] antibanner] beginTransaction];
            
            [AEUIUtils addWhitelistRule:domain.rule toJsonWithController:self completionBlock:^{
                
                // if rule is not comment decrease counter of the new rules
                _newRuleCount--;
                
                [self reloadRulesAndScrollBottom:YES];
                
                [[[AEService singleton] antibanner] endTransaction];
#ifdef PRO
                [[APVPNManager singleton] sendReloadUserfilterDataIfRule:domain.rule];
#endif
            } rollbackBlock:^{
                
                [[[AEService singleton] antibanner] rollbackTransaction];
            }];
        }
        else{
            // Update rule
            
            [[[AEService singleton] antibanner] beginTransaction];
            
            NSError *error = [[AEService singleton] updateRule:domain.rule oldRuleText:_ruleHolder.ruleText];
            if (error){
                
                [[[AEService singleton] antibanner] rollbackTransaction];

                if (error.code == AES_ERROR_UNSUPPORTED_RULE) {
                    
                    domain.domain = _domainHolder;
                    [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(AEUIWhitelistController) Alert title. Error when add incorrect rule into user filter.") message:[error localizedDescription]];
                }
            }
            else{

                [AEUIUtils invalidateJsonWithController:self completionBlock:^{
                
                    [self reloadRulesAndScrollBottom:NO];

                    [[[AEService singleton] antibanner] endTransaction];
                    
#ifdef PRO
                    [[APVPNManager singleton] sendReloadUserfilterDataIfRule:domain.rule];
#endif
                } rollbackBlock:^{

                    _ruleHolder.ruleText = domain.rule.ruleText;
                    domain.domain = _domainHolder;
                    
                    [[[AEService singleton] antibanner] rollbackTransaction];
                }];
            }
        }

    }
    _editRuleController = nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Private methods
/////////////////////////////////////////////////////////////////////

- (void)reloadRulesAndScrollBottom:(BOOL)bottom {

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
          @autoreleasepool {
              NSArray *rules = [[[AEService singleton] antibanner]
                  rulesForFilter:@(ASDF_USER_FILTER_ID)];
              NSString *searchString = self.searchController.searchBar.text;

              if (![NSString isNullOrEmpty:searchString]) {

                  rules = [rules
                      filteredArrayUsingPredicate:
                          [NSPredicate
                              predicateWithFormat:@"ruleText CONTAINS[cd] %@",
                                                  searchString]];
              }

              NSMutableArray *uiRules = [NSMutableArray array];
              self.rules = uiRules;
              AEWhitelistDomainObject *object;
              for (ASDFilterRule *item in rules) {

                  object = [[AEWhitelistDomainObject alloc] initWithRule:item];
                  if (object) {
                      [uiRules addObject:object];
                  }
              }

              dispatch_async(dispatch_get_main_queue(), ^{

                [self.tableView reloadData];
                if (bottom && self.rules.count) {
                    [self.tableView
                        scrollToRowAtIndexPath:
                            [NSIndexPath indexPathForRow:(self.rules.count - 1)
                                               inSection:0]
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
                }
              });
          }
        });
}

@end
