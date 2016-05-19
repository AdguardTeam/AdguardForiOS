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
#import "AEUIRulesController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEUIEditRuleController.h"
#import "AEUIFilterRuleObject.h"
#import "AESharedResources.h"
#import "AEFilterRuleSyntaxConstants.h"
#import "AppDelegate.h"
#import "AEUILoadingModal.h"
#import "AEUIUtils.h"

@interface AEUIRulesController (){

    AEUIEditRuleController *_editRuleController;
    id _observerObject;
}

@property NSMutableArray *rules;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation AEUIRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ruleTextHolder = @"";
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self reloadRulesAndScrollBottom:NO];
    
    _newRuleCount = 0;
    self.addButton.enabled = NO;
    [[AEService singleton] onReloadContentBlockingJsonComplete:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self calculateNewRuleCount];
            [self addRuleWhenActivateIfExists];
        });
    }];

    _observerObject = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:[UIApplication sharedApplication] queue:nil usingBlock:^(NSNotification * _Nonnull note) {

//        if (! [self.navigationController.topViewController isEqual:self]) {
//            [self.navigationController popToViewController:self animated:YES];
//        }
        _newRuleCount = 0;
        [[AEService singleton] onReloadContentBlockingJsonComplete:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self calculateNewRuleCount];
                [self reloadRulesAndScrollBottom:NO];
                // check that controller on top
                if ([self.navigationController.topViewController isEqual:self]) {
                    // on top
                    [self addRuleWhenActivateIfExists];
                }
            });
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    if (_observerObject) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:_observerObject];
    }
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rules.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ruleCellView" forIndexPath:indexPath];
    

    NSArray *rules = self.rules;
    NSInteger row = indexPath.row;
    if (row < rules.count) {
        
        AEUIFilterRuleObject *rule = rules[row];
        if (rule) {
            cell.textLabel.text = rule.ruleText;
            cell.textLabel.textColor = rule.textColor;
            cell.textLabel.font = rule.font;
            return cell;
        }
    }

    return nil;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        ASDFilterRule *rule = self.rules[[indexPath row]];
        if (!rule) {
            return;
        }
        
        void (^remove)() = ^{

            [[AEService singleton] removeRules:@[rule]];
            [self.rules removeObjectAtIndex:[indexPath row]];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            [[[AEService singleton] antibanner] endTransaction];

        };
        
        [[[AEService singleton] antibanner] beginTransaction];
        
        if ([rule.ruleText hasPrefix:COMMENT]) {
            
            remove();
        }
        else{
            
            // disable rule temporarily
            [[[AEService singleton] antibanner] setRules:@[rule.ruleId] filter:rule.filterId enabled:NO];
            
            [AEUIUtils invalidateJsonWithController:self completionBlock:^{
                
                // delete rule permanently
                remove();
                
                _newRuleCount++;
                
            }rollbackBlock:^{
                
                // enable rule (rollback)
                
                [[[AEService singleton] antibanner] rollbackTransaction];
                
                [tableView setEditing:NO animated:YES];
                
            }];
        }
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    if ([identifier isEqualToString:@"newRule"]) {
        
        return [self checkNewRuleCountWithAlert];
    }
    
    return YES;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    _editRuleController = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"newRule"]){
        
        _editRuleController.navigationItem.title = NSLocalizedString(@"Enter Rule", @"(AEUIRulesController) New rule title");
    }
    else if ([segue.identifier isEqualToString:@"editRule"]) {
        _editRuleController.navigationItem.title = NSLocalizedString(@"Edit Rule", @"(AEUIRulesController) Edit rule title");
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        AEUIFilterRuleObject *rule = self.rules[[path row]];
        if (rule) {
            _editRuleController.rule = rule;
            _ruleTextHolder = rule.ruleText;
        }
    }
    // Pass the selected object to the new view controller.
}

- (void)viewWillAppear:(BOOL)animated{
    
    if (_editRuleController && _editRuleController.done) {
        
        ASDFilterRule *rule = _editRuleController.rule;
        if ([rule.ruleId unsignedIntegerValue] == 0) {
            
            // New rule
            [self addNewRule:rule];
        }
        else{
            // Update rule

            // check that rule change count of new rules
            // was commet, became rule
            if (![rule.ruleText hasPrefix:COMMENT] && [_ruleTextHolder hasPrefix:COMMENT]) {
                
                if (_newRuleCount <= 0) {
                    
                    rule.ruleText = _ruleTextHolder;
                    _editRuleController = nil;
                    
                    [ACSSystemUtils showSimpleAlertForController:self
                                                       withTitle:NSLocalizedString(@"Error", @"(AEUIRulesController) Alert title. Error when rule was changed and max rules limit exceeded.")
                                                         message:NSLocalizedString(@"You have exceeded the maximum number of the filter rules.", @"(AEUIRulesController) Alert message. Error when rule was changed and max rules limit exceeded.")];
                    return;
                }
            }
            //------------------------------------------
            
            [[[AEService singleton] antibanner] beginTransaction];
            
            NSError *error = [[AEService singleton] updateRule:rule oldRuleText:_ruleTextHolder];
            if (error){
                
                [[[AEService singleton] antibanner] rollbackTransaction];
                
                if (error.code == AES_ERROR_UNSUPPORTED_RULE) {
                    
                    rule.ruleText = _ruleTextHolder;
                    [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(AEUIRulesController) Alert title. Error when add incorrect rule into user filter.") message:[error localizedDescription]];
                }
            }
            else {
                
                // ---- Completion Block ----------------
                dispatch_block_t completionBlock = ^(){

                    [[[AEService singleton] antibanner] endTransaction];
                };
                
                // ---- Rollback Block ----------------
                dispatch_block_t rollbackBlock = ^(){
                    
//                    NSString *ruleText = _ruleTextHolder;
//                    _ruleTextHolder = rule.ruleText;
//                    rule.ruleText = ruleText;
//                    
//                    [[AEService singleton] updateRule:rule oldRuleText:_ruleTextHolder];
                    [[[AEService singleton] antibanner] rollbackTransaction];
                    [self reloadRulesAndScrollBottom:NO];
                };
                // -----------------------------------
                
                [self reloadRulesAndScrollBottom:NO];

                // was commet, became rule
                if (![rule.ruleText hasPrefix:COMMENT] && [_ruleTextHolder hasPrefix:COMMENT]) {
                    
                    if (_newRuleCount >0) _newRuleCount--;
                    [AEUIUtils invalidateJsonWithController:self completionBlock:completionBlock rollbackBlock:rollbackBlock];
                }
                // was rule, became comment
                else if ([rule.ruleText hasPrefix:COMMENT] && ![_ruleTextHolder hasPrefix:COMMENT]){
                    
                    _newRuleCount++;
                    [AEUIUtils invalidateJsonWithController:self completionBlock:completionBlock rollbackBlock:rollbackBlock];
                }
                else if (![rule.ruleText hasPrefix:COMMENT]){
                    
                    [AEUIUtils invalidateJsonWithController:self completionBlock:completionBlock rollbackBlock:rollbackBlock];
                }
            }
        }
    }
    _editRuleController = nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Search Bar Delegates
/////////////////////////////////////////////////////////////////////

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [self reloadRulesAndScrollBottom:NO];
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
              for (ASDFilterRule *item in rules) {

                  [uiRules addObject:[[AEUIFilterRuleObject alloc]
                                         initWithRule:item]];
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

- (void)calculateNewRuleCount{
    
    self.addButton.enabled = YES;
    NSNumber *maxLimit = [[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONMaximumConvertedRules];
    NSNumber *converted = [[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONConvertedRules];
    _newRuleCount = [maxLimit unsignedIntegerValue] - [converted unsignedIntegerValue];
    if (_newRuleCount < 0) {
        _newRuleCount = 0;
    }
}

- (BOOL)checkNewRuleCountWithAlert{

    if (_newRuleCount <= 0) {
        
        [ACSSystemUtils showSimpleAlertForController:self
                                           withTitle:NSLocalizedString(@"Error", @"(AEUIRulesController) Alert title. Error when attempt add rule and max rules limit exceeded.")
                                             message:NSLocalizedString(@"You have exceeded the maximum number of the filter rules.", @"(AEUIRulesController) Alert message. Error when attempt add rule and max rules limit exceeded.")];
        
        return NO;
    }
    
    return YES;
}

- (void)addRuleWhenActivateIfExists{
    
    if (![NSString isNullOrEmpty:_ruleTextForAdding]) {
        if ([self checkNewRuleCountWithAlert]) {
        
            ASDFilterRule *rule = [ASDFilterRule new];
            rule.ruleText = _ruleTextForAdding;
            rule.isEnabled = @(YES);
            _ruleTextForAdding = nil;
            [self addNewRule:rule];
        }
    }
}

- (void)addNewRule:(ASDFilterRule *)rule{
    
    [[[AEService singleton] antibanner] beginTransaction];
    
    NSError *error = [[AEService singleton] addRule:rule temporarily:NO];
    if (error){
        
        [[[AEService singleton] antibanner] rollbackTransaction];
        
        if (error.code == AES_ERROR_UNSUPPORTED_RULE) {
            
            rule.ruleText = _ruleTextHolder;
            [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(AEUIRulesController) Alert title. Error when add incorrect rule into user filter.") message:[error localizedDescription]];
        }
    }
    else {
        [self reloadRulesAndScrollBottom:YES];
        
        // if rule is not comment decrease counter of the new rules
        if (![rule.ruleText hasPrefix:COMMENT]) {
            
            if(_newRuleCount > 0) _newRuleCount--;
            
            NSInteger newRuleCountHolder = _newRuleCount;
            [AEUIUtils invalidateJsonWithController:self completionBlock:^{
                
                _newRuleCount = newRuleCountHolder;
                [[[AEService singleton] antibanner] endTransaction];
                
            } rollbackBlock:^{
                
                _newRuleCount = newRuleCountHolder + 1;
                [[[AEService singleton] antibanner] rollbackTransaction];
                [self reloadRulesAndScrollBottom:YES];
            }];
        }
        
    }
}

@end
