//
//  APUIDnsRequestDetail.h
//  Adguard
//
//  Created by Roman Sokolov on 22.07.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "StaticDataTableViewController.h"

@class AEUILongLabelViewCell, APDnsLogRecord;

@interface APUIDnsRequestDetail : StaticDataTableViewController <UITableViewDelegate>

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

@property (nonatomic) APDnsLogRecord *logRecord;

/////////////////////////////////////////////////////////////////////
#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (weak, nonatomic) IBOutlet AEUILongLabelViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *serverCell;
@property (weak, nonatomic) IBOutlet AEUILongLabelViewCell *responsesCell;


@end
