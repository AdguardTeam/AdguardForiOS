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
#import "AEUIFilterRuleObject.h"
#import "ACommons/ACLang.h"
#import "AEFilterRuleSyntaxConstants.h"

#define COLOR_DEFAULT       darkGrayColor
#define COLOR_COMMENT       grayColor
#define COLOR_WHITELIST     colorWithRed:0.2 green:0.4 blue:0.4 alpha:1
#define COLOR_CONTENT       colorWithRed:0.631372549 green:0.462745098 blue:0.635294118 alpha:1
#define COLOR_CSSINJECT     colorWithRed:0.266666667 green:0.466666667 blue:0.666666667 alpha:1
#define COLOR_ELEMHIDE      colorWithRed:0.4 green:0.6 blue:0.8 alpha:1
#define COLOR_JS            colorWithRed:0.6 green:0.6 blue:0.2 alpha:1


/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIFilterRuleObject
/////////////////////////////////////////////////////////////////////

@implementation AEUIFilterRuleObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init{
    
    self = [super init];
    if (self) {
    
        isEnabledHolder = _isEnabled = super.isEnabled;
        
        self.ruleText = super.ruleText;
    }
    return self;
}

- (id)initWithRule:(ASDFilterRule *)rule{
    
    self = [super init];
    if (self) {
        
        self.filterId = rule.filterId;
        self.ruleId = rule.ruleId;
        isEnabledHolder = _isEnabled = rule.isEnabled;

        
        self.ruleText = rule.ruleText;
        
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

- (NSString *)ruleText{
    
    return _ruleText;
}

- (void)setRuleText:(NSString *)ruleText{
    
    if ([ruleText isEqualToString:_ruleText])
        return;
    
    [self willChangeValueForKey:@"ruleType"];
    
    _ruleText = [ruleText copy];

    if ([NSString isNullOrEmpty:_ruleText])
        _ruleType = AEUIFRUrlBlockType;

    else if ([_ruleText hasPrefix:MASK_WHITE_LIST])
        _ruleType = AEUIFRWhiteListType;

    else if ([_ruleText hasPrefix:COMMENT])
        _ruleType = AEUIFRCommentType;

    else if([_ruleText containsAny:@[MASK_CSS_RULE, MASK_CSS_EXCEPTION_RULE]])
        _ruleType = AEUIFRCssElementType;
    
    else if([_ruleText containsAny:@[MASK_CSS_INJECT_RULE, MASK_CSS_INJECT_EXCEPTION_RULE]])
        _ruleType = AEUIFRCssInjectType;
    
    else if ([_ruleText containsAny:@[MASK_CONTENT_RULE, MASK_CONTENT_EXCEPTION_RULE]])
        _ruleType = AEUIFRContentElementType;
    
    else if ([_ruleText containsAny:@[MASK_SCRIPT_RULE, MASK_SCRIPT_EXCEPTION_RULE]])
        _ruleType = AEUIFRJsElementType;
    
    else if ([_ruleText contains:@"~~"])
        _ruleType = AEUIFRConfiguraitionRuleType;
    
    else
        _ruleType = AEUIFRUrlBlockType;
    
    [self setProperties];
    
    [self didChangeValueForKey:@"ruleType"];
}

- (NSNumber *)isEnabled{
    
    return _isEnabled;
}

- (void)setIsEnabled:(NSNumber *)isEnabled{
    
    isEnabledHolder = isEnabled;
    
    if (_active) {
        
        _isEnabled = isEnabled;
    }
}
/////////////////////////////////////////////////////////////////////////
#pragma mark Private methods
/////////////////////////////////////////////////////////////////////////

- (void)setProperties{
    
    [self willChangeValueForKey:@"active"];
    [self willChangeValueForKey:@"textColor"];
    [self willChangeValueForKey:@"isEnabled"];
    [self willChangeValueForKey:@"attributeRuteText"];

    _active = YES;
    _isEnabled = isEnabledHolder;
    
    _font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    _textColor = [UIColor COLOR_DEFAULT];

    switch (_ruleType) {
            
        case AEUIFRCommentType:
            _active = NO;
            _isEnabled = @(0);
            _font = [UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
            _textColor = [UIColor COLOR_COMMENT];
            break;
            
        case AEUIFRWhiteListType:
            _textColor = [UIColor COLOR_WHITELIST];
            break;
            
        case AEUIFRCssElementType:
            _textColor = [UIColor COLOR_ELEMHIDE];
            break;

        case AEUIFRCssInjectType:
            _textColor = [UIColor COLOR_CSSINJECT];
            break;
            
        case AEUIFRJsElementType:
            _textColor = [UIColor COLOR_JS];
            break;
            
        case AEUIFRContentElementType:
            _textColor = [UIColor COLOR_CONTENT];
            break;
            
        default:
            break;
    }
    
    _attributeRuteText = [[NSAttributedString alloc]
                          initWithString:_ruleText
                          attributes:@{
                                       NSFontAttributeName: _font,
                                       NSForegroundColorAttributeName: _textColor
                                       }];
    
    [self didChangeValueForKey:@"attributeRuteText"];
    [self didChangeValueForKey:@"isEnabled"];
    [self didChangeValueForKey:@"textColor"];
    [self didChangeValueForKey:@"active"];
 
}
@end
