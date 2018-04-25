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
#import "ADLocations.h"
#import "ACommons/ACLang.h"

NSString *ADLDefaultApplicationBundleIdentifier = @"com.adguard";


#define LOCATIONS_SYSTEM_LEVEL  NSLocalDomainMask
#define LOCATIONS_USER_LEVEL    NSUserDomainMask

/// where is saved settings and application data
#define LOCATION_LEVEL          LOCATIONS_USER_LEVEL


@implementation ADLocations

static NSRecursiveLock *_lock;

static NSURL *_programDataDirectory;
static NSURL *_sharedProgramDataDirectory;
//static NSURL *_nfapiConfigurationDirectory;
//static NSURL *_appIconsCacheDirectory;
//static NSURL *_rootUtilsDirectory;

+ (void)initialize{
    
    if (self == [ADLocations class]) {
        
        _lock = [NSRecursiveLock new];
        _lock.name = @"ADLocations";
    }
}

/// Returns NSURL of application data directory (creates it if it does not exist)
+ (NSURL *)productDataDirectory {

    if (!_programDataDirectory) {

        [_lock lock];
        if (!_programDataDirectory) {
            _programDataDirectory = [ADLocations
                productDataDirectoryForDomain:LOCATIONS_USER_LEVEL];
        }
        [_lock unlock];
    }

    return _programDataDirectory;
}


/////////////////////////////////////////////////////////////////////////
#pragma mark Helper methods (Private)
/////////////////////////////////////////////////////////////////////////


+ (NSURL *)productDataDirectoryForDomain:(NSSearchPathDomainMask)domain{
    
    @autoreleasepool {
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *err;
        NSURL *url = [fm URLForDirectory:NSApplicationSupportDirectory inDomain:domain appropriateForURL:nil create:YES error:&err];
        
        if (err) {
            
            DDLogError(@"Cannot create application data directory: %@", [err localizedDescription]);
            [[NSException exceptionWithName:NSGenericException reason:@"Cannot create application data directory" userInfo:nil] raise];
        }
        NSString *ident = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
        
        if (!ident) {
            
            ident = ADLDefaultApplicationBundleIdentifier;
        }
        
        url = [url URLByAppendingPathComponent:ident isDirectory:YES];
        if (![fm createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&err]){
            
            url = nil;
            DDLogError(@"Cannot create application data directory: %@", [err localizedDescription]);
        }
        
        return url;
    }
}

@end
