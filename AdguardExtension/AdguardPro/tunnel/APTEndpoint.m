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

#import "APTEndpoint.h"
#import "ACommons/ACLang.h"

@implementation APTEndpoint{
    
    NSString *_key;
}

- (instancetype) initWithHostname:(NSString *)hostname port:(NSString *)port{

    if ([NSString isNullOrEmpty:hostname] || [NSString isNullOrEmpty:port]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        if([self checkHost:hostname]){
            
            _hostEndpoint = [NWHostEndpoint endpointWithHostname:hostname port:port];
            if (_hostEndpoint) {
                
                _host = hostname;
                _port = port;
                _key = [_host stringByAppendingFormat:@":%@", _port];
                
                return self;
            }
        }
    }
    return nil;
}

- (instancetype) initWithHostEndpoint:(NWHostEndpoint *)endpoint{
    
    if (!endpoint) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        // we do not check endpoint,
        //that it contains hostname as IPv4 address,
        //for better performance
        _hostEndpoint = endpoint;
        _host = _hostEndpoint.hostname;
        _port = _hostEndpoint.port;
        _key = [_host stringByAppendingFormat:@":%@", _port];
        
        return self;
    }
    return nil;
}

+ (instancetype)endpointWithHostEndpoint:(NWHostEndpoint *)hostEndpoint{
    
    return [[APTEndpoint alloc] initWithHostEndpoint:hostEndpoint];
}

+ (instancetype) endpointWithHostname:(NSString *)hostname port:(NSString *)port{
    
    return [[APTEndpoint alloc] initWithHostname:hostname port:port];
}

- (id)copyWithZone:(NSZone *)zone {
    
    return [APTEndpoint endpointWithHostname:self->_host port:self->_port];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Description, equals, hash

- (NSString *)description
{
    return _key;
}

- (BOOL)isEqual:(id)object {

    if (object == self)
        return YES;
    if ([object isKindOfClass:[self class]]) {
        __typeof__(self) obj = object;
        if ([self->_key isEqualToString:obj->_key]) {

            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return [_key hash];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods

- (BOOL)checkHost:(NSString *)host {
    
    // Check that this is IPv4 address
    struct in_addr addr;
    return (inet_pton(AF_INET, [host cStringUsingEncoding:NSUTF8StringEncoding], &(addr)) == 1);
}

@end
