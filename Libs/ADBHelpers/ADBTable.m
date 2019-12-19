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

#import "ADBTable.h"
#import <objc/runtime.h>
#import "ACommons/ACLang.h"
#import "ADBTableRow.h"

@implementation ADBTable

- (id)initWithRowClass:(Class)theClass db:(FMDatabase *)db{
    
    self = [super init];
    if (self){
        
        if (![theClass isSubclassOfClass:[ADBTableRow class]]) {
            return nil;
        }
        
        if (!db) {
            return  nil;
        }
        
        
        _db = db;
        _tableName = [theClass tableName];
        _objectClass = theClass;
        
        _propertyNames = [theClass propertyNames];
        _nsdatePropertyNames = [theClass nsdatePropertyNames];
        _plistPropertyNames = [theClass plistPropertyNames];
        
        [self initDescrForDb];
    }
    return self;
    
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (NSArray *)selectWithKeys:(NSArray *)keyFields inRowObject:(id)row{
    
    return [self selectWithKeys:keyFields inRowObject:row fromDb:_db];
}

- (NSArray *)selectWithKeys:(NSArray *)keyFields inRowObject:(id)row fromDb:(FMDatabase *)db{
    
    @autoreleasepool {
        
        if (!row) {
            
            row = [_objectClass new];
        }
        
        NSMutableArray *rows = [NSMutableArray array];
        
        NSString *queryString = [NSString stringWithFormat:@"select *, rowid from %@", _tableName];
        NSString *whereString = nil;
        
        NSArray *keys = [self validKeysFromKeyFields:keyFields andWhereString:&whereString];
        if (!keys)
            return nil;
        
        FMResultSet *result = [db executeQuery:[queryString stringByAppendingString:whereString] withParameterDictionary:[row dictionaryWithValuesForKeys:keys]];
        
        while ([result next]) {
            
            [rows addObject:[[_objectClass alloc] initWithDbResult:result]];
        }
        [result close];
        
        return rows;
    }
}

- (BOOL)deleteWithKeys:(NSArray *)keyFields inRowObject:(id)row{
    
    return [self deleteWithKeys:keyFields inRowObject:row fromDb:_db];
}

- (BOOL)deleteWithKeys:(NSArray *)keyFields inRowObject:(id)row fromDb:(FMDatabase *)db{
    
    @autoreleasepool {
        
        if (!row) {
            
            row = [_objectClass new];
        }

        if (![row isKindOfClass:_objectClass]) {
            
            return NO;
        }
        
        NSString *queryString = [NSString stringWithFormat:@"delete from %@", _tableName];
        NSString *whereString = nil;
        
        NSArray *keys = [self validKeysFromKeyFields:keyFields andWhereString:&whereString];
        if (!keys)
            return NO;
        
        return [db executeUpdate:[queryString stringByAppendingString:whereString] withParameterDictionary:[row dictionaryWithValuesForKeys:keys]];
    }
}

- (BOOL)insertOrReplace:(BOOL)orReplace fromRowObject:(id)row{
    
    return [self insertOrReplace:orReplace fromRowObject:row toDb:_db];
}

- (BOOL)insertOrReplace:(BOOL)orReplace fromRowObject:(id)row toDb:(FMDatabase *)db{
    
    @autoreleasepool {
        
        if (![row isKindOfClass:_objectClass]) {
            
            return NO;
        }
        
        // Get query string
        
        NSString *queryString = [NSString stringWithFormat:_insertQueryString, (orReplace ? @" or replace" : @"")];
        
        NSDictionary *objects = [row dictionaryWithValuesForKeys:_insertQueryKeys];
        NSMutableDictionary *valueObjects = [NSMutableDictionary dictionary];
        
        id obj;
        for (NSString *key in _insertQueryKeys) {
            obj = objects[key];
            
            //-------- Convert objects if need it ---------------
            
            if ([_nsdatePropertyNames containsObject:key] && [obj isKindOfClass:[NSDate class]]) {
                // mapping from NSDate
                
                valueObjects[key] = [obj iso8601String];
            }
            else if ([_plistPropertyNames containsObject:key] ){
                // mapping from complex object
                
                NSData *serializedData;
                if ([_columnTypes[key] isEqualToString:@"BLOB"]) {
                    
                    serializedData = [NSKeyedArchiver archivedDataWithRootObject:obj];
                    
                    if (serializedData) {
                        
                        valueObjects[key] = serializedData;
                    }
                }
                else {
                    NSMutableData *mutableData = [NSMutableData data];
                    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
                    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
                    
                    [archiver encodeObject:obj forKey:NSKeyedArchiveRootObjectKey];
                    [archiver finishEncoding];
                    
                    if (mutableData.length) {
                        
                        NSString *value = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
                        if (value) {
                            
                            valueObjects[key] = value;
                        }
                        
                    }
                }                                
            }
            else{
                
                //standard mapping
                valueObjects[key] = obj;
            }
            
            //---------------------------------------------------
            
        };
        
        return [db executeUpdate:queryString withParameterDictionary:valueObjects];
    }
}

- (BOOL)updateWithKeys:(NSArray *)keyFields fromRowObject:(id)keyRow updateFields:(NSArray *)updateFields fromRowObject:(id)valueRow{
    
    return [self updateWithKeys:keyFields fromRowObject:keyRow updateFields:updateFields fromRowObject:valueRow inDb:_db];
}

- (BOOL)updateWithKeys:(NSArray *)keyFields fromRowObject:(id)keyRow updateFields:(NSArray *)updateFields fromRowObject:(id)valueRow inDb:(FMDatabase *)db{
    
    @autoreleasepool {
        
        if (!keyRow) {
            
            keyRow = [_objectClass new];
        }
        
        if (!([keyRow isKindOfClass:_objectClass] && [valueRow isKindOfClass:_objectClass])) {
            
            return NO;
        }
        
        // caching method arguments
        if (!(_updateQueryString && keyFields == _updateKeyFields && updateFields == _updateFields)) {
            
            _updateKeyFields = keyFields;
            _updateFields = updateFields;
            
            NSMutableSet *theSet = [NSMutableSet setWithArray:_insertQueryKeys]; // hint _insertQueryKeys
            if ([_updateFields count]) {
                
                [theSet intersectSet:[NSSet setWithArray:_updateFields]];
            }
            _updateValidFields = [theSet allObjects];
            
            // Get value params for query string
            NSMutableArray *valueParams = [NSMutableArray array];
            for (NSString *key in _updateValidFields) {

                if ([_nsdatePropertyNames containsObject:key]) {
                    // mapping to NSDate
                    
                    [valueParams addObject:[NSString stringWithFormat:@"%@ = datetime(:u_%@)", key, key]];
                }
                else{
                    
                    //standant mapping
                    [valueParams addObject:[NSString stringWithFormat:@"%@ = :u_%@", key, key]];
                }
            }
            
            NSString *whereString;
            _updateWhereKeys = [self validKeysFromKeyFields:_updateKeyFields andWhereString:&whereString];
            if (!_updateWhereKeys) {
                
                //error processing
                _updateQueryString = nil;
                return NO;
            }
            
            _updateQueryString = [NSString stringWithFormat:@"update %@ set %@%@", _tableName, [valueParams componentsJoinedByString:@", "], whereString];
            
        }
        
        NSDictionary *objects = [valueRow dictionaryWithValuesForKeys:_updateValidFields];
        NSMutableDictionary *valueObjects = [NSMutableDictionary dictionary];
        
        id obj;
        for (NSString *key in _updateValidFields) {

            obj = objects[key];
            //-------- Convert objects if need it ---------------
            
            NSString *specialUpdateKey = [@"u_" stringByAppendingString:key];
            
            if ([_nsdatePropertyNames containsObject:key] && [obj isKindOfClass:[NSDate class]]) {
                // mapping from NSDate
                
                valueObjects[specialUpdateKey] = [obj iso8601String];
            }
            else if ([_plistPropertyNames containsObject:key] ){
                // mapping from Property List
                
                NSError *err = nil;
                NSData *serializedData;
                if ([_columnTypes[key] isEqualToString:@"BLOB"]) {
                    
                    serializedData = [NSKeyedArchiver archivedDataWithRootObject:obj];
                    if (serializedData) {
                        
                        valueObjects[specialUpdateKey] = serializedData;
                    }
                }
                else {
                    
                    NSMutableData *mutableData = [NSMutableData data];
                    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
                    archiver.outputFormat = NSPropertyListXMLFormat_v1_0;
                    
                    [archiver encodeRootObject:obj];
                    [archiver finishEncoding];
                    
                    if (mutableData.length) {
                      
                        NSString *value = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
                        if (value) {
                            
                            valueObjects[specialUpdateKey] = value;
                        }

                    }
                }
                
                if (err)
                    [NSException raise:NSGenericException format:@"Error converting key \"%@\" to property list: %@", key, [err localizedDescription]];
                
            }
            else{
                
                //standant mapping
                valueObjects[specialUpdateKey] = obj;
            }
            
            //---------------------------------------------------
        }
        
        
        // get where fields and append to valueObjects
        [valueObjects addEntriesFromDictionary:[keyRow dictionaryWithValuesForKeys:_updateWhereKeys]];
        
        return [db executeUpdate:_updateQueryString withParameterDictionary:valueObjects];
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////////

- (void)initDescrForDb{
    
    @autoreleasepool {
        
        NSMutableArray *names = [NSMutableArray array];
        NSMutableDictionary *types = [NSMutableDictionary dictionary];
        FMResultSet *result = [_db executeQuery:[NSString stringWithFormat:@"PRAGMA table_info('%@')", _tableName]];
        while ([result next]) {
            
            NSString *name = [result stringForColumnIndex:1];
            [names addObject:name];
            types[name] = [result stringForColumnIndex:2];
        }
        
        // add implicit "rowid" field
        [names addObject:@"rowid"];
        
        [result close];
        
        if ([names count]) {
            
            _columnNames = [NSSet setWithArray:names];
            _columnTypes = [types copy];
        }
        
        // Get insert query string and keys
        NSMutableSet *mKeySet = [_columnNames mutableCopy];
        [mKeySet intersectSet:_propertyNames];
        _insertQueryKeys = [mKeySet allObjects];
        
        NSMutableArray *valueParams = [NSMutableArray array];
        for (NSString *key in _insertQueryKeys) {
            
            if ([_nsdatePropertyNames containsObject:key]) {
                // mapping to NSDate
                
                [valueParams addObject:[NSString stringWithFormat:@"datetime(:%@)", key]];
            }
            else{
                
                //standant mapping
                [valueParams addObject:[NSString stringWithFormat:@":%@", key]];
            }
            
        }
        
        _insertQueryString = [NSString stringWithFormat:@"insert%%@ into %@ (%@) values (%@)", _tableName, [_insertQueryKeys componentsJoinedByString:@", "], [valueParams componentsJoinedByString:@", "]];
    }

}

- (NSArray *)validKeysFromKeyFields:(NSArray *)keyFields andWhereString:(NSString *__autoreleasing *)whereString{
    
    NSMutableArray *keys = [NSMutableArray array];
    *whereString = @"";
    
    if ([keyFields count]) {
        
        NSMutableArray *keyStrings = [NSMutableArray array];
        for (NSString *field in keyFields) {
            
            if ([_columnNames containsObject:field]) {
                
                [keys addObject:field];
                [keyStrings addObject:[NSString stringWithFormat:@"%@ = :%@", field, field]];
            }
        }
        
        if ([keys count])
            *whereString = [NSString stringWithFormat:@" where %@",[keyStrings componentsJoinedByString:@" AND "]];
        
        else{
            
            *whereString = @"";
            // returns error
            return nil;
        }
        
    }
    
    return keys;
}


@end
