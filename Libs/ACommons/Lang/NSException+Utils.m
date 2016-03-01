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
#import "NSException+Utils.h"

@implementation NSException (Utils)

+ (NSException *)argumentException:(NSString *)argumentName{
    if (!argumentName)
        argumentName = @"(NONE)";
    
    return [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"Method argument error: %@", argumentName] userInfo:nil];
}

+ (NSException *)mallocException:(NSString *)objectName{
    
    NSString *descriprion = @"Memory allocation error.";
    
    if (objectName) {
        
        descriprion = [descriprion stringByAppendingFormat:@" Attempt allocate memory for (%@).", objectName];
    }
    return [NSException exceptionWithName:NSMallocException reason:descriprion userInfo:nil];
}

+ (NSException *)appResourceUnavailableException:(NSString *)resourceName{
    
    NSString *descriprion = @"Application resource available error.";
    
    if (resourceName) {
        
        descriprion = [descriprion stringByAppendingFormat:@" Attempt load resource with name: %@.", resourceName];
    }
    return [NSException exceptionWithName:NSInternalInconsistencyException reason:descriprion userInfo:nil];
    
}

+ (NSException *)notImplementedException{
    
    return [NSException exceptionWithName:NSInvalidArgumentException reason:@"Selector not implemented" userInfo:nil];
}

@end
