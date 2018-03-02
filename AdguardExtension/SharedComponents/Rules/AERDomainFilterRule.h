/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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
#import "ACommons/ACNetwork.h"
#import "AEFilterRuleSyntaxConstants.h"

@interface AERDomainFilterRule : NSObject 

/////////////////////////////////////////////////////////////////////
#pragma mark -  Constructor (parsing rule text)
/////////////////////////////////////////////////////////////////////

/// Creates an domain blocking rule from its text presentation.
+ (AERDomainFilterRule *)rule:(NSString *)ruleText;

/**
 check rule syntax
 */
+ (BOOL) isValidRuleText:(NSString*)ruleText;

/////////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and query methods
/////////////////////////////////////////////////////////////////////////

/// If set to true - this is exception rule
@property (nonatomic, readonly) BOOL whiteListRule;
@property (nonatomic, readonly) BOOL maskRule;
@property (nonatomic, readonly) BOOL withSubdomainsRule;

/**
 Domain representation from rule text.
 */
@property (nonatomic, readonly) NSString *domainPattern;

/// Checks request domain against filter
- (BOOL)filteredForDomain:(NSString *)domain;

@end
