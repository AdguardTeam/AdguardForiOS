/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2016 Performix LLC. All rights reserved.
 
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



#include <sys/types.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/nameser.h>
#include <resolv.h>
#import "APDnsDatagram.h"
#import "APDnsResourceType.h"
#import "APDnsResourceClass.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"

#define BLOCKING_RESPONSE_TTL   60 * 60         // 1 hour

@interface APDnsDatagram ()

@property (nonatomic) NSNumber *ID;
@property (nonatomic) BOOL isRequest;
@property (nonatomic) BOOL isResponse;
@property (nonatomic) NSArray <APDnsRequest *> *requests;
@property (nonatomic) NSArray <APDnsResponse *> *responses;

@end

@implementation APDnsDatagram

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (id)initWithData:(NSData *)datagram{
    
    self = [super init];
    if (self) {
        
        if ([self parseData:datagram]) {
            return self;
        }
    }
    return nil;
}

- (NSData *)generatePayload{
    
    NSMutableData *payload = [NSMutableData dataWithLength:12];
    
    uint16_t trId = [_ID unsignedShortValue];
    if (trId == 0) {
        trId = (uint16_t)arc4random_uniform(UINT16_MAX);
    }
    
    [self setData:payload withUInt16:trId offset:0];
    
    uint8_t flags = 0;
    
    if (self.isResponse) {
        
        flags += 1 << 7;
    }
    [self setData:payload withUInt8:flags offset:2];
    
    [self setData:payload withUInt16:(uint16_t)self.requests.count offset:4];
    [self setData:payload withUInt16:(uint16_t)self.responses.count offset:6];
    
    for (APDnsRequest *item in self.requests) {
        if ([self appendRequest:item toData:payload] == NO) {
            return nil;
        }
    }
    for (APDnsResponse *item in self.responses) {
        if ([self appendResponse:item toData:payload] == NO) {
            return nil;
        }
    }
    
    return payload;
}

- (id)copyWithZone:(NSZone *)zone {
    
    APDnsDatagram *obj = [APDnsDatagram new];
    
    obj.ID = self.ID;
    obj.isRequest = self.isRequest;
    obj.isResponse = self.isResponse;
    obj.requests = [self.requests copyWithZone:zone];
    obj.responses = [self.responses copyWithZone:zone];
   
    return obj;
}

- (BOOL)convertToBlockingResponseWithIP: (NSString*)ip {
    
    if (self.isRequest == NO) {
        return NO;
    }
    
    NSMutableArray *responses = [NSMutableArray array];
    
    for (APDnsRequest *request in self.requests) {
        APDnsResponse *response = [APDnsResponse blockedResponseWithName:request.name type:request.type ip:ip];
        if (response) {
            [responses addObject:response];
        }
    }
    
    if (responses.count) {
        _responses = responses;
        _isRequest = NO;
        _isResponse = YES;
        
        return YES;
    }
    
    return NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Private Methods


- (BOOL)parseData:(NSData *)datagram{
    
    const u_char *msg = (const u_char *)datagram.bytes;
    int msglen = (int)datagram.length;
    ns_msg handle;
    
    // init
    if (ns_initparse(msg, msglen, &handle) < 0)
        return  NO;
    
    // ID
    _ID = @(ns_msg_id(handle));
    
    // request/response
    if (ns_msg_getflag(handle, ns_f_qr)) {
        _isResponse = YES;
        _isRequest = NO;
    }
    else{
        _isRequest = YES;
        _isResponse = NO;
    }
    
    // read requests
    uint16_t count = ns_msg_count(handle, ns_s_qd);
    ns_rr rr;
    
    if (count) {
        
        NSMutableArray *requests = [NSMutableArray arrayWithCapacity:count];
        
        for (uint16_t i = 0; i < count; i++) {
            
            if(ns_parserr(&handle, ns_s_qd, i, &rr) < 0){
                continue;
            }
            
            if (ns_rr_class(rr) != ns_c_in) {
                continue;
            }
            
            APDnsRequest *request = [[APDnsRequest alloc] initWithRR:rr];
            
            [requests addObject:request];
        }
        
        if (requests.count) {
            _requests = [requests copy];
        }
    }
    
    if (_isResponse) {
        
        count = ns_msg_count(handle, ns_s_an);
        if (count) {
            
            NSMutableArray *responses = [NSMutableArray arrayWithCapacity:count];
            
            for (uint16_t i = 0; i < count; i++) {
                
                if(ns_parserr(&handle, ns_s_an, i, &rr) < 0){
                    continue;
                }

                if (ns_rr_class(rr) != ns_c_in) {
                    continue;
                }
                
                APDnsResponse *response = [[APDnsResponse alloc] initWithRR:rr msg:handle];
                [responses addObject:response];
            }
            
            if (responses.count) {
                _responses = [responses copy];
            }
        }
    }
    
    return YES;
}

- (void)setData:(NSMutableData *)data withUInt8:(uint8_t)value offset:(NSUInteger)offset {
    
    [data replaceBytesInRange:NSMakeRange(offset, 1) withBytes:&value];
}

- (void)setData:(NSMutableData *)data withUInt16:(uint16_t)value offset:(NSUInteger)offset {
  
    uint16_t swaped = htons(value);
    [data replaceBytesInRange:NSMakeRange(offset, 2) withBytes:&swaped];
}

- (void)setData:(NSMutableData *)data withUInt32:(uint32_t)value offset:(NSUInteger)offset {
    
    uint32_t swaped = htonl(value);
    [data replaceBytesInRange:NSMakeRange(offset, 4) withBytes:&swaped];
}

- (BOOL)appendName:(NSString *)name toData:(NSMutableData *)data {
    
    for (NSString *item in [name componentsSeparatedByString:@"."]) {
        
        if (item.length == 0) {
            return NO;
        }
        NSData *itemData = [item dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger len = itemData.length;
        if (len == 0 || len > 255) {
            return  NO;
        }
        uint8_t b_len = (uint8_t)len;
        [data appendBytes:&b_len length:1];
        [data appendData:itemData];
    }
    [data setLength:(data.length + 1)];
    
    return YES;
}

- (BOOL)appendRequest:(APDnsRequest *)request toData:(NSMutableData *)data {
    
    if (![self appendName:request.name toData:data])
        return NO;
    
    [self setData:data withUInt16:request.type.intValue offset:data.length];
    [self setData:data withUInt16:request.qClass.intValue offset:data.length];
    
    return  YES;
}

- (BOOL)appendResponse:(APDnsResponse *)response toData:(NSMutableData *)data {
    
    if (![self appendName:response.name toData:data])
        return NO;
    
    [self setData:data withUInt16:response.type.intValue offset:data.length];
    [self setData:data withUInt16:response.qClass.intValue offset:data.length];
    
    // TTL
    [self setData:data withUInt32: BLOCKING_RESPONSE_TTL offset:data.length];
    
    uint16_t len = response.rdata.length;
    [self setData:data withUInt16:len offset:data.length];
    
    [data appendData:response.rdata];
    
    return YES;
}

@end
