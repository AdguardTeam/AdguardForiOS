#import <Foundation/Foundation.h>
#import <SharedAdGuardSDK/SharedAdGuardSDK.h>

/*
 * Objective-C Macro wrappers for our SwiftyBeaver logger
 */


#define ObjcLogInfo(logger, fmt, ...) \
[logger info: [NSString stringWithFormat: fmt, ##__VA_ARGS__] \
: [NSString stringWithFormat:@"%s", __FILE__] \
: [NSString stringWithFormat:@"%s", __FUNCTION__] \
line: [NSString stringWithFormat:@"%d", __LINE__] \
customLabel:nil];

#define ObjcLogWarn(logger, fmt, ...) \
[logger warn: [NSString stringWithFormat: fmt, ##__VA_ARGS__] \
: [NSString stringWithFormat:@"%s", __FILE__] \
: [NSString stringWithFormat:@"%s", __FUNCTION__] \
line: [NSString stringWithFormat:@"%d", __LINE__] \
customLabel:nil];

#define ObjcLogError(logger, fmt, ...) \
[logger error: [NSString stringWithFormat: fmt, ##__VA_ARGS__] \
: [NSString stringWithFormat:@"%s", __FILE__] \
: [NSString stringWithFormat:@"%s", __FUNCTION__] \
line: [NSString stringWithFormat:@"%d", __LINE__] \
customLabel:nil];

#define ObjcLogDebug(logger, fmt, ...) \
[logger debug: [NSString stringWithFormat: fmt, ##__VA_ARGS__] \
: [NSString stringWithFormat:@"%s", __FILE__] \
: [NSString stringWithFormat:@"%s", __FUNCTION__] \
line: [NSString stringWithFormat:@"%d", __LINE__] \
customLabel:nil];

