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

extern NSString *AESUserInfoRuleObject;

/////////////////////////////////////////////////////////////////////
#pragma mark - AEServices
/////////////////////////////////////////////////////////////////////

@class AESAntibanner, ASDFilterRule, AEService, ContentBlockerService;
@protocol AESharedResourcesProtocol;

@protocol AEServiceProtocol <NSObject>

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

//+ (AEService *)singleton;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@property (nonatomic, readonly) BOOL firstRunInProgress;

- (AESAntibanner *)antibanner;

- (void)start;

- (void)stop;

/**
 Method pushes block of code into queue,
 which will be run when service object will be ready.
 Blocks are performed on service working queue.
 */
- (void)onReady:(void (^)(void))block;

@end

@interface AEService : NSObject<AEServiceProtocol>

- (id)initWithContentBlocker: (ContentBlockerService*) contentBlockerService resources:(id<AESharedResourcesProtocol>)resources;

@end
