//##implementation

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


#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <NetworkExtension/NetworkExtension.h>
#import "APSharedResources.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - TodayViewController

@interface TodayViewController () <NCWidgetProviding> {
    
    NSMutableArray *_observers;
}

@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    _observers = [NSMutableArray new];
//
//    NSObject* observer = [[NSNotificationCenter defaultCenter] addObserverForName:NEVPNConfigurationChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//
//        [self checkStatus];
//    }];
//
//    [_observers addObject:observer];
//
//    observer = [[NSNotificationCenter defaultCenter] addObserverForName:NEVPNStatusDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
//
//        [self checkStatus];
//    }];
//
//    [_observers addObject:observer];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self checkStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    [self checkStatus];
    
    completionHandler(NCUpdateResultNewData);
}

#pragma mark - actions

- (IBAction)toogleStatusSwitch:(id)sender {
    
    NSString* url = [NSString stringWithFormat:@"%@://%@", AP_URLSCHEME,
                     self.statusSwitch.isOn ? AP_URLSCHEME_COMMAND_STATUS_ON :                                                             AP_URLSCHEME_COMMAND_STATUS_OFF];
    [self.extensionContext openURL:[NSURL URLWithString:url] completionHandler:^(BOOL success) {
        
    }];
}


#pragma mark - private methods

- (void) checkStatus {
    
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        
        NETunnelProviderManager* manager = managers.firstObject;
        
        BOOL enabled = manager.enabled;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.statusSwitch setOn:enabled];
        });
    }];
    
}

- (void)dealloc {
    
    for (id observer in _observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

@end
