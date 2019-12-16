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

#import "APPacketTunnelMigration.h"
#import "ACLLogger.h"

@implementation APPacketTunnelMigration

+ (NSDictionary<NSString*, NSArray<NSString*>* >*) migrateRulesIfNeeded: (id)rules{
 
    // in adgurd pro 2.0.0 - 2.0.2 we use NSArray of NSStrings as rulse collection
    // since 2.1.0 we use NSDictionary<NSString* sebscription uuid, NSArray* rules>
    
    if([rules isKindOfClass:NSDictionary.class]) {
        return rules;
    }
    
    if([rules isKindOfClass:NSArray.class]) {
        DDLogInfo(@"(PacketTunnelProvider) Migrate subscription rules");
        return @{@"MIGRATED_UUID": rules};
    }
    
    return nil;
}

+ (NSDictionary<NSString*, NSDictionary*> *) migrateHostsIfNeeded: (id)hosts{
    
    // in adgurd pro 2.0.0 - 2.0.2 we use NSDictionary<NSString host, NSString ip> as hosts collection
    // since 2.1.0 we use NSDictionary<NSString* sebscription uuid, NSDictionary* hosts>
    
    if([hosts isKindOfClass:NSDictionary.class]) {
        __block BOOL oldFormat = NO;
        [(NSDictionary*)hosts enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            *stop = YES;
            oldFormat = [key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class];
        }];
        
        if(oldFormat) {
            DDLogInfo(@"(PacketTunnelProvider) Migrate subscription hosts");
            return @{@"MIGRATED_UUID": hosts};
        }
        else {
            return hosts;
        }
    }
    
    return nil;
}

@end
