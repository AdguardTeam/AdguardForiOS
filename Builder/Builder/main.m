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
#import "ACommons/ACLang.h"
#import "ACommons/ACFiles.h"
#import "ADomain/ADomain.h"
#import "ABackEndClients/ABECFilter.h"
#import "ASDModels/ASDFilterObjects.h"
#import "ASDatabase/ASDatabase.h"
#import "FMDatabase+InMemoryOnDiskIO.h"
#import "FMSQLStatementSplitter.h"
#import "ACommons/vendor/NSDataGZip/NSData+GZIP.h"
#import "Adguard-Swift.h"

#define DB_SCHEME_FILE_NAME     @"schema.sql"
#define DB_SCHEME_PATTERN       @"schema*.sql"
#define DB_TEMP_DB_PATH         @"/tmp/adguradBuilderTempDb.db"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        ASDatabase *asDataBase = [ASDatabase new];
        BuilderHelper *helper = [BuilderHelper new];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSError *err;
        NSString *productPath = [fileManager currentDirectoryPath];
        NSString *configuration = @"--Release";
        
        if (argc > 1) {
            
            productPath = [NSString stringWithCString:argv[2] encoding:NSUTF8StringEncoding];
            configuration = [NSString stringWithCString:argv[1] encoding:NSUTF8StringEncoding];
            
        }
        
        
#pragma mark Creating default DB and filling of this db to data from Backend service
        
        NSString *dbPath = [productPath stringByAppendingPathComponent:ASD_DEFAULT_DB_NAME];
        
        FMDatabase *db;
        
        if ([configuration isEqualToString:@"--Release"]) {
            
            // If Release remove DB
            [fileManager removeItemAtPath:dbPath error:&err];
        }
        else{
            
            // If DB version is changed, remove DB
            
            NSString *currentVersion, *newVersion;
            db = [FMDatabase databaseWithPath:dbPath];
            if ([db open]) {
                
                FMResultSet *result = [db executeQuery:@"select schema_version from version"];
                if ([result next])
                    currentVersion = [result stringForColumnIndex:0];
                [result close];
                [db close];
                
                db = [FMDatabase databaseWithPath:nil];
                
                if ([db open]) {
                    
                    [asDataBase createDefaultDB:db scriptPath:[productPath stringByAppendingPathComponent:DB_SCHEME_FILE_NAME]];
                    FMResultSet *result = [db executeQuery:@"select schema_version from version"];
                    if ([result next])
                        newVersion = [result stringForColumnIndex:0];
                    [result close];
                    [db close];
                }
                if (!([NSString isNullOrEmpty:newVersion] || [currentVersion isEqualToString:newVersion])) {
                    
                    [fileManager removeItemAtPath:dbPath error:&err];
                }
            }
            
        }
        
        if (![fileManager fileExistsAtPath:dbPath]){
            
            NSString *dbPath = [productPath stringByAppendingPathComponent:ASD_DEFAULT_DB_NAME];
            
            db = [FMDatabase databaseWithPath:nil];
            
            if (![db open]) {
                NSLog(@"Error opening DB");
                exit(1);
            }
            
            if ([asDataBase createDefaultDB:db scriptPath:[productPath stringByAppendingPathComponent:DB_SCHEME_FILE_NAME]]){

#pragma mark *** Get filters data from backend and insert to DB
                
                __block ABECFilterClientMetadata *metadata;
                __block ABECFilterClientLocalization *i18n;
                
                dispatch_group_t group = dispatch_group_create();
                dispatch_group_enter(group);
                [helper loadFiltersMetadataWithCompletion:^(ABECFilterClientMetadata * _Nullable meta) {
                    metadata = meta;
                    dispatch_group_leave(group);
                }];
                
                dispatch_group_enter(group);
                [helper loadFiltersLocalizationsWithCompletion:^(ABECFilterClientLocalization * _Nullable localizations) {
                                    i18n = localizations;
                                    dispatch_group_leave(group);
                }];
                
                dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
                
                if (!metadata || !i18n) {
                    
                    NSLog(@"Error creating DB: Can't load filters/groups or i18n metadata from backend service.");
                    exit(1);
                }
                
                
                for (ASDFilterGroup *item in metadata.groups) {
                    
                    [db executeUpdate:@"insert into filter_groups (group_id, name, display_number, is_enabled) values (?, ?, ?, ?)", item.groupId, item.name, item.displayNumber, @0];
                    
                }
                for (ASDFilterGroupLocalization *locale in i18n.groups.localizations) {
                    
                    [db executeUpdate:@"insert into filter_group_localizations (group_id, lang, name) values (?, ?, ?)",
                     locale.groupId, locale.lang, locale.name];
                }
                
                for (ASDFilterMetadata *meta in metadata.filters) {
                    
                    if([meta.filterId isEqualToNumber:@(208)]) {
                        continue;
                    }
                    
                    [db executeUpdate:@"insert into filters (filter_id, group_id, version, display_number, name, description, homepage, expires, subscriptionUrl) values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                     meta.filterId, meta.groupId, meta.version, meta.displayNumber, meta.name, meta.descr, meta.homepage, meta.expires, meta.subscriptionUrl];
                    
                    for (NSString *lang in meta.langs)
                        [db executeUpdate:@"insert into filter_langs (filter_id, lang) values (?, ?)", meta.filterId, lang];
                    
                    for (ASDFilterTagMeta *tag in meta.tags){
                        [db executeUpdate:@"insert into filter_tags (filter_id, tag_id, type, name) values (?, ?, ?, ?)", meta.filterId, @(tag.tagId), @(tag.type), tag.name];
                    }
                    
                }
                for (ASDFilterLocalization *locale in i18n.filters.localizations)
                    [db executeUpdate:@"insert into filter_localizations (filter_id, lang, name, description) values (?, ?, ?, ?)",
                     locale.filterId, locale.lang, locale.name, locale.descr];
                
                ASDFilter *filterData;
                for (ASDFilterMetadata *version in metadata.filters) {
                    // TODO: load filters via FiltersStorage
//                    filterData = [[ABECFilterClient singleton] filterWithFilterId:version.filterId];
//
//                    if (filterData && filterData.rules.count)
//                        for (ASDFilterRule *rule in filterData.rules)
//                            [db executeUpdate:@"insert into filter_rules (filter_id, rule_id, rule_text, affinity) values (?, ?, ?, ?)", rule.filterId, rule.ruleId, rule.ruleText, rule.affinity];
//
                }
                
                [db writeToFile:dbPath];
            }
            else{
                
                NSLog(@"Error creating DB from scheme: %@", dbPath);
                exit(1);
            }
            
            // close db
            [db close];
            
            // gzip default DB
            NSData *dbData = [NSData dataWithContentsOfFile:dbPath];
            if (dbData.length) {
                dbData = [dbData gzippedData];
            }
            if (! [dbData writeToFile:[dbPath stringByAppendingString:@".gz"] atomically:YES]) {
                
                NSLog(@"Error compressing DB: %@", dbPath);
                exit(1);
            }
            
        }
        
#pragma mark *** Checking of update sequence for DB
        
        db = [FMDatabase databaseWithPath:[productPath stringByAppendingPathComponent:ASD_DEFAULT_DB_NAME]];
        
        if ([db open] && [db goodConnection]) {
            
            NSString *defaultVersion;
            FMResultSet *result = [db executeQuery:@"select schema_version from version;"];
            if ([result next]){
                
                defaultVersion = [result stringForColumnIndex:0];
                [result close];
            }
            else{
                
                NSLog(@"Error checking of update sequence for DB: Can't obtain default db version.");
                [db close];
                exit(1);
            }
            
            [db close];
            
            [fileManager removeItemAtPath:DB_TEMP_DB_PATH error:&err];
            
            FMDatabase *tempDb = [FMDatabase databaseWithPath:DB_TEMP_DB_PATH];
            if (!([tempDb open] && [tempDb goodConnection])){
                
                NSLog(@"Error checking of update sequence for DB: Can't open temporary db.");
                [tempDb close];
                exit(1);
            }
            
            NSArray *schemes = [ACFFileUtils findFileByName:DB_SCHEME_PATTERN inDirectory:[NSURL fileURLWithPath:productPath isDirectory:YES] level:1];
            
            if (schemes.count > 1) {
                
                schemes = [schemes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    
                    NSString *s1 = [(NSURL *)obj1 path];
                    NSString *s2 = [(NSURL *)obj2 path];
                    
                    return [s1 compare:s2 options:NSNumericSearch];
                }];
                
                NSString *tempDbPath = [schemes[1] path];
                if (![asDataBase createDefaultDB:tempDb scriptPath:tempDbPath]){
                    
                    NSLog(@"Error checking of update sequence for DB: Can't create tables in temporary db.");
                    [tempDb close];
                    exit(1);
                }
                
                NSString *version;
                result = [tempDb executeQuery:@"select schema_version from version;"];
                if ([result next])
                    version = [result stringForColumnIndex:0];
                else{
                    
                    [tempDb close];
                    NSLog(@"Error checking of update sequence for DB: Can't obtain temporary db version.");
                    exit(1);
                }
                
                if (![asDataBase updateDB:tempDb fromVersion:version toVersion:defaultVersion resourcePath:productPath]){
                    
                    [tempDb close];
                    NSLog(@"Error checking of update sequence for DB: Update sequence is invalid.");
                    exit(1);
                }
                [tempDb close];
            }
            
        }
        else{
            
            NSLog(@"Error checking of update sequence for DB: Can't open default db");
            exit(1);
        }
        
    }
    
    //-------------------------------------------------------------------------------------------
    
    return 0;
}
