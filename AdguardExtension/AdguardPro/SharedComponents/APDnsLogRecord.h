/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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

@class APDnsResponse, APDnsRequest;

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsLogRecord

/**
 Description of APDnsLogRecord
 */
@interface APDnsLogRecord  : NSObject <NSCoding>

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

/**
 Main init method. All parameters must be defined.
 
 @return Returns object, or nil if error occurs.
 */
- (id)initWithID:(NSNumber *)ID srcPort:(NSString *)srcPort vpnMode:(NSNumber *)vpnMode;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Timestamp log record.
 */
@property (nonatomic, readonly) NSDate *recordDate;
/**
 DNS request id.
 */
@property (readonly, nonatomic) NSNumber *ID;
/**
 Port of the app, that made request.
*/
@property (readonly, nonatomic) NSString *srcPort;
/**
 Mode of the VPN connection (see type APVpnMode in APVPNManager.h)
 */


@property (readonly, nonatomic) NSNumber *vpnMode;
/**
 DNS request.
 */
@property (nonatomic) NSArray <APDnsRequest *> *requests;
/**
 DNS Response.
 */
@property (nonatomic) NSArray <APDnsResponse *> *responses;

@end
