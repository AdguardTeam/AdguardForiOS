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
#import "ASDatabase.h"
#import "ACommons/ACLang.h"
#import "ADomain/ADomain.h"
#import "ACommons/vendor/NSDataGZip/NSData+GZIP.h"
#import "FMSQLStatementSplitter.h"

#define DB_SCHEME_FILE_FORMAT       @"%@/schema%@.sql"
#define DB_SCHEME_UPDATE_FORMAT     @"%@/update%@.sql"


#define CURRENT_VERSION
// Marker which defines version of the default DB in Adguard shared folder
#define DB_DEFAULTDB_MARKER_FILE    @"defaultdb-marker.data"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"

/////////////////////////////////////////////////////////////////////
#pragma mark - ASDatabase
/////////////////////////////////////////////////////////////////////

static const void * const kDatabaseQueueSpecificKey = &kDatabaseQueueSpecificKey;

static void isolateQueueReleaseFunc(void *dQueue){
    
    if (dQueue) {
        CFRelease(dQueue);
    }
    return;
}

@interface ASDatabase ()

@property BOOL ready;
@property NSError *error;

@end

@implementation ASDatabase

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (void)dealloc{
    
    [queue close];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

- (void)initDbWithURL:(NSURL *)dbURL upgradeDefaultDb:(BOOL)upgradeDefaultDb buildVersion:(NSString *)buildVersion {

    if (!dbURL) {
        return;
    }
    
    @synchronized (self) {
        
        if (self.dbURL) {
            return;
        }
        
        _dbURL = dbURL;
        
        self.error = nil;
        
        __block NSString *defaultDBVersion;

        // Open default DB
        
        NSString *defaultDbPath = [[[dbURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:ASD_DEFAULT_DB_NAME] path];
        
        
        NSURL *defaultDBMarkerFile = [[dbURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:DB_DEFAULTDB_MARKER_FILE];
        
        NSString *marker = [NSString stringWithContentsOfURL:defaultDBMarkerFile encoding:NSUTF8StringEncoding error:nil];
        
        if (! [marker isEqualToString: buildVersion]) {

            BOOL result = NO;
            
            if (upgradeDefaultDb) {
                
                // in this case we must update default DB to actual version
                
                // unzip default DB into working folder
                @autoreleasepool {
                    
                    NSString *zippedDefaultDbPath = [[[NSBundle bundleForClass:[self class]] resourcePath]
                                                     stringByAppendingPathComponent:ASD_DEFAULT_DB_NAME @".gz"];
                    
                    NSData *dbData;
                    @autoreleasepool {
                        NSData *zippedDbData = [NSData dataWithContentsOfFile:zippedDefaultDbPath];
                        if (zippedDbData.length) {
                            
                            dbData = [zippedDbData gunzippedData];
                        }
                    }
                    if (dbData.length) {
                        
                        result = [dbData writeToFile:defaultDbPath atomically:YES];
                    }
                    
                    
                    if (result) {
                        // save marker as current version+build
                        NSURL *defaultDBMarkerFile = [[dbURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:DB_DEFAULTDB_MARKER_FILE];
                        result = [buildVersion writeToURL:defaultDBMarkerFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    }
                    
                }
            }
            else {
                
                if (marker) {
                    // we found any marker, it means that default DB exists in shared folder
                    result = YES;
                }
            }
            if (result == NO) {
                self.error = [NSError errorWithDomain:ASDatabaseErrorDomain code:ASDatabaseInitDefaultDbErrorCode
                                             userInfo:@{NSLocalizedDescriptionKey : @"Error init default DB."}];
                DDLogError(@"Error init default DB.");
                
                return;
            }
            
        }
        
        defaultDbQueue = [FMDatabaseQueue databaseQueueWithPath:defaultDbPath flags:(SQLITE_OPEN_READONLY | SQLITE_OPEN_SHAREDCACHE)];
        if (defaultDbQueue){
            
            __typeof__(self) __weak  wSelf = self;
            
            [defaultDbQueue inDatabase:^(FMDatabase *db) {
                
                __typeof__(self) sSelf = wSelf;
                
                // check current version of production DB
                FMResultSet *result = [db executeQuery:@"select schema_version from version;"];
                if ([result next]){
                    
                    defaultDBVersion = [result stringForColumnIndex:0];
                    [result close];
                }
                else{
                    
                    sSelf.error = [db lastError];
                    DDLogError(@"Error selecting scheme_version from default DB: %@", [[db lastError] localizedDescription]);
                }
            }];
        }
        else{
            
            // Clinical case.
            [NSException raise:NSInternalInconsistencyException format:@"Can't open default DB."];
        }
        
        if (self.error) {
            
            [defaultDbQueue close];
            return;
        }
        
        // check production DB
        NSURL *productionDBUrl = _dbURL;

        if ([productionDBUrl checkResourceIsReachableAndReturnError:nil]) {
            
            // check current version of production DB

            // open production DB
            queue = [FMDatabaseQueue databaseQueueWithPath:[productionDBUrl path] flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE)];
            if (queue){
                
                [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {

                    FMResultSet *result = [db executeQuery:@"select schema_version from version;"];
                    if ([result next]){
                        
                        dbVersion = [result stringForColumnIndex:0];
                        if ([dbVersion compare:defaultDBVersion options:NSNumericSearch] == NSOrderedAscending) {

                            // STARTING OF UPDATE DATABASE STRUCTURE
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                
                               [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                                   
                                   *rollback = NO;
                                   if ([self updateDB:db fromVersion:dbVersion toVersion:defaultDBVersion])
                                       dispatch_async(dispatch_get_main_queue(), ^{

                                           self.ready = YES;
                                       });
                                   
                                   else
                                       *rollback = YES;
                               }];
                                
                            });
                            
                            //
                        }
                        else
                            self.ready = YES;
                    }
                    else{
                        
                        self.error = [db lastError];
                        DDLogError(@"Error selecting scheme_version from production DB: %@", [[db lastError] localizedDescription]);
                    }
                    [result close];
                }];
            }
        }
        else{
            
            //open production DB
            queue = [FMDatabaseQueue databaseQueueWithPath:[productionDBUrl path] flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE)];
            if (queue){
             
                [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    
                    *rollback = NO;
                    if ([db goodConnection]){
                        
                        //create production DB from default creation script
                        if ([self createDefaultDB:db version:@""])
                             self.ready = YES;
                        else
                            *rollback = YES;
                    }
                    else{
                        
                        self.error = [NSError errorWithDomain:ASDatabaseErrorDomain code:ASDatabaseOpenErrorCode
                                                         userInfo:@{NSLocalizedDescriptionKey : @"Error testing connection to production DB."}];
                        DDLogError(@"Error testing connection to production DB.");
                    }
                }];
            }
            else{
                
                self.error = [NSError errorWithDomain:ASDatabaseErrorDomain code:ASDatabaseOpenErrorCode
                                                 userInfo:@{NSLocalizedDescriptionKey : @"Error opening production DB."}];
                DDLogError(@"Error opening production DB.");
            }
        }
        
        if (self.error){
            
            [queue close];
            [defaultDbQueue close];
        }        
    }
}

- (void)readUncommited:(BOOL)enabled{
    
    if (self.ready){
        
        FMDatabaseQueue *execQueue;
        @synchronized(self) {
            execQueue = (__bridge FMDatabaseQueue *)dispatch_get_specific(kDatabaseQueueSpecificKey);
        }
        
        if (!execQueue) {
            execQueue = queue;
        }
        
        [execQueue inDatabase:^(FMDatabase *db) {
            
            if (enabled) {
                [db executeUpdate:@"PRAGMA read_uncommitted = True"];
            }
            else{
                [db executeUpdate:@"PRAGMA read_uncommitted = False"];
            }
        }];
    }
    else
        DDLogWarn(@"Database service not ready. Not possible execute query in production DB.");
}

- (void)exec:(void (^)(FMDatabase *db, BOOL *rollback))block{
    
    NSUInteger identifier = [self beginBackgroundTask];
    
    if (self.ready){
        
        FMDatabaseQueue *execQueue;
        @synchronized(self) {
            execQueue = (__bridge FMDatabaseQueue *)dispatch_get_specific(kDatabaseQueueSpecificKey);
        }
        
        if (!execQueue) {
            execQueue = queue;
        }

        [execQueue inSavePoint:block];
    }
    else
        DDLogWarn(@"Database service not ready. Not possible execute query in production DB.");
    
    [self endBackgroubdTaskWithId:identifier];
}

- (void)rawExec:(void (^)(FMDatabase *db))block{
    
    NSUInteger identifier = [self beginBackgroundTask];
    if (self.ready){
        
        FMDatabaseQueue *execQueue;
        @synchronized(self) {
           execQueue = (__bridge FMDatabaseQueue *)dispatch_get_specific(kDatabaseQueueSpecificKey);
        }
        
        if (!execQueue) {
            execQueue = queue;
        }
        
        [execQueue inDatabase:block];
    }
    else
        DDLogWarn(@"Database service not ready. Not possible execute query in production DB.");
    
    [self endBackgroubdTaskWithId:identifier];
}

- (void)queryDefaultDB:(void (^)(FMDatabase *db))block{
    
    NSUInteger identifier = [self beginBackgroundTask];
    
    if (self.ready)
        [defaultDbQueue inDatabase:block];
    else
        DDLogWarn(@"Database service not ready. Not possible execute query in default DB.");
    
    [self endBackgroubdTaskWithId:identifier];
}

- (BOOL)isolateQueue:(dispatch_queue_t)theQueue{
    
    if (theQueue == nil) {
        return NO;
    }
    
    if (self.ready){

        @synchronized(self) {

            FMDatabaseQueue *dQueue = (__bridge id)dispatch_queue_get_specific(theQueue, (kDatabaseQueueSpecificKey));
            if (dQueue) {
                return YES;
            }
            
            dQueue = [FMDatabaseQueue databaseQueueWithPath:[_dbURL path] flags:(SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_SHAREDCACHE)];
            if (dQueue){
                
                dispatch_queue_set_specific(theQueue, kDatabaseQueueSpecificKey, (void *)CFBridgingRetain(dQueue), &isolateQueueReleaseFunc);
                return YES;
            }
        }
    }

    return NO;
}

- (void)resetIsolationQueue:(dispatch_queue_t)theQueue{
    
    if (theQueue == nil) {
        return;
    }
    
    @synchronized(self) {
        
        dispatch_queue_set_specific(theQueue, kDatabaseQueueSpecificKey, NULL, NULL);
    }
    
    return;
}

- (void)stop {
    self.ready = NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark DB manipulation methods
/////////////////////////////////////////////////////////////////////

- (BOOL)createDefaultDB:(FMDatabase *)db version:(NSString *)version{
 
    @autoreleasepool {

        if (!version)
            version = @"";
            
        NSString *scriptPath = [NSString stringWithFormat:DB_SCHEME_FILE_FORMAT,  [[NSBundle bundleForClass:[self class]] resourcePath], version];
        
        return [self createDefaultDB:db scriptPath:scriptPath];
    }
}

- (BOOL)createDefaultDB:(FMDatabase *)db scriptPath:(NSString *)scriptPath{

    @autoreleasepool {
        
        NSError *err;
        
        NSString *dbCreateScript = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&err];
        
        if (err) {
            
            DDLogError(@"Error reading file with db creation script: %@", [err localizedDescription]);
            self.error = err;
            return NO;
        }
        
        NSArray *queries = [[FMSQLStatementSplitter sharedInstance] statementsFromBatchSqlStatement:dbCreateScript];
        
        BOOL result = YES;
        
        for (FMSplittedStatement *statement in queries) {
            
            NSString *query = [statement.statementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![NSString isNullOrEmpty:query])
                result &= [db executeUpdate:query];
        }
        
        return result;
    }
}

- (BOOL)updateDB:(FMDatabase *)db fromVersion:(NSString *)version toVersion:(NSString *)toVersion{

    NSString *resourcePath = [[NSBundle bundleForClass:[self class]] resourcePath];

    return [self updateDB:db fromVersion:version toVersion:toVersion resourcePath:resourcePath];
}

- (BOOL)updateDB:(FMDatabase *)db fromVersion:(NSString *)version toVersion:(NSString *)toVersion resourcePath:(NSString *)resourcePath{
    
    while (![version isEqualToString:toVersion]){
        @autoreleasepool {
            
            NSError *err;
            NSString *updateScriptPath = [NSString stringWithFormat:DB_SCHEME_UPDATE_FORMAT,  resourcePath, version];
            NSString *dbUpdateScript = [NSString stringWithContentsOfFile:updateScriptPath encoding:NSUTF8StringEncoding error:&err];
            
            if (err) {
                
                DDLogError(@"Error reading file with db update script: %@", [err localizedDescription]);
                self.error = err;
                return NO;
            }
            
            NSArray *queries = [[FMSQLStatementSplitter sharedInstance] statementsFromBatchSqlStatement:dbUpdateScript];
            
            for (FMSplittedStatement *statement in queries) {
                
                NSString *query = [statement.statementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (![NSString isNullOrEmpty:query]){
                    if (![db executeUpdate:query]){
                        
                        DDLogError(@"Error in update script: %@", updateScriptPath);
                        return NO;
                    }
                    else
                        [db closeOpenResultSets];
                }
            }

            FMResultSet *result = [db executeQuery:@"select schema_version from version;"];
            if ([result next]){

                version = [result stringForColumnIndex:0];
                [result close];
            }
            else
                return NO;
        }
    }
    
    return YES;
}

- (NSUInteger) beginBackgroundTask {
#if (!APP_EXTENSION) && (!TARGET_OS_OSX)
    return [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
#endif
    return 0;
}

- (void) endBackgroubdTaskWithId: (NSUInteger) identifier {
#if (!APP_EXTENSION) && (!TARGET_OS_OSX)
    return [[UIApplication sharedApplication] endBackgroundTask:identifier];
#endif
}

#pragma clang diagnostic pop

@end
