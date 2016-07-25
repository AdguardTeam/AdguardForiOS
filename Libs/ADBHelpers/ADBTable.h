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
#import "FMDB.h"

@class ADBTableRow;

@interface ADBTable : NSObject{
    
    Class _objectClass;
    NSSet *_propertyNames;
    NSSet *_nsdatePropertyNames;
    NSSet *_plistPropertyNames;

    FMDatabase * __weak  _db;
    NSString *_tableName;
    NSSet *_columnNames;
    NSDictionary *_columnTypes;
    
    // Cached values for insert request
    NSString *_insertQueryString;
    NSArray *_insertQueryKeys;

    NSArray *_updateKeyFields;
    NSArray *_updateFields;
    NSString *_updateQueryString;
    NSArray *_updateWhereKeys;
    NSArray *_updateValidFields;
    
}

- (id)initWithRowClass:(Class)theClass db:(FMDatabase *)db;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (NSArray *)selectWithKeys:(NSArray *)keyFields inRowObject:(id)row;
- (NSArray *)selectWithKeys:(NSArray *)keyFields inRowObject:(id)row fromDb:(FMDatabase *)db;

- (BOOL)deleteWithKeys:(NSArray *)keyFields inRowObject:(id)row;
- (BOOL)deleteWithKeys:(NSArray *)keyFields inRowObject:(id)row fromDb:(FMDatabase *)db;

- (BOOL)insertOrReplace:(BOOL)orReplace fromRowObject:(id)row;
- (BOOL)insertOrReplace:(BOOL)orReplace fromRowObject:(id)row toDb:(FMDatabase *)db;

- (BOOL)updateWithKeys:(NSArray *)keyFields fromRowObject:(id)keyRow updateFields:(NSArray *)updateFields fromRowObject:(id)valueRow;
- (BOOL)updateWithKeys:(NSArray *)keyFields fromRowObject:(id)keyRow updateFields:(NSArray *)updateFields fromRowObject:(id)valueRow inDb:(FMDatabase *)db;

@end
