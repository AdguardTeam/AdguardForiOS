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
#import "APVPNManager.h"

#define V_REMOTE_ADDRESS             @"111.111.111.111"

#define V_INTERFACE_IPV4_ADDRESS     @"169.254.254.2"
#define V_INTERFACE_IPV4_MASK        @"255.255.255.255"

#define V_INTERFACE_IPV6_ADDRESS     @"fe80::aaaa"
#define V_INTERFACE_IPV6_MASK        @(128)

#define VENDOR_DATA_KEY              @"VendorData"

@implementation PacketTunnelProvider{
    
    void (^pendingStartCompletion)(NSError *error);

}

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler
{
    pendingStartCompletion = completionHandler;
    
    NEPacketTunnelNetworkSettings *settings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:V_REMOTE_ADDRESS];
    
    // IPv4
    NEIPv4Settings *ipv4 = [[NEIPv4Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV4_ADDRESS]
                            subnetMasks:@[V_INTERFACE_IPV4_MASK]];
    ipv4.includedRoutes = @[[[NEIPv4Route alloc]
                             initWithDestinationAddress:V_INTERFACE_IPV4_ADDRESS
                             subnetMask:V_INTERFACE_IPV4_MASK]];
    ipv4.excludedRoutes = @[[NEIPv4Route defaultRoute]];
    
    settings.IPv4Settings = ipv4;
    
    // IPv6
    NEIPv6Settings *ipv6 = [[NEIPv6Settings alloc]
                            initWithAddresses:@[V_INTERFACE_IPV6_ADDRESS]
                            networkPrefixLengths:@[V_INTERFACE_IPV6_MASK]];
    ipv6.includedRoutes = @[[[NEIPv6Route alloc]
                             initWithDestinationAddress:V_INTERFACE_IPV6_ADDRESS
                            networkPrefixLength:V_INTERFACE_IPV6_MASK]];
    ipv6.excludedRoutes = @[[NEIPv6Route defaultRoute]];
    
    settings.IPv6Settings = ipv6;

    // DNS
    NETunnelProviderProtocol *protocol = (NETunnelProviderProtocol *)self.protocolConfiguration;
    
    NSArray *dnsAddresses = protocol.providerConfiguration[APVpnManagerParameterDNSAddresses];
    if (dnsAddresses) {
        
        NEDNSSettings *dns = [[NEDNSSettings alloc] initWithServers:dnsAddresses];
        dns.matchDomains = @[@""];
        
        settings.DNSSettings = dns;
        
        // SETs network settings
        __typeof__(self) __weak wSelf = self;
        [self setTunnelNetworkSettings:settings completionHandler:^(NSError * _Nullable error) {
            
            __typeof__(self) sSelf = wSelf;
            sSelf->pendingStartCompletion(error);
            sSelf->pendingStartCompletion = nil;
        }];
    }
    else{
        
        NSError *error = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_NODNSCONFIGURATION userInfo:nil];
        
        pendingStartCompletion(error);
    }
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler
{
	// Add code here to start the process of stopping the tunnel.
	completionHandler();
}

- (void)handleAppMessage:(NSData *)messageData completionHandler:(void (^)(NSData *))completionHandler
{
	// Add code here to handle the message.
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler
{
	// Add code here to get ready to sleep.
	completionHandler();
}

- (void)wake
{
	// Add code here to wake up.
}

@end
