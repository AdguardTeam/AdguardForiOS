//
//  APUIDnsRequestDetail.m
//  Adguard
//
//  Created by Roman Sokolov on 22.07.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "APUIDnsRequestDetail.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "APDnsLogRecord.h"
#import "AEUILongLabelViewCell.h"

@interface APUIDnsRequestDetail ()

@end

@implementation APUIDnsRequestDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark Table View Delegates

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        // Fitting size of the request name
        return [self.nameCell fitHeight];
    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        
        // Fitting size of the responses
        return [self.responsesCell fitHeight];
    }
    return UITableViewAutomaticDimension;
}

@end
