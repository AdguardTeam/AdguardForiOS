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

#import "APUIDnsLogRecord.h"
#import "APDnsRequest.h"
#import "APDnsResponse.h"
#import "AEUICommons.h"

#define DATE_FORMAT(DATE)   [NSDateFormatter localizedStringFromDate:DATE dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]


@implementation APUIDnsLogRecord

- (id)initWithRecord:(APDnsLogRecord *)record {
    
    if (!record) {
        return nil;
    }
    
    self = [self init];
    if (self) {
        
        _representedObject = record;
        
        if (!record.requests.count) {
            return nil;
        }
        APDnsResponse *response = record.preferredResponse;
        
        APDnsRequest *request = record.requests[0];
        
        _text = request.name;
        
        if (response) {
            
            if (response.blocked) {
                _color = AEUIC_WARNING_COLOR;
                _detailText = [NSString stringWithFormat:NSLocalizedString(@"%@ - Blocked", @"(APUIDnsLogRecord) PRO version. On the System-wide Ad Blocking -> DNS Requests screen. It is the complementary text below the blocked DNS request."), DATE_FORMAT(record.recordDate)];
            } else {
                
                _color = [UIColor whiteColor];
                NSArray *responses = [record.responses valueForKey:@"stringValue"];
                if (record.isWhitelisted) {

                    _detailText = [NSString stringWithFormat:NSLocalizedString(@"%@ - Exception %@", @"(APUIDnsLogRecord) PRO version. On the System-wide Ad Blocking -> DNS Requests screen. It is the complementary text below the whitelisted DNS request."), DATE_FORMAT(record.recordDate), [responses componentsJoinedByString:@", "]];
                } else {
                    _detailText = [NSString stringWithFormat:@"%@ - %@", DATE_FORMAT(record.recordDate), [responses componentsJoinedByString:@", "]];
                }
            }
        }
        else{
            
            _color = [UIColor whiteColor];
            
            _detailText = [NSString stringWithFormat:NSLocalizedString(@"%@ - No response", @"(APUIDnsLogRecord) PRO version. On the System-wide Ad Blocking -> DNS Requests screen. It is the complementary text below the DNS request without a response."), DATE_FORMAT(record.recordDate)];
        }
        
        if (record.isWhitelisted) {
            _color = AEUIC_EXCEPTION_COLOR;
        }
        else if(record.isTracker) {
            _color = AEUIC_TRACKER_COLOR;
        }
    }
    
    return self;
}

@end
