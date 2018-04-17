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
#import "AEUISubscriptionLoaderController.h"
#import "AEUISubscriptionSectionObject.h"
#import "AEUISubscriptionController.h"
#import "AEService.h"

@interface AEUISubscriptionLoaderController (){
    
    NSArray *_filters;
}

@end

@implementation AEUISubscriptionLoaderController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[AEService singleton] onReady:^{
        
        [AEUISubscriptionSectionObject load:NO completionBlock:^(NSArray *filters) {
            
            [self.loadIndicator stopAnimating];
            _filters = filters;
            [self.actionButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AEUISubscriptionController *controller = (AEUISubscriptionController *)[segue destinationViewController];
    
    controller.mainFilterObjectsArray = _filters;
    _filters = nil;
}


@end
