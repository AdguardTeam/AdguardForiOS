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
#import "APTunnelConnectionsHandler.h"
#import "APSharedResources.h"
#import "APTunnelConnectionsHandler.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider Constants

NSString *APTunnelProviderErrorDomain = @"APTunnelProviderErrorDomain";

#define V_REMOTE_ADDRESS             @"111.111.111.111"

#define V_INTERFACE_IPV4_ADDRESS     @"169.254.254.2"
#define V_INTERFACE_IPV4_MASK        @"255.255.255.255"

#define V_INTERFACE_IPV6_ADDRESS     @"fe80::aaaa"
#define V_INTERFACE_IPV6_MASK        @(128)

/////////////////////////////////////////////////////////////////////
#pragma mark - PacketTunnelProvider

@implementation PacketTunnelProvider{
    
    void (^pendingStartCompletion)(NSError *error);
    
    APTunnelConnectionsHandler *_connectionHandler;
    APVpnMode _currentMode;
}

+ (void)initialize{
    
    if (self == [PacketTunnelProvider class]) {
        
        // Init Logger
        [[ACLLogger singleton] initLogger:[AESharedResources sharedAppLogsURL]];
        
#if DEBUG
        [[ACLLogger singleton] setLogLevel:ACLLDebugLevel];
#endif
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Controll connection methods

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler
{
    DDLogInfo(@"(PacketTunnelProvider) Start Tunnel Event");
    
   pendingStartCompletion = completionHandler;
    
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    // Getting DNS
    NETunnelProviderProtocol *protocol = (NETunnelProviderProtocol *)self.protocolConfiguration;
    
    NSArray *ipv4DnsAddresses = protocol.providerConfiguration[APVpnManagerParameterIPv4DNSAddresses];
    if (!ipv4DnsAddresses) {
        
        DDLogError(@"(PacketTunnelProvider) Can't obtain DNS addresses from protocol configuration.");
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_NODNSCONFIGURATION userInfo:nil];
        
        pendingStartCompletion(error);
    }
    
    _currentMode = [protocol.providerConfiguration[APVpnManagerParameterMode] intValue];
    
    // IPv4
    NEIPv4Settings *ipv4 = [[NEIPv4Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV4_ADDRESS]
                            subnetMasks:@[V_INTERFACE_IPV4_MASK]];
    
    // route for ipv4, which includes dns addresses
    NSMutableArray *routers = [NSMutableArray arrayWithCapacity:2];
//    [routers addObject:[[NEIPv4Route alloc]
//                        initWithDestinationAddress:V_INTERFACE_IPV4_ADDRESS
//                        subnetMask:V_INTERFACE_IPV4_MASK]];
    for (NSString *item in ipv4DnsAddresses) {
        [routers addObject:[[NEIPv4Route alloc]
                            initWithDestinationAddress:item
                            subnetMask:V_INTERFACE_IPV4_MASK]];
    }
    
    ipv4.includedRoutes = routers;
    ipv4.excludedRoutes = @[[NEIPv4Route defaultRoute]];
    
    settings.IPv4Settings = ipv4;
    
    // IPv6
    NEIPv6Settings *ipv6 = [[NEIPv6Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV6_ADDRESS]
                            networkPrefixLengths:@[V_INTERFACE_IPV6_MASK]];
//    ipv6.includedRoutes = @[[[NEIPv6Route alloc]
//                             initWithDestinationAddress:V_INTERFACE_IPV6_ADDRESS
//                            networkPrefixLength:V_INTERFACE_IPV6_MASK]];
    ipv6.excludedRoutes = @[[NEIPv6Route defaultRoute]];
    
    settings.IPv6Settings = ipv6;

    // DNS

    NEDNSSettings *dns = [[NEDNSSettings alloc] initWithServers:ipv4DnsAddresses];
    dns.matchDomains = @[ @"" ];

    settings.DNSSettings = dns;

    // Create connection handler
    _connectionHandler = [[APTunnelConnectionsHandler alloc] initWithProvider:self];
    if (!_connectionHandler) {
        DDLogError(@"(PacketTunnelProvider) Can't create connection handler.");
        NSError *error = [NSError errorWithDomain:APTunnelProviderErrorDomain code:APTN_ERROR_CONNECTION_HANDLER userInfo:nil];
        
        pendingStartCompletion(error);
    }
    
    // SETs network settings
    __typeof__(self) __weak wSelf = self;
    [self setTunnelNetworkSettings:settings completionHandler:^(NSError *_Nullable error) {

        __typeof__(self) sSelf = wSelf;

        [sSelf->_connectionHandler setDnsActivityLoggingEnabled:[[AESharedResources sharedDefaults] boolForKey:APDefaultsDnsLoggingEnabled]];
        [sSelf->_connectionHandler startHandlingPackets];

        sSelf->pendingStartCompletion(error);
        sSelf->pendingStartCompletion = nil;
    }];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
	// Add code here to start the process of stopping the tunnel.
    DDLogInfo(@"(PacketTunnelProvider) Stop Tunnel Event");
    
    _connectionHandler = nil;
    
	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler
{
    NSString *command = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
    
    // Logging command conversations
    if (_connectionHandler) {
        
        if ([command isEqualToString:APMDnsLoggingEnabled]) {
            
            //Log enabled
            [_connectionHandler setDnsActivityLoggingEnabled:YES];
        }
        else if ([command isEqualToString:APMDnsLoggingDisabled]){
            
            //Log disabled
            [_connectionHandler setDnsActivityLoggingEnabled:NO];
        }
        else if ([command isEqualToString:APMDnsLoggingClearLog]){
            
            //Clear log
            [_connectionHandler clearDnsActivityLog];
        }
        else if ([command isEqualToString:APMDnsLoggingGiveRecords]){
            
            //Request for log records
            NSArray *records = [_connectionHandler dnsActivityLogRecords];
            if (records.count) {
                
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:records];
                completionHandler(data);
                return;
            }
            completionHandler(nil);
        }
    }
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler
{
	// Add code here to get ready to sleep.
    DDLogInfo(@"(PacketTunnelProvider) Sleep Event");
    [_connectionHandler setDnsActivityLoggingEnabled:NO];
	completionHandler();
}

- (void)wake
{
	// Add code here to wake up.
    DDLogInfo(@"(PacketTunnelProvider) Wake Event");
    
    if (_connectionHandler == nil) {
        
        // Create connection handler
        _connectionHandler = [[APTunnelConnectionsHandler alloc] initWithProvider:self];
        if (!_connectionHandler) {
            DDLogError(@"(PacketTunnelProvider) Can't create connection handler on wakeup.");
            return;
        }
        
        [_connectionHandler startHandlingPackets];
    }
    
    [_connectionHandler setDnsActivityLoggingEnabled:[[AESharedResources sharedDefaults] boolForKey:APDefaultsDnsLoggingEnabled]];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (APVpnMode)vpnMode{

    return _currentMode;
}

@end
