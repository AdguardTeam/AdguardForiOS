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
#import "Adguard-Swift.h"

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
        
        if (defs){
            
            NSLog(@"ActionRequestHandler: default.plist loaded!");

            [[resources sharedDefaults] registerDefaults:defs];
        }
        //-------------------------------
        
        BOOL filteringEnabled = [[resources sharedDefaults] boolForKey:AEDefaultsAdguardEnabled];
        
        NSURL *jsonURL = [[ADLocations productDataDirectory] URLByAppendingPathComponent:AE_BLOCKLIST_NAME];
        SafariService* safariService = [[SafariService alloc] initWithResources:resources];
        NSString* filename = [safariService filenameById: NSBundle.mainBundle.bundleIdentifier];
        
        if (jsonURL) {
            
            NSLog(@"ActionRequestHandler: JSON URL \"%@\"", jsonURL);
            
            NSData *jsonData;
            if (filteringEnabled) {
                jsonData = [resources loadDataFromFileRelativePath:filename];
            }
            
            if ( !(filteringEnabled && jsonData.length >= MINIMUM_JSON_LENGTH) ) {
                jsonData = [AEFakeBlockinRule dataUsingEncoding:NSUTF8StringEncoding];
            }
            
            if ([jsonData writeToURL:jsonURL atomically:YES]) {
                
                NSLog(@"ActionRequestHandler: JSON saved with length in bytes: %lu", jsonData.length);
                
                NSItemProvider *attachment =
                    [[NSItemProvider alloc] initWithContentsOfURL:jsonURL];

                NSArray* items = nil;
                
                if (attachment) {
                    NSLog(@"ActionRequestHandler: Attachment initialized!");
                    
                    NSExtensionItem *item = [[NSExtensionItem alloc] init];
                    item.attachments = @[ attachment ];

                    items = @[item];
                }

                
                [context completeRequestReturningItems:items
                                     completionHandler:nil];
                return;
            }
        }
        
        [context completeRequestReturningItems:nil completionHandler:nil];
        return;
    }
}


@end
