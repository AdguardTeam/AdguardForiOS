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
#import "ASDFilterObjects.h"

@implementation AEUIUtils

+ (void)invalidateJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] reloadContentBlockingJsonASyncWithBackgroundUpdate:NO completionBlock:^(NSError *error) {
            
            [self complateWithError:error controller:controller completionBlock:completionBlock rollbackBlock:rollbackBlock];
        }];
    }];
}

+ (void)addWhitelistdomain:(NSString *)domainName toJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] addWhitelistDomain:domainName completionBlock:^(NSError *error) {
            
            [self complateWithError:error controller:controller completionBlock:completionBlock rollbackBlock:rollbackBlock];
        }];
    }];
}

+ (void)removeWhitelistRule:(ASDFilterRule *)rule toJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] removeWhitelistRule:rule completionBlock:^(NSError *error) {
            
            [self complateWithError:error controller:controller completionBlock:completionBlock rollbackBlock:rollbackBlock];
        }];
    }];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper methods (Private)

+ (void)complateWithError:(NSError *)error controller:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock {

    if (error) {

        if (rollbackBlock) {
            dispatch_sync(dispatch_get_main_queue(), rollbackBlock);
        }

        [[AEUILoadingModal singleton] loadingModalHideWithCompletion:^{

            [ACSSystemUtils showSimpleAlertForController:controller withTitle:NSLocalizedString(@"Error", @"(AEUIUtils) Alert title. When converting rules process ended.") message:[error localizedDescription]];
        }];

        return;
    }

    [[AEUILoadingModal singleton] loadingModalHide];

    if (completionBlock) {
        dispatch_sync(dispatch_get_main_queue(), completionBlock);
    }
}

@end
