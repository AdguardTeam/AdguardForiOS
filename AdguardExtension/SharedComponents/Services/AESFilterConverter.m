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
#import "AESFilterConverter.h"
#import "ACommons/ACLang.h"
#import "ASDModels/ASDFilterObjects.h"

NSString *AESFConvertedCountKey = @"convertedCount";
NSString *AESFConvertedRulesKey = @"converted";
NSString *AESFCOverLimitKey = @"overLimit";
NSString *AESFConvertedErrorKey = @"AESFConvertedErrorKey";

NSString *AESFConverterError = @"AESFConverterError";

#define JS_CONVERTER_FILE       @"JSConverter.js"
#define JS_CONVERTER_FUNC       @"jsonFromFilters"

/////////////////////////////////////////////////////////////////////
#pragma mark - AESFiltersConverter
/////////////////////////////////////////////////////////////////////

@interface AESFilterConverter (){
    
    JSContext *_context;
    JSValue *_converterFunc;
}

@end

@implementation AESFilterConverter

/////////////////////////////////////////////////////////////////////
#pragma mark Init
/////////////////////////////////////////////////////////////////////


- (AESFilterConverter *)init{
    
    self = [super init];
    if (self) {
        
        _context = [[JSContext alloc] init]; //WithVirtualMachine:[JSVirtualMachine new]];
        if (!_context) {
            DDLogError(@"(AESFilterConverter) Can't init JSContext.");
            return nil;
        }
        
        NSString *script;
        NSURL *url = [[[NSBundle bundleForClass:[self class]] resourceURL] URLByAppendingPathComponent:JS_CONVERTER_FILE];
        if (url) {
            script = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        }
        if (!script) {
            DDLogError(@"(AESFilterConverter) Can't load javascript file: %@", url);
            return nil;
        }
        
        [_context evaluateScript:@"var console = {}"];
        _context[@"console"][@"log"] = ^(NSString *message) {
            DDLogDebug(@"Javascript: %@",message);
        };
        _context[@"console"][@"warn"] = ^(NSString *message) {
            DDLogWarn(@"Javascript Warn: %@",message);
        };
        _context[@"console"][@"info"] = ^(NSString *message) {
            DDLogInfo(@"Javascript Info: %@",message);
        };
        _context[@"console"][@"error"] = ^(NSString *message) {
            DDLogError(@"Javascript Error: %@",message);
        };

        [_context evaluateScript:script];
        _converterFunc = _context[JS_CONVERTER_FUNC];
        if (!_converterFunc || [_converterFunc isUndefined]) {
            DDLogError(@"(AESFilterConverter) Can't obtain converter function object: %@", JS_CONVERTER_FUNC);
            return nil;
        }
    }
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and Public methods
/////////////////////////////////////////////////////////////////////

- (NSDictionary *)jsonFromRules:(NSArray *)rules upTo:(NSUInteger)limit optimize:(BOOL)optimize {

    if (!(rules.count && limit)) {
        return nil;
    }

    @autoreleasepool {
        NSMutableArray *_rules = [NSMutableArray arrayWithCapacity:rules.count];
        NSMutableSet *ruleTextSet = [NSMutableSet set];
        for (ASDFilterRule *rule in rules) {
            // This should delete duplicates.
            if (![ruleTextSet containsObject:rule.ruleText]) {

                [ruleTextSet addObject:rule.ruleText];
                //--------------
                [_rules addObject:rule.ruleText];
            }
        }

        JSValue *result = [_converterFunc callWithArguments:@[ _rules, @(limit), @(optimize)]];

        NSDictionary *dictResult = [result toDictionary];
        return [self checkResultDictionary:dictResult];
    }
}

- (NSDictionary *)checkResultDictionary:(NSDictionary *)dict{

    if ([dict isKindOfClass:[NSDictionary class]]) {

        NSString *string = dict[AESFConvertedRulesKey];
        if (string) {
            NSNumber *number = dict[AESFConvertedCountKey];
            if (number) {
                
                number = dict[AESFCOverLimitKey];
                if (number) {
                    
                    //All Okey!
                    return dict;
                }
            }
        }
    }
    
    NSString *message = NSLocalizedString(@"Can't convert rules. Unexpected error occured. Please contact support team.", @"(AESFilterConverter) Error occured when checking of the result from JSON converter.");
    NSError *error = [NSError errorWithDomain:AESFConverterError code:AESF_ERROR_WRONG_DICTIONARY userInfo:@{NSLocalizedDescriptionKey: message}];
    
    return @{AESFConvertedErrorKey: error};
}

@end
