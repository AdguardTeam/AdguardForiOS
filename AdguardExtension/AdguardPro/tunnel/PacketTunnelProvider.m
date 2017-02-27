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
#import "ACommons/ACLang.h"
#import "ACommons/ACNetwork.h"
#import "APTunnelConnectionsHandler.h"
#import "APSharedResources.h"
#import "APTunnelConnectionsHandler.h"
#import "APDnsServerObject.h"

#import "ASDFilterObjects.h"
#import "AESAntibanner.h"
#import "AEService.h"
#import "AEWhitelistDomainObject.h"
#import "AEBlacklistDomainObject.h"
#import "ASDatabase.h"

#include <arpa/inet.h>
#include <ifaddrs.h>
#include <resolv.h>
#include <dns.h>

/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider Constants

NSString *APTunnelProviderErrorDomain = @"APTunnelProviderErrorDomain";

#define V_REMOTE_ADDRESS             @"127.0.0.1"

#define V_INTERFACE_IPV4_ADDRESS     @"172.16.209.2"
#define V_INTERFACE_IPV4_MASK        @"255.255.255.255"

#define V_INTERFACE_IPV6_ADDRESS     @"fd12:1:1:1::2"
#define V_INTERFACE_IPV6_MASK        @(128)

/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider

@implementation PacketTunnelProvider{
    
    void (^pendingStartCompletion)(NSError *error);
    
    APDnsServerObject *_currentServer;
    BOOL    _localFiltering;
    BOOL    _isRemoteServer;
    
    Reachability *_reachabilityHandler;
    APTunnelConnectionsHandler *_connectionHandler;
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
    
    // Init database
    NSURL *dbURL = [[AESharedResources sharedResuorcesURL] URLByAppendingPathComponent:AE_PRODUCTION_DB];
    if (! [[ASDatabase singleton] checkDefaultDbVersionWithURL:dbURL]) {
        
        DDLogError(@"(PacketTunnelProvider) Fatal error. No production DB.");
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_STANDART userInfo:nil];
        
        pendingStartCompletion(error);
        return;
    }
    
    [[ASDatabase singleton] initDbWithURL:dbURL];
    //--------------------------
    
    [_reachabilityHandler startNotifier];
    
   pendingStartCompletion = completionHandler;
    
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    //TODO: delete this
    
//    NEProxySettings *proxySettings = [NEProxySettings new];
//    proxySettings.HTTPEnabled = YES;
//    proxySettings.HTTPServer = [[NEProxyServer alloc] initWithAddress:@"10.210.210.120" port:3128];
//    settings.proxySettings = proxySettings;
    //-------------------
    
    // Getting DNS
    NETunnelProviderProtocol *protocol = (NETunnelProviderProtocol *)self.protocolConfiguration;
    
    _currentServer = nil;
    NSData *currentServerData = protocol.providerConfiguration[APVpnManagerParameterRemoteDnsServer];
    if (currentServerData) {

        _currentServer = [NSKeyedUnarchiver unarchiveObjectWithData:currentServerData];
    }
    
    if (_currentServer == nil) {
        
        DDLogError(@"(PacketTunnelProvider) Bad configuration. Can't obtain remote DNS server object.");
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_BADCONFIGURATION userInfo:nil];
        
        pendingStartCompletion(error);
        return;
    }
    
    _localFiltering = [protocol.providerConfiguration[APVpnManagerParameterLocalFiltering] boolValue];
    _isRemoteServer = ! [_currentServer.tag isEqualToString:APDnsServerTagLocal];
    
    // Check configuration
    if (_localFiltering == NO && [_currentServer.tag isEqualToString:APDnsServerTagLocal]) {
        
        DDLogError(@"(PacketTunnelProvider) Bad configuration. Attempting set localFiltering = NO and to use system DNS settings.");
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_BADCONFIGURATION userInfo:nil];
        
        pendingStartCompletion(error);
        return;
    }
    
    if (! (_currentServer.ipv4Addresses.count || _currentServer.ipv6Addresses.count)) {
        
        DDLogError(@"(PacketTunnelProvider) Can't obtain DNS addresses from protocol configuration.");
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_NODNSCONFIGURATION userInfo:nil];
        
        pendingStartCompletion(error);
        return;
    }
    
    // IPv4
    NEIPv4Settings *ipv4 = [[NEIPv4Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV4_ADDRESS]
                            subnetMasks:@[V_INTERFACE_IPV4_MASK]];
    
    NSMutableArray *routers = [NSMutableArray arrayWithCapacity:2];
    
    if (_isRemoteServer) {

        // route for ipv4, which includes dns addresses
        for (NSString *item in _currentServer.ipv4Addresses) {
            [routers addObject:[[NEIPv4Route alloc]
                                initWithDestinationAddress:item
                                subnetMask:V_INTERFACE_IPV4_MASK]];
        }
    }
    else {
        // route for ipv4, which includes FAKE dns addresses
        [routers addObject:[[NEIPv4Route alloc]
                              initWithDestinationAddress:V_INTERFACE_IPV4_ADDRESS
                              subnetMask:V_INTERFACE_IPV4_MASK]];
    }
    ipv4.includedRoutes = routers;
    ipv4.excludedRoutes = @[[NEIPv4Route defaultRoute]];
  
    settings.IPv4Settings = ipv4;
    
    // IPv6
    NEIPv6Settings *ipv6 = [[NEIPv6Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV6_ADDRESS]
                            networkPrefixLengths:@[V_INTERFACE_IPV6_MASK]];
    
    routers = [NSMutableArray arrayWithCapacity:2];
    if (_isRemoteServer) {
        
        // route for ipv6, which includes dns addresses
        for (NSString *item in _currentServer.ipv6Addresses) {
            [routers addObject:[[NEIPv6Route alloc]
                                initWithDestinationAddress:item
                                networkPrefixLength:V_INTERFACE_IPV6_MASK]];
        }
        
    }
    else {
        // route for ipv6, which includes FAKE dns addresses
        [routers addObject:[[NEIPv6Route alloc]
                              initWithDestinationAddress:V_INTERFACE_IPV6_ADDRESS
                              networkPrefixLength:V_INTERFACE_IPV6_MASK]];
    }
    ipv6.includedRoutes = routers;
    ipv6.excludedRoutes = @[[NEIPv6Route defaultRoute]];
    
    settings.IPv6Settings = ipv6;

    // DNS

    NSMutableArray *dnsAddresses = [NSMutableArray arrayWithCapacity:2];
    NSArray *deviceDnsServers = [self getDNSServers];
    
    if (_isRemoteServer) {
        
        [dnsAddresses addObjectsFromArray:_currentServer.ipv4Addresses];
        [dnsAddresses addObjectsFromArray:_currentServer.ipv6Addresses];
        
    }
    else {
        [dnsAddresses addObject:V_INTERFACE_IPV4_ADDRESS];
        [dnsAddresses addObject:V_INTERFACE_IPV6_ADDRESS];
    }
    [_connectionHandler setDeviceDnsAddresses:deviceDnsServers adguardDnsAddresses:dnsAddresses];
    
    NEDNSSettings *dns = [[NEDNSSettings alloc] initWithServers:dnsAddresses];
    dns.matchDomains = @[ @"" ];

    settings.DNSSettings = dns;
    
    [self reloadWhitelistBlacklistDomain];
    
    // SETs network settings
    __typeof__(self) __weak wSelf = self;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError *_Nullable error) {

        __typeof__(self) sSelf = wSelf;

        @synchronized (sSelf->_connectionHandler) {
            if (sSelf->_connectionHandler) {
                [sSelf->_connectionHandler startHandlingPackets];
            }
        }

        sSelf->pendingStartCompletion(error);
        sSelf->pendingStartCompletion = nil;
    }];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
	// Add code here to start the process of stopping the tunnel.
    DDLogInfo(@"(PacketTunnelProvider) Stop Tunnel Event");
    
    [_reachabilityHandler stopNotifier];

	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler
{
    DDLogInfo(@"(PacketTunnelProvider) Handle Message Event");
    
    @synchronized (_connectionHandler) {
        
        switch ([APSharedResources host2tunnelMessageType:messageData]) {
            case APHTMLoggingEnabled:
                //Log enabled
                [_connectionHandler setDnsActivityLoggingEnabled:YES];
                break;
                
            case APHTMLoggingDisabled:
                //Log disabled
                [_connectionHandler setDnsActivityLoggingEnabled:NO];
                break;
                
            case APHTMLSystemWideDomainListReload:
                
                DDLogInfo(@"(PacketTunnelProvider) Domains lists changed. Reconnecting..");
                [self stopVPN];

                break;
                
            default:
                break;
        }
    }
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler
{
	// Add code here to get ready to sleep.
    DDLogInfo(@"(PacketTunnelProvider) Sleep Event");
	completionHandler();
}

- (void)wake
{
	// Add code here to wake up.
    DDLogInfo(@"(PacketTunnelProvider) Wake Event");
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

- (NSArray <NSString *> *)getDNSServers {
    @autoreleasepool {
        
        NSMutableArray *ips = [NSMutableArray array];
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
                } else if (addr_union[i].sin6.sin6_family == AF_INET6) {
                    char ip[INET6_ADDRSTRLEN];
                    str = inet_ntop(AF_INET6, &(addr_union[i].sin6.sin6_addr), ip, INET6_ADDRSTRLEN);
                } else {
                    str = NULL;
                }
                
                if (str) {
                    [ips addObject:[NSString stringWithUTF8String:str]];
                }
            }
        }
        res_nclose(res);
        free(res);
        
        return [ips copy];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper methods (private)

- (void)stopVPN {
    
    
    DDLogInfo(@"(PacketTunnelProvider) Stop VPN.");

    [_reachabilityHandler stopNotifier];

    self.reasserting = YES;
    [self cancelTunnelWithError:nil];

}

- (void)reachNotify:(NSNotification *)note {
    
    DDLogInfo(@"(PacketTunnelProvider) reachability Notify");
    [self stopVPN];
}

- (void)reloadWhitelistBlacklistDomain {
    
    if (_localFiltering == NO) {
        
        [_connectionHandler setWhitelistDomains:nil];
        [_connectionHandler setBlacklistDomains:nil];

        return;
    }
    
    @autoreleasepool {

        
        AESAntibanner *antibanner = [[AEService singleton] antibanner];
        NSArray *rules = [antibanner rulesForFilter:@(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)];
        
        NSMutableArray *wRules = [NSMutableArray array];
        NSMutableArray *bRules = [NSMutableArray array];
        AEWhitelistDomainObject *object;
        for (ASDFilterRule *item in rules) {
            
            object = [[AEWhitelistDomainObject alloc] initWithRule:item];
            if (object) {
                [wRules addObject:object];
            }
            else {
                
                object = [[AEBlacklistDomainObject alloc] initWithRule:item];
                if (object) {
                    [bRules addObject:object];
                }
            }
        }

        @autoreleasepool {
            
            NSArray *list = [wRules valueForKey:@"domain"];
            wRules = [NSMutableArray arrayWithArray:list];
        }

        @autoreleasepool {
            NSArray *domainList = APSharedResources.whitelistDomains;
            if (domainList.count) {
                [wRules addObjectsFromArray:domainList];
            }
        }
        
        
        [_connectionHandler setWhitelistDomains:wRules];
        
        @autoreleasepool {
            
            NSArray *list = [bRules valueForKey:@"domain"];
            bRules = [NSMutableArray arrayWithArray:list];
        }
        
        @autoreleasepool {
            NSArray *domainList = APSharedResources.blacklistDomains;
            if (domainList.count) {
                [bRules addObjectsFromArray:domainList];
            }
        }
        
        [_connectionHandler setBlacklistDomains:bRules];
    }
}
@end
