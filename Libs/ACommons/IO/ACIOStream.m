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
#import "ACommons/ACLang.h"
#import "ACIOStream.h"

#define DEFAULT_WRITE_TIMEOUT 30

@implementation ACIOStream

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)init{
    
    self = [super init];
    if (self) {
        
        _bytesRead = _bytesWritten = 0;
        _counterWrittenBytes = 0;
        _counterWrittenBytesLocker = [NSLock new];
    }
    
    return self;
}

- (id)initWithDelegate:(id<ACIOStreamDelegate>)delegate{
    
    self = [self init];
    if (self) {
        
        _delegate = delegate;
    }
    
    return self;
}

- (void)dealloc{

}
/////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and public methods
/////////////////////////////////////////////////////////////////////


- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len{

    if (len == 0)
        return 0;
    
    if (buffer == NULL)
        return ACIO_ERROR;
    
    NSInteger result = ACIO_EOF;
    if (_delegate && [_delegate respondsToSelector:@selector(read:maxLength:stream:)]){
        
        result = [_delegate read:buffer maxLength:len stream:self];

        if (result > 0)
            _bytesRead += result;
        
    }
    else result = ACIO_ERROR;

    return result;
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
    if (len == 0)
        return 0;
    if (buffer == NULL)
        return ACIO_ERROR;
    
    NSInteger result = 0;

    if (_delegate && [_delegate respondsToSelector:@selector(write:maxLength:stream:)]){
 
            result = [_delegate write:buffer maxLength:len stream:self];
        
        if (result > ACIO_EOF){
            
            _bytesWritten += result;
            
            [_counterWrittenBytesLocker lock];
            _counterWrittenBytes += result;
            [_counterWrittenBytesLocker unlock];
        }
    }
    else
        return ACIO_ERROR;
    
    return result;
}

- (void)clearCounterWrittenBytes{
    
    [_counterWrittenBytesLocker lock];
    _counterWrittenBytes = 0;
    [_counterWrittenBytesLocker unlock];
}

@end
