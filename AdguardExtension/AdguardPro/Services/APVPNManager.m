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
#import "ASDFilterObjects.h"
#import "APDnsServerObject.h"
#import "AEService.h"
#import "AESAntibanner.h"


#define VPN_NAME                            @" VPN"
#define MAX_COUNT_OF_REMOTE_DNS_SERVERS     16
#define NOTIFICATION_DELAY                  1

NSString *APVpnChangedNotification = @"APVpnChangedNotification";


NSString *APVpnManagerParameterRemoteDnsServer = @"APVpnManagerParameterRemoteDnsServer";
NSString *APVpnManagerParameterLocalFiltering = @"APVpnManagerParameterLocalFiltering";
NSString *APVpnManagerErrorDomain = @"APVpnManagerErrorDomain";
NSString *APVpnManagerTunnelMode = @"APVpnManagerTunnelMode";

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

@implementation APVPNManager{
    
    dispatch_queue_t workingQueue;
    NSOperationQueue *_notificationQueue;
    
    ACLExecuteBlockDelayed *_delayedSendNotify;
    
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
    
    APVpnManagerTunnelModeEnum _tunnelMode;
    NSNumber          *_delayedSetTunnelMode;
    
    NSError     *_standartError;
    
    BOOL _dnsRequestsLogging;
    
    NSMutableArray <APDnsServerObject *> *_customRemoteDnsServers;
}

static APVPNManager *singletonVPNManager;

/////////////////////////////////////////////////////////////////////
#pragma mark Initialize and class properties

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
        _notificationQueue = [NSOperationQueue new];
        _notificationQueue.underlyingQueue = workingQueue;
        _notificationQueue.name = @"APVPNManager notification";
        
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
        _localFiltering = NO;
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


+ (NSMutableArray <APDnsServerObject *> *)predefinedDnsServers {
    
    // Create default Adgaurd servers
    
    NSMutableArray *predefinedRemoteDnsServers = [NSMutableArray arrayWithCapacity:3];
    APDnsServerObject *server = [[APDnsServerObject alloc]
                                 initWithUUID: @"AGDEF00"
                                 name: NSLocalizedString(@"System Default", @"(APVPNManager) PRO version. It is title of the mode when iOS uses DNS from current network configuration")
                                 description: NSLocalizedString(@"default system DNS settings are used", @"(APVPNManager) PRO version. It is description of the mode when iOS uses DNS from current network configuration")
                                 ipAddresses:@"127.0.0.1, ::1"];
    server.tag = APDnsServerTagLocal;
    server.editable = NO;
    
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF01"
              name: NSLocalizedString(@"Adguard Default", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses DNS Filtering, when only 'regular' ads are blocked.")
              description: NSLocalizedString(@"blocks ads, trackers and phishing websites", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the Adguard DNS 'Default' mode.")
              ipAddresses:@"176.103.130.130, 176.103.130.131"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF02"
              name: NSLocalizedString(@"Adguard Family Protection", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses DNS Filtering, when 'regular' ads are blocked as well as adult websites.")
              description: NSLocalizedString(@"blocks all above and adult websites", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the Adguard DNS 'Family Protection' mode.")
              ipAddresses:@"176.103.130.132, 176.103.130.134"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF03"
              name: NSLocalizedString(@"OpenDNS Home", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses OpenDNS Home.")
              description: NSLocalizedString(@"custom filtering and identity theft protection", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the 'OpenDNS Home' mode.")
              ipAddresses:@"208.67.222.222, 208.67.220.220"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF04"
              name: NSLocalizedString(@"OpenDNS Family Shield", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses OpenDNS Family Shield.")
              description: NSLocalizedString(@"preconfigured to block adult content", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the 'OpenDNS Family Shield' mode.")
              ipAddresses:@"208.67.222.123, 208.67.220.123"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF06"
              name: NSLocalizedString(@"Yandex DNS Safe", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses Yandex DNS Safe.")
              description: NSLocalizedString(@"protection from virus and fraudulent content", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the 'Yandex DNS Safe' mode.")
              ipAddresses:@"77.88.8.88, 77.88.8.2"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF07"
              name: NSLocalizedString(@"Yandex DNS Family", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses Yandex DNS Family.")
              description: NSLocalizedString(@"blocks all above and adult content", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the 'Yandex DNS Family' mode.")
              ipAddresses:@"77.88.8.7, 77.88.8.3"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    server = [[APDnsServerObject alloc]
              initWithUUID: @"AGDEF05"
              name: NSLocalizedString(@"Google Public DNS", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the title of the mode that requires fake VPN and uses Google Public DNS.")
              description: NSLocalizedString(@"global dns resolution service provided by Google", @"(APVPNManager) PRO version. On the DNS Filtering screen. It is the description of the 'Google Public DNS' mode.")
              ipAddresses:@"8.8.8.8, 8.8.4.4, 2001:4860:4860::8888, 2001:4860:4860::8844"];
    server.editable = NO;
    [predefinedRemoteDnsServers addObject:server];
    
    return predefinedRemoteDnsServers;
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

- (void)setTunnelMode:(APVpnManagerTunnelModeEnum)tunnelMode {
    _lastError = nil;
    
    [_busyLock lock];
    
    if (_busy) {
        
        _delayedSetTunnelMode = @(tunnelMode);
    } else {
        dispatch_async(workingQueue, ^{
            
            [self internalSetTunnelMode:tunnelMode];
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

- (APVpnManagerTunnelModeEnum)tunnelMode {
    return _tunnelMode;
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
            
            DDLogWarn(@"(APVPNManager)  Can't set logging DNS requests to %@: VPN session connection is nil", (dnsRequestsLogging ? @"YES" : @"NO"));
            _dnsRequestsLogging = NO;
            [[AESharedResources sharedDefaults] setBool:_dnsRequestsLogging forKey:APDefaultsDnsLoggingEnabled];
        }
        
        [self sendNotificationForced:NO];
    }
}

- (void)sendReloadSystemWideDomainLists {
    
    _lastError = nil;
    if (_manager.connection) {
        
        NSData *message = [APSharedResources host2tunnelMessageSystemWideDomainListReload];
        NSError *err = nil;
        [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:nil];
        if (err) {
            
            DDLogError(@"(APVPNManager) Can't send message for reload domains lists data: %@, %ld, %@", err.domain, err.code, err.localizedDescription);
            _lastError = _standartError;
        }
    }
    else {
        
        DDLogWarn(@"(APVPNManager)  Can't send message for reload domains lists data: VPN session connection is nil");
    }
    
    [self sendNotificationForced:NO];
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
            [_customRemoteDnsServers addObject:server];
            
            [self saveCustomRemoteDnsServersToDefaults];
        });
        
        return YES;
    }
    
    return NO;
}

- (BOOL)removeRemoteDnsServer:(APDnsServerObject *)server {
    
    if (server.editable &&  _remoteDnsServers && [_remoteDnsServers containsObject:server]) {
        
        if ([_activeRemoteDnsServer isEqual:server]) {
            self.activeRemoteDnsServer = _remoteDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
        }
        
        // async because method have not returns value
        dispatch_sync(workingQueue, ^{
            
            [_customRemoteDnsServers removeObject:server];
            _remoteDnsServers = [APVPNManager.predefinedDnsServers copy];
            _remoteDnsServers = [_remoteDnsServers arrayByAddingObjectsFromArray:_customRemoteDnsServers];
            
            [self saveCustomRemoteDnsServersToDefaults];
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
            
            NSUInteger index = [_customRemoteDnsServers indexOfObject:server];
            APDnsServerObject *remoteDnsServer = _customRemoteDnsServers[index];
            if (remoteDnsServer.editable) {
        
                [_customRemoteDnsServers replaceObjectAtIndex:index withObject:server];
                _remoteDnsServers = [APVPNManager.predefinedDnsServers copy];
                _remoteDnsServers = [_remoteDnsServers arrayByAddingObjectsFromArray:_customRemoteDnsServers];
                
                [self saveCustomRemoteDnsServersToDefaults];
                
                result = YES;
            }
        });
        
        if (result && resetEnabled) {
            
            _activeRemoteDnsServer = _remoteDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
            
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
        
        
        [self updateConfigurationForLocalFiltering:_localFiltering remoteServer:_activeRemoteDnsServer tunnelMode:_tunnelMode enabled:enabled];
        
        // If do not completely stop the tunnel in full mode, then other VPNs can not start
        if(!enabled && _tunnelMode == APVpnManagerTunnelModeFull) {
            [(NETunnelProviderSession *)_manager.connection stopTunnel];
        }

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
        [self updateConfigurationForLocalFiltering:_localFiltering remoteServer:server tunnelMode:_tunnelMode enabled:NO];
    }
}

//must be called on workingQueue
- (void)internalSetLocalFiltering:(BOOL)localFiltering{
    
    if (localFiltering != _localFiltering) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        
        [self updateConfigurationForLocalFiltering:localFiltering remoteServer:_activeRemoteDnsServer tunnelMode:_tunnelMode enabled:NO];
    }
}

//must be called on workingQueue
- (void)internalSetTunnelMode:(APVpnManagerTunnelModeEnum)tunnelMode {
    if(tunnelMode != _tunnelMode) {
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForLocalFiltering:_localFiltering remoteServer:_activeRemoteDnsServer tunnelMode:tunnelMode enabled:NO];
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
                
                //Checks that loaded configuration is related to tunnel bundle ID.
                //If no, removes all old configurations.
                if (! [_protocolConfiguration.providerBundleIdentifier isEqualToString:AP_TUNNEL_ID]) {
                    for (NETunnelProviderManager *item in managers) {
                        [item removeFromPreferencesWithCompletionHandler:nil];
                    }
                    
                    _manager = nil;
                    _protocolConfiguration = nil;
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
            DDLogInfo(@"(APVPNManager) Loading vpn conviguration failured: %@, local filtering: %@",
                      (self.activeRemoteDnsServer.serverName ?: @"None"),
                      (self.localFiltering ? @"YES" : @"NO"));
        }
        else{
            DDLogInfo(@"(APVPNManager) Vpn configuration successfully loaded: %@, local filtering: %@",
                      (self.activeRemoteDnsServer.serverName ?: @"None"),
                      (self.localFiltering ? @"YES" : @"NO"));
        }
        
        [self sendNotificationForced:YES];
    }];
    
}

- (void)updateConfigurationForLocalFiltering:(BOOL)localFiltering remoteServer:(APDnsServerObject *)remoteServer tunnelMode:(APVpnManagerTunnelModeEnum) tunnelMode enabled:(BOOL)enabled{
    
    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    if (remoteServer == nil) {
        
        remoteServer = _remoteDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
    }

    //Check input parameters
    
//    if (enabled
//        && [remoteServer.tag isEqualToString:APDnsServerTagLocal]
//        && localFiltering == NO) {
//
//        _lastError = [NSError
//                      errorWithDomain:APVpnManagerErrorDomain
//                      code:APVPN_MANAGER_ERROR_BADCONFIGURATION
//                      userInfo:@{
//                                 NSLocalizedDescriptionKey :
//                                     NSLocalizedString(@"VPN can not be enabled because you have turned off the System-wide ad blocking and are not using spoofing DNS server.",
//                                                       @"(APVPNManager)  PRO version. Bad configuration error, which may occur in DNS Filtering module. When user turns on DNS Filtering functionality.")
//                                 }];
//
//        [_busyLock lock];
//        _busy = NO;
//        [_busyLock unlock];
//
//        [self sendNotificationForced:NO];
//        return;
//    }
    
    //------
    
    NETunnelProviderProtocol *protocol;
    NETunnelProviderManager *newManager;
    
    if (_protocolConfiguration) {
        protocol = _protocolConfiguration;
    }
    else{
        
        protocol = [NETunnelProviderProtocol new];
        protocol.providerBundleIdentifier =  AP_TUNNEL_ID;
    }
    
    NSData *remoteServerData = [NSKeyedArchiver archivedDataWithRootObject:remoteServer];
    protocol.serverAddress = remoteServer.serverName;
    protocol.providerConfiguration = @{
                                       APVpnManagerParameterLocalFiltering: @(localFiltering),
                                       APVpnManagerParameterRemoteDnsServer: remoteServerData,
                                       APVpnManagerTunnelMode: @(tunnelMode)
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
            
            [self sendNotificationForced:NO];
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
        
        // Getting current settings from configuration.
        //If settings are incorrect, then we assign default values.
        _activeRemoteDnsServer = [NSKeyedUnarchiver unarchiveObjectWithData:remoteDnsServerData] ?: _remoteDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
        _localFiltering = _protocolConfiguration.providerConfiguration[APVpnManagerParameterLocalFiltering] ?
        [_protocolConfiguration.providerConfiguration[APVpnManagerParameterLocalFiltering] boolValue] : APVPN_MANAGER_DEFAULT_LOCAL_FILTERING;
        _tunnelMode = _protocolConfiguration.providerConfiguration[APVpnManagerTunnelMode] ?
        [_protocolConfiguration.providerConfiguration[APVpnManagerTunnelMode] unsignedIntValue] : APVpnManagerTunnelModeSplit;
        //-------------
        
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
        _activeRemoteDnsServer = _remoteDnsServers[APVPN_MANAGER_DEFAULT_DNS_SERVER_INDEX];
        _localFiltering = APVPN_MANAGER_DEFAULT_LOCAL_FILTERING;
        _connectionStatus = APVpnConnectionStatusDisabled;
        
        DDLogInfo(@"(APVPNManager) Updated Status:\nNo manager instance.");
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
                   queue:_notificationQueue
                   usingBlock:^(NSNotification *_Nonnull note) {
                       
                       // When configuration is changed
                       DDLogInfo(@"(APVPNManager) Notify that vpn configuration changed.");
                       [self loadConfiguration];

                   }];
    
    [_observers addObject:observer];
    
    observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:NEVPNStatusDidChangeNotification
                object: nil //_manager.connection
                   queue:_notificationQueue
                   usingBlock:^(NSNotification *_Nonnull note) {
                       
                       // When connection status is changed
                       DDLogInfo(@"(APVPNManager) Notify that vpn connection status changed.");
                       [self setStatuses];
                       [self sendNotificationForced:NO];
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
        else if (_delayedSetTunnelMode) {
            
            APVpnManagerTunnelModeEnum mode = [_delayedSetTunnelMode unsignedIntegerValue];
            _delayedSetTunnelMode = nil;
            dispatch_async(workingQueue, ^{
                [self internalSetTunnelMode:mode];
            });
        }
    }
    
    [_busyLock unlock];
}

- (void)initDefinitions{
    
        // Create default Adgaurd servers
        
    _remoteDnsServers = [APVPNManager.predefinedDnsServers copy];
    
    [self loadCustomRemoteDnsServersFromDefaults];
    _remoteDnsServers = [_remoteDnsServers arrayByAddingObjectsFromArray:_customRemoteDnsServers];
}

- (void)sendNotificationForced:(BOOL)forced{
    
    if (forced) {
        [_delayedSendNotify executeNow];
    }
    else {
        [_delayedSendNotify executeOnceAfterCalm];
    }
}

- (void)saveCustomRemoteDnsServersToDefaults {
    
    NSData *dataForSave = [NSKeyedArchiver archivedDataWithRootObject:_customRemoteDnsServers];
    
    if (dataForSave) {
        [[AESharedResources sharedDefaults] setObject:dataForSave forKey:APDefaultsCustomRemoteDnsServers];
        [[AESharedResources sharedDefaults] synchronize];
    }
}

- (void)loadCustomRemoteDnsServersFromDefaults {
 
    NSData *loadedData = [[AESharedResources sharedDefaults] objectForKey:APDefaultsCustomRemoteDnsServers];
    
    if (loadedData) {
        _customRemoteDnsServers = [NSKeyedUnarchiver unarchiveObjectWithData:loadedData];
    }
    else {
        _customRemoteDnsServers = [NSMutableArray arrayWithCapacity:MAX_COUNT_OF_REMOTE_DNS_SERVERS];
    }
}

@end

