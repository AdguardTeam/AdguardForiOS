//
//  StaticTableViewController.h
//  StaticTableViewController 2.0
//
//  Created by Peter Paulis on 31.1.2013.
//  Copyright (c) 2013 Peter Paulis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaticDataTableViewController : UITableViewController

@property (nonatomic, assign) BOOL hideSectionsWithHiddenRows;
@property (nonatomic, assign) BOOL animateSectionHeaders;

@property (nonatomic, assign) UITableViewRowAnimation insertTableViewRowAnimation;

@property (nonatomic, assign) UITableViewRowAnimation deleteTableViewRowAnimation;

@property (nonatomic, assign) UITableViewRowAnimation reloadTableViewRowAnimation;


- (BOOL)cellIsHidden:(UITableViewCell *)cell;

- (void)updateCell:(UITableViewCell *)cell;

- (void)updateCells:(NSArray *)cells;

- (void)cell:(UITableViewCell *)cell setHidden:(BOOL)hidden;

- (void)cells:(NSArray *)cells setHidden:(BOOL)hidden;

- (void)cell:(UITableViewCell *)cell setHeight:(CGFloat)height;

- (void)cells:(NSArray *)cells setHeight:(CGFloat)height;

// never call [self.tableView reloadData] directly
// doing so will lead to data inconsistenci
// always use this method for reload
- (void)reloadDataAnimated:(BOOL)animated;

@end
