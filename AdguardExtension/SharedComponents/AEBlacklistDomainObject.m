//
//  AEBlacklistDomainObject.m
//  Adguard
//
//  Created by Roman Sokolov on 05.10.16.
//  Copyright © 2016 Performiks. All rights reserved.
//

#import "AEBlacklistDomainObject.h"
#import "AEFilterRuleSyntaxConstants.h"
#import "ACommons/ACLang.h"
#import "ASDFilterObjects.h"

@implementation AEBlacklistDomainObject

- (NSString *)ruleDomainPrefix {
    
    return AFRU_MASK_START_URL;
}
- (NSString *)ruleDomainSufix {
    return AFRU_MASK_SEPARATOR;
}

@end
