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
#import "AEUISubscriptionController.h"
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "AESharedResources.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "AEUISubscriptionSectionObject.h"
#import "ASDFilterObjects.h"
#import "AEUILoadingModalController.h"
#import "AEUISubscriptionFilterDetailController.h"
#import "AEUISubscriptionTableViewCell.h"
#import "AppDelegate.h"
#import "AEUILoadingModal.h"
#import "AEUIUtils.h"
#import "AEUICommons.h"

@interface AEUISubscriptionController (){
    
    ACLJobController *subscribeJobController;
    NSMutableSet *_editedFilters;
}

@property (strong, nonatomic) UISearchController *searchController;
@property NSArray *filterObjects;

@end

@implementation AEUISubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.refreshControl addTarget:self action:@selector(refreshFilters:) forControlEvents:UIControlEventValueChanged];
    
    [self updateSearchResultsForSearchController:self.searchController];
    
    // set toolbar items
    self.filterInfo.text = NSLocalizedString(@"Loading info...", @"(AEUISubscriptionController) Title on bottom bar.");
    self.rulesInfo.text = @"";

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appDidActive:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];

    [self setToolbar];
    [self setNavigationBar];
    [self updateStatusInfo];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editClick:(id)sender {

    if (self.tableView.editing) {
        
        return;
    }
    
    _editedFilters = [NSMutableSet set];
    
    [self.tableView setEditing:YES animated:YES];
    
    [self setToolbar];
    [self setNavigationBar];
}

- (IBAction)doneClick:(id)sender {

    [self massUpdate];
}

- (void)editDoneClick:(id)sender {

    if (self.tableView.editing) {
        
        [self.tableView setEditing:NO animated:YES];
        
        [self rollbackEditStateOnEditedFilters];
        
        [self setNavigationBar];
        [self setToolbar];
        
        [self.tableView reloadData];
    }
}

- (IBAction)clearAllClick:(id)sender {
    @autoreleasepool {
        
        for (AEUISubscriptionSectionObject *item in self.filterObjects) {
            
            for (AEUISubscriptionSectionFilterMetadata *filterMeta in item.filters) {
                
                if ([filterMeta.enabled boolValue] || filterMeta.editedEnabled) {
                    filterMeta.editedEnabled = @NO;
                    [_editedFilters addObject:filterMeta];
                }
            }
        }
        
        [self.tableView reloadData];
    }
}

- (void)updateStatusInfo{
    
    [[AEService singleton] onReloadContentBlockingJsonComplete:^{
        
        @autoreleasepool {
            
            NSUInteger count = 0, enabledCount = 0;
            for (AEUISubscriptionSectionObject *item in self.mainFilterObjectsArray) {
                
                for (ASDFilterMetadata *filterMeta in item.filters) {
                    
                    count++;
                    if ([filterMeta.enabled boolValue]) {
                        enabledCount++;
                    }
                }
            }

            NSString* filterInfoText = [NSString stringWithFormat:NSLocalizedString(@"Filters enabled: %1$lu out of %2$lu", @"(AEUISubscriptionController) Filter info, in bottom status."), enabledCount, count];
            NSUInteger rulesCount = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONConvertedRules] unsignedIntegerValue];
            NSUInteger totalRulesCount = [[[AESharedResources sharedDefaults] objectForKey:AEDefaultsJSONRulesForConvertion] unsignedIntegerValue];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.filterInfo.text = filterInfoText;
                if (totalRulesCount > rulesCount) {
                    self.rulesInfo.textColor = AEUIC_WARNING_COLOR;
                    self.rulesInfo.text = [NSString stringWithFormat:NSLocalizedString(@"Enabled rules: %2$lu Active rules: %1$lu", @"(AEUISubscriptionController) Rules info, in bottom status. When overlimit occured."), rulesCount, totalRulesCount];
                }
                else{
                    self.rulesInfo.textColor = [UIColor lightGrayColor];
                    self.rulesInfo.text = [NSString stringWithFormat:NSLocalizedString(@"Active filter rules: %lu", @"(AEUISubscriptionController) Rules info, in bottom status."), rulesCount];
                }
            });
        }
    }];
}

- (IBAction)cancelSubsrciption:(id)sender {
    
    [subscribeJobController cancel];
}


#pragma mark Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"filterDetail"]) {
        if ([self filterForSelectedRow] == nil || [self.tableView isEditing]) {
            return NO;
        }
    }
    
    return YES;
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"filterDetail"]) {
         
         AEUISubscriptionFilterDetailController *destination = [segue destinationViewController];
         AEUISubscriptionSectionFilterMetadata *meta = [self filterForSelectedRow];
         destination.meta = meta;
         destination.parent = self;
         destination.selectedFilterCellPath = [self.tableView indexPathForSelectedRow];
     }
 }


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = YES;
}

#pragma mark Table Delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @autoreleasepool {
        if (tableView.editing) {
            // EDIT MODE
            
            AEUISubscriptionSectionFilterMetadata *meta = [self filterForIndexPath:indexPath];
            if (meta) {
                
                NSNumber *newEnabled = meta.editedEnabled;
                if (newEnabled) {
                    newEnabled = @(![newEnabled boolValue]);
                    meta.editedEnabled = newEnabled;
                }
                else{
                    newEnabled = @(![meta.enabled boolValue]);
                    meta.editedEnabled = newEnabled;
                }
                [_editedFilters addObject:meta];
                
                AEUISubscriptionTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.on = [newEnabled boolValue];
            }
        }
    }
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filterObjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.filterObjects[section] filters] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ident = @"subscriptionItem";
    
    AEUISubscriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell.accessoryView == nil) {
        
    }
    
    // Configure the cell...
    AEUISubscriptionSectionObject *section = self.filterObjects[[indexPath section]];
    AEUISubscriptionSectionFilterMetadata *meta = section.filters[[indexPath row]];
    
    if (!meta) {
        return nil;
    }
    
    cell.textLabel.text = meta.i18nName;

    BOOL enabled = [meta.enabled boolValue];
    
    if (tableView.editing) {
        if (meta.editedEnabled) {
            enabled = [meta.editedEnabled boolValue];
        }
    }
    
    cell.on = enabled;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    AEUISubscriptionSectionObject *sectionObj = self.filterObjects[section];
    
    if (sectionObj) {
        return sectionObj.name;
    }
    
    return @"";
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/////////////////////////////////////////////////////////////////////
#pragma mark  Search Bar Delegates
/////////////////////////////////////////////////////////////////////

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = self.searchController.searchBar.text;
    
    if ([NSString isNullOrEmpty:searchString]){
        
        self.filterObjects = self.mainFilterObjectsArray;
    }
    else {
        
        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:self.mainFilterObjectsArray.count];
        for (AEUISubscriptionSectionObject *item in self.mainFilterObjectsArray) {
            
            NSArray *sectionFilters = [item.filters filteredArrayUsingPredicate:
                                       [NSPredicate
                                        predicateWithFormat:@"i18nName CONTAINS[cd] %@",
                                        searchString]];
            if (sectionFilters.count) {
                AEUISubscriptionSectionObject *newSection = [AEUISubscriptionSectionObject new];
                newSection.name = item.name;
                newSection.filters = sectionFilters;
                
                [sections addObject:newSection];
            }
        }
        
        self.filterObjects = sections;
    }
    
    [self.tableView reloadData];
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Private methods
/////////////////////////////////////////////////////////////////////

- (IBAction)refreshFilters:(id)sender {

    [self.refreshControl beginRefreshing];

    [AEUISubscriptionSectionObject load:YES completionBlock:^(NSArray *filters) {

      self.mainFilterObjectsArray = filters;
      if (self.refreshControl.refreshing) {
          [self.refreshControl endRefreshing];
      }

      [self updateSearchResultsForSearchController:self.searchController];
      [self updateStatusInfo];
    }];
}


- (AEUISubscriptionSectionFilterMetadata *)filterForSelectedRow{
    
    return [self filterForIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (AEUISubscriptionSectionFilterMetadata *)filterForIndexPath:(NSIndexPath *)path{

    if (path) {
        
        AEUISubscriptionSectionObject *section =
        self.filterObjects[[path section]];
        return section.filters[[path row]];
    }

    return nil;
}

- (void)rollbackEditStateOnEditedFilters{
    
    [[_editedFilters allObjects] setValue:nil forKey:@"editedEnabled"];
    _editedFilters = nil;
}
- (void)commitEditStateOnEditedFilters{
    
    for (AEUISubscriptionSectionFilterMetadata *item in [_editedFilters allObjects]) {
        item.enabled = item.editedEnabled;
    }
    _editedFilters = nil;
}

- (void)setToolbar{

    UIView *toolbar = self.navigationController.toolbar;
    if (toolbar) {
        
        if (self.tableView.editing) {
            // EDIT MODE
            
            UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Clear Selected", @"(AEUISubscriptionController) Clear all button in edit mode on filter list.") style:UIBarButtonItemStylePlain target:self action:@selector(clearAllClick:)];

            UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editDoneClick:)];

            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

            if (itemLeft && itemRight) {
                self.toolbarItems = @[itemLeft, spacer, itemRight];
            }
        }
        else{
            // VIEW MODE
            
            UIEdgeInsets insets = toolbar.layoutMargins;
            //        UIEdgeInsets rootInsets = self.navigationController.view.layoutMargins;
            CGRect frame = toolbar.bounds;
            frame.origin = CGPointMake(0, 0);
            frame.size.height -= insets.top + insets.bottom;
            
            [self.toolBarView setFrame:frame];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarView];
            UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            if (item) {
                self.toolbarItems = @[spacer, item, spacer];
            }
        }
        
    }
}

- (void)setNavigationBar{

    UINavigationItem *nav = self.navigationItem;
    
    if (nav) {
        
        UIBarButtonItem *item;
        if (self.tableView.editing) {
            
            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick:)];
        }
        else{
            
            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editClick:)];
        }
        
        if (item) {
            [nav setRightBarButtonItem:item animated:YES];
        }
    }
}

- (void)massUpdate{
    
    NSMutableArray *filtersForUpdate = [NSMutableArray array];
    
    for (AEUISubscriptionSectionFilterMetadata *item in [_editedFilters allObjects]) {
        if (![item.editedEnabled isEqual:item.enabled]) {
            [filtersForUpdate addObject:item];
        }
    }

    if (!filtersForUpdate.count) {
        [self editDoneClick:self];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // getting of the filters, which need install
        NSMutableArray *filtersForInstall = [NSMutableArray array];
        NSArray *installedFilters = [[[AEService singleton] antibanner] filters];
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        for (int i=0; i < filtersForUpdate.count; i++) {
            AEUISubscriptionSectionFilterMetadata *item = filtersForUpdate[i];
            if (![installedFilters containsObject:item]) {
                
                item = [AEUISubscriptionSectionFilterMetadata copyFromMetadata:item];
                item.enabled = @YES;
                [filtersForInstall addObject:item];
                [indexes addIndex:i];
            }
        }
        [filtersForUpdate removeObjectsAtIndexes:indexes];
        
        //BEGIN ANTIBANNER TRANSACTION
        [[[AEService singleton] antibanner] beginTransaction];

        if (filtersForInstall.count) {
            
            // install filters in background task
            // Subscribe
            AEUILoadingModal *modal = [AEUILoadingModal singleton];
            [modal loadingModalShowWithParent:self message:NSLocalizedString(@"Loading Filters...", @"(AEUISubscriptionController) When toggling Done button in edit mode and subscription process goes.") cancelAction:@selector(cancelSubsrciption:) completion:^{
                
                dispatch_async(
                               dispatch_get_global_queue(
                                                         DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                               ^{
                                   @autoreleasepool {
                                       
                                       subscribeJobController = [ACLJobController new];
                                       [subscribeJobController start];
                                       
                                       BOOL result = [[[AEService singleton] antibanner]
                                                      subscribeFilters:filtersForInstall
                                                      jobController:subscribeJobController];
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [subscribeJobController stop];
                                           
                                           if (subscribeJobController.state == ACLJCCancelSate) {
                                               
                                               // user pressed cancel button, rollback
                                               [[[AEService singleton] antibanner] rollbackTransaction];
                                               [self editDoneClick:self];
                                           }
                                           else if (!result){
                                               
                                               //rollback
                                               [[[AEService singleton] antibanner] rollbackTransaction];
                                               [self editDoneClick:self];
                                               
                                               
                                               [ACSSystemUtils showSimpleAlertForController:self withTitle:NSLocalizedString(@"Error", @"(AEUISubscriptionController) Alert title. When subscription process failed.") message:NSLocalizedString(@"Cannot load filter from the server.", @"(AEUISubscriptionController) Alert message. When subscription process failed.")];
                                               
                                           }
                                           else{
                                               
                                               //Perform reloading JSON
                                               [self reloadJsonWithFiltersForUpdate:filtersForUpdate];
                                           }
                                           
                                       });
                                   }
                               });
            }];

        }
        else if (filtersForUpdate.count){
            
            [self reloadJsonWithFiltersForUpdate:filtersForUpdate];
        }
        
        
    });
}

- (void)reloadJsonWithFiltersForUpdate:(NSArray *)filters{
    
    for (AEUISubscriptionSectionFilterMetadata *meta in filters) {
        // Set enabled/disabled
        [[[AEService singleton] antibanner]
         setFilter:meta.filterId
         enabled:[meta.editedEnabled boolValue]
         fromUI:YES];
    }
    
    //Perform reloading JSON
    [AEUIUtils invalidateJsonWithController:self completionBlock:^{
        
        [[[AEService singleton] antibanner] endTransaction];

        [self commitEditStateOnEditedFilters];
        
        [self editDoneClick:self];
        [self updateStatusInfo];
        
    } rollbackBlock:^{
        
        [[[AEService singleton] antibanner] rollbackTransaction];
        [self editDoneClick:self];
    }];
}

- (void)appDidActive:(NSNotification *)noti {

    [self updateStatusInfo];
}

@end
