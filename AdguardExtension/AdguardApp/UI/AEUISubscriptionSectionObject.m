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
#import "AEUISubscriptionSectionObject.h"
#import "ACommons/ACLang.h"
#import "AESAntibanner.h"
#import "AEService.h"
//#import "<#header#>"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUISubscriptionSectionFilterMetadata
/////////////////////////////////////////////////////////////////////

@implementation AEUISubscriptionSectionFilterMetadata

+ (AEUISubscriptionSectionFilterMetadata *)copyFromMetadata:(ASDFilterMetadata *)filterMetadata{
    
    AEUISubscriptionSectionFilterMetadata *obj = [AEUISubscriptionSectionFilterMetadata new];
    
    NSDictionary *dict = [filterMetadata dictionaryWithValuesForKeys:@[
                                                                       @"filterId",
                                                                       @"updateDate",
                                                                       @"updateDateString",
                                                                       @"checkDate",
                                                                       @"checkDateString",
                                                                       @"version",
                                                                       @"enabled",
                                                                       @"editable",
                                                                       @"removable",
                                                                       @"displayNumber",
                                                                       @"groupId",
                                                                       @"name",
                                                                       @"descr",
                                                                       @"homepage",
                                                                       @"expires",
                                                                       @"subscriptionUrl",
                                                                       @"rulesCount",
                                                                       @"langs",
                                                                       @"localizations"
                                                                       
]];
   
    if (dict) {
        [obj setValuesForKeysWithDictionary:dict];
    }
    
    obj.editedEnabled = nil;
    
    return obj;
}

@end

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUISubscriptionSectionObject
/////////////////////////////////////////////////////////////////////

@implementation AEUISubscriptionSectionObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

+ (NSMutableArray *)obtainSectionsObjectsFromMetadatas:(NSArray *)metadatas groups:(NSArray *)groups{
    
    @autoreleasepool {
        
        if (!(metadatas.count && groups.count)) {
            
            return nil;
        }
        
        // sorting groups
        groups = [groups sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            ASDFilterGroup *group1 = obj1, *group2 = obj2;
            
            // by display number
            NSComparisonResult result = [group1.displayNumber compare:group2.displayNumber];
            
            if (result == NSOrderedSame) {
                
                // by name
                result = [group1.name compare:group2.name options:NSNumericSearch];
            }
            
            return result;
        }];
        
        NSMutableDictionary *groupSortingIndexes = [NSMutableDictionary dictionaryWithCapacity:groups.count];
        NSUInteger counter = 0;
        for (NSNumber *item in [groups valueForKey:@"groupId"]) {
            
            groupSortingIndexes[item] = @(counter++);
        }

        // sorting filters
        metadatas = [metadatas sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            ASDFilterMetadata *meta1 = obj1, *meta2 = obj2;
            
            //by group
            
            NSNumber *groupSortingIndex1 = groupSortingIndexes[meta1.groupId];
            NSNumber *groupSortingIndex2 = groupSortingIndexes[meta2.groupId];
            if (!(groupSortingIndex1 && groupSortingIndex2)) {
                
                groupSortingIndex2 = groupSortingIndex1 = @(0);
                DDLogError(@"Inconsistant metadata: Filter group id do not found in groups metadata.");
                DDLogErrorTrace();
            }
            NSComparisonResult result = [groupSortingIndex1 compare:groupSortingIndex2];
            if (result == NSOrderedSame)
                // by display number
                result = [meta1.displayNumber compare:meta2.displayNumber];
            
            return result;
        }];
        
        //generate objects for filters table
        AEUISubscriptionSectionObject *object;
        NSMutableArray *convertedMetas = [NSMutableArray arrayWithCapacity:metadatas.count];
        NSMutableArray *filters;
        NSNumber *groupId;
        ASDFilterGroup *group;
        NSNumber *index;
        
        for (ASDFilterMetadata *item in metadatas){
            
            if (![groupId isEqual:item.groupId]){
                
                // end previos
                if (object && filters) {
                    object.filters = [filters copy];
                    [convertedMetas addObject:object];
                    filters = nil;
                }
                
                // begin next
                object = [AEUISubscriptionSectionObject new];
                groupId = item.groupId;
                index = groupSortingIndexes[groupId];
                if (index) {
                    
                    group = groups[[index unsignedIntegerValue]];
                    object.name = group.localization.name;
                    if (!object.name) {
                        object.name = [NSString new];
                    }
                    
                    filters = [NSMutableArray array];
                }
            }

            [filters addObject:[AEUISubscriptionSectionFilterMetadata copyFromMetadata:item]];
        }

        // end last
        if (object && filters) {
            object.filters = [filters copy];
            [convertedMetas addObject:object];
            filters = nil;
        }
        
        return [convertedMetas copy];
    }
    
}

+ (void)load:(BOOL)refresh completionBlock:(void (^)(NSArray *subscriptionSectionObjects))completionBlock {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          @autoreleasepool {

              NSMutableArray *filters = [[[[AEService singleton] antibanner]
                  filtersForSubscribe:refresh] mutableCopy];
              NSArray *installedFilters =
                  [[[AEService singleton] antibanner] filters];
              ASDFilterMetadata *meta;
              for (ASDFilterMetadata *item in installedFilters) {
                  NSUInteger index = [filters indexOfObject:item];
                  if (index != NSNotFound) {
                      meta = filters[index];
                      NSDictionary *values = [item dictionaryWithValuesForKeys:@[
                          @"updateDate",
                          @"updateDateString",
                          @"checkDate",
                          @"checkDateString",
                          @"version",
                          @"enabled",
                          @"rulesCount"
                      ]];
                      [meta setValuesForKeysWithDictionary:values];
                  } else if ([item.filterId unsignedIntegerValue] !=
                             ASDF_USER_FILTER_ID) {
                      [filters addObject:item];
                  }
              }
              NSArray *disabledFilters = [filters
                  filteredArrayUsingPredicate:
                      [NSPredicate
                          predicateWithFormat:@"NOT (filterId IN %@)",
                                              [installedFilters
                                                  valueForKey:@"filterId"]]];
              [disabledFilters setValue:@(0) forKey:@"enabled"];

              [UIApplication sharedApplication]
                  .networkActivityIndicatorVisible = NO;
              NSArray *loadedFilters = [AEUISubscriptionSectionObject
                  obtainSectionsObjectsFromMetadatas:
                      filters groups:[[[AEService singleton] antibanner]
                                         groupsForSubscribe:YES]];

              dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(loadedFilters);
              });
          }
        });
}

@end
