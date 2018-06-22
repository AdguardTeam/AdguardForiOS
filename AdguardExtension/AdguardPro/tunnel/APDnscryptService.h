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

#import <Foundation/Foundation.h>
#import "APDnsServerObject.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnscryptService

/**
 Class controls dnscrypt client.
 */
@interface APDnscryptService : NSObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

/**
 init service.
 params - ip and port for dnscrypt client
 */
- (instancetype) initWithIp:(NSString*)ip port:(NSString*) port;

/**
 starts service
 server - remote server configuration
 completionBlock will called in main dispatch queue right after the service will be succesfully initialized
 */
- (BOOL) startWithRemoteServer:(APDnsServerObject*) server completionBlock:(void (^)())completionBlock;

/**
 stops service
 completionBlock will called in main dispatch queue right after the service will be succesfully stopped
 if service is not running now then completionBlock will call immediately in main queue
 */
- (BOOL) stopWithCompletionBlock:(void (^)())completionBlock;

@end
