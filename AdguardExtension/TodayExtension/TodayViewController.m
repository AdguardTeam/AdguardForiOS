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
#import "APCommonSharedResources.h"
#import "APDnsServerObject.h"
#import "ACLang.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - TodayViewController

@interface TodayViewController () <NCWidgetProviding> {
    
    BOOL _enabled;
}

@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
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

- (IBAction)touchWidgetAction:(id)sender {
    
    NSString* url = [NSString stringWithFormat:@"%@://%@", AP_URLSCHEME,
                     _enabled ? AP_URLSCHEME_COMMAND_STATUS_OFF :                                                             AP_URLSCHEME_COMMAND_STATUS_ON];
    [self.extensionContext openURL:[NSURL URLWithString:url] completionHandler:^(BOOL success) {
        
    }];

}

#pragma mark - private methods

- (void) checkStatus {
    
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        
        NETunnelProviderManager* manager = managers.firstObject;
        
        _enabled = manager.enabled;
        
        ASSIGN_WEAK(self);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ASSIGN_STRONG(self);
            
            if(USE_STRONG(self)->_enabled) {
                NETunnelProviderProtocol * protocolConfiguration = (NETunnelProviderProtocol *)manager.protocolConfiguration;
                
                NSData *remoteDnsServerData = protocolConfiguration.providerConfiguration[APVpnManagerParameterRemoteDnsServer];
                
                APDnsServerObject *activeRemoteDnsServer = [NSKeyedUnarchiver unarchiveObjectWithData:remoteDnsServerData];
             
                NSString* format = NSLocalizedString(@"Connected to \"%@\"", @"Today widget - text when remote DNS is enabled");
                USE_STRONG(self).mainTextLabel.text = [NSString stringWithFormat:format, activeRemoteDnsServer.serverName];
                
                USE_STRONG(self).detailTextLabel.text = NSLocalizedString(@"Touch to disable DNS filtering", @"Today widget - hint text");
                
                [USE_STRONG(self).mainTextLabel sizeToFit];
                
                if(USE_STRONG(self).mainTextLabel.frame.size.height >= USE_STRONG(self).mainTextLabel.font.pointSize * 2) {
                    
                    USE_STRONG(self).mainTextLabel.text = activeRemoteDnsServer.serverName;
                    [USE_STRONG(self).mainTextLabel sizeToFit];
                }
                
                USE_STRONG(self).logo.alpha = 1.0;
            }
            else {
        
                USE_STRONG(self).mainTextLabel.text = NSLocalizedString(@"DNS filtering is disabled", @"Today widget - text when remote DNS is disabled");
                
                [USE_STRONG(self).mainTextLabel sizeToFit];

                USE_STRONG(self).detailTextLabel.text = NSLocalizedString(@"Touch to enable DNS filtering", @"Today widget - hint text");

                USE_STRONG(self).logo.alpha = 0.5;
            }
            
        });
    }];
    
}

@end
