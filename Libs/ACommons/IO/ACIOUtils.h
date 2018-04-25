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
#import <Foundation/Foundation.h>
#import "ACIOUtilsProtocols.h"

#define IOUTILS_CR 13
#define IOUTILS_LF 10
#define IOUTILS_H_TAB 9
#define IOUTILS_SP 32

#define ACIO_STREAM_READ_ERROR          100
#define ACIO_STREAM_WRITE_ERROR         200
#define ACIO_STREAM_CHUNK_WRITE_ERROR   201

#define ACIO_STREAM_WRITE_BYTES_KEY     @"ACIOWriteBytes"

static const NSInteger ACIOUtilsDefaultBufferSize = 8192*1;
static const NSInteger ACIOUtilsDefaultLineBufferSize = 128;
static NSString  *ACIOStreamErrorDomain = @"ACIOStreamErrorDomain";

@interface ACIOUtils : NSObject

+ (NSInteger)bufferSize;
+ (void)setBufferSize:(NSInteger)size;
+ (NSInteger)lineBufferSize;
+ (void)setLineBufferSize:(NSInteger)size;

+ (NSData *)read:(id<ACIOUtilReadProtocol>)input len:(NSInteger)bytesToRead;
+ (NSString *)readLine:(id<ACIOUtilReadProtocol>)stream;
+ (NSString *)readLine:(id<ACIOUtilReadProtocol>)stream encoding:(NSStringEncoding)encoding;
+ (NSData *)readLineBytes:(id<ACIOUtilReadProtocol>)stream;
+ (BOOL)isEmptyOrWhitespace:(NSData *)data;

+ (NSData *)readToEnd:(id<ACIOUtilReadProtocol>)input;
+ (NSData *)readToEnd:(id<ACIOUtilReadProtocol>)input length:(NSInteger)contentLength;

/// Copies bytes from input stream to the output stream,
/// but not more then "contentLength". (If contentLength is "-1", copies everything).
/// @return Amount of bytes read from input stream
+ (NSInteger)copyFrom:(id<ACIOUtilReadProtocol>)input to:(id<ACIOUtilWriteProtocol>)output length:(NSInteger)contentLength;

@end
