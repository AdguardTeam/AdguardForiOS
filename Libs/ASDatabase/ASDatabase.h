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

//#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
#import <UIKit/UIKit.h>
//#endif

#import <Foundation/Foundation.h>
#import "vendors/fmdb/FMDB.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDatabase Constants
/////////////////////////////////////////////////////////////////////

#define ASD_DEFAULT_DB_NAME             @"default.db"

#define ASDatabaseErrorDomain               @"ASDatabaseErrorDomain"
#define ASDatabaseOpenErrorCode             100
#define ASDatabaseInitDefaultDbErrorCode    200

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDatabase
/////////////////////////////////////////////////////////////////////

/**
 Managing database and queue for DB operations
 */
@interface ASDatabase : NSObject{
 
    FMDatabaseQueue *defaultDbQueue; // queue for default DB
    FMDatabaseQueue *queue; // queue for production DB
    NSString *dbVersion;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

@property (readonly) BOOL ready;
@property (readonly) NSError *error;
@property (readonly, nonatomic) NSURL *dbURL;

/**
    Init database, copying default.db to production if need it, checking scheme version.
    If error occurs, then `ready` property stays NO and `error` property has last error object.
 
    @param dbURL                    Url of the production DB.
    @param upgradeDefaultDb         Set to YES this parameter, 
                                    if you need fresh version of the default DB in shared folder.
 */
- (void)initDbWithURL:(NSURL *)dbURL upgradeDefaultDb:(BOOL)upgradeDefaultDb;

/**
 Executes queries in "transaction" (in fact in save point,
 so if no open transaction at the moment, then code will be performed
 as single transaction).
 
 @param block Block of a code, which will be performed in single transaction.
 */
- (void)exec:(void (^)(FMDatabase *db, BOOL *rollback))block;

/**
 Executes queries.
 @param block Block of a code, which will be performed.
 */
- (void)rawExec:(void (^)(FMDatabase *db))block;

/**
    Execute select query in default DB.
 */
- (void)queryDefaultDB:(void (^)(FMDatabase *db))block;

/**
 Sets parameter "READ UNCOMMITTED" on current DB connection.
 */
- (void)readUncommited:(BOOL)enabled;

/**
 Turns on mode for GCD queue, when job in DB, in this queue, 
 is performed on separated DB connection.
 */
- (BOOL)isolateQueue:(dispatch_queue_t)theQueue;
/**
 Turns off isolated mode for GCD queue. 
 See description of method: - (BOOL)isolateQueue:(dispatch_queue_t)theQueue;
 */
- (void)resetIsolationQueue:(dispatch_queue_t)theQueue;

/////////////////////////////////////////////////////////////////////
#pragma mark DB manipulation methods
/////////////////////////////////////////////////////////////////////

/**
    Create tables in DB using creation script.
    @param version May be empty string. 
    In this case is used default creation script.
 */
- (BOOL)createDefaultDB:(FMDatabase *)db version:(NSString *)version;
/**
 Create tables in DB using creation script.
 @param scriptPath Full path to creation script.
 */
- (BOOL)createDefaultDB:(FMDatabase *)db scriptPath:(NSString *)scriptPath;

/**
    Update tables in DB using update scripts up to version,
    that defined by toVersion parameter.
 */
- (BOOL)updateDB:(FMDatabase *)db fromVersion:(NSString *)version toVersion:(NSString *)toVersion;

/**
 Update tables in DB using update scripts up to version,
 that defined by toVersion parameter.
 
 @param resourcePath Path where is update scripts.
 */
- (BOOL)updateDB:(FMDatabase *)db fromVersion:(NSString *)version toVersion:(NSString *)toVersion resourcePath:(NSString *)resourcePath;

/** stop database working. Requests will no longer be executed */
- (void) stop;

@end
