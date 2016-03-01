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
#import "ACIOUtils.h"
#import "ACNetwork.h"
#import "ACLang.h"
#import "ACIO.h"

static NSInteger _bufferSize = ACIOUtilsDefaultBufferSize;
static NSInteger _lineBufferSize = ACIOUtilsDefaultLineBufferSize;

@interface ACIOUtils()
+ (BOOL)isEmptyOrWhitespaceByte:(Byte)byteToCheck;
+ (BOOL)isEmptyOrWhitespace:(NSData *)data;
+ (NSString *)toStringRemovingTrailingCrLf:(NSData *)data;
+ (NSString *)toStringRemovingTrailingCrLf:(NSData *)data encoding:(NSStringEncoding)encoding;
@end

@implementation ACIOUtils

+ (NSInteger)bufferSize
{
    return _bufferSize;
}

+ (void)setBufferSize:(NSInteger)size
{
    _bufferSize = size;
}

+ (NSInteger)lineBufferSize
{
    return _lineBufferSize;
}

+ (void)setLineBufferSize:(NSInteger)size
{
    _lineBufferSize = size;
}

+ (NSData *)read:(id<ACIOUtilReadProtocol>)input len:(NSInteger)bytesToRead {
    @autoreleasepool {

        NSInteger bytesRead = 0;
        NSInteger toRead = bytesToRead;

        Byte *buffer = malloc(bytesToRead);
        if (!buffer)
            [[NSException mallocException:@"buffer"] raise];

        NSData *outdata;

        while (toRead > 0) {
            NSInteger result = [input read:buffer + bytesRead maxLength:toRead];
            if (result <= ACIO_EOF) {
                break;
            }
            bytesRead += result;
            toRead -= result;
        }

        outdata = [NSData dataWithBytes:buffer length:bytesRead];

        free(buffer);

        return outdata;
    }
}

+ (BOOL)isEmptyOrWhitespaceByte:(Byte)byteToCheck
{
    return byteToCheck == IOUTILS_CR ||
           byteToCheck == IOUTILS_LF ||
           byteToCheck == IOUTILS_SP ||
           byteToCheck == IOUTILS_H_TAB;
}

+ (BOOL)isEmptyOrWhitespace:(NSData *)data
{
    if (data == nil || data.length == 0) return YES;

    const Byte *bytes = [data bytes];
    
    for (int i = 0; i < data.length; i++)
    {
        if (![ACIOUtils isEmptyOrWhitespaceByte:bytes[i]])
        {
            return NO;
        }
    }
    
    return YES;
}

+ (NSData *)readLineBytes:(id<ACIOUtilReadProtocol>)stream {
    @autoreleasepool {

        NSUInteger length = 0;
        NSMutableData *buffer = [NSMutableData dataWithLength:_lineBufferSize];

        Byte byteRead;
        while ([stream read:&byteRead maxLength:1] > ACIO_EOF) {
            if (buffer.length <= length) {
                [buffer setLength:buffer.length + _lineBufferSize];
            }

            switch (byteRead) {
            case IOUTILS_LF:
                ((Byte *)[buffer mutableBytes])[length] = byteRead;
                ++length;
                return [buffer subdataWithRange:NSMakeRange(0, length)];
                break;
            default:
                ((Byte *)[buffer mutableBytes])[length] = byteRead;
                ++length;
                break;
            }
        }

        return [buffer subdataWithRange:NSMakeRange(0, length)];
    }
}

+ (NSString *)readLine:(id<ACIOUtilReadProtocol>)stream
{
    @autoreleasepool {

        NSData *lineBytes = [self readLineBytes:stream];
        if (lineBytes.length == 0) {
            return nil;
        }
        return [ACIOUtils toStringRemovingTrailingCrLf:lineBytes];
    }
}

+ (NSString *)readLine:(id<ACIOUtilReadProtocol>)stream encoding:(NSStringEncoding)encoding{
    @autoreleasepool {
        
        NSData *lineBytes = [self readLineBytes:stream];
        if (lineBytes.length == 0) {
            return nil;
        }
        return [ACIOUtils toStringRemovingTrailingCrLf:lineBytes encoding:encoding];
    }
}

+ (NSString *)toStringRemovingTrailingCrLf:(NSData *)data
{
    return [ACIOUtils toStringRemovingTrailingCrLf:data encoding:[ACNHttpUtils defaultHttpEncoding]];
}

+ (NSString *)toStringRemovingTrailingCrLf:(NSData *)data encoding:(NSStringEncoding)encoding
{
    NSString *string = [[NSString alloc] initWithData:data encoding:encoding];
    if (string == nil && data.length > 0) {
        // something wrong with encoding, trying ISOLatin1
        string =[[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

+ (NSData *)readToEnd:(id<ACIOUtilReadProtocol>)input
{
    return [ACIOUtils readToEnd:input length:-1];
}

+ (NSData *)readToEnd:(id<ACIOUtilReadProtocol>)input length:(NSInteger)contentLength
{
    @autoreleasepool {

        // doing nothing for content-length == 0
        if (contentLength == 0) return nil;
        
        NSUInteger bufferSize;
        if (contentLength == -1)
            bufferSize = _bufferSize;
        
        else if (_bufferSize > contentLength)
            bufferSize = contentLength;
        
        else
            bufferSize = _bufferSize;
        
        NSMutableData *outputData = [NSMutableData dataWithCapacity:bufferSize];
        
        Byte *buffer = malloc(bufferSize * sizeof(Byte));
        if (buffer == nil)
            @throw [NSException mallocException:@"buffer"];
        
        NSUInteger bytesRead = 0;
        NSInteger read = 0;
        @try {
            
            while (1)
            {
                read = [input read:buffer maxLength:bufferSize];
                if (read <= ACIO_EOF)
                    break;
                
                [outputData appendBytes:buffer length:read];
                if (contentLength != -1){
                    
                    bytesRead += read;
                    if (bytesRead == contentLength)
                        break;
                    
                    if (contentLength - bytesRead < bufferSize)
                        bufferSize = contentLength - bytesRead;
                }
            }
        }
        @finally {
            
            free(buffer);
        }
        
        return outputData;
    }
}


/// Copies bytes from input stream to the output stream,
/// but not more then "contentLength". (If contentLength is "-1", copies everything).
/// @return Amount of bytes read from input stream
+ (NSInteger)copyFrom:(id<ACIOUtilReadProtocol>)input to:(id<ACIOUtilWriteProtocol>)output length:(NSInteger)contentLength
{
    @autoreleasepool {
    
        // doing nothing for content-length == 0
        if (contentLength == 0) return 0;
        
        NSUInteger bufferSize;
        if (contentLength == -1)
            bufferSize = _bufferSize;
        
        else if (_bufferSize > contentLength)
            bufferSize = contentLength;
        
        else
            bufferSize = _bufferSize;
        
        Byte *buffer = malloc(bufferSize * sizeof(Byte));
        if (buffer == nil)
            @throw [NSException mallocException:@"buffer"];
        
        NSUInteger bytesRead = 0;
        NSInteger read = 0;
        @try {
            
            while (1)
            {
                read = [input read:buffer maxLength:bufferSize];
                if (read <= ACIO_EOF)
                    break;
                
                [output write:buffer maxLength:read];
                if (contentLength != -1){
                    
                    bytesRead += read;
                    if (bytesRead == contentLength)
                        break;
                    
                    if (contentLength - bytesRead < bufferSize)
                        bufferSize = contentLength - bytesRead;
                }
            }
        }
        @finally {
            
            free(buffer);
        }
        
        return bytesRead;
    }
}


@end
