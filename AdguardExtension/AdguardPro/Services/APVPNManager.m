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


#import "APVPNManager.h"
#import <NetworkExtension/NetworkExtension.h>
#import "ACommons/ACLang.h"
#import "ACommons/ACSystem.h"
#import "APSharedResources.h"
#import "AppDelegate.h"
#import "ACommons/ACNetwork.h"
#import "AEBlacklistDomainObject.h"
#import "ASDFilterObjects.h"
#import "APDnsServerObject.h"
#import "AEService.h"
#import "AESAntibanner.h"


#define VPN_NAME                            @" VPN"
#define MAX_COUNT_OF_REMOTE_DNS_SERVERS     10

NSString *APVpnChangedNotification = @"APVpnChangedNotification";


NSString *APVpnManagerParameterRemoteDnsServer = @"APVpnManagerParameterRemoteDnsServer";
NSString *APVpnManagerParameterLocalFiltering = @"APVpnManagerParameterLocalFiltering";
NSString *APVpnManagerErrorDomain = @"APVpnManagerErrorDomain";

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

@implementation APVPNManager{
    
    dispatch_queue_t workingQueue;
    
    NETunnelProviderManager *_manager;
    NETunnelProviderProtocol *_protocolConfiguration;
    NSMutableArray *_observers;
    
    BOOL        _enabled;
    
    BOOL         _busy;
    NSLock      *_busyLock;
    NSNumber    *_delayedSetEnabled;
//    NSNumber    *_delayedSetTunnelEnabled;
    
    APDnsServerObject *_activeRemoteDnsServer;
    APDnsServerObject *_delayedSetActiveRemoteDnsServer;
    
    BOOL               _localFiltering;
    NSNumber          *_delayedSetLocalFiltering;
    
    NSError     *_standartError;
    
    BOOL _dnsRequestsLogging;
}

static APVPNManager *singletonVPNManager;

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize

+ (APVPNManager *)singleton{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        singletonVPNManager = [APVPNManager alloc];
        singletonVPNManager = [singletonVPNManager init];
    });
    
    return singletonVPNManager;
    
}

- (id)init{
    
    if (singletonVPNManager != self) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        workingQueue = dispatch_queue_create("APVPNManager", DISPATCH_QUEUE_SERIAL);
        _busy = NO;
        _busyLock = [NSLock new];

        _standartError = [NSError
            errorWithDomain:APVpnManagerErrorDomain
                       code:APVPN_MANAGER_ERROR_STANDART
                   userInfo:@{
                       NSLocalizedDescriptionKey : NSLocalizedString(
                           @"There was a problem with VPN configuration, "
                           @"please contact our support team.",
                           @"(APVPNManager)  PRO version. Error, which may "
                           @"occur in DNS Filtering module. When user turns on "
                           @"DNS Filtering functionality.")
                   }];

        [self initDefinitions];

        [self attachToNotifications];
        
        _maxCountOfRemoteDnsServers = MAX_COUNT_OF_REMOTE_DNS_SERVERS;
        _localFiltering = YES;
        _connectionStatus = APVpnConnectionStatusDisconnecting;
        _enabled = NO;
        
        _dnsRequestsLogging = [[AESharedResources sharedDefaults] boolForKey:APDefaultsDnsLoggingEnabled];
        
        [self loadConfiguration];
    }
    
    return self;
}

- (void)dealloc{
    
    for (id observer in _observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
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
            
            [self internalSetEnabled:enabled];
        });
    }
    
    [_busyLock unlock];
}

- (void)setActiveRemoteDnsServer:(APDnsServerObject *)activeRemoteDnsServer {
    
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetActiveRemoteDnsServer = activeRemoteDnsServer;
    } else {
        dispatch_async(workingQueue, ^{
            
            [self internalSetRemoteServer:activeRemoteDnsServer];
        });
    }
    
    [_busyLock unlock];
    
}

- (APDnsServerObject *)activeRemoteDnsServer {
    
    return _activeRemoteDnsServer;
}

- (void)setLocalFiltering:(BOOL)localFiltering {
    
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetLocalFiltering = @(localFiltering);
    } else {
        dispatch_async(workingQueue, ^{
            
            [self internalSetLocalFiltering:localFiltering];
        });
    }
    
    [_busyLock unlock];
    
}

- (BOOL)localFiltering {
    
    return _localFiltering;
}

- (BOOL)dnsRequestsLogging {

    return _dnsRequestsLogging;
}

- (void)setDnsRequestsLogging:(BOOL)dnsRequestsLogging {

    if (dnsRequestsLogging != _dnsRequestsLogging) {

        _lastError = nil;
        if (_manager.connection) {

            NSData *message;
            if (dnsRequestsLogging) {
                message = [APSharedResources host2tunnelMessageLogEnabled];
            } else {
                message = [APSharedResources host2tunnelMessageLogDisabled];
            }

            NSError *err = nil;
            [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:nil];
            if (err) {

                DDLogError(@"(APVPNManager) Can't set logging DNS requests to %@: %@, %ld, %@", (dnsRequestsLogging ? @"YES" : @"NO"), err.domain, err.code, err.localizedDescription);
                _lastError = _standartError;
            }
            else {
                
                _dnsRequestsLogging = dnsRequestsLogging;
            }

            [[AESharedResources sharedDefaults] setBool:_dnsRequestsLogging forKey:APDefaultsDnsLoggingEnabled];
        }
        else {
            
            DDLogError(@"(APVPNManager)  Can't set logging DNS requests to %@: VPN session connection is nil", (dnsRequestsLogging ? @"YES" : @"NO"));
            _dnsRequestsLogging = NO;
            _lastError = _standartError;
            [[AESharedResources sharedDefaults] setBool:_dnsRequestsLogging forKey:APDefaultsDnsLoggingEnabled];
        }
        
        [self sendNotification];
    }
}

- (void)sendReloadUserfilterDataIfRule:(ASDFilterRule *)rule {
    
    if (! ([[AEWhitelistDomainObject alloc] initWithRule:rule]
           || [[AEBlacklistDomainObject alloc] initWithRule:rule])) {
        
        return;
    }
    
    _lastError = nil;
    if (_manager.connection) {
        
        NSData *message = [APSharedResources host2tunnelMessageUserfilterDataReload];
        NSError *err = nil;
        [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:nil];
        if (err) {
            
            DDLogError(@"(APVPNManager) Can't send message for reload user filter data: %@, %ld, %@", err.domain, err.code, err.localizedDescription);
            _lastError = _standartError;
        }
        return;
    }
    else {
        
        DDLogError(@"(APVPNManager)  Can't send message for reload user filter data: VPN session connection is nil");
        _lastError = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_CONNECTION_HANDLER userInfo:nil];
    }
}

- (BOOL)clearDnsRequestsLog {

    _lastError = nil;

    return [APSharedResources removeDnsLog];
}

- (void)obtainDnsLogRecords:(void (^)(NSArray<APDnsLogRecord *> *records))completionBlock {

    _lastError = nil;
    
    if (completionBlock == nil) {
        return;
    }
    
    NSArray <APDnsLogRecord *> *records = [APSharedResources readDnsLog];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        completionBlock(records);
    });
}

- (BOOL)addRemoteDnsServer:(APDnsServerObject *)server {
    
    if (server.editable
        && _remoteDnsServers
        && _remoteDnsServers.count < self.maxCountOfRemoteDnsServers
        && ! [_remoteDnsServers containsObject:server]) {
        
        dispatch_sync(workingQueue, ^{
           
            _remoteDnsServers = [_remoteDnsServers arrayByAddingObject:server];
            
            [self saveRemoteDnsServersToDefaults];
        });
        
        return YES;
    }
    
    return NO;
}

- (BOOL)removeRemoteDnsServer:(APDnsServerObject *)server {
    
    if (server.editable &&  _remoteDnsServers && [_remoteDnsServers containsObject:server]) {
        
        if ([_activeRemoteDnsServer isEqual:server]) {
            self.activeRemoteDnsServer = _remoteDnsServers[0];
        }
        
        // async because method have not returns value
        dispatch_sync(workingQueue, ^{
            
            NSMutableArray *servers = [_remoteDnsServers mutableCopy];
            [servers removeObject:server];
            _remoteDnsServers = [servers copy];
            
            [self saveRemoteDnsServersToDefaults];
        });
        
        return YES;
    }
    
    return NO;
}

- (BOOL)resetRemoteDnsServer:(APDnsServerObject *)server {
    
    if (server.editable &&  _remoteDnsServers && [_remoteDnsServers containsObject:server]) {
        
        BOOL resetEnabled = NO;
        if ([self.activeRemoteDnsServer isEqual:server]) {
            resetEnabled = YES;
        }
       __block BOOL result = NO;
        dispatch_sync(workingQueue, ^{
            
            NSUInteger index = [_remoteDnsServers indexOfObject:server];
            APDnsServerObject *remoteDnsServer = _remoteDnsServers[index];
            if (remoteDnsServer.editable) {
        
                NSMutableArray *servers = [[_remoteDnsServers subarrayWithRange:NSMakeRange(0, index)] mutableCopy];
                [servers addObject:server];
                [servers addObjectsFromArray:
                 [_remoteDnsServers subarrayWithRange:NSMakeRange((index + 1), (_remoteDnsServers.count - index - 1))]];
                _remoteDnsServers = [servers copy];
                
                [self saveRemoteDnsServersToDefaults];
                
                result = YES;
            }
        });
        
        if (result && resetEnabled) {
            
            _activeRemoteDnsServer = _remoteDnsServers[0];
            
            self.activeRemoteDnsServer = server;
        }
        return result;
    }
    
    return NO;
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (Private)

//must be called on workingQueue
- (void)internalSetEnabled:(BOOL)enabled{
    
    if (enabled != _enabled) {
        
        if (_activeRemoteDnsServer == nil) {
            // if we have initial state, when vpn configuration still was not loaded.
            _delayedSetEnabled = @(enabled);
            return;
        }
        
        
        [self updateConfigurationForLocalFiltering:_localFiltering remoteServer:_activeRemoteDnsServer enabled:enabled];
    }
}

//must be called on workingQueue
- (void)internalSetRemoteServer:(APDnsServerObject *)server{
    
    if (_activeRemoteDnsServer == nil) {
        // if we have initial state, when vpn configuration still was not loaded.
        _delayedSetActiveRemoteDnsServer = server;
        return;
    }
    
    if (server
        && ![server isEqual:_activeRemoteDnsServer]
        && [_remoteDnsServers containsObject:server]) {
        
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForLocalFiltering:_localFiltering remoteServer:server enabled:NO];
    }
}

//must be called on workingQueue
- (void)internalSetLocalFiltering:(BOOL)localFiltering{
    
    if (localFiltering != _localFiltering) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        
        if (localFiltering) {
            
            if (![self prepareForLocalFiltering]) {
                
                DDLogError(@"Error occurred when loading Simplified domain names filter.");
                _lastError = [NSError
                              errorWithDomain:APVpnManagerErrorDomain
                              code:APVPN_MANAGER_ERROR_INSTALL_FILTER
                              userInfo:@{
                                         NSLocalizedDescriptionKey :
                                             NSLocalizedString(@"Unable to install filter for local filtering of the DNS. Contact to support team.",
                                                               @"(APVPNManager)  PRO version. Error, which may occur in DNS Filtering module. When user turns on Local Filtering functionality.")
                                         }];
                DDLogErrorTrace();
                
                [self sendNotification];

                return;
            }
        }
        [self updateConfigurationForLocalFiltering:localFiltering remoteServer:_activeRemoteDnsServer enabled:NO];
    }
}

/*
//must be called on workingQueue
- (void)internalSetTunnelEnabled:(BOOL)enabled{
    
    if (_connectionStatus) {

        switch (_connectionStatus) {

        case APVpnConnectionStatusDisconnected:
        case APVpnConnectionStatusInvalid:
            if (enabled) {

                NSError *err;
                BOOL result = [(NETunnelProviderSession *)_manager.connection
                    startTunnelWithOptions:nil
                            andReturnError:&err];
                if (!result || err) {

                    DDLogError(@"(APVPNManager) Error occurs when starting tunnel: %@", err.localizedDescription);
                    _lastError = _standartError;
                    [self sendNotification];
                    return;
                }
                DDLogInfo(@"(APVPNManager) Tunnel started in mode: %@", [self modeDescription:_vpnMode]);
            }
            break;

        case APVpnConnectionStatusDisconnecting:
        case APVpnConnectionStatusConnecting:
            _delayedSetTunnelEnabled = @(enabled);
            break;

        case APVpnConnectionStatusReconnecting:
        case APVpnConnectionStatusConnected:
            if (enabled) {
                _delayedSetTunnelEnabled = @(YES);
            }
            [(NETunnelProviderSession *)_manager.connection stopTunnel];
            DDLogInfo(@"(APVPNManager) Tunnel stoped in mode: %@",
                      [self modeDescription:_vpnMode]);
            break;

        default:
            break;
        }
    }
    else{
        
        if (enabled) {
            
            _delayedSetTunnelEnabled = @(enabled);
            [self updateConfigurationForMode:_vpnMode enabled:enabled];
        }
    }
}
*/

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
                _manager = managers[0];
                _protocolConfiguration = (NETunnelProviderProtocol *)_manager.protocolConfiguration;
            }
        }

        [_busyLock lock];
        _busy = NO;
        [_busyLock unlock];
        
        dispatch_sync(workingQueue, ^{
            
            [self setStatuses];
        });
        
        if (error) {
            DDLogInfo(@"(APVPNManager) Loading vpn conviguration failured: %@, local filtering: %@",
                      (self.activeRemoteDnsServer.serverName ?: @"None"),
                      (self.localFiltering ? @"YES" : @"NO"));
        }
        else{
            DDLogInfo(@"(APVPNManager) Vpn configuration successfully loaded: %@, local filtering: %@",
                      (self.activeRemoteDnsServer.serverName ?: @"None"),
                      (self.localFiltering ? @"YES" : @"NO"));
        }
        
        [self sendNotification];
    }];
    
}

- (void)updateConfigurationForLocalFiltering:(BOOL)localFiltering remoteServer:(APDnsServerObject *)remoteServer enabled:(BOOL)enabled{
    
    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    if (remoteServer == nil) {
        
        remoteServer = _remoteDnsServers[0];
    }

    //Check input parameters
    
    if (enabled
        && [remoteServer.tag isEqualToString:APDnsServerTagLocal]
        && localFiltering == NO) {
        
        _lastError = [NSError
                      errorWithDomain:APVpnManagerErrorDomain
                      code:APVPN_MANAGER_ERROR_BADCONFIGURATION
                      userInfo:@{
                                 NSLocalizedDescriptionKey :
                                     NSLocalizedString(@"VPN will not be enabled because you have turned off the filtering locally, and are not using spoofing DNS server.",
                                                       @"(APVPNManager)  PRO version. Bad configuration error, which may occur in DNS Filtering module. When user turns on DNS Filtering functionality.")
                                 }];

        [_busyLock lock];
        _busy = NO;
        [_busyLock unlock];
        
        [self sendNotification];
        return;
    }
    
    //------
    
    NETunnelProviderProtocol *protocol;
    NETunnelProviderManager *newManager;
    
    if (_protocolConfiguration) {
        protocol = _protocolConfiguration;
    }
    else{
        
        protocol = [NETunnelProviderProtocol new];
        protocol.providerBundleIdentifier =  AE_HOSTAPP_ID @".tunnel";
    }
    
    NSData *remoteServerData = [NSKeyedArchiver archivedDataWithRootObject:remoteServer];
    protocol.serverAddress = remoteServer.serverName;
    protocol.providerConfiguration = @{
                                       APVpnManagerParameterLocalFiltering: @(localFiltering),
                                       APVpnManagerParameterRemoteDnsServer: remoteServerData
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
            
            DDLogInfo(@"(APVPNManager) Updating vpn conviguration failured: %@, local filtering: %@",
                      (self.activeRemoteDnsServer.serverName ?: @"None"),
                      (self.localFiltering ? @"YES" : @"NO"));
            
            [self sendNotification];
            return;
        }
        
        DDLogInfo(@"(APVPNManager) Vpn configuration successfully updated: %@, local filtering: %@",
                  (self.activeRemoteDnsServer.serverName ?: @"None"),
                  (self.localFiltering ? @"YES" : @"NO"));
        
        [self loadConfiguration];
    }];
}

- (void)setStatuses{
    
    _enabled = NO;
    
    if (_manager) {
        
        NSData *remoteDnsServerData = _protocolConfiguration.providerConfiguration[APVpnManagerParameterRemoteDnsServer];
        _activeRemoteDnsServer = [NSKeyedUnarchiver unarchiveObjectWithData:remoteDnsServerData];
        _localFiltering = [_protocolConfiguration.providerConfiguration[APVpnManagerParameterLocalFiltering] boolValue];
        
        if (_manager.enabled && _manager.onDemandEnabled) {
            
            _enabled = YES;

            switch (_manager.connection.status) {
                    
                case NEVPNStatusDisconnected:
                    _connectionStatus = APVpnConnectionStatusDisconnected;
                    break;
                    
                case NEVPNStatusReasserting:
                    _connectionStatus = APVpnConnectionStatusReconnecting;
                    break;
                    
                case NEVPNStatusConnecting:
                    _connectionStatus = APVpnConnectionStatusReconnecting;
                    break;
                    
                case NEVPNStatusDisconnecting:
                    _connectionStatus = APVpnConnectionStatusDisconnecting;
                    break;
                    
                case NEVPNStatusConnected:
                    _connectionStatus = APVpnConnectionStatusConnected;
                    break;
                    
                case NEVPNStatusInvalid:
                default:
                    _connectionStatus = APVpnConnectionStatusInvalid;
                    break;
            }
        }
        else{
            
            _connectionStatus = APVpnConnectionStatusDisabled;
        }
    }
    else{
        _activeRemoteDnsServer = _remoteDnsServers[0];
        _localFiltering = YES;
        _connectionStatus = APVpnConnectionStatusDisabled;
    }
    
    // start delayed
    [self startDelayedOperationsIfNeedIt];
}

- (void)attachToNotifications{
    
//    if (!_manager) {
//        return;
//    }
    
    _observers = [NSMutableArray arrayWithCapacity:2];
    
    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NEVPNConfigurationChangeNotification
                   object: nil //_manager
                   queue:nil
                   usingBlock:^(NSNotification *_Nonnull note) {
                       
                       // When configuration is changed
                       DDLogInfo(@"(APVPNManager) Notify that vpn configuration changed.");
                       [self loadConfiguration];

                   }];
    
    [_observers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NEVPNStatusDidChangeNotification
                object: nil //_manager.connection
                   queue:nil
                   usingBlock:^(NSNotification *_Nonnull note) {
                       
                       // When connection status is changed
                       DDLogInfo(@"(APVPNManager) Notify that vpn connection status changed.");
                       [self setStatuses];
                       [self sendNotification];
                   }];
    
    [_observers addObject:observer];
    
}

- (void)startDelayedOperationsIfNeedIt{
    
    [_busyLock lock];
    if (!_busy) {
        
        if (_lastError) {
            _delayedSetEnabled = nil;
            _delayedSetActiveRemoteDnsServer = nil;
            _delayedSetLocalFiltering = nil;
        }
        
        int localValue = 0;
        if (_delayedSetActiveRemoteDnsServer) {
            APDnsServerObject *server = _delayedSetActiveRemoteDnsServer;
            _delayedSetActiveRemoteDnsServer = nil;
            dispatch_async(workingQueue, ^{
               
                [self internalSetRemoteServer:server];
            });
        }
        else if (_delayedSetLocalFiltering){
            
            localValue = [_delayedSetLocalFiltering boolValue];
            _delayedSetLocalFiltering = nil;
            dispatch_async(workingQueue, ^{
                [self internalSetLocalFiltering:localValue];
            });
        }
        else if (_delayedSetEnabled){
            
            localValue = [_delayedSetEnabled boolValue];
            _delayedSetEnabled = nil;
            dispatch_async(workingQueue, ^{
                [self internalSetEnabled:localValue];
            });
        }
    }
    
    [_busyLock unlock];
}

- (void)initDefinitions{
    
    [self loadRemoteDnsServersFromDefaults];

    if (_remoteDnsServers == nil) {
        
        // Create default Adgaurd servers
        
        NSMutableArray *servers = [NSMutableArray arrayWithCapacity:3];
        APDnsServerObject *server = [[APDnsServerObject alloc] initWithName: @"None"
                                                                description: @"None"
                                                                ipAddresses:@"127.0.0.1, ::1"];
        server.tag = APDnsServerTagLocal;
        server.editable = NO;
        
        [servers addObject:server];

        server = [[APDnsServerObject alloc] initWithName: @"Adguard Default"
                                             description: @"Adguard Default"
                                             ipAddresses:@"176.103.130.130, 176.103.130.131"];
        server.editable = NO;
        [servers addObject:server];

        server = [[APDnsServerObject alloc] initWithName: @"Adguard Family Protection"
                                             description: @"Adguard Family Protection"
                                             ipAddresses:@"176.103.130.132, 176.103.130.134"];
        server.editable = NO;
        [servers addObject:server];
        _remoteDnsServers = [servers copy];
        
        [self saveRemoteDnsServersToDefaults];
    }
    
    //Changes names and descriptions for predefined servers
    
    APDnsServerObject *server = _remoteDnsServers[0];
    server.serverName = NSLocalizedString(@"System Default", @"(APVPNManager) PRO version. It is title of the mode when iOS uses DNS from current network configuration");
    server.serverDescription = NSLocalizedString(@"used default system DNS settings", @"(APVPNManager) PRO version. It is description of the mode when iOS uses DNS from current network configuration");
    
    
    server = _remoteDnsServers[1];
    server.serverName = NSLocalizedString(@"Adguard Default", @"(APVPNManager) PRO version. It is title of the mode when fake VPN is enabled and iOS uses DNS Filtering, where only 'regular' ads will be blocked");
    server.serverDescription = NSLocalizedString(@"blocks ads, trackers and phishing websites", @"(APVPNManager) PRO version. It is description of the mode when fake VPN is enabled and iOS uses DNS Filtering, where only 'regular' ads will be blocked");
    
    server = _remoteDnsServers[2];
    server.serverName = NSLocalizedString(@"Adguard Family Protection", @"(APVPNManager) PRO version. It is title of the mode when fake VPN is enabled and iOS uses Adguard Famaly DNS");
    server.serverDescription = NSLocalizedString(@"blocks ads, trackers and phishing websites", @"(APVPNManager) PRO version. It is description of the mode when fake VPN is enabled and iOS uses Adguard Famaly DNS");

}

- (void)sendNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:APVpnChangedNotification object:self];
        
        // Reset last ERROR!!!
        _lastError = nil;
    });

}

- (void)saveRemoteDnsServersToDefaults {
    
    NSData *dataForSave = [NSKeyedArchiver archivedDataWithRootObject:_remoteDnsServers];
    
    if (dataForSave) {
        [[AESharedResources sharedDefaults] setObject:dataForSave forKey:APDefaultsRemoteDnsServers];
        [[AESharedResources sharedDefaults] synchronize];
    }
}

- (void)loadRemoteDnsServersFromDefaults {
 
    NSData *loadedData = [[AESharedResources sharedDefaults] objectForKey:APDefaultsRemoteDnsServers];
    
    if (loadedData) {
        _remoteDnsServers = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    }
}

/**
 Checks that Simplified Domain Names Filter was installed. If not, installs it.
 */
- (BOOL)prepareForLocalFiltering {
 
    AESAntibanner *antibanner = [[AEService singleton] antibanner];
    if ([antibanner checkIfFilterInstalled:@(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)]) {
        
        return YES;
    }
    else {
        
        NSArray *filters = [[[antibanner metadataForSubscribe:NO] filters]
                            filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterId == %@", @(ASDF_SIMPL_DOMAINNAMES_FILTER_ID)]];
        if (filters.count == 1) {
            ASDFilterMetadata *filter = filters[0];
            
            filter.removable = @(NO);
            filter.editable = @(NO);
            filter.enabled = @(NO);

            return [antibanner subscribeFilters:filters jobController:nil];
        }
    }

    return NO;
}

@end

