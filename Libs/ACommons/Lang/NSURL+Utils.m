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
#import "NSURL+Utils.h"
#import "NSString+Utils.h"

@implementation NSURL (Utils)

//////////////////////////////////////////////////////////////
#pragma mark - C# and other sugar
//////////////////////////////////////////////////////////////

- (NSString *)hostWithPort{
    
    if ([self port])
        return [NSString stringWithFormat:@"%@:%@",[self host], [self port]];
    else
        return [self host];
}

- (NSString *)relativeUrlString{
    
    NSString *result = [self absoluteString];
    
    NSInteger index = [result indexOf:@"://"];

    if (index < 0)
        return result;
    else{
        
        index = [result indexOf:@"/" fromIndex:(index + 3)];
        if (index < 0)
            return result;
        
        return [result substringFromIndex:index];
    }
}
@end
