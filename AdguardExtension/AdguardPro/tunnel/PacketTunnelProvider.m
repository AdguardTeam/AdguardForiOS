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

#import "PacketTunnelProvider.h"
#import "app.h"

#import <UIKit/UIDevice.h>

#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "APTunnelConnectionsHandler.h"
#import "APSharedResources.h"
#import "APTunnelConnectionsHandler.h"
#import "APDnsServerObject.h"

#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "APWhitelistDomainObject.h"
#import "AEBlacklistDomainObject.h"
#import "ASDatabase.h"
#import "ACNIPUtils.h"
#import "APDnsServerAddress.h"
#import "APBlockingSubscriptionsManager.h"
#import "ACNCidrRange.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>
#include <net/if.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider Constants

NSString *APTunnelProviderErrorDomain = @"APTunnelProviderErrorDomain";

#define V_REMOTE_ADDRESS                        @"127.1.1.1"

#define V_INTERFACE_IPV4_ADDRESS                @"172.16.209.2"
#define V_INTERFACE_IPV4_MASK                   @"255.255.255.252"
#define V_INTERFACE_IPV4_FULL_MASK              @"255.255.255.255"

#define V_INTERFACE_IPV6_ADDRESS                @"fd12:1:1:1::2"
#define V_INTERFACE_IPV6_MASK                   @(64)
#define V_INTERFACE_IPV6_FULL_MASK              @(128)

#define V_DNS_IPV6_ADDRESS                      @"2001:ad00:ad00::ad00"
#define V_DNS_IPV6_ADDRESS2                     @"2001:ad00:ad00::ad01"

#define V_DNS_IPV4_ADDRESS                      @"121.121.121.121"
#define V_DNS_IPV4_ADDRESS2                     @"121.121.121.122"
#define V_DNS_IPV4_ADDRESS3                     @"121.121.121.123"
#define V_DNS_IPV4_ADDRESS4                     @"121.121.121.124"

#define V_DNSCRYPT_LOCAL_ADDDRESS               @"127.0.0.1"
#define V_DNSCRYPT_LOCAL_PORT                   @"8853"


/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider

@implementation NEIPv6Route(cidr)

+ (NEIPv6Route*) ipv6RouteWithCidr:(NSString*)cidr {
    
    NSArray* components = [cidr componentsSeparatedByString:@"/"];
    if(components.count != 2)
        return nil;
    
    NSString* dest = components[0];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *mask = [formatter numberFromString:components[1]];
    
    return [[NEIPv6Route alloc] initWithDestinationAddress:dest networkPrefixLength:mask];
}



@end

@implementation NEIPv4Route(cidr)
+ (NEIPv4Route*) ipv4RouteWithCidr:(NSString*)cidr {
    
    NSArray* components = [cidr componentsSeparatedByString:@"/"];
    if(components.count != 2)
        return nil;
    
    NSString* dest = components[0];
    
    int maskLength = [components[1] intValue];
    in_addr_t maskLong = 0xffffffff >> (32 - maskLength) << (32 - maskLength);
    maskLong = CFSwapInt32(maskLong);
    const char *buf = addr2ascii(AF_INET, &maskLong, sizeof(maskLong), NULL);
    NSString *mask = [NSString stringWithCString:buf
                                        encoding:NSUTF8StringEncoding];
    
    return [[NEIPv4Route alloc] initWithDestinationAddress:dest subnetMask:mask];
}
@end

@implementation PacketTunnelProvider{
    
    void (^pendingStartCompletion)(NSError *error);
    void (^pendingStopCompletion)(void);
    
    APDnsServerObject *_currentServer;
    BOOL    _localFiltering;
    BOOL    _isRemoteServer;
    APVpnManagerTunnelMode _tunnelMode;
    
    Reachability *_reachabilityHandler;
    APTunnelConnectionsHandler *_connectionHandler;
    
    NetworkStatus _lastReachabilityStatus;
    
    dispatch_queue_t _dnsCryptDispatchQueue;
    void (^_dnsCryptEndBlock)();
}

+ (void)initialize{
    
    if (self == [PacketTunnelProvider class]) {
        
        // Init Logger
        [[ACLLogger singleton] initLogger:[AESharedResources sharedAppLogsURL]];
        
#if DEBUG
        [[ACLLogger singleton] setLogLevel:ACLLVerboseLevel];
#endif
        
    }
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        // Create connection handler
        _connectionHandler = [[APTunnelConnectionsHandler alloc] initWithProvider:self];
        [_connectionHandler setDnsActivityLoggingEnabled:YES];

        _reachabilityHandler = [Reachability reachabilityForInternetConnection];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachNotify:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Controll connection methods

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler
{
    DDLogInfo(@"(PacketTunnelProvider) Start Tunnel Event");
    
    pendingStartCompletion = completionHandler;
    
    [_reachabilityHandler startNotifier];
    _lastReachabilityStatus = [_reachabilityHandler currentReachabilityStatus];
    
    __typeof__(self) __weak wSelf = self;
    
    [self updateTunnelSettingsWithCompletionHandler:^(NSError * _Nullable error) {
        
        __typeof__(self) sSelf = wSelf;
        if(!sSelf)
            return;
        
        if (sSelf->_connectionHandler) {
            [sSelf->_connectionHandler startHandlingPackets];
            DDLogInfo(@"(PacketTunnelProvider) connectionHandler started handling packets.");
        }
        
        if(sSelf->pendingStartCompletion) {
            DDLogInfo(@"(PacketTunnelProvider) Call pendingStartCompletion.");
            sSelf->pendingStartCompletion(error);
            sSelf->pendingStartCompletion = nil;
        }
        
        if(_currentServer.isDnsCrypt.boolValue) {
            
            [self startDnscryptProxy];
        }
    }];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
	// Add code here to start the process of stopping the tunnel.
    DDLogInfo(@"(PacketTunnelProvider) Stop Tunnel Event");
    
    NSString *reasonString;
    
    switch (reason) {
        case NEProviderStopReasonNone:
            reasonString = @"NEProviderStopReasonNone No specific reason. ";
            break;
        case NEProviderStopReasonUserInitiated:
            reasonString = @"NEProviderStopReasonUserInitiated The user stopped the provider. ";
            break;
        case NEProviderStopReasonProviderFailed:
            reasonString = @"NEProviderStopReasonProviderFailed The provider failed. ";
            break;
        case NEProviderStopReasonNoNetworkAvailable:
            reasonString = @"NEProviderStopReasonNoNetworkAvailable There is no network connectivity. ";
            break;
        case NEProviderStopReasonUnrecoverableNetworkChange:
            reasonString = @"NEProviderStopReasonUnrecoverableNetworkChange The device attached to a new network. ";
            break;
        case NEProviderStopReasonProviderDisabled:
            reasonString = @"NEProviderStopReasonProviderDisabled The provider was disabled. ";
            break;
        case NEProviderStopReasonAuthenticationCanceled:
            reasonString = @"NEProviderStopReasonAuthenticationCanceled The authentication process was cancelled. ";
            break;
        case NEProviderStopReasonConfigurationFailed:
            reasonString = @"NEProviderStopReasonConfigurationFailed The provider could not be configured. ";
            break;
        case NEProviderStopReasonIdleTimeout:
            reasonString = @"NEProviderStopReasonIdleTimeout The provider was idle for too long. ";
            break;
        case NEProviderStopReasonConfigurationDisabled:
            reasonString = @"NEProviderStopReasonConfigurationDisabled The associated configuration was disabled. ";
            break;
        case NEProviderStopReasonConfigurationRemoved:
            reasonString = @"NEProviderStopReasonConfigurationRemoved The associated configuration was deleted. ";
            break;
        case NEProviderStopReasonSuperceded:
            reasonString = @"NEProviderStopReasonSuperceded A high-priority configuration was started. ";
            break;
        case NEProviderStopReasonUserLogout:
            reasonString = @"NEProviderStopReasonUserLogout The user logged out. ";
            break;
        case NEProviderStopReasonUserSwitch:
            reasonString = @"NEProviderStopReasonUserSwitch The active user changed. ";
            break;
        case NEProviderStopReasonConnectionFailed:
            reasonString = @"NEProviderStopReasonConnectionFailed Failed to establish connection. ";
            break;
            
        default:
            reasonString = @"Unknown reason. ";
            
    }
    DDLogInfo(@"(PacketTunnelProvider) Stop Tunnel Reason String:\n%@", reasonString);
    
    [_reachabilityHandler stopNotifier];
    
    pendingStartCompletion = nil;
    pendingStopCompletion = completionHandler;
    
    [self logNetworkInterfaces];
    
    if(_currentServer.isDnsCrypt.boolValue) {
        [self stopDnscryptProxyWithCallback:^{
            [self closeConnections];
        }];
    }
    else {
        [self closeConnections];
    }
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler
{
    DDLogInfo(@"(PacketTunnelProvider) Handle Message Event");
    
        switch ([APSharedResources host2tunnelMessageType:messageData]) {
            case APHTMLoggingEnabled:
                //Log enabled
                [_connectionHandler setDnsActivityLoggingEnabled:YES];
                DDLogInfo(@"(PacketTunnelProvider) Handled LoggingEnabled Message Event");
                break;
                
            case APHTMLoggingDisabled:
                //Log disabled
                [_connectionHandler setDnsActivityLoggingEnabled:NO];
                DDLogInfo(@"(PacketTunnelProvider) Handled LoggingDisabled Message Event");
                break;
                
            case APHTMLSystemWideDomainListReload:
                
                DDLogInfo(@"(PacketTunnelProvider) Domains lists changed. Reconnecting..");
            
                [self updateTunnelSettingsWithCompletionHandler:nil];

                break;
                
            default:
                break;
        }
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler
{
	// Add code here to get ready to sleep.
    DDLogInfo(@"(PacketTunnelProvider) Sleep Event");
    
    [self logNetworkInterfaces];
	completionHandler();
}

- (void)wake
{
	// Add code here to wake up.
    DDLogInfo(@"(PacketTunnelProvider) Wake Event");
    [self logNetworkInterfaces];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (APDnsServerObject *)currentDnsServer {
    
    return _currentServer;
}

- (BOOL)localFiltering {
    
    return _localFiltering;
}

- (BOOL)isRemoteServer {

    return _isRemoteServer;
}

- (APVpnManagerTunnelMode)tunnelMode {
    return _tunnelMode;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper methods (private)

- (void)closeConnections {
    [_connectionHandler closeAllConnections:^{
        pendingStartCompletion = nil;
        pendingStopCompletion();
        pendingStopCompletion = nil;
        
        DDLogInfo(@"(PacketTunnelProvider) Stop completion performed.");
    }];
}

- (void)getDNSServersIpv4: (NSArray <APDnsServerAddress *> **) ipv4DNSServers ipv6: (NSArray <APDnsServerAddress *> **) ipv6DNSServers {
  
    NSMutableArray<APDnsServerAddress*> *ipv4s = [NSMutableArray array];
    NSMutableArray<APDnsServerAddress*> *ipv6s = [NSMutableArray array];
    
    @autoreleasepool {
        
        [ACNIPUtils enumerateSystemDnsWithProcessingBlock:^(NSString *ip, NSString *port, BOOL ipv4, BOOL *stop) {
            if(ipv4)
               [ipv4s addObject:[[APDnsServerAddress alloc] initWithIp:ip port:port]];
            else
                [ipv6s addObject:[[APDnsServerAddress alloc] initWithIp:ip port:port]];
        }];
    }
    
    *ipv4DNSServers = [ipv4s copy];
    *ipv6DNSServers = [ipv6s copy];
    
    return;
}

- (void) updateTunnelSettingsWithCompletionHandler:(nullable void (^)( NSError * __nullable error))completionHandler {
    
    // we need to reset network settings to remove our dns servers and read system default dns servers
    ASSIGN_WEAK(self);
    [self setTunnelNetworkSettings:nil completionHandler:^(NSError * _Nullable error) {
        
        ASSIGN_STRONG(self);
        
        [USE_STRONG(self) updateTunnelSettingsInternalWithCompletionHandler:completionHandler];
    }];
}

- (void) updateTunnelSettingsInternalWithCompletionHandler:(nullable void (^)( NSError * __nullable error))completionHandler {
    
    DDLogInfo(@"(PacketTunnelProvider) update Tunnel Settings");
    // Getting DNS
    NETunnelProviderProtocol *protocol = (NETunnelProviderProtocol *)self.protocolConfiguration;
    
    _currentServer = nil;
    NSData *currentServerData = protocol.providerConfiguration[APVpnManagerParameterRemoteDnsServer];
    if (currentServerData) {
        
        _currentServer = [NSKeyedUnarchiver unarchiveObjectWithData:currentServerData];
    }
    
    //protection for bad or old configuration
    if (_currentServer == nil) {
        
        @autoreleasepool {
            _currentServer = APVPNManager.predefinedDnsServers[APVPN_MANAGER_DEFAULT_REMOTE_DNS_SERVER_INDEX];
            _localFiltering = NO;
            _isRemoteServer = YES;
        }
    }
    else {
        
        _localFiltering = [protocol.providerConfiguration[APVpnManagerParameterLocalFiltering] boolValue];
        
        _isRemoteServer = ! [_currentServer.tag isEqualToString:APDnsServerTagLocal];
        
        // in ipv6-only networks we can not use remote dns server
        if(_isRemoteServer && ![ACNIPUtils isIpv4Available]) {
            
            DDLogInfo(@"(PacketTunnelProvider) ipv4 not available. Set _isRemoteServer = NO");
            _isRemoteServer = NO;
        }
    }
    
    
    DDLogInfo(@"(PacketTunnelProvider) Start Tunnel with configuration: %@%@%@", _currentServer.serverName,
              (_localFiltering ? @", LocalFiltering" : @""), (_isRemoteServer ? @", isRemoteServer" : @""));
    
    //create empty tunnel settings
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    DDLogInfo(@"(PacketTunnelProvider) Empty tunnel settings created.");
    
    // Check configuration
    if (!_currentServer.isDnsCrypt.boolValue && !(_currentServer.ipv4Addresses.count || _currentServer.ipv6Addresses.count)) {
        
        DDLogError(@"(PacketTunnelProvider) Can't obtain DNS addresses from protocol configuration.");
    }
    else {
        _tunnelMode = [protocol.providerConfiguration[APVpnManagerParameterTunnelMode] unsignedIntegerValue];
        
        BOOL full = NO;
        BOOL withoutIcon = NO;
        
        NSString* modeName = @"";
        if (_tunnelMode == APVpnManagerTunnelModeSplit){
            modeName = @"SPLIT";
        }
        else if(_tunnelMode == APVpnManagerTunnelModeFull) {
            modeName = @"FULL";
            full = YES;
        }
        else if (_tunnelMode == APVpnManagerTunnelModeFullWithoutVPNIcon) {
            modeName = @"FULL without VPN icon";
            full = YES;
            withoutIcon = YES;
        }
        
        [self logNetworkInterfaces];
        DDLogInfo(@"PacketTunnelProvider) Start Tunnel mode: %@", modeName);
        
        settings = [self createTunnelSettings:full wihoutVPNIcon:withoutIcon];
        DDLogInfo(@"(PacketTunnelProvider) Tunnel settings filled.");
    }
    
    
    // SETs network settings
    __typeof__(self) __weak wSelf = self;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError *_Nullable error) {
        
        __typeof__(self) sSelf = wSelf;
        
        if(error)
            DDLogInfo(@"(PacketTunnelProvider) setTunnelNetworkSettings error : %@", error.localizedDescription);
        
        if(sSelf == nil)
            return;
        
        [sSelf reloadWhitelistBlacklistDomain];
        
        if(completionHandler) {
            
            DDLogInfo(@"(PacketTunnelProvider) update Tunnel Settings ");
            
            completionHandler(error);
        }
        
        [sSelf logNetworkInterfaces];
    }];
}

- (void)reachNotify:(NSNotification *)note {
    
    DDLogInfo(@"(PacketTunnelProvider) reachability Notify");
    
    if(_currentServer.isDnsCrypt.boolValue) {
        
        [self stopDnscryptProxyWithCallback:^{
            [self startDnscryptProxy];
        }];
    }
    
    // sometimes we recieve reach notify right after the tunnel is started(kSCNetworkReachabilityFlagsIsDirect flag changed). In this case the restart of the tunnel enters an infinite loop.
    if(_lastReachabilityStatus == [_reachabilityHandler currentReachabilityStatus]) {
        DDLogInfo(@"(PacketTunnelProvider) network status not changed. Skip reachability notify");
        return;
    }
    
    if(!_reachabilityHandler.isReachable) {
        DDLogInfo(@"(PacketTunnelProvider) network not reachable. Skip reachability notify");
        return;
    }
    
    _lastReachabilityStatus = [_reachabilityHandler currentReachabilityStatus];
    
    [self updateTunnelSettingsWithCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

- (void)reloadWhitelistBlacklistDomain {
    
//    if (_localFiltering == NO) {
//
//        [_connectionHandler setGlobalWhitelistFilter:nil];
//        [_connectionHandler setGlobalBlacklistFilter:nil];
//        [_connectionHandler setUserWhitelistFilter:nil];
//        [_connectionHandler setUserBlacklistFilter:nil];
//
//        DDLogInfo(@"(PacketTunnelProvider) System-Wide Filtering rules set to nil.");
//
//        return;
//    }
//
    @autoreleasepool {

//        AERDomainFilter *globalWhiteRules = [AERDomainFilter filter];
//        AERDomainFilter *globalBlackRules = [AERDomainFilter filter];
//
//        NSArray *rules;
//        @autoreleasepool {
//
//            // Init database and get rules
//            NSURL *dbURL = [[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:AE_PRODUCTION_DB];
//
//            [[ASDatabase singleton] initDbWithURL:dbURL upgradeDefaultDb:NO];
//            NSError *error = [[ASDatabase singleton] error];
//            if (!error) {
//
//                AESAntibanner *antibanner = [[AEService new] antibanner];
//                rules = [antibanner rulesForFilter:@(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)];
//
//                DDLogInfo(@"(PacketTunnelProvider) Count of rules, which was loaded from simple domain names filter: %lu.", rules.count);
//            }
//
//            [ASDatabase destroySingleton];
//            //--------------------------
//            if (rules.count == 0 && _isRemoteServer == NO) {
//
//                DDLogError(@"(PacketTunnelProvider) We switch filtration to default remote server.");
//                @autoreleasepool {
//                    _currentServer = APVPNManager.predefinedDnsServers[APVPN_MANAGER_DEFAULT_REMOTE_DNS_SERVER_INDEX];
//                    _isRemoteServer = YES;
//                }
//            }
//        }
//
//        @autoreleasepool {
//
//            AERDomainFilterRule *rule;
//            for (ASDFilterRule *item in rules) {
//
//                rule = [AERDomainFilterRule rule:item.ruleText];
//
//                if (rule.whiteListRule) {
//                    [globalWhiteRules addRule:rule];
//                }
//                else {
//
//                    [globalBlackRules addRule:rule];
//                }
//            }
//        }
//
//        [_connectionHandler setGlobalWhitelistFilter:globalWhiteRules];
//        [_connectionHandler setGlobalBlacklistFilter:globalBlackRules];
//
//        DDLogInfo(@"(PacketTunnelProvider) Loaded whitelist rules: %lu, blacklist rules: %lu.", globalWhiteRules.rulesCount, globalBlackRules.rulesCount);
        
        AERDomainFilter *userWhiteRules = [AERDomainFilter filter];
        AERDomainFilter *userBlackRules = [AERDomainFilter filter];
        AERDomainFilter *trackersRules = [AERDomainFilter filter];
        
        @autoreleasepool {
            NSArray *domainList = APSharedResources.whitelistDomains;
            for (NSString *item in domainList) {
                
                NSString *ruleText = [[[[APWhitelistDomainObject alloc] initWithDomain:item] rule] ruleText];
                if (ruleText) {
                    
                    [userWhiteRules addRule:[AERDomainFilterRule rule:ruleText]];
                }
            }
        }
        
        @autoreleasepool {
            NSArray *domainList = APSharedResources.blacklistDomains;
            for (NSString *ruleText in domainList) {
                
                if (ruleText) {
                    
                    AERDomainFilterRule* rule = [AERDomainFilterRule rule:ruleText];
                    if(rule.whiteListRule) {
                        
                        [userWhiteRules addRule:rule];
                    }
                    else {
                        
                        [userBlackRules addRule:rule];
                    }
                }
            }
        }
        
        @autoreleasepool {
            NSDictionary *domainList = [APSharedResources loadTrackerslistDomainsAndCacheResult:NO];
            __block NSUInteger counter = 0;
            [domainList enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString* domain = key;
                //NSString* name = obj;
                
                [trackersRules addRule:[AERDomainFilterRule rule:domain]];
                
                counter++;
            }];
            DDLogInfo(@"(PacketTunnelProvider) User trackers rules: %lu", counter);
        }
        
        [_connectionHandler setUserWhitelistFilter:nil];
        [_connectionHandler setUserBlacklistFilter:nil];
        [_connectionHandler setTrackersFilter:nil];
        [_connectionHandler setHostsFilter:nil];
        [_connectionHandler setGlobalBlacklistFilter:nil];
        
        AERDomainFilter *subscriptionRules = [AERDomainFilter filter];
       
        NSArray* subscriptionRulesStrings = [APBlockingSubscriptionsManager loadRules];
        
        for (NSString* ruleString in subscriptionRulesStrings) {
            [subscriptionRules addRule:[AERDomainFilterRule rule:ruleString]];
        }
        
        NSMutableDictionary* hosts = [[NSMutableDictionary alloc] initWithDictionary:APSharedResources.hosts];
        NSDictionary *subscriptionsHosts = [APBlockingSubscriptionsManager loadHosts];
        [hosts addEntriesFromDictionary:subscriptionsHosts];
        
        [_connectionHandler setUserWhitelistFilter:userWhiteRules];
        [_connectionHandler setUserBlacklistFilter:userBlackRules];
        [_connectionHandler setTrackersFilter:trackersRules];
        
        [_connectionHandler setHostsFilter:hosts];
        
        [_connectionHandler setGlobalBlacklistFilter:subscriptionRules];
        
        DDLogInfo(@"(PacketTunnelProvider) User whitelist rules: %lu", userWhiteRules.rulesCount);
        DDLogInfo(@"(PacketTunnelProvider) User blacklist rules: %lu", userBlackRules.rulesCount);
    }
}

/**
 returns array of ipv4 exclude ranges for full tunnel modes
 
 withoutVPNIcon - it is a hack. If we add range 0.0.0.0 with mask 31 or lower to exclude routes, then vpn icon appears.
 It is important to understand that it's not just about the icon itself.
 The appearance and disappearance of the icon causes different strangeness in the behavior of the system.
 In mode "with the icon" does not work facetime(https://github.com/AdguardTeam/AdguardForiOS/issues/501).
 Perhaps some other apple services use the address 0.0.0.0 and does not work.
 In the "no icon" mode, you can not disable wi-fi(https://github.com/AdguardTeam/AdguardForiOS/issues/674).
 This behavior leads to crashes in ios 11.3 beta.
 
 NOTE. To show VPN icon it's enough to add either 0.0.0.0/(0-31) to ipv4 excludes or ::/(0-127) to ipv6 exclude routes.
 */
- (NSArray<NEIPv4Route *> *) ipv4ExcludedRoutesWithoutVPNIcon:(BOOL) withoutVPNIcon {
    
    NSMutableArray *ipv4excludeRoutes = [NSMutableArray new];
    
    ACNCidrRange *defaultRoute = [[ACNCidrRange alloc]initWithCidrString:@"0.0.0.0/0"];
    
    NSArray<ACNCidrRange*> * dnsRanges = @[
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV4_ADDRESS],
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV4_ADDRESS2],
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV4_ADDRESS3],
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV4_ADDRESS4]
                                           ];
    
    if(!withoutVPNIcon) {
        // see comment in method header
        dnsRanges = [dnsRanges arrayByAddingObject:[[ACNCidrRange alloc]initWithCidrString:@"0.0.0.0/31"]];
    }
    
    NSArray<ACNCidrRange*> *excludedRanges = [ACNCidrRange excludeFrom:@[defaultRoute] excludedRanges:dnsRanges];
    
    for (ACNCidrRange* range in excludedRanges) {
        NSString* cidr = [range toString];
        [ipv4excludeRoutes addObject:[NEIPv4Route ipv4RouteWithCidr:cidr]];
    }
    
    return ipv4excludeRoutes;
}

/**
 returns array of ipv6 ыexclude ranges for full tunnel modes
 
 NOTE. detailed description in the ipv4ExcludedRoutesWithoutVPNIcon header
 */
- (NSArray<NEIPv6Route *> *) ipv6ExcludedRoutesWithoutVPNIcon:(BOOL) withoutVPNIcon {
    
    NSMutableArray *ipv6ExcludedRoutes = [NSMutableArray new];
    
    ACNCidrRange *defaultRoute = [[ACNCidrRange alloc]initWithCidrString:@"::/0"];
    NSArray<ACNCidrRange*> * dnsRanges = @[
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV6_ADDRESS],
                                           [[ACNCidrRange alloc]initWithCidrString:V_DNS_IPV6_ADDRESS2]
                                           ];
    
    if(!withoutVPNIcon) {
        dnsRanges = [dnsRanges arrayByAddingObject:[[ACNCidrRange alloc]initWithCidrString:@"::/127"]];
    }
    
    NSArray<ACNCidrRange*> *excludedRanges = [ACNCidrRange excludeFrom:@[defaultRoute] excludedRanges:dnsRanges];
    
    for (ACNCidrRange* range in excludedRanges) {
        NSString* cidr = [range toString];
        [ipv6ExcludedRoutes addObject:[NEIPv6Route ipv6RouteWithCidr:cidr]];
    }
    
    return ipv6ExcludedRoutes;
}

- (NEPacketTunnelNetworkSettings *)createTunnelSettings: (BOOL)fullTunnel wihoutVPNIcon:(BOOL)withoutVPNIcon {

    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    BOOL dnsCrypt = _currentServer.isDnsCrypt.boolValue;
    
    // DNS
    
    NSArray<APDnsServerAddress*> *deviceIpv4DnsServers;
    NSArray<APDnsServerAddress*> *deviceIpv6DnsServers;
    
    [self getDNSServersIpv4:&deviceIpv4DnsServers ipv6:&deviceIpv6DnsServers];
    
    BOOL ipv6Available = [ACNIPUtils isIpv6Available];
    BOOL ipv4Available = [ACNIPUtils isIpv4Available];
    
    NSMutableArray<APDnsServerAddress*> *deviceDnsServers = [NSMutableArray new];
    [deviceDnsServers addObjectsFromArray:deviceIpv4DnsServers];
    [deviceDnsServers addObjectsFromArray:deviceIpv6DnsServers];
    
    NSMutableArray<APDnsServerAddress*> *remoteDnsIpv4Addresses = [NSMutableArray new];
    NSMutableArray<APDnsServerAddress*> *remoteDnsIpv6Addresses = [NSMutableArray new];
    
    if(_isRemoteServer) {
        
        if(dnsCrypt) {
            
            APDnsServerAddress* localAddress = [[APDnsServerAddress alloc] initWithIp:V_DNSCRYPT_LOCAL_ADDDRESS port:V_DNSCRYPT_LOCAL_PORT];
            
            [remoteDnsIpv4Addresses addObject:localAddress];
        }
        else {
            
            [remoteDnsIpv4Addresses addObjectsFromArray:_currentServer.ipv4Addresses];
            [remoteDnsIpv6Addresses addObjectsFromArray:_currentServer.ipv6Addresses];
        }
    }
    
    NSArray<NSString*>* fakeIpv4DnsAddresses = ipv4Available ? @[V_DNS_IPV4_ADDRESS, V_DNS_IPV4_ADDRESS2, V_DNS_IPV4_ADDRESS3, V_DNS_IPV4_ADDRESS4] : @[];
    NSArray<NSString*>* fakeIpv6DnsAddresses = (ipv6Available && !dnsCrypt) ? @[V_DNS_IPV6_ADDRESS, V_DNS_IPV6_ADDRESS2] : @[];
    NSMutableArray* fakeDnsAddresses = [NSMutableArray new];
    [fakeDnsAddresses addObjectsFromArray:fakeIpv4DnsAddresses];
    [fakeDnsAddresses addObjectsFromArray:fakeIpv6DnsAddresses];
   
    [_connectionHandler setDeviceDnsAddressesIpv4:deviceIpv4DnsServers
                           deviceDnsAddressesIpv6:deviceIpv6DnsServers
                    adguardRemoteDnsAddressesIpv4:remoteDnsIpv4Addresses
                    adguardRemoteDnsAddressesIpv6:remoteDnsIpv6Addresses
                      adguardFakeDnsAddressesIpv4:fakeIpv4DnsAddresses
                      adguardFakeDnsAddressesIpv6:fakeIpv6DnsAddresses];
    
    NEDNSSettings *dns = [[NEDNSSettings alloc] initWithServers: fakeDnsAddresses];
    
    dns.matchDomains = @[ @"" ];
    
    settings.DNSSettings = dns;
    
    // exclude routes
    
    NEIPv4Settings *ipv4 = [[NEIPv4Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV4_ADDRESS]
                            subnetMasks:@[V_INTERFACE_IPV4_MASK]];
    
    
    NEIPv6Settings *ipv6 = [[NEIPv6Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV6_ADDRESS]
                            networkPrefixLengths:@[V_INTERFACE_IPV6_MASK]];
    
    
    // include routes
    
    if(fullTunnel) {
        
        ipv4.includedRoutes = @[[NEIPv4Route defaultRoute]];
        ipv6.includedRoutes = @[[NEIPv6Route defaultRoute]];
        
        // To reduce the negative effects of "vpn icon", we don't exclude the zero route only for the IPv6 if it possible
        BOOL ipv4WithoutIcon = withoutVPNIcon || ipv6Available;
        
        ipv4.excludedRoutes = [self ipv4ExcludedRoutesWithoutVPNIcon:ipv4WithoutIcon];
        ipv6.excludedRoutes = [self ipv6ExcludedRoutesWithoutVPNIcon:withoutVPNIcon];
    }
    else {
        
        NSMutableArray* ipv4IncludedRoutes = [NSMutableArray new];
        for(NSString* dns in fakeIpv4DnsAddresses) {
            
            [ipv4IncludedRoutes addObject:[[NEIPv4Route alloc] initWithDestinationAddress:dns
                                                                              subnetMask:V_INTERFACE_IPV4_FULL_MASK]];
        }
        
        NSMutableArray* ipv6IncludedRoutes = [NSMutableArray new];
        for(NSString* dns in fakeIpv6DnsAddresses) {
            [ipv6IncludedRoutes addObject:[[NEIPv6Route alloc] initWithDestinationAddress:dns
                                                                     networkPrefixLength:V_INTERFACE_IPV6_FULL_MASK]];
        }
        
        ipv4.includedRoutes = ipv4IncludedRoutes;
        ipv6.includedRoutes = ipv6IncludedRoutes;
        
        ipv4.excludedRoutes = @[[NEIPv4Route defaultRoute]];
        ipv6.excludedRoutes = @[[NEIPv6Route defaultRoute]];
    }
    
    if(ipv4Available) {
        settings.IPv4Settings = ipv4;
    }
    
    if(ipv6Available) {
        settings.IPv6Settings = ipv6;
    }
    
    return settings;
}

- (void)logNetworkInterfaces {
    
    NSMutableString* log = [NSMutableString new];
    
    [ACNIPUtils enumerateNetworkInterfacesWithProcessingBlock:^(struct ifaddrs *addr, BOOL *stop) {
        
        NSString* address;
        if(addr->ifa_addr->sa_family == AF_INET){
            address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)addr->ifa_addr)->sin_addr)];
            
            NSString* interfaceString = [NSString stringWithFormat:@"%@/ipv4:%@", [NSString stringWithUTF8String:addr->ifa_name], address];
            [log appendFormat:@"%@\n", interfaceString];
        }
        else if(addr->ifa_addr->sa_family == AF_INET6){
            char ip[INET6_ADDRSTRLEN];
            const char *str = inet_ntop(AF_INET6, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), ip, INET6_ADDRSTRLEN);
            
            address = [NSString stringWithUTF8String:str];
            
            NSString* interfaceString = [NSString stringWithFormat:@"%@/ipv6:%@", [NSString stringWithUTF8String:addr->ifa_name], address];
            [log appendFormat:@"%@\n", interfaceString];
        }
    }];
    
    DDLogInfo(@"(PacketTunnelProvider) Available network interfaces:\n%@", log);
}

- (void) startDnscryptProxy {
    
    if(!_dnsCryptDispatchQueue) {
        _dnsCryptDispatchQueue = dispatch_queue_create("dns_crypt_queue", DISPATCH_QUEUE_SERIAL);
    }
    
    dispatch_async(_dnsCryptDispatchQueue, ^{
        
        NSString* localAddress = [NSString stringWithFormat:@"%@:%@", V_DNSCRYPT_LOCAL_ADDDRESS, V_DNSCRYPT_LOCAL_PORT];
        
        const char* argv[] = { "proxy",
            "--local-address", localAddress.UTF8String,
            "--provider-name", _currentServer.dnsCryptProviderName.UTF8String,
            "--provider-key", _currentServer.dnsCryptProviderPublicKey.UTF8String,
            "--resolver-address", _currentServer.dnsCryptResolverAddress.UTF8String,
            };
        
        int argc = 9;
        
        NSMutableString* args = [NSMutableString new];
        
        for(int i = 0; i < argc; ++i) {
            
            [args appendFormat:@"%s ", (char*) argv[i]];
        }
        
        DDLogInfo(@"(PacketTunnelProvider) start dns crypt proxy with args: %@", args);
        
        if(dnscrypt_proxy_main(argc, (char **)argv) != 0) {
        
            DDLogError(@"(PacketTunnelProvider) can't start dns crypt proxy");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(_dnsCryptEndBlock) {
                _dnsCryptEndBlock();
                
                _dnsCryptEndBlock = nil;
            }
        });
    });
}

- (void) stopDnscryptProxyWithCallback:(void (^)())callback {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        _dnsCryptEndBlock = ^void() {
            
            if(callback) {
                callback();
            }
        };
        
        dnscrypt_proxy_loop_break();
    });
}

@end
