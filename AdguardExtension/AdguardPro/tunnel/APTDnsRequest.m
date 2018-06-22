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


#import "APTDnsRequest.h"

@implementation APTDnsRequest{
    
    NSMutableArray <NSString *>*domains;
    int transactionID;
    int flags;
    NSMutableArray <NSNumber *>*requestTypes;
    int questions;
    int answers;
    int authorities;
    int additional;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)init{
    
    return [self initWithData:nil];
}

- (id)initWithData:(NSData *)requestData{
    
    if (requestData.length < 13) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        transactionID = 0;
        flags = 0;
        questions = 0;
        answers = 0;
        authorities = 0;
        additional = 0;
        
        if ([self parseRequest:requestData]) {
            return self;
        }
    }
    
    return nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private methods

- (BOOL)parseRequest:(NSData *)requestData{

    Byte *buf = (Byte *)requestData.bytes;
    
    transactionID = ((0xFF & buf[0]) << 8) + (0xFF & buf[1]);
    flags = ((0xFF & buf[2]) << 8) + (0xFF & buf[3]);
    questions = ((0xFF & buf[4]) << 8) + (0xFF & buf[5]);
    answers = ((0xFF & buf[6]) << 8) + (0xFF & buf[7]);
    authorities = ((0xFF & buf[8]) << 8) + (0xFF & buf[9]);
    additional = ((0xFF & buf[10]) << 8) + (0xFF & buf[11]);
   
    if (flags == 0x0100 && questions > 0) {
        // questions start at 12
        int off = 12;
        domains = [NSMutableArray arrayWithCapacity:questions];
        requestTypes = [NSMutableArray arrayWithCapacity:questions];
        
        for (int i = 0; i < questions; i++) {
            int len = (buf[off] & 0xFF);
            NSMutableString *sb = [NSMutableString string];
            while (len != 0) {
                if (len < 128) {
                    off++;
                    if ((off + len) > (requestData.length - 1)) {
                        //error
                        return NO;
                    }
                    NSString *part = [[NSString alloc] initWithBytes:(buf + off) length:len encoding:NSASCIIStringEncoding];
                    if (!part) {
                        //error
                        return NO;
                    }
                    [sb appendString:part];
                    off += len;
                }
                else{
                    off += len + 1;
                }
                len = (buf[off] & 0xFF);
                if (len != 0)
                    [sb appendString:@"."];
            }
            off++;
            [domains addObject:sb];
            NSNumber *type = @(((0xFF & buf[off]) << 8) + (0xFF & buf[off + 1]));
            [requestTypes addObject:type];
            //Log.w("DNS", "transaction = "+Integer.toHexString(transactionID) + ", domain = "+domains[i]+", type = " + requestTypes[i]);
            off += 4; // class is ignored
        }
        return YES;
    }

    return NO;
}

- (NSString *)description{
    
    NSMutableString *sb = [NSMutableString string];
    [domains enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (sb.length) {
            [sb appendFormat:@", %@", obj];
        }
        else{
            [sb appendString:obj];
        }
        
        [sb appendFormat:@", request type = %d", [self->requestTypes[idx] intValue]];
    }];
    
    return sb;
}

@end
