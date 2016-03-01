/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015 Performix LLC. All rights reserved.

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
#import "AEUIUtils.h"
#import "ACommons/ACSystem.h"
#import "AEService.h"
#import "AEUILoadingModal.h"

@implementation AEUIUtils

+ (void)invalidateJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] reloadContentBlockingJsonASync:YES backgroundUpdate:NO completionBlock:^(NSError *error) {
            
            if (error) {
                
                if (rollbackBlock) {
                    dispatch_sync(dispatch_get_main_queue(),rollbackBlock);
                }
                
                [[AEUILoadingModal singleton] loadingModalHideWithCompletion:^{
                    
                    [ACSSystemUtils showSimpleAlertForController:controller withTitle: NSLocalizedString(@"Error", @"(AEUIUtils) Alert title. When converting rules process ended.") message:[error localizedDescription]];
                }];
                
                return;
            }
            
            [[AEUILoadingModal singleton] loadingModalHide];
            
            if (completionBlock) {
                dispatch_sync(dispatch_get_main_queue(), completionBlock);
            }
            
        }];
    }];
}

@end
