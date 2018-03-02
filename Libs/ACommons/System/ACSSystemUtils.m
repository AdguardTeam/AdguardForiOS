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
#import "ACSSystemUtils.h"
#import "NSException+Utils.h"
#import <stdlib.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - ACSSystemUtils
/////////////////////////////////////////////////////////////////////

@implementation ACSSystemUtils

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
#pragma mark Only iOS code here
/////////////////////////////////////////////////////////////////////
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_IOS

+ (void)showSimpleAlertForController:(UIViewController *)controller withTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK Button caption in alerts") style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              [controller dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Only OS X code here
/////////////////////////////////////////////////////////////////////
#elif TARGET_OS_MAC

+ (BOOL)rootPrivileges{
    
    return !(geteuid());
}

+ (int)cliUtil:(NSString *)utilPath arguments:(NSArray *)arguments outputData:(NSData **)outputData{
    
    NSData *data;
    int result = 0;

    @autoreleasepool {
        
        if (!utilPath) {
            [[NSException argumentException:@"utilPath"] raise];
        }
        if (!arguments) {
            arguments = @[];
        }
        
        NSTask *task = [[NSTask alloc] init];
        
        task.launchPath = utilPath;
        task.arguments = arguments;
        
        
        NSPipe *pipe;
        
        if (outputData) {
            pipe = [NSPipe pipe];
            task.standardOutput = pipe;
            task.standardError = pipe;
        }
        
        [task launch];
        
        if (outputData) {
            data = [[pipe fileHandleForReading] readDataToEndOfFile];
        }
        
        [task waitUntilExit];
        
        result = task.terminationStatus;
    }
    
    if (outputData) {
        
        *outputData = data;
    }
    
    return result;
}

+ (int)cliUtil:(NSString *)utilPath arguments:(NSArray *)arguments output:(NSString **)output{
    
    NSString *outputString;
    int result = 0;
    NSData *data;
    
    if (output) {
        
        result = [ACSSystemUtils cliUtil:utilPath arguments:arguments outputData:&data];
    }
    else {
        
        result = [ACSSystemUtils cliUtil:utilPath arguments:arguments outputData:NULL];
    }
    
    
    if (output) {
        outputString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!outputString){
            outputString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
        }
        
        *output = outputString;
    }
    
    return result;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Common code here
/////////////////////////////////////////////////////////////////////
#endif

+ (NSString *)createUUID{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef cfString = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    NSString *result = [(__bridge NSString *)cfString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    CFRelease(cfString);
    
    return result;
}

+ (void)callOnMainQueue:(dispatch_block_t)block{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
#pragma clang diagnostic pop
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    if (currentQueue == mainQueue) {
        block();
    }
    else{
        dispatch_sync(mainQueue, block);
    }
    
}

@end
