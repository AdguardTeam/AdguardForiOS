/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
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

#import "APSProductSchemaManager.h"
#import "ACommons/ACLang.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "ASDFilterObjects.h"
#import "APVPNManager.h"
#import "ABECServicesParser.h"
#import "APSharedResources.h"

@implementation APSProductSchemaManager

+ (BOOL)onInstall {
    
    BOOL result = [super onInstall];
    if (result) {
        
        //set VPN Manager
        [self installDefaultSettingsForVPNManager];
        
        //setup trackers
        [self installTrackersDomainList];
        
    }
    return result;
}

+ (void)upgrade {
    
    [super upgrade];
}

+ (BOOL)onUpgradeFrom:(NSNumber *)from to:(NSNumber *)to {
    
    DDLogInfo(@"(APSProductSchemaManager) upgrade from:%@ to:%@ started.", from, to);
    
    BOOL result = [super onUpgradeFrom:from to:to];
    if (result) {
        
        if (from == nil) {
            
            if ([to isEqual:@(1)]) {
                // Upgrade from 1.1.* or 1.2.0 to 1.2.1
                DDLogInfo(@"(APSProductSchemaManager) Upgrade from 1.1.* or 1.2.0 to 1.2.1");
                
                //install filter
                result = [self installSimpleDomainnamesFilter];
                if (result) {
                    
                    //set VPN Manager
                    [self installDefaultSettingsForVPNManager];
                }
            }
        }
    }
    return result;
}

+ (void)onMinorUpgrade {
    
    [super onMinorUpgrade];
    
    [self installTrackersDomainList];
    [APVPNManager.singleton removeCustomRemoteServersDuplicates];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (private)

+ (BOOL)installSimpleDomainnamesFilter {
    
    
    BOOL result = NO;
    
    AESAntibanner *antibanner = [[AEService singleton] antibanner];
    NSArray *filters = [[[antibanner metadataForSubscribe:NO] filters]
                        filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterId == %@", @(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)]];
    if (filters.count == 1) {
        ASDFilterMetadata *filter = filters[0];
        
        filter.removable = @(NO);
        filter.editable = @(NO);
        filter.enabled = @(NO);
        
        result = [antibanner subscribeFilters:filters jobController:nil];
    }
    
    if (result) {
        
        DDLogInfo(@"(APSProductSchemaManager) Simplified domain names filter installed.");
    }
    else {
        
        DDLogError(@"(APSProductSchemaManager) Error occurred when install Simplified domain names filter.");
        DDLogErrorTrace();
    }
    
    return result;

}

+ (BOOL) installTrackersDomainList {
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"services" ofType: @"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    ABECServicesParser* parser = [ABECServicesParser new];
    [parser parseData:data];
    
    APSharedResources.trackerslistDomains = parser.hosts;
    
    return YES;
}

+ (void)installDefaultSettingsForVPNManagerV9 {

    //APVPNManager.singleton.localFiltering = NO;
    APVPNManager.singleton.activeRemoteDnsServer =
     APVPNManager.predefinedDnsServers[APVPN_MANAGER_DEFAULT_REMOTE_DNS_SERVER_INDEX];
    DDLogInfo(@"(APSProductSchemaManager) VPN Manager: local filtering = NO, default remote DNS server.");

}

+ (void)installDefaultSettingsForVPNManagerV10 {
    
    //APVPNManager.singleton.localFiltering = YES;
    APVPNManager.singleton.activeRemoteDnsServer =
    APVPNManager.predefinedDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
    DDLogInfo(@"(APSProductSchemaManager) VPN Manager: local filtering = YES, system default DNS server.");
}

+ (void)installDefaultSettingsForVPNManager {
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version < 10.0) {
        
        [self installDefaultSettingsForVPNManagerV9];
        
    }
    else {
        [self installDefaultSettingsForVPNManagerV10];
    }

}
@end
