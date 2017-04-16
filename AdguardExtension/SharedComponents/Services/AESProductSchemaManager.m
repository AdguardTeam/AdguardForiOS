/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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


#import "AESProductSchemaManager.h"
#import "ACommons/ACLang.h"
#import "AESharedResources.h"

#define SCHEMA_VERSION                      @(1)


/////////////////////////////////////////////////////////////////////
#pragma mark - AESProductSchemaManager

@implementation AESProductSchemaManager

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

+ (void)upgrade {
    
    NSNumber *currentSchemaVersion = [[AESharedResources sharedDefaults] objectForKey:AEDefaultsProductSchemaVersion];
 
    if (! [currentSchemaVersion isEqual:SCHEMA_VERSION]) {
        
        DDLogInfo(@"(AESProductSchemaManager) Upgrade will be started. Current schema version: %@, we need: %@.", currentSchemaVersion, SCHEMA_VERSION);
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            if ([self onUpgradeFrom:currentSchemaVersion to:SCHEMA_VERSION]) {
                
                [[AESharedResources sharedDefaults] setObject:SCHEMA_VERSION forKey:AEDefaultsProductSchemaVersion];
            }
            else {
                
                DDLogError(@"(AESProductSchemaManager) Product schema could not upgraded.");
            }
        });
    }
}

+ (void)install {
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        if ([self onInstall]) {
            
            [[AESharedResources sharedDefaults] setObject:SCHEMA_VERSION forKey:AEDefaultsProductSchemaVersion];
        }
    });
}

/////////////////////////////////////////////////////////////////////
#pragma mark Main Methods (private)

+ (BOOL)onUpgradeFrom:(NSNumber *)from to:(NSNumber *)to {
    
    return YES;
}

+ (BOOL)onInstall {
    
    return YES;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (private)


@end
