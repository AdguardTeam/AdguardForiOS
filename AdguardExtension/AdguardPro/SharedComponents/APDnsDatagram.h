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



@import Darwin.libkern;
@import Foundation;

@class APDnsRequest, APDnsResponse;

@interface APDnsDatagram : NSObject <NSCopying>

- (id)initWithData:(NSData *)datagram;

@property (readonly, nonatomic) NSNumber *ID;
@property (readonly, nonatomic) BOOL isRequest;
@property (readonly, nonatomic) BOOL isResponse;

@property (readonly, nonatomic) NSArray <APDnsRequest *> *requests;
@property (readonly, nonatomic) NSArray <APDnsResponse *> *responses;

/**
 Converts to blocking response. 
 Ie appends responses for all address requests , herewith, responses contain localhost address.
 
 @return Returns YES on success
 */
- (BOOL)convertToBlockingResponseWithIP: (NSString*)ip;

- (NSData *)generatePayload;

@end
