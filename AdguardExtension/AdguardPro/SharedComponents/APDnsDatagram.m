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
#import "APDnsRequest.h"
#import "APDnsResponse.h"

@implementation APDnsDatagram

- (id)initWithData:(NSData *)datagram{
    
    self = [super init];
    if (self) {
        
        if ([self parseData:datagram]) {
            return self;
        }
    }
    return nil;
}


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
    u_int16_t count = ns_msg_count(handle, ns_s_qd);
    ns_rr rr;
    
    if (count) {
        
        NSMutableArray *requests = [NSMutableArray arrayWithCapacity:count];
        
        for (u_int16_t i = 0; i < count; i++) {
            
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
            
            for (u_int16_t i = 0; i < count; i++) {
                
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

@end
