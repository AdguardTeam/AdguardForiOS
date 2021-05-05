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
#import "ADomain/ADomain.h"
#import "ActionRequestHandler.h"
#import "AESharedResources.h"
#import "ACLLogger.h"
#import "Adguard-Swift.h"
#import <AdGuardSDK/AdGuardSDK-Swift.h>

#define AE_BLOCKLIST_NAME       @"blockerList.json"

// minimum json file length. In some cases we get json containing "[]" or "[\t\n]". We must process it as empty file
#define MINIMUM_JSON_LENGTH     5

NSString const *AEFakeBlockinRule = @"[{\"trigger\": {\"url-filter\": \".*\",\"if-domain\": [\"domain.com\"]},\"action\":{\"type\": \"ignore-previous-rules\"}}]";

@interface ActionRequestHandler ()

@end

@implementation ActionRequestHandler

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    
    NSLog(@"ActionRequestHandler: beginRequestWithExtensionContext");
    
    @autoreleasepool {

        // Registering standart Defaults
        NSString *appPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"../../"];
        NSDictionary * defs = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleWithPath:appPath] pathForResource:@"defaults" ofType:@"plist"]];
        
        AESharedResources* resources = [AESharedResources new];
    
        id<SafariProtectionServiceProtocol> safariProtectionService = [[SafariProtectionService alloc] initWithResources: resources];
        
        if (defs){
            
            NSLog(@"ActionRequestHandler: default.plist loaded!");

            [[resources sharedDefaults] registerDefaults:defs];
        }
        //-------------------------------
        
        // Init Logger
        BOOL isDebugLogs = [resources.sharedDefaults boolForKey: AEDefaultsDebugLogs];
        DDLogInfo(@"Init ActionRequestHandler with loglevel %s", isDebugLogs ? "DEBUG" : "NORMAL");
        [[ACLLogger singleton] initLogger:[resources sharedAppLogsURL]];
        [[ACLLogger singleton] setLogLevel: isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel];
        
    #if DEBUG
        [[ACLLogger singleton] setLogLevel: ACLLDebugLevel];
    #endif

        BOOL filteringEnabled = [safariProtectionService safariProtectionEnabled];
        
        DDLogInfo(@"(ActionRequestHandler) start content blocker loading - %@. filteringEnabled = %@", NSBundle.mainBundle.bundleIdentifier, filteringEnabled ? @"TRUE" : @"FALSE");
        
        NSURL *jsonURL = [[ADLocations productDataDirectory] URLByAppendingPathComponent:AE_BLOCKLIST_NAME];
        SafariService* safariService = [[SafariService alloc] initWithMainAppBundleId: NSBundle.mainBundle.infoDictionary[@"HostAppBundleId"]];
        
        NSString* filename = [safariService filenameById: NSBundle.mainBundle.bundleIdentifier];
        NSString* path = [resources pathForRelativePath:filename];
        NSURL* fileUrl = [NSURL fileURLWithPath:path];
        
        if (jsonURL) {
            
            long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil][NSFileSize] longLongValue];
            
            DDLogInfo(@"(ActionRequestHandler) content blocker file size - %lld", fileSize);
            
            BOOL succedded = NO;
            
            if ( !(filteringEnabled && fileSize >= MINIMUM_JSON_LENGTH) ) {
                NSData* jsonData = [AEFakeBlockinRule dataUsingEncoding:NSUTF8StringEncoding];
                succedded = [jsonData writeToURL:jsonURL atomically:YES];
                DDLogInfo(@"(ActionRequestHandler) write fake rule with result: %@", succedded ? @"TRUE" : @"FALSE");
            }
            else {
                NSError* error;
                [[NSFileManager defaultManager] removeItemAtURL:jsonURL error:&error];
                succedded = [[NSFileManager defaultManager] copyItemAtURL:fileUrl toURL:jsonURL error:&error];
                DDLogInfo(@"(ActionRequestHandler) copy json with result: %@", succedded ? @"TRUE" : @"FALSE");
            }
            
            if (succedded) {
                
                NSItemProvider *attachment =
                    [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];

                NSArray* items = nil;
                
                if (attachment) {
                    DDLogInfo(@"ActionRequestHandler: Attachment is initialized!");
                    
                    NSExtensionItem *item = [[NSExtensionItem alloc] init];
                    item.attachments = @[ attachment ];

                    items = @[item];
                }
                
                [context completeRequestReturningItems:items
                                     completionHandler:nil];
                return;
            }
        }
        else {
            DDLogError(@"(ActionRequestHandler) error - can not create jsonURL");
        }
        
        DDLogError(@"(ActionRequestHandler) something wrong - return nil");
        [context completeRequestReturningItems:nil completionHandler:nil];
        return;
    }
}


@end
