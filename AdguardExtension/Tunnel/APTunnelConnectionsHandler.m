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

#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "APTunnelConnectionsHandler.h"
#import "PacketTunnelProvider.h"
#import "APUDPPacket.h"

#import "Adguard-Swift.h"

/////////////////////////////////////////////////////////////////////
#pragma mark - APTunnelConnectionsHandler

@implementation APTunnelConnectionsHandler {
    
    BOOL _packetFlowObserver;
    dispatch_queue_t _readQueue;
    BOOL _packetHandling;
    id<DnsProxyServiceProtocol> _dnsProxy;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Init and Class methods

- (id)initWithProvider:(nonnull PacketTunnelProvider *)provider dnsProxy: (id<DnsProxyServiceProtocol>) dnsProxy {

    self = [super init];
    if (self) {

        _provider = provider;
        _dnsProxy = dnsProxy;
        _readQueue = dispatch_queue_create("com.adguard.AdguardPro.tunnel.read", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {

    if (_packetFlowObserver) {
        [_provider removeObserver:self forKeyPath:@"packetFlow"];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods


- (void)startHandlingPackets {

    if (_provider.packetFlow) {

        [self startHandlingPacketsInternal];
    } else {

        DDLogWarn(@"(APTunnelConnectionsHandler) - startHandlingPackets PacketFlow empty!");

        [_provider addObserver:self forKeyPath:@"packetFlow" options:0 context:NULL];
        _packetFlowObserver = YES;
    }
}

- (void)stopHandlingPackets {
    
    _packetHandling = NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqual:@"packetFlow"]) {

        DDLogDebug(@"(APTunnelConnectionsHandler) KVO _provider.packetFlow: %@", _provider.packetFlow);
        if (_provider.packetFlow) {

            if (_packetFlowObserver) {
                
                [_provider removeObserver:self forKeyPath:@"packetFlow"];
                _packetFlowObserver = NO;
            }
            [self startHandlingPacketsInternal];
        }
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark - Helper Methods

- (void)startHandlingPacketsInternal {
    
    __typeof__(self) __weak wSelf = self;

    DDLogDebug(@"(APTunnelConnectionsHandler) startHandlingPacketsInternal");
    
    dispatch_async(_readQueue, ^{
        
        if(!_packetHandling) {
            _packetHandling = YES;
            
            [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {
                
                __typeof__(self) sSelf = wSelf;
                [sSelf handlePackets:packets protocols:protocols];
            }];
        }
    });

}

/// Handle packets coming from the packet flow.
- (void)handlePackets:(NSArray<NSData *> *_Nonnull)packets protocols:(NSArray<NSNumber *> *_Nonnull)protocols {

    DDLogDebugTrace();

    // Work here

    [packets enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        
        APUDPPacket *udpPacket = [[APUDPPacket alloc] initWithData:obj af:protocols[idx]];
        
        [_dnsProxy resolveWithDnsRequest:obj callback:^(NSData * _Nullable reply) {
            if (reply != nil) {
                [_provider.packetFlow writePackets:@[reply] withProtocols:@[udpPacket.aFamily]];
            }
        }];
    }];

    // Read more
    __typeof__(self) __weak wSelf = self;

    dispatch_async(_readQueue, ^{

        [_provider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> *_Nonnull packets, NSArray<NSNumber *> *_Nonnull protocols) {

            __typeof__(self) sSelf = wSelf;

            if(!sSelf || !sSelf->_packetHandling){

                DDLogDebug(@"In readPacketsWithCompletionHandler stop handle");

                return;
            }
            [sSelf handlePackets:packets protocols:protocols];

        }];
    });
}

@end
