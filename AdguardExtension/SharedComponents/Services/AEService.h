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
#import <Foundation/Foundation.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - AEServices Constants
/////////////////////////////////////////////////////////////////////


/**
 NSError domain for errors from AEService object.
 */
extern NSString *AEServiceErrorDomain;
#define AES_ERROR_SERVICE_NOT_STARTED                   1
#define AES_ERROR_JSON_CONVERTER_OVERLIMIT              10
#define AES_ERROR_ARGUMENT                              20
#define AES_ERROR_UNSUPPORTED_RULE                      30
#define AES_ERROR_DB                                    40
#define AES_ERROR_SAFARI_EXCEPTION                      50

/////////////////////////////////////////////////////////////////////
#pragma mark - AEServices
/////////////////////////////////////////////////////////////////////

@class AESAntibanner, ASDFilterRule;

@interface AEService : NSObject
/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+ (AEService *)singleton;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@property (nonatomic, readonly) BOOL firstRunInProgress;

- (AESAntibanner *)antibanner;

- (void)start;

- (void)stop;


- (NSError *)updateRule:(ASDFilterRule *)rule oldRuleText:(NSString *)oldRuleText;
- (NSError *)addRule:(ASDFilterRule *)rule temporarily:(BOOL)temporarily;
- (BOOL)removeRules:(NSArray *)rules;

/**
 Adds whitelist rule, modifies content blocking JSON
 and replaces this JSON in shared resources asynchronously.
 Method performs completionBlock when done on service working queue.
 */
- (void)addWhitelistRule:(ASDFilterRule *)rule completionBlock:(void (^)(NSError *error))completionBlock;

/**
 Removes whitelist rule, modifies content blocking JSON
 and replaces this JSON in shared resources asynchronously.
 Method performs completionBlock when done on service working queue.
 */
- (void)removeWhitelistRule:(ASDFilterRule *)rule completionBlock:(void (^)(NSError *error))completionBlock;

/**
 Converts active filter rules to content blocking JSON 
 and replaces this JSON in shared resources asynchronously. 
 Method performs completionBlock when done on service working queue.
 */
- (void)reloadContentBlockingJsonASyncWithBackgroundUpdate:(BOOL)backgroundUpdate completionBlock:(void (^)(NSError *error))completionBlock;

/**
 If reloadContentBlockingJsonASync (addWhitelistDomain, removeWhitelistRule) 
 method is running still, this method pushes block of code into queue,
 which will be run when reloadContentBlockingJsonASync 
 (addWhitelistDomain, removeWhitelistRule) method will be completed,
 else performs block of code immediately.
 Blocks are performed on service working queue.
 */
- (void)onReloadContentBlockingJsonComplete:(void (^)(void))block;

/**
 Method pushes block of code into queue,
 which will be run when service object will be ready.
 Blocks are performed on service working queue.
 */
- (void)onReady:(void (^)(void))block;

@end
