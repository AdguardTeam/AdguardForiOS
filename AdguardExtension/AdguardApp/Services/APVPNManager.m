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


#import "APVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "AppDelegate.h"
#import "ACommons/ACNetwork.h"
#import "ASDFilterObjects.h"
#import "AEService.h"
#import "AESAntibanner.h"
#import "Adguard-Swift.h"

#define VPN_NAME                            @" VPN"
#define MAX_COUNT_OF_REMOTE_DNS_SERVERS     20
#define NOTIFICATION_DELAY                  1

NSString *APVpnChangedNotification = @"APVpnChangedNotification";

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

@implementation APVPNManager{
    
    dispatch_queue_t workingQueue;
    NSOperationQueue *_notificationQueue;
    
    ACLExecuteBlockDelayed *_delayedSendNotify;
    
    NETunnelProviderManager *_manager;
    NSMutableArray *_observers;
    
    BOOL        _enabled;
    
    BOOL         _busy;
    NSLock      *_busyLock;
    NSNumber    *_delayedSetEnabled;
    
    DnsServerInfo *_activeDnsServer;
    DnsServerInfo *_delayedSetActiveDnsServer;
    
    APVpnManagerTunnelMode _tunnelMode;
    NSNumber          *_delayedSetTunnelMode;
    
    BOOL          _delayedRestartByReachability;
    
    NSError     *_standartError;
    
    BOOL _restartByReachability;
    
    NSMutableArray <DnsProviderInfo *> *_customDnsProviders;
    
    DnsProvidersService * _providersService;
    
    APSharedResources *_resources;
    ConfigurationService *_configuration;
}

@synthesize connectionStatus = _connectionStatus;
@synthesize lastError = _lastError;

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize and class properties

- (id)initWithResources: (nonnull APSharedResources*) resources
          configuration: (ConfigurationService *) configuration {
    
    self = [super init];
    if (self) {
        
        _resources = resources;
        _configuration = configuration;
        workingQueue = dispatch_queue_create("APVPNManager", DISPATCH_QUEUE_SERIAL);
        _notificationQueue = [NSOperationQueue new];
        _notificationQueue.underlyingQueue = workingQueue;
        _notificationQueue.name = @"APVPNManager notification";
        
        [_configuration addObserver:self forKeyPath:@"proStatus" options:NSKeyValueObservingOptionNew context:nil];
        
        // set delayed notify
        _delayedSendNotify = [[ACLExecuteBlockDelayed alloc]
                              initWithTimeout:NOTIFICATION_DELAY
                              leeway:NOTIFICATION_DELAY
                              queue:workingQueue block:^{
            
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      if (self.lastError) {
                                          DDLogInfo(@"(APVPNManager) Notify others that vpn connection status changed with error: %@", self.lastError.localizedDescription);
                                      }
                                      else {
                                          DDLogInfo(@"(APVPNManager) Notify others that vpn connection status changed.");
                                      }
                                      [[NSNotificationCenter defaultCenter] postNotificationName:APVpnChangedNotification object:self];
                                      
                                      // Reset last ERROR!!!
                                      _lastError = nil;
                                  });
                                  
        }];
        //------------------
        
        _busy = NO;
        _busyLock = [NSLock new];

        _standartError = [NSError
            errorWithDomain:APVpnManagerErrorDomain
                       code:APVPN_MANAGER_ERROR_STANDART
                   userInfo:@{
                       NSLocalizedDescriptionKey : ACLocalizedString(
                           @"support_vpn_configuration_problem", nil)
                   }];

        [self initDefinitions];

        [self attachToNotifications];
        
        _connectionStatus = APVpnConnectionStatusDisconnecting;
        _enabled = NO;
        
        _providersService = [DnsProvidersService new];
        
        // don't restart by default
        _restartByReachability = NO;
        
        [self loadConfiguration];
    }
    
    return self;
}

- (void)dealloc{
    
    for (id observer in _observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    
    [_configuration removeObserver:self forKeyPath:@"proStatus"];
}

/////////////////////////////////////////////////////////////////////
#pragma mark Properties and public methods

- (BOOL)enabled {
    
    return _enabled;
}
- (void)setEnabled:(BOOL)enabled{
    
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetEnabled = @(enabled);
    }
    else{
        dispatch_async(workingQueue, ^{
            
            if(_busy) {
                
                _delayedSetEnabled = @(enabled);
            } else {
                
                [self internalSetEnabled:enabled];
            }
        });
    }
    
    [_busyLock unlock];
}

- (void)setActiveDnsServer:(DnsServerInfo *)activeDnsServer{
    
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetActiveDnsServer = activeDnsServer;
    } else {
        dispatch_async(workingQueue, ^{
            
            if (_busy) {
                
                _delayedSetActiveDnsServer = activeDnsServer;
            } else {
                
                [self internalSetRemoteServer:activeDnsServer];
            }
        });
    }
    
    [_busyLock unlock];
    
}

- (NSArray<DnsProviderInfo *> *)providers {
    return [_providersService.providers arrayByAddingObjectsFromArray:_customDnsProviders];
}

- (DnsProviderInfo *)activeDnsProvider {
    if (!self.activeDnsServer)
        return nil;
    
    for (DnsProviderInfo* provider in _providersService.providers) {
        for(DnsServerInfo* server in provider.servers) {
            if ([server.serverId isEqualToString: self.activeDnsServer.serverId]) {
                return provider;
            }
        }
    }
    
    return nil;
}

- (BOOL)isActiveProvider:(DnsProviderInfo *)provider {
    if (!self.activeDnsServer)
        return NO;
    
    for(DnsServerInfo* server in provider.servers) {
        if ([server.serverId isEqualToString: self.activeDnsServer.serverId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isCustomProvider:(DnsProviderInfo *)provider {
    for (DnsProviderInfo* customProvider in _customDnsProviders) {
        if ([provider.servers.firstObject.serverId isEqual: customProvider.servers.firstObject.serverId]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isCustomServer:(DnsServerInfo *) server {
    for (DnsProviderInfo* provider in _customDnsProviders) {
        for (DnsServerInfo* customServer in provider.servers) {
            if ([customServer.serverId isEqual: server.serverId]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL) isCustomServerActive {
    return [self isCustomServer:_activeDnsServer];
}

- (DnsServerInfo *)activeDnsServer {
    return _activeDnsServer;
}

- (DnsServerInfo *)defaultServer {
    return self.providers.firstObject.servers.firstObject;
}

- (void)setTunnelMode:(APVpnManagerTunnelMode)tunnelMode {
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetTunnelMode = @(tunnelMode);
    } else {
        dispatch_async(workingQueue, ^{
            
            if (_busy) {
                
                _delayedSetTunnelMode = @(tunnelMode);
            } else {
                
                [self internalSetTunnelMode:tunnelMode];
            }
        });
    }
    
    [_busyLock unlock];
}

- (BOOL)restartByReachability {
    return _restartByReachability;
}

- (void)setRestartByReachability:(BOOL)restartByReachability {
    
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedRestartByReachability = restartByReachability;
    } else {
        dispatch_async(workingQueue, ^{
            
            if (_busy) {
                
                _delayedRestartByReachability = restartByReachability;
            } else {
                
                [self internalSetRestartByReachability:restartByReachability];
            }
        });
    }
    
     [_busyLock unlock];
}

- (APVpnManagerTunnelMode)tunnelMode {
    return _tunnelMode;
}

- (BOOL)clearDnsRequestsLog {

    _lastError = nil;

    return [_resources removeDnsLog];
}

- (void)obtainDnsLogRecords:(void (^)(NSArray<DnsLogRecord *> *records))completionBlock {

    _lastError = nil;
    
    if (completionBlock == nil) {
        return;
    }
    
    NSArray <DnsLogRecord *> *records = [_resources readDnsLog];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        completionBlock(records);
    });
}

- (BOOL)addRemoteDnsServer:(NSString *)name upstreams:(NSArray<NSString*>*) upstreams {
    
    DnsProviderInfo* provider = [_providersService createProviderWithName:name upstreams:upstreams];
    
    [self addCustomProvider: provider];
    
    [self setActiveDnsServer:provider.servers.firstObject];
    
    return YES;
}

- (BOOL)deleteCustomDnsProvider:(DnsProviderInfo *)provider {
    
    __block BOOL result;
    
    dispatch_sync(workingQueue, ^{
        
        if ([self isActiveProvider:provider]) {
            self.activeDnsServer = self.defaultServer;
        }
        
        // search provider by server id.
        DnsProviderInfo* foundProvider = nil;
        for (DnsProviderInfo* customProvider in _customDnsProviders) {
            // Each custom provider has only one server
            if ([customProvider.servers.firstObject.serverId isEqualToString:provider.servers.firstObject.serverId]) {
                foundProvider = customProvider;
                break;
            }
        }
        
        if (!foundProvider) {
            DDLogError(@"(APVPNManager) Error - can not delete custom dns provider with name: %@, upsrteams: %@", provider.name, provider.servers.firstObject.upstreams);
            result = NO;
            return;
        }
        
        [self willChangeValueForKey:@"providers"];
        [_customDnsProviders removeObject:foundProvider];
        [self didChangeValueForKey:@"providers"];
        
        [self saveCustomDnsProviders];
        result = YES;
    });
    
    return YES;
}

- (BOOL)resetCustomDnsProvider:(DnsProviderInfo *)provider {
    
    __block BOOL result;
    
    dispatch_sync(workingQueue, ^{
       
        // search provider by server id.
        DnsProviderInfo* foundProvider = nil;
        for (DnsProviderInfo* customProvider in _customDnsProviders) {
            // Each custom provider has only one server
            if ([customProvider.servers.firstObject.serverId isEqualToString:provider.servers.firstObject.serverId]) {
                foundProvider = customProvider;
                break;
            }
        }
        
        if (!foundProvider) {
            DDLogError(@"(APVPNManager) Error - can not edit custom dns provider with name: %@, upsrteams: %@", provider.name, provider.servers.firstObject.upstreams);
            result = NO;
            return;
        }
        
        [self willChangeValueForKey:@"providers"];
        foundProvider.name = provider.name;
        foundProvider.servers.firstObject.upstreams = provider.servers.firstObject.upstreams;
        [self didChangeValueForKey:@"providers"];
        
        // update active server if needed
        if ([self isActiveProvider:provider]) {
            self.activeDnsServer =  provider.servers.firstObject;
        }
        
        [self saveCustomDnsProviders];
        result = YES;
    });
    
    return result;
}

- (void) addCustomProvider: (DnsProviderInfo*) provider {
    
    dispatch_sync(workingQueue, ^{
        
        [self willChangeValueForKey:@"providers"];
        [_customDnsProviders addObject:provider];
        [self didChangeValueForKey:@"providers"];
        
        [self saveCustomDnsProviders];
        
    });
}

- (BOOL)vpnInstalled {
    return _manager != nil;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Key Value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"proStatus"] && !_configuration.proStatus) {
        [self removeVpnConfiguration];
    }
}


/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (Private)

//must be called on workingQueue
- (void)internalSetEnabled:(BOOL)enabled{
    
    if (enabled != _enabled) {
        
        if (_activeDnsServer == nil) {
            // if we have initial state, when vpn configuration still was not loaded.
            _delayedSetEnabled = @(enabled);
            return;
        }
        
        
        [self updateConfigurationForRemoteServer:_activeDnsServer tunnelMode:_tunnelMode restartByReachability:_restartByReachability enabled:enabled];
        
        // If do not completely stop the tunnel in full mode, then other VPNs can not start
        if(!enabled && _tunnelMode == APVpnManagerTunnelModeFull) {
            [(NETunnelProviderSession *)_manager.connection stopTunnel];
        }

    }
}

//must be called on workingQueue
- (void)internalSetRemoteServer:(DnsServerInfo *)server{
    
    if (_activeDnsServer == nil) {
        // if we have initial state, when vpn configuration still was not loaded.
        _delayedSetActiveDnsServer = server;
        return;
    }
    
    if (server) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForRemoteServer:server tunnelMode:_tunnelMode restartByReachability:_restartByReachability enabled:NO];
    }
}

//must be called on workingQueue
- (void)internalSetTunnelMode:(APVpnManagerTunnelMode)tunnelMode {
    if(tunnelMode != _tunnelMode) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForRemoteServer:_activeDnsServer tunnelMode:tunnelMode restartByReachability:_restartByReachability enabled:NO];
    }
}

//must be called on workingQueue
- (void)internalSetRestartByReachability:(BOOL)restart {
    
    if(restart != _restartByReachability) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForRemoteServer:_activeDnsServer tunnelMode:_tunnelMode restartByReachability:restart enabled:NO];
    }
}

- (void)loadConfiguration{

    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error){
            
            DDLogError(@"(APVPNManager) Error loading vpn configuration: %@, %ld, %@", error.domain, error.code, error.localizedDescription);
            _lastError = _standartError;
        }
        else {
            
            if (managers.count) {
                //Checks that loaded configuration is related to tunnel bundle ID.
                //If no, removes all old configurations.
                if (managers.count > 1 || ! [((NETunnelProviderProtocol *)managers.firstObject.protocolConfiguration).providerBundleIdentifier isEqualToString:AP_TUNNEL_ID]) {
                    
                    DDLogError(@"(APVPNManager) Error. there are %lu managers in system. Remove all", managers.count);
                    for (NETunnelProviderManager *item in managers) {
                        [item removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                            if(error) {
                                DDLogError(@"(APVPNManager) Error. Manager removing failed with error: %@", error.localizedDescription);
                            }
                            else {
                                DDLogInfo(@"(APVPNManager) Error. Manager successfully removed");
                            }
                        }];
                    }
                    
                    _manager = nil;
                }
                else {
                    
                    _manager = managers[0];
                }
            }
        }

        [_busyLock lock];
        _busy = NO;
        [_busyLock unlock];
        
        dispatch_sync(workingQueue, ^{
            
            [self setStatuses];
        });
        
        if (error) {
            DDLogInfo(@"(APVPNManager) Loading vpn conviguration failured: %@",
                      (self.activeDnsServer.name ?: @"None"));
        }
        else{
            DDLogInfo(@"(APVPNManager) Vpn configuration successfully loaded: %@",
                      (self.activeDnsServer.name ?: @"None"));
        }
        
        [self sendNotificationForced:YES];
    }];
    
}

- (void)updateConfigurationForRemoteServer:(DnsServerInfo *)remoteServer tunnelMode:(APVpnManagerTunnelMode) tunnelMode restartByReachability:(BOOL)restartByReachability enabled:(BOOL)enabled{
    
    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    if (remoteServer == nil) {
        remoteServer = self.defaultServer;
    }
    
    NETunnelProviderProtocol *protocol = (NETunnelProviderProtocol *)_manager.protocolConfiguration;
    NETunnelProviderManager *newManager;
    
    if (!protocol)
    {
        protocol = [NETunnelProviderProtocol new];
        protocol.providerBundleIdentifier =  AP_TUNNEL_ID;
    }
    
    NSData *remoteServerData = [NSKeyedArchiver archivedDataWithRootObject:remoteServer];
    protocol.serverAddress = remoteServer.name;
    protocol.providerConfiguration = @{
                                       APVpnManagerParameterRemoteDnsServer: remoteServerData,
                                       APVpnManagerParameterTunnelMode: @(tunnelMode),
                                       APVpnManagerRestartByReachability : @(restartByReachability)
                                       };
    
    if (_manager) {
        newManager = _manager;
    }
    else{
        newManager = [NETunnelProviderManager new];
        newManager.protocolConfiguration = protocol;
        
        // Configure onDemand
        NEOnDemandRuleConnect *rule = [NEOnDemandRuleConnect new];
        rule.interfaceTypeMatch = NEOnDemandRuleInterfaceTypeAny;
        newManager.onDemandRules = @[rule];
    }
    
    newManager.enabled = enabled;
    newManager.onDemandEnabled = enabled;
    newManager.localizedDescription = AE_PRODUCT_NAME VPN_NAME;
    [newManager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if (error){
            
            DDLogError(@"(APVPNManager) Error updating vpn configuration: %@, %ld, %@", error.domain, error.code, error.localizedDescription);
            _lastError = _standartError;

            [_busyLock lock];
            _busy = NO;
            [_busyLock unlock];
            
            dispatch_sync(workingQueue, ^{
                
                [self setStatuses];
            });
            
            DDLogInfo(@"(APVPNManager) Updating vpn conviguration failured: %@",
                      (self.activeDnsServer.name ?: @"None"));
            
            [self sendNotificationForced:NO];
            return;
        }
        
        DDLogInfo(@"(APVPNManager) Vpn configuration successfully updated: %@",
                  (self.activeDnsServer.name ?: @"None"));
        
        [self loadConfiguration];
    }];
}

- (void)removeVpnConfiguration {
    
    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if (error){
            
            DDLogError(@"(APVPNManager) removeVpnConfiguration - Error loading vpn configuration: %@, %ld, %@", error.domain, error.code, error.localizedDescription);
            _lastError = _standartError;
        }
        else {
            
            if (managers.count) {
                for (NETunnelProviderManager *item in managers) {
                    [item removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                        if(error) {
                            DDLogError(@"(APVPNManager) Error. Manager removing failed with error: %@", error.localizedDescription);
                        }
                        else {
                            DDLogInfo(@"(APVPNManager) Error. Manager successfully removed");
                        }
                    }];
                }
                
                _manager = nil;
            }
        }
        
        [_busyLock lock];
        _busy = NO;
        [_busyLock unlock];
    }];
}

- (void)setStatuses{
    
    _enabled = NO;
    
    if (_manager) {
        
        NETunnelProviderProtocol * protocolConfiguration = (NETunnelProviderProtocol *)_manager.protocolConfiguration;
        NSData *remoteDnsServerData = protocolConfiguration.providerConfiguration[APVpnManagerParameterRemoteDnsServer];
        
        // Getting current settings from configuration.
        //If settings are incorrect, then we assign default values.
        [self willChangeValueForKey:@"activeDnsServer"];
        _activeDnsServer = [NSKeyedUnarchiver unarchiveObjectWithData:remoteDnsServerData] ?: self.defaultServer;
        [self didChangeValueForKey:@"activeDnsServer"];
        
        _resources.activeDnsServer = _activeDnsServer;
        _resources.vpnTunnelMode = _tunnelMode;
        
        [self willChangeValueForKey:@"tunnelMode"];
        _tunnelMode = protocolConfiguration.providerConfiguration[APVpnManagerParameterTunnelMode] ?
        [protocolConfiguration.providerConfiguration[APVpnManagerParameterTunnelMode] unsignedIntValue] : APVpnManagerTunnelModeSplit;
        
        [self didChangeValueForKey:@"tunnelMode"];
        //-------------
        
        _restartByReachability = protocolConfiguration.providerConfiguration[APVpnManagerRestartByReachability] ?
        [protocolConfiguration.providerConfiguration[APVpnManagerRestartByReachability] boolValue] : NO; // NO by default
        
        _resources.restartByReachability = _restartByReachability;
        
        NSString *connectionStatusReason = @"Unknown";
        
        if (_manager.enabled && _manager.onDemandEnabled) {
            
            _enabled = YES;

            switch (_manager.connection.status) {
                    
                case NEVPNStatusDisconnected:
                    _connectionStatus = APVpnConnectionStatusDisconnected;
                    connectionStatusReason = @"NEVPNStatusDisconnected The VPN is disconnected.";
                    break;
                    
                case NEVPNStatusReasserting:
                    _connectionStatus = APVpnConnectionStatusReconnecting;
                    connectionStatusReason = @"NEVPNStatusReasserting The VPN is reconnecting following loss of underlying network connectivity.";
                    break;
                    
                case NEVPNStatusConnecting:
                    _connectionStatus = APVpnConnectionStatusReconnecting;
                    connectionStatusReason = @"NEVPNStatusConnecting The VPN is connecting.";
                    break;
                    
                case NEVPNStatusDisconnecting:
                    _connectionStatus = APVpnConnectionStatusDisconnecting;
                    connectionStatusReason = @"NEVPNStatusDisconnecting The VPN is disconnecting.";
                    break;
                    
                case NEVPNStatusConnected:
                    _connectionStatus = APVpnConnectionStatusConnected;
                    connectionStatusReason = @"NEVPNStatusConnected The VPN is connected.";
                    break;
                    
                case NEVPNStatusInvalid:
                    connectionStatusReason = @"NEVPNStatusInvalid The VPN is not configured.";
                default:
                    _connectionStatus = APVpnConnectionStatusInvalid;
                    break;
            }
        }
        else{
            
            _connectionStatus = APVpnConnectionStatusDisabled;
        }
        
        DDLogInfo(@"(APVPNManager) Updated Status:\nmanager.enabled = %@\nmanager.onDemandEnabled = %@\nConnection Status: %@", _manager.enabled ? @"YES" : @"NO", _manager.onDemandEnabled ? @"YES" : @"NO", connectionStatusReason);
    }
    else{
        [self willChangeValueForKey:@"activeDnsServer"];
        _activeDnsServer = self.defaultServer;
        [self didChangeValueForKey:@"activeDnsServer"];
        
        _connectionStatus = APVpnConnectionStatusDisabled;
        
        DDLogInfo(@"(APVPNManager) Updated Status:\nNo manager instance.");
    }
    _resources.vpnEnabled = _enabled;
    // start delayed
    [self startDelayedOperationsIfNeedIt];
}

- (void)attachToNotifications{
    
    _observers = [NSMutableArray arrayWithCapacity:2];
    
    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NEVPNConfigurationChangeNotification
                   object: nil //_manager
                   queue:_notificationQueue
                   usingBlock:^(NSNotification *_Nonnull note) {
                    // When VPN configuration is changed
                    [_manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
                        if(!error) {
                            DDLogInfo(@"(APVPNManager) Notify that vpn configuration changed.");

                            dispatch_sync(workingQueue, ^{
                                [self setStatuses];
                            });
                        } else {
                            DDLogError(@"(APVPNManager) Error loading vpn configuration: %@, %ld, %@", error.domain, error.code, error.localizedDescription);
                            _lastError = _standartError;
                        }
                    }];
                   }];
    
    [_observers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NEVPNStatusDidChangeNotification
                object: nil //_manager.connection
                   queue:_notificationQueue
                   usingBlock:^(NSNotification *_Nonnull note) {
                        // When connection status is changed
                        [_manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
                            if(!error) {
                                DDLogInfo(@"(APVPNManager) Notify that vpn connection status changed.");

                                dispatch_sync(workingQueue, ^{
                                    [self setStatuses];
                                });
                            } else {
                                DDLogError(@"(APVPNManager) Error loading vpn configuration: %@, %ld, %@", error.domain, error.code, error.localizedDescription);
                                _lastError = _standartError;
                            }
                        }];
                   }];
    
    [_observers addObject:observer];
    
}

- (void)startDelayedOperationsIfNeedIt{
    
    [_busyLock lock];
    if (!_busy) {
        
        if (_lastError) {
            _delayedSetEnabled = nil;
            _delayedSetActiveDnsServer = nil;
        }
        
        int localValue = 0;
        if (_delayedSetActiveDnsServer) {
            DnsServerInfo *server = _delayedSetActiveDnsServer;
            _delayedSetActiveDnsServer = nil;
            dispatch_async(workingQueue, ^{
               
                [self internalSetRemoteServer:server];
            });
        }
        else if (_delayedSetEnabled){
            
            localValue = [_delayedSetEnabled boolValue];
            _delayedSetEnabled = nil;
            dispatch_async(workingQueue, ^{
                [self internalSetEnabled:localValue];
            });
        }
        else if (_delayedSetTunnelMode) {
            
            APVpnManagerTunnelMode mode = [_delayedSetTunnelMode unsignedIntegerValue];
            _delayedSetTunnelMode = nil;
            dispatch_async(workingQueue, ^{
                [self internalSetTunnelMode:mode];
            });
        }
    }
    
    [_busyLock unlock];
}

- (void)initDefinitions{
    [self loadCustomDnsProviders];
}

- (void)sendNotificationForced:(BOOL)forced{
    
    if (forced) {
        [_delayedSendNotify executeNow];
    }
    else {
        [_delayedSendNotify executeOnceAfterCalm];
    }
}

- (void)saveCustomDnsProviders {
    
    NSData *dataForSave = [NSKeyedArchiver archivedDataWithRootObject:_customDnsProviders];
    
    if (dataForSave) {
        [_resources.sharedDefaults setObject:dataForSave forKey:APDefaultsCustomDnsProviders];
        [_resources.sharedDefaults synchronize];
    }
}

- (void)loadCustomDnsProviders {
    
    NSData *loadedData = [_resources.sharedDefaults objectForKey:APDefaultsCustomDnsProviders];
    
    if(loadedData) {
        _customDnsProviders = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    }
    
    if(!_customDnsProviders) {
        _customDnsProviders = [NSMutableArray new];
    }
}

@end

