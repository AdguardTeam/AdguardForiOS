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
    BOOL    _fullTunnel;
    
    Reachability *_reachabilityHandler;
    APTunnelConnectionsHandler *_connectionHandler;
    
    NetworkStatus _lastReachabilityStatus;
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
        [_connectionHandler setDnsActivityLoggingEnabled:[[AESharedResources sharedDefaults] boolForKey:APDefaultsDnsLoggingEnabled]];

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
        
        [sSelf reloadWhitelistBlacklistDomain];
        
        if (sSelf->_connectionHandler) {
            [sSelf->_connectionHandler startHandlingPackets];
            DDLogInfo(@"(PacketTunnelProvider) connectionHandler started handling packets.");
        }
        
        if(sSelf->pendingStartCompletion) {
            DDLogInfo(@"(PacketTunnelProvider) Call pendingStartCompletion.");
            sSelf->pendingStartCompletion(error);
            sSelf->pendingStartCompletion = nil;
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
    
    [_connectionHandler closeAllConnections:^{
        pendingStartCompletion = nil;
        pendingStopCompletion();
        pendingStopCompletion = nil;
        
        DDLogInfo(@"(PacketTunnelProvider) Stop completion performed.");
    }];
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

- (BOOL)isFullMode {
    return _fullTunnel;
}

- (void)getDNSServersIpv4: (NSArray <NSString *> **) ipv4DNSServers ipv6: (NSArray <NSString *> **) ipv6DNSServers {
  
    NSMutableArray *ipv4s = [NSMutableArray array];
    NSMutableArray *ipv6s = [NSMutableArray array];
    
    @autoreleasepool {
        
        res_state res = malloc(sizeof(struct __res_state));
        int result = res_ninit(res);
        if (result == 0) {
            union res_9_sockaddr_union *addr_union = malloc(res->nscount * sizeof(union res_9_sockaddr_union));
            res_getservers(res, addr_union, res->nscount);
            
            const char *str;
            for (int i = 0; i < res->nscount; i++) {
                if (addr_union[i].sin.sin_family == AF_INET) {
                    char ip[INET_ADDRSTRLEN];
                    str = inet_ntop(AF_INET, &(addr_union[i].sin.sin_addr), ip, INET_ADDRSTRLEN);
                    if (str) {
                        [ipv4s addObject:[NSString stringWithUTF8String:str]];
                    }
                } else if (addr_union[i].sin6.sin6_family == AF_INET6) {
                    char ip[INET6_ADDRSTRLEN];
                    str = inet_ntop(AF_INET6, &(addr_union[i].sin6.sin6_addr), ip, INET6_ADDRSTRLEN);
                    if (str) {
                        [ipv6s addObject:[NSString stringWithUTF8String:str]];
                    }
                } else {
                    str = NULL;
                }
                
                
            }
        }
        res_nclose(res);
        free(res);
    }
    
    *ipv4DNSServers = [ipv4s copy];
    *ipv6DNSServers = [ipv6s copy];
    
    return;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper methods (private)
    
- (void) updateTunnelSettingsWithCompletionHandler:(nullable void (^)( NSError * __nullable error))completionHandler {
    
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
    if (! (_currentServer.ipv4Addresses.count || _currentServer.ipv6Addresses.count)) {
        
        DDLogError(@"(PacketTunnelProvider) Can't obtain DNS addresses from protocol configuration.");
    }
    else {
        APVpnManagerTunnelMode mode = [protocol.providerConfiguration[APVpnManagerParameterTunnelMode] unsignedIntegerValue];
        
        NSString* modeName = @"";
        if(mode == APVpnManagerTunnelModeFull) {
            _fullTunnel = YES;
            modeName = @"full";
        }
        else if (mode == APVpnManagerTunnelModeSplit){
            _fullTunnel = NO;
            modeName = @"split";
        }
        
        [self logNetworkInterfaces];
        DDLogInfo(@"PacketTunnelProvider) Start Tunnel user mode: %@, fullTunnel: %@", modeName, _fullTunnel ? @"YES" : @"NO");
        
        settings = [self createTunnelSettings:_fullTunnel];
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
        
        if(completionHandler) {
            
            DDLogInfo(@"(PacketTunnelProvider) update Tunnel Settings ");
            
            completionHandler(error);
        }
        
        [sSelf logNetworkInterfaces];
    }];
}

- (void)reachNotify:(NSNotification *)note {
    
    DDLogInfo(@"(PacketTunnelProvider) reachability Notify");
    
    // sometimes we recieve reach notify right after the tunnel is started(kSCNetworkReachabilityFlagsIsDirect flag changed). In this case the restart of the tunnel enters an infinite loop.
    if(_lastReachabilityStatus == [_reachabilityHandler currentReachabilityStatus]) {
        DDLogInfo(@"(PacketTunnelProvider) network status not changed. Skip reachability notify");
        return;
    }
    
    _lastReachabilityStatus = [_reachabilityHandler currentReachabilityStatus];
    
    [self updateTunnelSettingsWithCompletionHandler:nil];
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

        
        @autoreleasepool {
            NSArray *domainList = APSharedResources.whitelistDomains;
            NSUInteger counter = 0;
            for (NSString *item in domainList) {
                
                NSString *ruleText = [[[[APWhitelistDomainObject alloc] initWithDomain:item] rule] ruleText];
                if (ruleText) {
                    
                    [userWhiteRules addRule:[AERDomainFilterRule rule:ruleText]];
                    counter++;
                }
            }
            DDLogInfo(@"(PacketTunnelProvider) User whitelist rules: %lu", counter);
        }
        
        [_connectionHandler setUserWhitelistFilter:userWhiteRules];
        
        @autoreleasepool {
            NSArray *domainList = APSharedResources.blacklistDomains;
            NSUInteger counter = 0;
            for (NSString *ruleText in domainList) {
                
                if (ruleText) {
                    
                    [userBlackRules addRule:[AERDomainFilterRule rule:ruleText]];
                    counter++;
                }
            }
            DDLogInfo(@"(PacketTunnelProvider) User blacklist rules: %lu", counter);
        }
        
        [_connectionHandler setUserBlacklistFilter:userBlackRules];
    }
}

- (NSArray<NEIPv4Route *> *) ipv4ExcludedRoutes {
    
    NSMutableArray *ipv4excludeRoutes = [NSMutableArray new];
    
    // exclude all ip addresses. Our tunnel interface ip will not be excluded.
    // NSArray* excludeCidrs = @[@"0.0.0.0/1", @"128.0.0.0/1"];
    
    NSArray* excludeIpv4Cidrs = @[
                                  
                                  // if we add 0.0.0.0 with any mask to excluded routes, then Ios starts to work very strange. Hides VPN icon in statusbar. And sometimes turn off wi-fi.
                                  // https://github.com/AdguardTeam/AdguardForiOS/issues/424#issuecomment-315397726
                                  //@"0.0.0.0/2",
                                  
                                  @"0.0.0.1/32",
                                  @"0.0.0.2/31",
                                  @"0.0.0.4/30",
                                  @"0.0.0.8/29",
                                  @"0.0.0.16/28",
                                  @"0.0.0.32/27",
                                  @"0.0.0.64/26",
                                  @"0.0.0.128/25",
                                  @"0.0.1.0/24",
                                  @"0.0.2.0/23",
                                  @"0.0.4.0/22",
                                  @"0.0.8.0/21",
                                  @"0.0.16.0/20",
                                  @"0.0.32.0/19",
                                  @"0.0.64.0/18",
                                  @"0.0.128.0/17",
                                  @"0.1.0.0/16",
                                  @"0.2.0.0/15",
                                  @"0.4.0.0/14",
                                  @"0.8.0.0/13",
                                  @"0.16.0.0/12",
                                  @"0.32.0.0/11",
                                  @"0.64.0.0/10",
                                  @"0.128.0.0/9",
                                  @"1.0.0.0/8",
                                  @"2.0.0.0/7",
                                  @"4.0.0.0/6",
                                  @"8.0.0.0/5",
                                  @"16.0.0.0/4",
                                  @"32.0.0.0/3",
                                  
                                  @"64.0.0.0/3",
                                  @"96.0.0.0/4",
                                  @"112.0.0.0/5",
                                  @"120.0.0.0/8",
                                  @"121.0.0.0/10",
                                  @"121.64.0.0/11",
                                  @"121.96.0.0/12",
                                  @"121.112.0.0/13",
                                  @"121.120.0.0/16",
                                  @"121.121.0.0/18",
                                  @"121.121.64.0/19",
                                  @"121.121.96.0/20",
                                  @"121.121.112.0/21",
                                  @"121.121.120.0/24",
                                  @"121.121.121.0/26",
                                  @"121.121.121.64/27",
                                  @"121.121.121.96/28",
                                  @"121.121.121.112/29",
                                  @"121.121.121.120/32",
                                  @"121.121.121.125/32",
                                  @"121.121.121.126/31",
                                  @"121.121.121.128/25",
                                  @"121.121.122.0/23",
                                  @"121.121.124.0/22",
                                  @"121.121.128.0/17",
                                  @"121.122.0.0/15",
                                  @"121.124.0.0/14",
                                  @"121.128.0.0/9",
                                  @"122.0.0.0/7",
                                  @"124.0.0.0/6",
                                  @"128.0.0.0/1",
                                  ];
    
    for(NSString* cidr in excludeIpv4Cidrs) {
        [ipv4excludeRoutes addObject:[NEIPv4Route ipv4RouteWithCidr:cidr]];
    }
    
    return ipv4excludeRoutes;
}

- (NSArray<NEIPv6Route *> *) ipv6ExcludedRoutes {
    
    NSMutableArray *ipv6ExcludedRoutes = [NSMutableArray new];
    
    //NSArray* excludeIpv6cidrs = @[@"::/1", @"8000::/1"];
    NSArray *excludeIpv6cidrs = @[
                                  @"2001:ad00:ad00::/113",
                                  @"2001:ad00:ad00::8000/115",
                                  @"2001:ad00:ad00::a000/117",
                                  @"2001:ad00:ad00::a800/118",
                                  @"2001:ad00:ad00::ac00/120",
                                  @"2001:ad00::/33",
                                  @"2001:ad00:8000::/35",
                                  @"2001:ad00:a000::/37",
                                  @"2001:ad00:a800::/38",
                                  @"2001:ad00:ac00::/40",
                                  @"2001::/17",
                                  @"2001:8000::/19",
                                  @"2001:a000::/21",
                                  @"2001:a800::/22",
                                  @"2001:ac00::/24",
                                  @"2000::/16",
                                  @"::/3",
                                  @"2001:ad00:ad00::ad02/127",
                                  @"2001:ad00:ad00::ad04/126",
                                  @"2001:ad00:ad00::ad08/125",
                                  @"2001:ad00:ad00::ad10/124",
                                  @"2001:ad00:ad00::ad20/123",
                                  @"2001:ad00:ad00::ad40/122",
                                  @"2001:ad00:ad00::ad80/121",
                                  @"2001:ad00:ad00::ae00/119",
                                  @"2001:ad00:ad00::b000/116",
                                  @"2001:ad00:ad00::c000/114",
                                  @"2001:ad00:ad00::1:0/112",
                                  @"2001:ad00:ad00::2:0/111",
                                  @"2001:ad00:ad00::4:0/110",
                                  @"2001:ad00:ad00::8:0/109",
                                  @"2001:ad00:ad00::10:0/108",
                                  @"2001:ad00:ad00::20:0/107",
                                  @"2001:ad00:ad00::40:0/106",
                                  @"2001:ad00:ad00::80:0/105",
                                  @"2001:ad00:ad00::100:0/104",
                                  @"2001:ad00:ad00::200:0/103",
                                  @"2001:ad00:ad00::400:0/102",
                                  @"2001:ad00:ad00::800:0/101",
                                  @"2001:ad00:ad00::1000:0/100",
                                  @"2001:ad00:ad00::2000:0/99",
                                  @"2001:ad00:ad00::4000:0/98",
                                  @"2001:ad00:ad00::8000:0/97",
                                  @"2001:ad00:ad00::1:0:0/96",
                                  @"2001:ad00:ad00::2:0:0/95",
                                  @"2001:ad00:ad00::4:0:0/94",
                                  @"2001:ad00:ad00::8:0:0/93",
                                  @"2001:ad00:ad00::10:0:0/92",
                                  @"2001:ad00:ad00::20:0:0/91",
                                  @"2001:ad00:ad00::40:0:0/90",
                                  @"2001:ad00:ad00::80:0:0/89",
                                  @"2001:ad00:ad00::100:0:0/88",
                                  @"2001:ad00:ad00::200:0:0/87",
                                  @"2001:ad00:ad00::400:0:0/86",
                                  @"2001:ad00:ad00::800:0:0/85",
                                  @"2001:ad00:ad00::1000:0:0/84",
                                  @"2001:ad00:ad00::2000:0:0/83",
                                  @"2001:ad00:ad00::4000:0:0/82",
                                  @"2001:ad00:ad00::8000:0:0/81",
                                  @"2001:ad00:ad00:0:1::/80",
                                  @"2001:ad00:ad00:0:2::/79",
                                  @"2001:ad00:ad00:0:4::/78",
                                  @"2001:ad00:ad00:0:8::/77",
                                  @"2001:ad00:ad00:0:10::/76",
                                  @"2001:ad00:ad00:0:20::/75",
                                  @"2001:ad00:ad00:0:40::/74",
                                  @"2001:ad00:ad00:0:80::/73",
                                  @"2001:ad00:ad00:0:100::/72",
                                  @"2001:ad00:ad00:0:200::/71",
                                  @"2001:ad00:ad00:0:400::/70",
                                  @"2001:ad00:ad00:0:800::/69",
                                  @"2001:ad00:ad00:0:1000::/68",
                                  @"2001:ad00:ad00:0:2000::/67",
                                  @"2001:ad00:ad00:0:4000::/66",
                                  @"2001:ad00:ad00:0:8000::/65",
                                  @"2001:ad00:ad00:1::/64",
                                  @"2001:ad00:ad00:2::/63",
                                  @"2001:ad00:ad00:4::/62",
                                  @"2001:ad00:ad00:8::/61",
                                  @"2001:ad00:ad00:10::/60",
                                  @"2001:ad00:ad00:20::/59",
                                  @"2001:ad00:ad00:40::/58",
                                  @"2001:ad00:ad00:80::/57",
                                  @"2001:ad00:ad00:100::/56",
                                  @"2001:ad00:ad00:200::/55",
                                  @"2001:ad00:ad00:400::/54",
                                  @"2001:ad00:ad00:800::/53",
                                  @"2001:ad00:ad00:1000::/52",
                                  @"2001:ad00:ad00:2000::/51",
                                  @"2001:ad00:ad00:4000::/50",
                                  @"2001:ad00:ad00:8000::/49",
                                  @"2001:ad00:ad01::/48",
                                  @"2001:ad00:ad02::/47",
                                  @"2001:ad00:ad04::/46",
                                  @"2001:ad00:ad08::/45",
                                  @"2001:ad00:ad10::/44",
                                  @"2001:ad00:ad20::/43",
                                  @"2001:ad00:ad40::/42",
                                  @"2001:ad00:ad80::/41",
                                  @"2001:ad00:ae00::/39",
                                  @"2001:ad00:b000::/36",
                                  @"2001:ad00:c000::/34",
                                  @"2001:ad01::/32",
                                  @"2001:ad02::/31",
                                  @"2001:ad04::/30",
                                  @"2001:ad08::/29",
                                  @"2001:ad10::/28",
                                  @"2001:ad20::/27",
                                  @"2001:ad40::/26",
                                  @"2001:ad80::/25",
                                  @"2001:ae00::/23",
                                  @"2001:b000::/20",
                                  @"2001:c000::/18",
                                  @"2002::/15",
                                  @"2004::/14",
                                  @"2008::/13",
                                  @"2010::/12",
                                  @"2020::/11",
                                  @"2040::/10",
                                  @"2080::/9",
                                  @"2100::/8",
                                  @"2200::/7",
                                  @"2400::/6",
                                  @"2800::/5",
                                  @"3000::/4",
                                  @"4000::/2",
                                  @"8000::/1",
                                  ];
    
    for (NSString* cidr in excludeIpv6cidrs) {
        [ipv6ExcludedRoutes addObject:[NEIPv6Route ipv6RouteWithCidr:cidr]];
    }
    
    return ipv6ExcludedRoutes;
}

- (NEPacketTunnelNetworkSettings *)createTunnelSettings: (BOOL)fullTunnel {

    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    BOOL ipv6Available = [ACNIPUtils isIpv6Available];
    
    // DNS
    
    NSArray *deviceIpv4DnsServers;
    NSArray *deviceIpv6DnsServers;
    
    [self getDNSServersIpv4:&deviceIpv4DnsServers ipv6:&deviceIpv6DnsServers];
    
    NSMutableArray *deviceDnsServers = [NSMutableArray new];
    [deviceDnsServers addObjectsFromArray:deviceIpv4DnsServers];
    [deviceDnsServers addObjectsFromArray:deviceIpv6DnsServers];
    
    NSMutableArray *remoteDnsIpv4Addresses = [NSMutableArray new];
    NSMutableArray *remoteDnsIpv6Addresses = [NSMutableArray new];
    
    if(_isRemoteServer) {
        [remoteDnsIpv4Addresses addObjectsFromArray:_currentServer.ipv4Addresses];
        [remoteDnsIpv6Addresses addObjectsFromArray:_currentServer.ipv6Addresses];
    }
    
    NSArray* fakeIpv4DnsAddresses = @[V_DNS_IPV4_ADDRESS, V_DNS_IPV4_ADDRESS2, V_DNS_IPV4_ADDRESS3, V_DNS_IPV4_ADDRESS4];
    NSArray* fakeIpv6DnsAddresses = ipv6Available ? @[V_DNS_IPV6_ADDRESS, V_DNS_IPV6_ADDRESS2] : @[];
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
        
        ipv4.excludedRoutes = [self ipv4ExcludedRoutes];
        ipv6.excludedRoutes = [self ipv6ExcludedRoutes];
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
    
    settings.IPv4Settings = ipv4;
    
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

@end
