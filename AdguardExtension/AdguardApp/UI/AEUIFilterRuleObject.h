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
#import <UIKit/UIKit.h>
#import "ASDFilterObjects.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIFilterRuleObject Constants
/////////////////////////////////////////////////////////////////////

typedef enum {
    AEUIFRUnknownType = 0,
    AEUIFRCommentType,
    AEUIFRUrlBlockType,
    AEUIFRWhiteListType,
    AEUIFRCssElementType,
    AEUIFRCssInjectType,
    AEUIFRJsElementType,
    AEUIFRContentElementType,
    AEUIFRConfiguraitionRuleType
    
} AEUIFilterRuleObjectType;

/////////////////////////////////////////////////////////////////////
#pragma mark - AEUIFilterRuleObject
/////////////////////////////////////////////////////////////////////

/**    
    Class represents row for table that displays list of rules
    for corresponding ad-block filter.
 */
@interface AEUIFilterRuleObject : ASDFilterRule{
    
    NSString *_ruleText;
    AEUIFilterRuleObjectType _ruleType;

    NSNumber *_isEnabled;

    NSNumber *isEnabledHolder;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods
/////////////////////////////////////////////////////////////////////

/**
    Initialize from rule object
 */
- (id)initWithRule:(ASDFilterRule *)rule;

/////////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods
/////////////////////////////////////////////////////////////////////////

@property (nonatomic, readonly) AEUIFilterRuleObjectType ruleType;

@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, readonly) UIColor *textColor;

@end
