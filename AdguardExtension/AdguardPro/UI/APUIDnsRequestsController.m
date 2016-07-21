//
//  APUIDnsRequestsController.m
//  Adguard
//
//  Created by Roman Sokolov on 19.07.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "APUIDnsRequestsController.h"
#import "ACommons/ACLang.h"
#import "AEUICommons.h"
#import "APVPNManager.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "APDnsLogRecord.h"

#define DATE_FORMAT(DATE)   [NSDateFormatter localizedStringFromDate:DATE dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]

@interface APUIDnsRequestsController ()

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic) NSArray <APDnsLogRecord *> *logRecords;
@property (nonatomic) NSArray <APDnsLogRecord *> *filteredLogRecords;

@end

@implementation APUIDnsRequestsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    [self.refreshControl addTarget:self action:@selector(refreshLog:) forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredLogRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dnsRequestCell" forIndexPath:indexPath];

    NSInteger row = indexPath.row;
    if (row < self.filteredLogRecords.count) {

        APDnsLogRecord *record = self.filteredLogRecords[row];
        APDnsResponse *response = record.preferredResponse;
        
        if (response) {
            
            cell.textLabel.text = response.name;
            
            if (response.blocked) {
                cell.detailTextLabel.textColor = AEUIC_WARNING_COLOR;
                cell.textLabel.textColor = AEUIC_WARNING_COLOR;
                cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ - Blocked", @"(APUIDnsRequestsController) PRO version. On the Adguard DNS -> DNS Requests screen. It is the detailed text in row of the request, if this DNS request was blocked."), DATE_FORMAT(record.recordDate)];
            } else {
                
                cell.textLabel.textColor = [UIColor darkTextColor];
                cell.detailTextLabel.textColor = [UIColor darkTextColor];
                NSArray *responses = [record.responses valueForKey:@"stringValue"];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", DATE_FORMAT(record.recordDate), [responses componentsJoinedByString:@", "]];
            }
        }
        else{
            
            cell.textLabel.textColor = [UIColor darkTextColor];
            cell.detailTextLabel.textColor = [UIColor darkTextColor];
            
            APDnsRequest *request = record.requests[0];
            cell.textLabel.text = request.name;
            cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ - No response", @"(APUIDnsRequestsController) PRO version. On the Adguard DNS -> DNS Requests screen. It is the detailed text in row of the request, if this DNS request do not have response."), DATE_FORMAT(record.recordDate)];
        }
    }

    return cell;
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
#pragma mark  Search Bar Delegates

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    NSString *searchString = self.searchController.searchBar.text;
    
    if ([NSString isNullOrEmpty:searchString]){
        
        self.filteredLogRecords = [self revertArray:self.logRecords];
    }
    else {

        NSMutableArray *fileredReverted = [NSMutableArray new];
        //revert array
        [self.logRecords enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(APDnsLogRecord * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if ([obj.requests[0].name contains:searchString caseSensitive:NO]) {
                [fileredReverted addObject:obj];
                return;
            }

            if ([DATE_FORMAT(obj.recordDate) contains:searchString caseSensitive:NO]) {
                
                [fileredReverted addObject:obj];
                return;
            }
            
            NSString *responsesString = [[obj.responses valueForKey:@"stringValue"] componentsJoinedByString:@" "];
            if ([responsesString contains:searchString caseSensitive:NO]) {
                
                [fileredReverted addObject:obj];
            }
        }];
        
        self.filteredLogRecords = fileredReverted;
    }
    
    [self.tableView reloadData];
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Actions

- (IBAction)refreshLog:(id)sender {

    [self reloadData];
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

- (void)reloadData {
    
    [self.refreshControl beginRefreshing];
    [[APVPNManager singleton] obtainDnsLogRecords:^(NSArray<APDnsLogRecord *> *records) {
        
        self.logRecords = records;
        [self updateSearchResultsForSearchController:self.searchController];
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (NSArray *)revertArray:(NSArray *)arr {

    NSMutableArray *reversed = [NSMutableArray arrayWithCapacity:arr.count];
    [arr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [reversed addObject:obj];
    }];

    return reversed;
}

- (IBAction)clickClear:(id)sender {

    if ([[APVPNManager singleton] clearDnsRequestsLog]) {
        
        [self reloadData];
    }
}

@end
