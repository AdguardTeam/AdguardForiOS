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
//#import "ABECConstants.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ABECRequest
/////////////////////////////////////////////////////////////////////

/**
 *  Description of ABECRequest
 */
@interface ABECRequest  : NSMutableURLRequest

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////


/**
    Create request object with POST method.
    @param parameters   May be nil.
 */
+ (nonnull NSURLRequest*) postRequestForURL:(nonnull NSURL *)theURL parameters:(nullable NSDictionary<NSString*, NSString*> *)parameters headers:(nullable NSDictionary<NSString*, NSString*>*) headers;

/**
 Create request object with POST method^ Content-Type = application/json
 @param jsonString - jaon to send
 */
+ (nonnull NSURLRequest*) postRequestForURL:(nonnull NSURL *)theURL json:(nonnull NSString*) jsonString;

/**
    Create request object with GET method.
    @param parameters   May be nil.
 */
+ (nonnull id) getRequestForURL:(nonnull NSURL *)theURL parameters:(nullable NSDictionary *)parameters;

/**
    Create parameter string from dictionary.
    Parameters values is converted using percent escaping.
 */
+ (nonnull NSString *) createStringFromParameters:(nonnull NSDictionary *)parameters;

@end

