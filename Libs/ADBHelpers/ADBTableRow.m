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

#import <objc/runtime.h>
#import "FMResultSet.h"
#import "ADBTableRow.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - ADBTableRow
/////////////////////////////////////////////////////////////////////

@implementation ADBTableRow

static NSMutableDictionary *_propertyNamesForClasses;
static NSMutableDictionary *_nsdatePropertyNamesForClasses;
static NSMutableDictionary *_plistPropertyNamesForClasses;

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+(void)initialize{
 
    [super initialize];
    @autoreleasepool {
        
        // obtainning typies of object properties
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList( self, &count );
        
        NSMutableArray *dateNames = [NSMutableArray array];
        NSMutableArray *plistNames = [NSMutableArray array];
        NSMutableArray *pNames = [NSMutableArray array];
        NSString *propertyName;
        char *propertyType;
        NSString *pType;
        for (NSUInteger i = 0; i <count; i++) {
            
            propertyType = property_copyAttributeValue(properties[i], "T");
            propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
            pType = [NSString stringWithUTF8String:propertyType];
            if ([pType hasPrefix:@"@\""])
                pType = [pType substringWithRange:NSMakeRange(2, pType.length - 3)];

            [pNames addObject:propertyName];
            if ([pType isEqualToString:@"NSDate"]) {
                
                [dateNames addObject:propertyName];
            }
            else if (
                     [pType containsAny:@[@"NSDictionary",@"NSMutableDictionary",@"NSArray",@"NSMutableArray"]]
                     || (! [pType hasPrefix:@"NS"] && [NSClassFromString(pType) conformsToProtocol:@protocol(NSCoding)])
                     ){
                
                [plistNames addObject:propertyName];
            }
            
            free(propertyType);
            
        }
        
        if (pNames.count) {
            
            if (!_propertyNamesForClasses)
                _propertyNamesForClasses = [NSMutableDictionary dictionary];

            [self setPropertiesCacheDictionary:_propertyNamesForClasses withArray:pNames];
        }
        if (dateNames.count) {
            
            if (!_nsdatePropertyNamesForClasses)
                _nsdatePropertyNamesForClasses = [NSMutableDictionary dictionary];
            
            [self setPropertiesCacheDictionary:_nsdatePropertyNamesForClasses withArray:dateNames];
        }
        if (plistNames.count) {
            
            if (!_plistPropertyNamesForClasses)
                _plistPropertyNamesForClasses = [NSMutableDictionary dictionary];
            
            [self setPropertiesCacheDictionary:_plistPropertyNamesForClasses withArray:plistNames];
        }

        if ( properties != NULL )
            free( properties );
    }
    
}

+ (NSString *)tableName{
    
    if ([self class] == [ADBTableRow class]) {
        return nil;
    }
    
    return NSStringFromClass([self class]);
}

+ (NSSet *)propertyNames{
    
    return _propertyNamesForClasses[NSStringFromClass([self class])];
}

+ (NSSet *)nsdatePropertyNames{
    
    return _nsdatePropertyNamesForClasses[NSStringFromClass([self class])];
}

+ (NSSet *)plistPropertyNames{
    
    return _plistPropertyNamesForClasses[NSStringFromClass([self class])];
}


- (id)initWithDbResult:(FMResultSet *)dbResult{
 
    self = [self init];
    if (self) {
        
        if (dbResult) {
            
            NSDictionary *result = [dbResult resultDictionary];
            NSSet *nsdateP = [[self class] nsdatePropertyNames];
            NSSet *plistP = [[self class] plistPropertyNames];
            [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                // sets nil value
                if (!obj || obj == [NSNull null]) {
                    
                    [self setValue:nil forKey:key];
                    return;
                }
                
                if ([nsdateP containsObject:key]) {
                    // mapping to NSDate
                    
                    [self setValue:[NSDate dateWithSQliteString:obj] forKey:key];
                }
                else if ([plistP containsObject:key]){
                    // mapping to complex object
                    
                    id plist;
                    if ([obj isKindOfClass:[NSData class]]) {

                        plist = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                    }
                    else if ([obj isKindOfClass:[NSString class]]){
                        
                        plist = [NSKeyedUnarchiver unarchiveObjectWithData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                    
                    [self setValue:plist forKey:key];
                }
                else{
                    
                    //standant mapping
                    [self setValue:obj forKey:key];
                }
            }];
            
        }
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods
/////////////////////////////////////////////////////////////////////
+ (void)setPropertiesCacheDictionary:(NSMutableDictionary *)dict withArray:(NSArray *)pNames{
  
    @autoreleasepool {

        NSString *className = NSStringFromClass(self);
        NSMutableSet *propertyNames = dict[className];
        
        if (!propertyNames) {
            propertyNames = [NSMutableSet set];
            dict[className] = propertyNames;
        }
        
        [propertyNames addObjectsFromArray:pNames];
        
        // add properties from super classes
        Class superClass = self;
        NSSet *pSet;
        while ([(superClass = [superClass superclass]) isSubclassOfClass:[ACObject class]]) {
            
            className = NSStringFromClass(superClass);
            pSet = dict[className];
            if (pSet)
                [propertyNames unionSet:pSet];
        }
    }
}

@end
