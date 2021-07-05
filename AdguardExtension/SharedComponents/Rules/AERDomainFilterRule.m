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

#import "AERDomainFilterRule.h"
#import "ACommons/ACLang.h"

#define PARAMETER_START                 @"["
#define PARAMETER_END                   @"]"
#define MASK_REGEX_RULE                 @"/"
#define MASK_WHITE_LIST                 @"@@"
#define MASK_CONTENT_RULE               @"$$"
#define MASK_CONTENT_EXCEPTION_RULE     @"$@$"
#define MASK_CSS_RULE                   @"##"
#define MASK_CSS_EXCEPTION_RULE         @"#@#"
#define MASK_CSS_INJECT_RULE            @"#$#"
#define MASK_CSS_INJECT_EXCEPTION_RULE  @"#@$#"
#define MASK_SCRIPT_RULE                @"#%#"
#define MASK_SCRIPT_EXCEPTION_RULE      @"#@%#"
#define MASK_OBSOLETE_SCRIPT_INJECTION  @"###adg_start_script_inject"
#define OLD_INJECT_RULES                @"adg_start_style_inject"
#define COMMENT                         @"!"
#define EQUAL                           @"="
#define COMA_DELIMITER                  @","
#define LINE_DELIMITER                  @"|"
#define NOT_MARK                        @"~"
#define MASK_JS_RULE                    @"%%"
#define MASK_FILTER_UNSUPPORTED_RULE    @"##^"

#define AFRU_OPTIONS_DELIMITER          @"$"
#define AFRU_OPTIONS_ESCAPE             @"\\"
#define AFRU_DOMAIN_OPTION              @"domain"
#define AFRU_THIRD_PARTY_OPTION         @"third-party"
#define AFRU_MATCH_CASE_OPTION          @"match-case"
#define AFRU_DOCUMENT_OPTION            @"document"
#define AFRU_ELEMHIDE_OPTION            @"elemhide"
#define AFRU_URLBLOCK_OPTION            @"urlblock"
#define AFRU_JSINJECT_OPTION            @"jsinject"
#define AFRU_CONTENT_OPTION             @"content"
#define AFRU_SCRIPT_OPTION              @"jscript" //TODO: may be depricated
#define AFRU_POPUP_OPTION               @"popup"
#define AFRU_REPLACE_WITH_MP4_OPTION    @"mp4"
#define AFRU_EMPTY_OPTION               @"empty"

#define AFRU_OPTIONS_MARKER_SYM          '$'
#define AFRU_OPTIONS_ESCAPE_SYM          '\\'
#define AFRU_OPTIONS_DELIMITER_SYM       ','


// content type filtering
#define AFRU_AD_SCRIPT_OPTION           @"script"
#define AFRU_AD_IMAGE_OPTION            @"image"
#define AFRU_AD_STYLESHEET_OPTION       @"stylesheet"
#define AFRU_AD_OBJECT_OPTION           @"object"
#define AFRU_AD_XMLHTTPREQUEST_OPTION   @"xmlhttprequest"
#define AFRU_AD_SUBDOCUMENT_OPTION      @"subdocument"
#define AFRU_AD_OBJECTSUBREQUEST_OPTION @"object-subrequest" //TODO: may be depricated

#define AFRU_MASK_START_URL             @"||"
#define AFRU_MASK_PIPE                  @"|"
#define AFRU_MASK_ANY_SYMBOL            @"*"
#define AFRU_URL_SCHEME_SEPARATOR       @"//"
#define AFRU_URL_PATH_SEPARATOR         @"/"
#define AFRU_MASK_SEPARATOR             @"^"
#define AFRU_REGEXP_START_URL           @"^https?://([a-z0-9-_.]+\\.)?"
#define AFRU_REGEXP_ANY_SYMBOL          @".*"
#define AFRU_REGEXP_START_STRING        @"^"
#define AFRU_REGEXP_SEPARATOR           @"([^ a-zA-Z0-9.%]|$)"
#define AFRU_REGEXP_END_STRING          @"$"



@implementation AERDomainFilterRule {
    
    NSUInteger *_partsLength;
    NSUInteger _partsCount;
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Constructor (parsing rule text)
/////////////////////////////////////////////////////////////////////

/// Init (parsing rule text)
- (id)initWithRule:(NSString *)rule {
    
    @autoreleasepool {
        
        if ([AERDomainFilterRule isValidRuleText:rule] == NO) {
            DDLogWarn(@"Error creating invalid rule: %@", rule);
            return nil;
        }
        
        if ([self isComment:rule]) {
            return nil;
        }
        
        self = [super init];
        if (self) {
            
            _whiteListRule = _withSubdomainsRule = _maskRule = NO;
            _partsCount = 0;
            _partsLength = NULL;
            
            if ([rule hasPrefix:MASK_WHITE_LIST]) {
                rule = [rule substringFromIndex:MASK_WHITE_LIST.length];
                _whiteListRule = YES;
            }
            
            //check head
            NSString *head = [rule substringToIndex:(rule.length > 9) ? 9 : rule.length];
            NSInteger idx = [head indexOf:AFRU_URL_SCHEME_SEPARATOR];
            if (idx != -1) {

                rule = [rule substringFromIndex:idx + 2];
            }
            else if ([rule hasPrefix:AFRU_MASK_START_URL]) {
                
                rule = [rule substringFromIndex:AFRU_MASK_START_URL.length];
                _withSubdomainsRule = YES;
            }
            else if ([rule hasPrefix:AFRU_MASK_PIPE]) {
                
                rule = [rule substringFromIndex:AFRU_MASK_PIPE.length];
            }
            else if ([rule hasPrefix:AFRU_MASK_ANY_SYMBOL] == NO) {
                
                rule = [AFRU_MASK_ANY_SYMBOL stringByAppendingString:rule];
            }
            
            //check tail
            if ([rule hasSuffix:AFRU_MASK_SEPARATOR]
                || [rule hasSuffix:AFRU_MASK_PIPE]
                || [rule hasSuffix:AFRU_URL_PATH_SEPARATOR]) {
                
                rule = [rule substringToIndex:(rule.length - 1)];
            }
            else if ([rule hasSuffix:AFRU_MASK_ANY_SYMBOL] == NO){
                
                rule = [rule stringByAppendingString:AFRU_MASK_ANY_SYMBOL];
            }
            
            if (rule.length == 0  || [rule isEqualToString:AFRU_MASK_ANY_SYMBOL]) {
                // Rule matches everything and does not have any domain restriction
                DDLogWarn(@"Too wide basic rule: %@", rule);
                return nil;
            }
            
            // punycoding here
            rule = [rule IDNAEncodedString];
            
            // Searching for shortcut
            [self findParts:rule];
            
            _domainPattern = rule;
        }
    }
    return self;

}
+ (AERDomainFilterRule *)rule:(NSString *)ruleText{
    AERDomainFilterRule *rule = [[AERDomainFilterRule alloc] initWithRule:ruleText];

    return rule;

}

- (void)dealloc {
    
    free(_partsLength);
}

/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////////


- (BOOL)filteredForDomain:(NSString *)domain {

    NSUInteger idx = 0;
    NSUInteger len = 0;
    NSRange range;
    NSInteger domainIdx = 0;
    NSString *part;
    for (int i = 0; i < _partsCount; i++) {
        
        len = _partsLength[i];
        range = NSMakeRange(idx, len);
        
        if (len) {
            
            part = [_domainPattern substringWithRange:range];
            
            //first part
            if (idx == 0) {
                domainIdx  = [domain hasPrefix:part] ? 0 : -1;
            }
            else {
                //other parts
                domainIdx = [domain indexOf:part fromIndex:domainIdx];
            }
            
            if (domainIdx == -1) {
                
                // if this is subdomain rule
                // and we on first part
                if (idx == 0 && _withSubdomainsRule) {
                    
                    part = [@"." stringByAppendingString:part];
                    domainIdx = [domain indexOf:part];
                    
                    if (domainIdx == -1) {
                        return NO;
                    }
                    
                    domainIdx ++; // compensation of '.'
                }
                else {
                    return NO;
                }
            }
        }
        
        idx += len + 1;
        domainIdx += len;
    }
    
    return YES;
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Private methods
/////////////////////////////////////////////////////////////////////


+ (BOOL)isValidRuleText:(__unsafe_unretained NSString *)ruleText {
    
    if ([NSString isNullOrEmpty:ruleText]
        || [ruleText contains:MASK_OBSOLETE_SCRIPT_INJECTION]) {
        
        return NO;
    }

    if ([ruleText hasPrefix:MASK_WHITE_LIST]) {
        return YES;
    }
    
    if ([ruleText contains:MASK_CONTENT_RULE]
        || [ruleText contains:MASK_CONTENT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_INJECT_RULE]
        || [ruleText contains:MASK_CSS_INJECT_EXCEPTION_RULE]
        || [ruleText contains:MASK_SCRIPT_RULE]
        || [ruleText contains:MASK_SCRIPT_EXCEPTION_RULE]
        || [ruleText contains:MASK_CSS_RULE]
        || [ruleText contains:MASK_CSS_EXCEPTION_RULE]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isComment:(__unsafe_unretained NSString *)ruleText {
    
    return [[NSString stringByTrim:ruleText] hasPrefix:COMMENT];
}

- (void)findParts:(NSString *)urlmask {
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString: AFRU_MASK_ANY_SYMBOL];
    NSArray *parts = [urlmask componentsSeparatedByCharactersInSet:cSet];
    
    _partsCount = parts.count;
    _partsLength = malloc(sizeof(*_partsLength) * _partsCount);
    
    if (_partsCount > 1) {
        _maskRule = YES;
    }
    
    int i = 0;
    for (NSString *part in parts) {
        
        _partsLength[i++] = part.length;
        
    }
    
}

@end
