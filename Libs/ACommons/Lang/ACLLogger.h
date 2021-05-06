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
#import "Logger/Lumberjack/DDLogMacros.h"
#import "Logger/Lumberjack/DDFileLogger.h"
#import "Logger/Lumberjack/DDTTYLogger.h"
#import "Logger/Lumberjack/DDOSLogger.h"

//Max log file size
#define ACL_MAX_LOG_FILE_SIZE     512000

// Set this log level for application.
typedef enum{
    
    ACLLDefaultLevel = DDLogLevelInfo,
    ACLLDebugLevel = DDLogLevelDebug,
    ACLLVerboseLevel = DDLogLevelVerbose
    
} ACLLogLevelType;

//---------------------------------------------------

#undef LOG_ASYNC_ENABLED
#define LOG_ASYNC_ENABLED false

#define DDLogTrace() LOG_OBJC_MAYBE(LOG_ASYNC_VERBOSE, ddLogLevel, DDLogFlagVerbose, 0, @"%@[%p]: %@", THIS_FILE, self, THIS_METHOD)

#define DDLogVerboseTrace(fmt, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagVerbose,   0, nil, __PRETTY_FUNCTION__, @"(%@[%p]: %@) " fmt, THIS_FILE, self, THIS_METHOD,  ##__VA_ARGS__)

#define DDLogDebugTrace()   LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, @"%@[%p]: %@", THIS_FILE, self, THIS_METHOD)

#define DDLogErrorTrace()   LOG_MAYBE(LOG_ASYNC_ENABLED, ddLogLevel, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, @"Error trace - %@[%p]: %@", THIS_FILE, self, THIS_METHOD)

extern int ddLogLevel;

@class ACLFileLogger;

/**
    Global logger class, which have one singleton object.
 */
@interface ACLLogger : NSObject{
    
    BOOL _initialized;
}

+ (ACLLogger *)singleton;

/////////////////////////////////////////////////////////////////////
#pragma mark Only iOS code here
/////////////////////////////////////////////////////////////////////
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

/**
 Initializing of logger.
 This method must be called before writing to log file.

 @param folderURL URL of the directory where logger will be write logs.
 If nil then will be used default value, that is name of process.
 */
- (void)initLogger:(NSURL *)folderURL;

/////////////////////////////////////////////////////////////////////
#pragma mark Only OS X code here
/////////////////////////////////////////////////////////////////////
#elif TARGET_OS_MAC

/**
 Initializing of logger.
 This method must be called before writing to log file.
 
 @param appName Directory name where logger will be write logs.
 If nil then will be used default value, that is name of process.
 */
- (void)initLogger:(NSString *)appName;

/////////////////////////////////////////////////////////////////////
#pragma mark Common code here
/////////////////////////////////////////////////////////////////////
#endif

/// Access to file logger. It need for extracting info from log files.
@property (readonly) ACLFileLogger *fileLogger;

/// Log level of the application.
@property ACLLogLevelType logLevel;

/// Flush all logs.
- (void)flush;

@end
