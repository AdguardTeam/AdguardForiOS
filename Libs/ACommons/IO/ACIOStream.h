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
#import <Foundation/Foundation.h>
#import "ACIOUtilsProtocols.h"

#define ACIOStreamReadTimeoutException      @"ACIOStreamReadTimeoutException"
#define ACIOStreamWriteTimeoutException     @"ACIOStreamWriteTimeoutException"
#define ACIOStreamErrorException            @"ACIOStreamErrorException"

enum{
    
    ACIO_ERROR =  -1,
    ACIO_EOF
};

@class ACIOStream;

/// Protocol for getting events when ACIOStream performs job
@protocol ACIOStreamDelegate <NSObject>

@optional

/**
    Reads and places data into buffer.
    @return Method must return count of readed bytes.
    If error occurs method must return ACIO_ERROR constant.
    If end of stream occurs method must return ACIO_EOF constant.
 */
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len stream:(ACIOStream *)stream;
/**
    Writes the contents of a provided data buffer to the receiver.
 
    @return Method must return the number of bytes actually written, or ACIO_ERROR constant if an error occurs. If the receiver is a fixed-length and has reached its capacity, method must return ACIO_EOF constant.
 */
- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len stream:(ACIOStream *)stream;

@end



/**
 *  CSharp-like ABSTRACT class for stream.
 *  All work is performed through delegate, which conform ACIOStreamDelegate protocol
 */
@interface ACIOStream : NSObject <ACIOUtilReadProtocol, ACIOUtilWriteProtocol>{
    
    NSLock *_counterWrittenBytesLocker;
}

/////////////////////////////////////////////////////////////////////
#pragma mark -  Init and Class methods
/////////////////////////////////////////////////////////////////////

- (id)initWithDelegate:(id<ACIOStreamDelegate>)delegate;

/////////////////////////////////////////////////////////////////////
#pragma mark -  Properties and public methods
/////////////////////////////////////////////////////////////////////

@property (weak) id<ACIOStreamDelegate> delegate;

/// Count of written bytes
@property (nonatomic, readonly) NSUInteger bytesWritten;

/// Custom counter of written bytes.
@property (nonatomic, readonly) NSUInteger counterWrittenBytes;

/// Count of read bytes
@property (nonatomic, readonly) NSUInteger bytesRead;

/// Reads up to length bytes into the supplied buffer, which must be at least of size len.
/// Returns the actual number of bytes read.
- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len;

/**
    Writes the bytes from the specified buffer to the stream up to len bytes.
    Returns the number of bytes actually written, 
    or ACIO_ERROR constant if an error occurs. 
    If the receiver is a fixed-length and has reached its capacity, 
    ACIO_EOF constant is returned.
 */
- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len;

/**
    Clears custom counter written bytes.
 */
- (void)clearCounterWrittenBytes;

@end
