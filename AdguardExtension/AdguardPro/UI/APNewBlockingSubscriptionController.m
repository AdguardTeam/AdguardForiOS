/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "ACLang.h"
#import "APNewBlockingSubscriptionController.h"
#import "ACNUrlUtils.h"
#import "APPredefinedBlockingSubscriptionsController.h"

@interface APNewBlockingSubscriptionController ()
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) APBlockingSubscription* subscription;

@end

@implementation APNewBlockingSubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscription = [APBlockingSubscription new];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"toPredefinedSubscriptions"]) {
        
        ASSIGN_WEAK(self);
        APPredefinedBlockingSubscriptionsController* controller = segue.destinationViewController;
        controller.done = ^(APBlockingSubscription *subscription) {
            ASSIGN_STRONG(self);
            USE_STRONG(self).subscription = subscription;
            [USE_STRONG(self) updateFields];
            [USE_STRONG(self) updateDone];
        };
    }
}

#pragma mark Actions

- (IBAction)nameChanged:(UITextField*)sender {
    
    self.subscription.name = sender.text;
    [self updateDone];
}

- (IBAction)descriptionChanged:(UITextField*)sender {
    
    self.subscription.subscriptionDescription = sender.text;
}

- (IBAction)urlChanged:(UITextField*)sender {
    
    self.subscription.url = sender.text;
    [self updateDone];
}

- (IBAction)doneActions:(id)sender {
    
    self.done(self, self.subscription);
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark private methods

- (void) updateDone {
    
    self.doneButton.enabled = self.nameLabel.text.length && [ACNUrlUtils isValidUrl:self.urlLabel.text];
}

- (void) updateFields {
    
    self.nameLabel.text = self.subscription.name;
    self.descriptionLabel.text = self.subscription.subscriptionDescription;
    self.urlLabel.text = self.subscription.url;
}

@end
