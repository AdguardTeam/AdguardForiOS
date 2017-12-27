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
#import <UIKit/UIKit.h>

@class ASDFilterRule;

@interface AEUIUtils : NSObject

/**
 Method shows modal dialog with "standard" loading message,
 then reloads content blocking JSON. On success performs completionBlock,
 on failure shows error message and performs rollbackBlock.
 Blocks are performed synchronously in main queue.
 
 @param completionBlock Block which is performed on success. May be nil.
 @param rollbackBlock Block which is performed on failure. May be nil.
 */
+ (void)invalidateJsonWithController:(UIViewController *)controller
                     completionBlock:(dispatch_block_t)completionBlock
                       rollbackBlock:(dispatch_block_t)rollbackBlock;

/**
 Method shows modal dialog with "standard" loading message,
 then adds whitelist rule and modifies content blocking JSON.
 On success performs completionBlock,
 on failure shows error message and performs rollbackBlock.
 Blocks are performed synchronously in main queue.
 
 @param completionBlock Block which is performed on success. May be nil.
 @param rollbackBlock Block which is performed on failure. May be nil.
 */
+ (void)addWhitelistRule:(ASDFilterRule *)rule
    toJsonWithController:(UIViewController *)controller
         completionBlock:(dispatch_block_t)completionBlock
           rollbackBlock:(dispatch_block_t)rollbackBlock;

/**
 Method shows modal dialog with "standard" loading message,
 then removes whitelist rule and modifies content blocking JSON.
 On success performs completionBlock,
 on failure shows error message and performs rollbackBlock.
 Blocks are performed synchronously in main queue.
 
 @param completionBlock Block which is performed on success. May be nil.
 @param rollbackBlock Block which is performed on failure. May be nil.
 */
+ (void)removeWhitelistRule:(ASDFilterRule *)rule
       toJsonWithController:(UIViewController *)controller
            completionBlock:(dispatch_block_t)completionBlock
              rollbackBlock:(dispatch_block_t)rollbackBlock;

/**
 Method shows modal dialog with "standard" loading message,
 then replaces all rules in User Filter.
 On success performs completionBlock,
 on failure shows error message and performs rollbackBlock.
 Blocks are performed synchronously in main queue.

 @param rules New rules for user filer
 @param completionBlock Block which is performed on success. May be nil.
 @param rollbackBlock Block which is performed on failure. May be nil.
 */
+ (void)replaceUserFilterRules:(NSArray <ASDFilterRule *> *)rules
                withController:(UIViewController *)controller
               completionBlock:(dispatch_block_t)completionBlock
                 rollbackBlock:(void (^)(NSError *error))rollbackBlock;

/**
 add adguard logo to navigation bar
 */
+ (void) addTitleViewToNavigationItem:(UINavigationItem*) navigationItem;

@end
