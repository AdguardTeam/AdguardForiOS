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
#import "AESharedResources.h"


@class APDnsLogRecord;

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources Constants

/**
 User Defaults key that define, create log of the DNS requests or not.
 */
extern NSString *APDefaultsDnsLoggingEnabled;
/**
 User Defaults key, which defines list of the remote DNS servers (list of APDnsServerObject objects).
 */
extern NSString *APDefaultsCustomRemoteDnsServers;
/**
 User Defaults key, which defines, to filter DNS request locally or not.
 */
extern NSString *APDefaultsDnsLocalFiltering;

typedef NS_ENUM(Byte, APHost2TunnelMessageType){
    
    // Commands for controlling "DNS activity log", between tunnel provider extension and host application.
    APHTMLoggingEnabled = 1,
    APHTMLoggingDisabled,
    // Command for notification of the tunnel provider extension that domains whitelist/blacklist were changed.
    APHTMLSystemWideDomainListReload
};

/////////////////////////////////////////////////////////////////////
#pragma mark - APSharedResources

/**
     (PRO) Class, which provides exchanging data between app and extension.
 */
@interface APSharedResources : AESharedResources

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

+ (NSArray <APDnsLogRecord *> *)readDnsLog;

+ (BOOL)removeDnsLog;

+ (void)writeToDnsLogRecords:(NSArray <APDnsLogRecord *> *)logRecords;

+ (APHost2TunnelMessageType)host2tunnelMessageType:(NSData *)messageData;
+ (NSData *)host2tunnelMessageLogEnabled;
+ (NSData *)host2tunnelMessageLogDisabled;
+ (NSData *)host2tunnelMessageSystemWideDomainListReload;

/**
 User-entered list of domains to be excluded from locking at the system-wide level.
 */
@property (class) NSArray <NSString *> *whitelistDomains;
/**
 User-entered list of domains that are blocked at the system-wide level.
 */
@property (class) NSArray <NSString *> *blacklistDomains;

@end
