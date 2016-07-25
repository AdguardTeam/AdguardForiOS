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


#import "APDnsResourceType.h"

@implementation APDnsResourceType

static NSDictionary *_types;

+ (void)initialize{

    if (self == [APDnsResourceType class]) {

        _types = @{
            @(0) : @{@"name" : @"INVALID", @"descr" : @"Cookie."},
            @(1) : @{@"name" : @"A", @"descr" : @"Host address."},
            @(2) : @{@"name" : @"NS", @"descr" : @"Authoritative server."},
            @(3) : @{@"name" : @"MD", @"descr" : @"Mail destination."},
            @(4) : @{@"name" : @"MF", @"descr" : @"Mail forwarder."},
            @(5) : @{@"name" : @"CNAME", @"descr" : @"Canonical name."},
            @(6) : @{@"name" : @"SOA", @"descr" : @"Start of authority zone."},
            @(7) : @{@"name" : @"MB", @"descr" : @"Mailbox domain name."},
            @(8) : @{@"name" : @"MG", @"descr" : @"Mail group member."},
            @(9) : @{@"name" : @"MR", @"descr" : @"Mail rename name."},
            @(10) : @{@"name" : @"NULL", @"descr" : @"Null resource record."},
            @(11) : @{@"name" : @"WKS", @"descr" : @"Well known service."},
            @(12) : @{@"name" : @"PTR", @"descr" : @"Domain name pointer."},
            @(13) : @{@"name" : @"HINFO", @"descr" : @"Host information."},
            @(14) : @{@"name" : @"MINFO", @"descr" : @"Mailbox information."},
            @(15) : @{@"name" : @"MX", @"descr" : @"Mail routing information."},
            @(16) : @{@"name" : @"TXT", @"descr" : @"Text strings."},
            @(17) : @{@"name" : @"RP", @"descr" : @"Responsible person."},
            @(18) : @{@"name" : @"AFSDB", @"descr" : @"AFS cell database."},
            @(19) : @{@"name" : @"X25", @"descr" : @"X_25 calling address."},
            @(20) : @{@"name" : @"ISDN", @"descr" : @"ISDN calling address."},
            @(21) : @{@"name" : @"RT", @"descr" : @"Router."},
            @(22) : @{@"name" : @"NSAP", @"descr" : @"NSAP address."},
            @(23) : @{@"name" : @"NSAP_PTR", @"descr" : @"Reverse NSAP lookup (deprecated)."},
            @(24) : @{@"name" : @"SIG", @"descr" : @"Security signature."},
            @(25) : @{@"name" : @"KEY", @"descr" : @"Security key."},
            @(26) : @{@"name" : @"PX", @"descr" : @"X.400 mail mapping."},
            @(27) : @{@"name" : @"GPOS", @"descr" : @"Geographical position (withdrawn)."},
            @(28) : @{@"name" : @"AAAA", @"descr" : @"Ip6 Address."},
            @(29) : @{@"name" : @"LOC", @"descr" : @"Location Information."},
            @(30) : @{@"name" : @"NXT", @"descr" : @"Next domain (security)."},
            @(31) : @{@"name" : @"EID", @"descr" : @"Endpoint identifier."},
            @(32) : @{@"name" : @"NIMLOC", @"descr" : @"Nimrod Locator."},
            @(33) : @{@"name" : @"SRV", @"descr" : @"Server Selection."},
            @(34) : @{@"name" : @"ATMA", @"descr" : @"ATM Address"},
            @(35) : @{@"name" : @"NAPTR", @"descr" : @"Naming Authority PoinTeR"},
            @(36) : @{@"name" : @"KX", @"descr" : @"Key Exchange"},
            @(37) : @{@"name" : @"CERT", @"descr" : @"Certification record"},
            @(38) : @{@"name" : @"A6", @"descr" : @"IPv6 address (deprecates AAAA)"},
            @(39) : @{@"name" : @"DNAME", @"descr" : @"Non-terminal DNAME (for IPv6)"},
            @(40) : @{@"name" : @"SINK", @"descr" : @"Kitchen sink (experimentatl)"},
            @(41) : @{@"name" : @"OPT", @"descr" : @"EDNS0 option (meta-RR)"},
            @(249) : @{@"name" : @"TKEY", @"descr" : @"Transaction key"},
            @(250) : @{@"name" : @"TSIG", @"descr" : @"Transaction signature."},
            @(251) : @{@"name" : @"IXFR", @"descr" : @"Incremental zone transfer."},
            @(252) : @{@"name" : @"AXFR", @"descr" : @"Transfer zone of authority."},
            @(253) : @{@"name" : @"MAILB", @"descr" : @"Transfer mailbox records."},
            @(254) : @{@"name" : @"MAILA", @"descr" : @"Transfer mail agent records."},
            @(255) : @{@"name" : @"ANY", @"descr" : @"Wildcard match."},
            @(256) : @{@"name" : @"ZXFR", @"descr" : @"BIND-specific, nonstandard."},
            @(65536) : @{@"name" : @"MAX", @"descr" : @"Max value."}
        };
    }
}

+ (APDnsResourceType *)type:(u_int16_t)value{
    
    APDnsResourceType *theType = [APDnsResourceType new];
    theType.intValue = value;
    
    return theType;
}

- (NSString *)description{
    
    return _types[@(self.intValue)][@"name"];
}

- (NSString *)humanReadable{
    
    return _types[@(self.intValue)][@"descr"];
}

@end
