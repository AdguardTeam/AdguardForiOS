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
#import "ACLLogger.h"
#import "ACLFileLogger.h"

int ddLogLevel = LOG_LEVEL_VERBOSE;

@interface ACLoggerFormatter : DDLogFileFormatterDefault
@end

@implementation ACLoggerFormatter


- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    NSString *dateAndTime = [dateFormatter stringFromDate:(logMessage->timestamp)];
    
    NSString* thread = logMessage->queueLabel ?  [NSString stringWithFormat:@"[%u(%s)]", logMessage->machThreadID, logMessage->queueLabel] :
                                                        [NSString stringWithFormat:@"[%u]", logMessage->machThreadID];
    return [NSString stringWithFormat:@"%@ %@  %@", dateAndTime, thread, logMessage->logMsg];
}

@end

@implementation ACLLogger

static ACLLogger *singletonLogger;

- (id)init{
    
    if (self != singletonLogger)
        return nil;
        
    self = [super init];
    if (self)
    {
        _initialized = NO;
        ddLogLevel = ACLLDefaultLevel;
    }
    
    return self;

}


+ (ACLLogger *)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singletonLogger = [ACLLogger alloc];
        singletonLogger = [singletonLogger init];
    });
    
    return singletonLogger;
    
}
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

- (void)initLogger:(NSURL *)folderURL{
    
    if (!_initialized) {
        
        DDLogFileManagerDefault *defaultLogFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[folderURL path]];
        
        _fileLogger = [[ACLFileLogger alloc] initWithLogFileManager:defaultLogFileManager];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        _fileLogger.maximumFileSize = ACL_MAX_LOG_FILE_SIZE;
        _fileLogger.logFormatter = [ACLoggerFormatter new];
        
        [DDLog addLogger:_fileLogger];
#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
#endif
        
        _initialized = YES;
    }
}

#elif TARGET_OS_MAC

- (void)initLogger:(NSString *)appName{
    
    if (!_initialized) {
        
        // Determines logs directory.
        NSString *logsDirectory;
        if (appName) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
            logsDirectory = [[basePath stringByAppendingPathComponent:@"Logs"] stringByAppendingPathComponent:appName];
        }
        
        //
        DDLogFileManagerDefault *defaultLogFileManager = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:logsDirectory];
        
        _fileLogger = [[ACLFileLogger alloc] initWithLogFileManager:defaultLogFileManager];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        _fileLogger.maximumFileSize = ACL_MAX_LOG_FILE_SIZE;
        
        [DDLog addLogger:_fileLogger];
#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
#endif
        
        _initialized = YES;
    }
}
/// Initializing of logger.
#endif

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////

- (void)setLogLevel:(ACLLogLevelType)logLevel{
    
    [self willChangeValueForKey:@"logLevel"];
    [self.fileLogger rollLogFileWithCompletionBlock:^{
        ddLogLevel = logLevel;
        [self didChangeValueForKey:@"logLevel"];
    }];
}

- (ACLLogLevelType)logLevel{
    
    switch (ddLogLevel) {
        case ACLLDefaultLevel:
            return ACLLDefaultLevel;
            break;
            
        case ACLLDebugLevel:
            return ACLLDebugLevel;
            break;
            
        default:
            return ACLLDefaultLevel;
            break;
    }
}

- (void)flush{
    
    [DDLog flushLog];
}

@end
