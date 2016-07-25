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
#import "APDnsResourceType.h"
#import "APVPNManager.h"

#define DATE_FORMAT(DATE)   [NSDateFormatter localizedStringFromDate:DATE dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]

@interface APUIDnsRequestDetail ()

@end

@implementation APUIDnsRequestDetail

static NSDateFormatter *_timeFormatter;

+ (void)initialize{
    
    if (self == [APUIDnsRequestDetail class]) {
        _timeFormatter = [NSDateFormatter new];
        _timeFormatter.dateFormat = @"HH:mm:ss.SSS ";
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    APDnsRequest *request = self.logRecord.requests[0];
    
    self.timeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",
                               [_timeFormatter stringFromDate:self.logRecord.recordDate],
                               DATE_FORMAT(self.logRecord.recordDate)];
    
    self.nameCell.longLabel.text = request.name;
    self.typeCell.detailTextLabel.text = [request.type description];
    self.serverCell.detailTextLabel.text = [[APVPNManager singleton] modeDescription:[self.logRecord.vpnMode intValue]];
    
    NSMutableAttributedString *sb = [NSMutableAttributedString new];
    
    NSDictionary *bold = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightBold] };
    NSDictionary *normal = @{ NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:[UIFont systemFontSize] weight:UIFontWeightRegular] };
    
    if (self.logRecord.responses.count) {
        
        for (APDnsResponse *item in self.logRecord.responses) {
            
            NSString *str;
            if (sb.length) {
                str = [NSString stringWithFormat:@"\n\n%@\n", item.type];
            }
            else{
                str = [NSString stringWithFormat:@"%@\n", item.type];
            }
            [sb appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:bold]];
            [sb appendAttributedString:[[NSAttributedString alloc] initWithString:item.stringValue attributes:normal]];
        }
        
        self.responsesCell.longLabel.attributedText = sb;
    }
    else{
        
        self.responsesCell.longLabel.text = NSLocalizedString(@"No response", @"(APUIDnsRequestsController) PRO version. On the Adguard DNS -> DNS Requests screen -> Request Detail. It is the detailed text in RESPONSES section, if this DNS request do not have response.");
    }
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
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
