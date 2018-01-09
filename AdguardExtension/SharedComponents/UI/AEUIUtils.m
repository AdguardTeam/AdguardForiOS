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
#import "AESAntibanner.h"
#import "AEFilterRuleSyntaxConstants.h"

@implementation AEUIUtils

+ (void)invalidateJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] reloadContentBlockingJsonASyncWithBackgroundUpdate:NO completionBlock:^(NSError *error) {
            
            [self complateWithError:error controller:controller completionBlock:completionBlock rollbackBlock:rollbackBlock];
        }];
    }];
}

+ (void)addWhitelistRule:(ASDFilterRule *)rule toJsonWithController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(dispatch_block_t)rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        [[AEService singleton] addWhitelistRule:rule completionBlock:^(NSError *error) {
            
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

+ (void)replaceUserFilterRules:(NSArray <ASDFilterRule *> *)rules withController:(UIViewController *)controller completionBlock:(dispatch_block_t)completionBlock rollbackBlock:(void (^)(NSError *error))rollbackBlock{
    
    [[AEUILoadingModal singleton] standardLoadingModalShowWithParent:controller completion:^{
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            NSError *error;
            for (ASDFilterRule *item in rules) {
                error = [[AEService singleton] checkRule:item];
                if (error) {
                    if (error.code == AES_ERROR_UNSUPPORTED_RULE) {
                        
                        error = nil;
                        NSString *errorDescription = NSLocalizedString(@"Cannot convert user filter rules. One of the rules contains an error. Check the rule next to the current cursor position.", @"(AEUIUtils) User filter convertering error description.");
                        error = [NSError errorWithDomain:AEServiceErrorDomain
                                                    code:AES_ERROR_UNSUPPORTED_RULE
                                                userInfo:@{NSLocalizedDescriptionKey : errorDescription,
                                                           AESUserInfoRuleObject: item}];

                    }
                    break;
                }
            }
            
            if (error == nil) {
                error = [[AEService singleton] replaceUserFilterWithRules:rules];
            }
            
            if (error) {
                
                if (rollbackBlock) {
                    
                    [ACSSystemUtils callOnMainQueue:^{
                        rollbackBlock(error);
                    }];
                }
                [[AEUILoadingModal singleton] loadingModalHideWithCompletion:^{
                    
                    if (error.code != AES_ERROR_UNSUPPORTED_RULE || UIAccessibilityIsVoiceOverRunning()) {
                        [ACSSystemUtils showSimpleAlertForController:controller withTitle:NSLocalizedString(@"Error", @"(AEUIUtils) Alert title. When converting rules process ended.") message:[error localizedDescription]];
                    }
                }];
                return;
            }
            
            [[AEService singleton] reloadContentBlockingJsonASyncWithBackgroundUpdate:NO completionBlock:^(NSError *error) {
                
                [self complateWithError:error controller:controller completionBlock:completionBlock rollbackBlock:^{
                    rollbackBlock(error);
                }];
            }];
        });
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

+ (void)addTitleViewToNavigationItem:(UINavigationItem *)navigationItem {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 119, 27)];
    UIImageView *titleLogo = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"navbarLogo"]];
    titleLogo.contentMode = UIViewContentModeScaleAspectFit;
    titleLogo.frame = titleView.frame;
    [titleView addSubview:titleLogo];
    navigationItem.titleView = titleView;
}

+ (UITableViewCell *)createCellByTemplate:(UITableViewCell *)templateCell style:(UITableViewCellStyle)style {
    
    UITableViewCell *newCell = [[[templateCell class] alloc] initWithStyle:style reuseIdentifier:nil];
    
    newCell.textLabel.textColor = templateCell.textLabel.textColor;
    newCell.textLabel.font = templateCell.textLabel.font;
    newCell.detailTextLabel.textColor = templateCell.detailTextLabel.textColor;
    newCell.detailTextLabel.font = templateCell.detailTextLabel.font;
    newCell.indentationLevel = templateCell.indentationLevel;
    newCell.indentationWidth = templateCell.indentationWidth;
    newCell.selectionStyle = templateCell.selectionStyle;
    newCell.backgroundColor = templateCell.backgroundColor;
    newCell.tintColor = templateCell.tintColor;
    newCell.imageView.tintColor = templateCell.tintColor;
    newCell.autoresizingMask = templateCell.autoresizingMask;
    newCell.autoresizesSubviews = templateCell.autoresizesSubviews;
    newCell.textLabel.autoresizingMask = templateCell.textLabel.autoresizingMask;
    newCell.detailTextLabel.autoresizingMask = templateCell.detailTextLabel.autoresizingMask;
    
    return newCell;
}


@end
