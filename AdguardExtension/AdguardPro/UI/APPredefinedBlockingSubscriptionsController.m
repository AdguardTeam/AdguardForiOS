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

#import "APPredefinedBlockingSubscriptionsController.h"

@interface APPredefinedBlockingSubscriptionsController ()

@property (nonatomic) NSArray<APBlockingSubscription*> *subscriptions;

@end

@implementation APPredefinedBlockingSubscriptionsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.subscriptions = APBlockingSubscriptionsManager.predefinedSubscriptions;// subscriptions.copy;
}

#pragma mark UITableViewMethods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.subscriptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PredefinedListCell"];
    cell.textLabel.text = self.subscriptions[indexPath.row].name;
    
    BOOL enabled = ![APBlockingSubscriptionsManager.subscriptionsMeta containsObject:self.subscriptions[indexPath.row]];
    
    cell.textLabel.enabled = enabled;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL enabled = ![APBlockingSubscriptionsManager.subscriptionsMeta containsObject:self.subscriptions[indexPath.row]];
    
    return enabled ? indexPath : nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.done) {
        self.done(self.subscriptions[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
