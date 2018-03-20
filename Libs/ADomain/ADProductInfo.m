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
#import "ADProductInfo.h"
#import "ACommons/ACLang.h"
#import "ADLocations.h"
#import "vendors/fmdb/FMDatabase.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

#import <UIKit/UIKit.h>
#endif

#define DEFAULT_PRODUCT_VERSION                 @"1.0"
#define DEFAULT_PRODUCT_NAME                    @"Adguard"

#define INFO_KEY_APPID                          @"applicationId"

/////////////////////////////////////////////////////////////////////
#pragma mark - ADProductInfo
/////////////////////////////////////////////////////////////////////

@implementation ADProductInfo

static NSString *mVersion;
static NSString *_buildVersion;
static NSString *mName;
static NSString *userAgentString;
static NSDictionary *persistentProductInfo;

/// Returns Product Version
+ (NSString *)version{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *version = [[NSBundle bundleForClass:[ADProductInfo class]] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if (!version)
            version = [self buildNumber];
        
        mVersion = version ? version : DEFAULT_PRODUCT_VERSION;
    });
    
    return mVersion;
}

+ (NSString *)versionWithBuildNumber {
    NSString *build = [self buildNumber];
    
    if(build)
        return [NSString stringWithFormat:@"%@(%@)", [self version], build];
    else
        return [self version];
}

/// Returns Product Version With Build Number
+ (NSString *)buildVersion{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *version = [[NSBundle bundleForClass:[ADProductInfo class]] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSString *build = [self buildNumber];
#ifdef DEBUG
        build = [build stringByAppendingString:@".DEBUG"];
#endif
        if (version && build)
            version = [NSString stringWithFormat:@"%@.%@", version, build];
        
        else if (build)
            version = build;
        
        _buildVersion = version ? version : DEFAULT_PRODUCT_VERSION;
    });
    
    return _buildVersion;
}

+ (NSString *)buildNumber {
    return [[NSBundle bundleForClass:[ADProductInfo class]] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

/// Returns Localized Product Name
+ (NSString *)name{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *name = [[NSBundle bundleForClass:[ADProductInfo class]] objectForInfoDictionaryKey:@"CFBundleName"];
        
        mName = name ? name : DEFAULT_PRODUCT_NAME;
    });
    
    return mName;
}


+ (NSString *)applicationID{

    [ADProductInfo prepareProductInfo];
    
    return persistentProductInfo[INFO_KEY_APPID];
}

+ (NSString *)userAgentString{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
        
        NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
        
        userAgentString = [NSString stringWithFormat:@"%@/%@ (%@; %@ %ld_%ld_%ld)",
                           DEFAULT_PRODUCT_NAME, [ADProductInfo version], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemName], (long)version.majorVersion, (long)version.minorVersion, (long)version.patchVersion];
        
#elif TARGET_OS_MAC
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        SInt32 major, minor, bugfix;
        Gestalt(gestaltSystemVersionMajor, &major);
        Gestalt(gestaltSystemVersionMinor, &minor);
        Gestalt(gestaltSystemVersionBugFix, &bugfix);
#pragma clang diagnostic pop
        
        userAgentString = [NSString stringWithFormat:@"%@/%@ (Macintosh; Intel Mac OS X %d_%d_%d)",
                           DEFAULT_PRODUCT_NAME, [ADProductInfo version], major, minor, bugfix];
        
#endif

    });
    
    return userAgentString;
    
}

/////////////////////////////////////////////////////////////////////
#pragma mark  Private Methods
/////////////////////////////////////////////////////////////////////

+ (void)prepareProductInfo {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

      @autoreleasepool {

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS
          
          // Creating product info
          NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
          persistentProductInfo =
          @{INFO_KEY_APPID : [uuid UUIDString]};
          
#elif TARGET_OS_MAC
          
          // Creating product info
          persistentProductInfo =
          @{INFO_KEY_APPID : DEFAULT_PRODUCT_NAME};
          
#endif
      }
    });
}

@end
