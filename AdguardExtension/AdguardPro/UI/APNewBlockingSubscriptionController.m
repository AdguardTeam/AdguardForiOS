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
#import "AEUICommons.h"
#import "APUIProSectionFooter.h"

#define FOOTER_TEXT_MARGIN 10

@interface APNewBlockingSubscriptionController () {
    NSAttributedString* _footerString;
}
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlLabel;

@property (strong, nonatomic) APUIProSectionFooter * footer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) APBlockingSubscription* subscription;

@end

@implementation APNewBlockingSubscriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscription = [APBlockingSubscription new];
    
    self.nameLabel.keyboardAppearance = UIKeyboardAppearanceDark;
    self.descriptionLabel.keyboardAppearance = UIKeyboardAppearanceDark;
    self.urlLabel.keyboardAppearance = UIKeyboardAppearanceDark;
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

#pragma mark UITableView methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0)
        return [self sectionFooter];
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0)
        return [[self sectionFooter] heightForWidth:self.view.frame.size.width];
    
    return 0;
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

- (APUIProSectionFooter*) sectionFooter {
    
    if(!self.footer) {
        
        self.footer = [[APUIProSectionFooter alloc] initWithFrame:self.view.frame];
        [self.footer setText:[self footerString]];
        
        ASSIGN_WEAK(self);
        self.footer.urlClickBlock = ^BOOL(NSURL *url) {
            
            ASSIGN_STRONG(self);
            [USE_STRONG(self) performSegueWithIdentifier:@"toPredefinedSubscriptions" sender:USE_STRONG(self)];
            
            return YES;
        };
    }
    
    return self.footer;
}

- (NSAttributedString*) footerString {
    if(!_footerString) {
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Rules subscriptions are lists of filtering rules combined together. Usually, a subscription serves some particular purpose like blocking malicious or tracking domains. Here you can find some popular filter subscriptions.", @"(APBlockingListsController) blocking subscriptions footer text. Also you must define a clickable part of this string - \"Here\". Please be careful, this is very important to define it properly.")];
        
        NSRange clickableRange = [string.string rangeOfString:NSLocalizedString(@"Here", @"(APNewBlockingSubscriptionController) Clickable part of blocking subscriptions footer text")];
        
        [string addAttributes:@{ NSForegroundColorAttributeName : UIColor.blueColor,
                                  NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                            NSLinkAttributeName : [NSString stringWithFormat:@"adguardlink://info"]
                                }
                        range:clickableRange];
        
        _footerString = string.copy;
    }
    
    return _footerString;
}

@end
