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
#import "APDnsRequest.h"
#import "APDnsResponse.h"

@class DnsServerInfo;

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
- (nullable id)initWithID:(nullable NSNumber *)ID srcPort:(nullable NSString *)srcPort dnsServer:(nonnull DnsServerInfo *)dnsServer;

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

/**
 Timestamp log record.
 */
@property (nonatomic, readonly, nonnull) NSDate *recordDate;
/**
 DNS request id.
 */
@property (readonly, nonatomic, nonnull) NSNumber *ID;
/**
 Port of the app, that made request.
*/
@property (readonly, nonatomic, nonnull) NSString *srcPort;
/**
 DNS server description.
 */
@property (readonly, nonatomic, nonnull) DnsServerInfo *dnsServer;
/**
 DNS request.
 */
@property (nonatomic, nullable) NSArray <APDnsRequest *> *requests;
/**
 DNS Response.
 */
@property (nullable, nonatomic) NSArray <APDnsResponse *> *responses;
/**
 Returns DNS response, which will be used for presentation.
 */
@property (nonatomic, readonly, nullable) APDnsResponse *preferredResponse;

/**
 Indicates that this record contains domain from trackers list.
 */
@property (nonatomic) BOOL isTracker;

@end
