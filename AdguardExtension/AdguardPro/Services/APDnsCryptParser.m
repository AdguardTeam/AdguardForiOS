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


#import "APDnsCryptParser.h"

typedef enum : NSUInteger {
    Name,
    FullName,
    Description,
    Location,
    Coordinates,
    URL,
    Version,
    DNSSECValidation,
    NoLogs,
    Namecoin,
    ResolverAddress,
    ProviderName,
    ProviderPublicKey,
    ProviderPublicKeyTXTRecord
}APDnsCryptParserFields;

/////////////////////////////////////////////////////////////////////
#pragma mark - APDnsCryptParser

@implementation APDnsCryptParser {
    
    NSMutableArray* _servers;
    APDnsServerObject* _currentServer;
    APDnsCryptParserCallback _callback;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (void)parseServers:(APDnsCryptParserCallback)callback {
    
    _callback = callback;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"dnscrypt-resolvers" withExtension:@"csv"];
    
    CHCSVParser* parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:url];
    parser.sanitizesFields = YES;
    
    parser.delegate = self;
    
    [parser parse];
}

#pragma mark CHCSVParserDelegate methods

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    
    _servers = [NSMutableArray new];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {

    _currentServer = [APDnsServerObject new];
    
    _currentServer.editable = NO;
    _currentServer.isDnsCrypt = @(YES);
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    
    if(recordNumber != 1) {
        // do not add field captions
        [_servers addObject:_currentServer];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    
    switch (fieldIndex) {
            
        case Name:
            _currentServer.dnsCryptId = field;
            break;
            
        case FullName:
            _currentServer.serverName = field;
            break;
            
        case Description:
            _currentServer.serverDescription = field;
            break;
            
        case Location:
            _currentServer.dnsCryptLocation = field;
            break;
            
        case Coordinates:
            _currentServer.dnsCryptCoordinates = field;
            break;
            
        case URL:
            _currentServer.dnsCryptURL = field;
            break;
            
        case Version:
            _currentServer.dnsCryptVersion = field;
            break;
            
        case  DNSSECValidation:
            _currentServer.dnsCryptDNSSECValidation = field;
            break;
            
        case NoLogs:
            _currentServer.dnsCryptNoLogs = field;
            break;
            
        case Namecoin:
            _currentServer.dnsCryptNamecoin = field;
            break;
       
        case ResolverAddress:
            _currentServer.dnsCryptResolverAddress = field;
            break;
            
        case ProviderName:
            _currentServer.dnsCryptProviderName = field;
            break;
            
        case ProviderPublicKey:
            _currentServer.dnsCryptProviderPublicKey = field;
            break;
            
        case ProviderPublicKeyTXTRecord:
            _currentServer.dnsCryptProviderPublicKeyTXTRecord = field;
            break;
            
        default:
            break;
    }
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
    
    _callback([_servers copy]);
}

@end
