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

#import "AEInvertedWhitelistDomainsObject.h"
#import "ASDFilterObjects.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - AEInvertedWhitelistDomainsObject

@implementation AEInvertedWhitelistDomainsObject

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithDomains:(NSArray<NSString *> *)domains {
    
    if(self = [super init]) {
        
        _domains = domains;
        _rule = [self ruleFromDomains:domains];
    }
    
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark private methods

- (NSString*) rulePrefix {
    
    return @"@@||*$document,domain=";
}

- (ASDFilterRule*) ruleFromDomains:(NSArray<NSString*>*) domains {
    
    NSMutableString* ruleString = [[self rulePrefix] mutableCopy];
    
    for(int i = 0; i < domains.count; ++i) {
        
        if(domains[i].length == 0)
            continue;
        
        if(i > 0)
            [ruleString appendString:@"|"];
        
        [ruleString appendFormat:@"~%@", domains[i]];
    }
    
    ASDFilterRule *rule = [ASDFilterRule new];
    rule.ruleText = [ruleString copy];
    rule.isEnabled = @(YES);
    return rule;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)addDomain:(NSString *)domain {
    
    if(!_domains) {
        _domains = [NSArray new];
    }
    
    _domains = [_domains arrayByAddingObject:domain];
    _rule = [self ruleFromDomains:_domains];
}

- (void)setDomains:(NSArray<NSString *> *)domains {
    
    _domains = domains;
    _rule = [self ruleFromDomains:_domains];
}

@end
