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


#define VPN_NAME                @" VPN"

NSString *APVpnChangedNotification = @"APVpnChangedNotification";


NSString *APVpnManagerParameterMode = @"APVpnManagerParameterMode";
NSString *APVpnManagerParameterIPv4DNSAddresses = @"APVpnManagerParameterIPv4DNSAddresses";
NSString *APVpnManagerErrorDomain = @"APVpnManagerErrorDomain";

/////////////////////////////////////////////////////////////////////
#pragma mark - APVPNManager

@implementation APVPNManager{
    
    dispatch_queue_t workingQueue;
    
    NETunnelProviderManager *_manager;
    NETunnelProviderProtocol *_protocolConfiguration;
    NSMutableArray *_observers;
    NSArray *_vpnModeDescription;
    NSArray *_vpnModeIPv4DNSAddresses;
    
    BOOL        _enabled;
    
    BOOL         _busy;
    NSLock      *_busyLock;
    NSNumber    *_delayedSetEnabled;
//    NSNumber    *_delayedSetTunnelEnabled;
    NSNumber    *_delayedSetMode;
    
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
                           @"occur in Adguard DNS module. When user turns on "
                           @"Adguard DNS functionality.")
                   }];

        [self initDefinitions];

        [self attachToNotifications];
        _vpnMode = APVpnModeUndef;
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

- (NSString *)modeDescription:(APVpnMode)vpnMode{

    // 'vpnMode > 0' - ignore 0
    if (vpnMode > 0 && _vpnModeDescription.count > vpnMode) {
        return _vpnModeDescription[vpnMode];
    }
    
    return nil;
}

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

- (void)setMode:(APVpnMode)vpnMode {

    _lastError = nil;

    [_busyLock lock];

    if (_busy) {

        _delayedSetMode = @(vpnMode);
    } else {
        dispatch_async(workingQueue, ^{

            [self internalSetMode:vpnMode];
        });
    }

    [_busyLock unlock];
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
                message = [APMDnsLoggingEnabled dataUsingEncoding:NSUTF8StringEncoding];
            } else {
                message = [APMDnsLoggingDisabled dataUsingEncoding:NSUTF8StringEncoding];
            }

            NSError *err = nil;
            [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:nil];
            if (err) {

                DDLogError(@"(APVPNManager) Can't set logging DNS requests to %@: %@, %ld, %@", (dnsRequestsLogging ? @"YES" : @"NO"), err.domain, err.code, err.localizedDescription);
                _lastError = _standartError;
            }

            _dnsRequestsLogging = dnsRequestsLogging;
            [[AESharedResources sharedDefaults] setBool:_dnsRequestsLogging forKey:APDefaultsDnsLoggingEnabled];
            return;
        }
        else {
            
            DDLogError(@"(APVPNManager)  Can't set logging DNS requests to %@: VPN session connection is nil", (dnsRequestsLogging ? @"YES" : @"NO"));
            _lastError = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_CONNECTION_HANDLER userInfo:nil];
        }
    }
}

- (BOOL)clearDnsRequestsLog {

    _lastError = nil;
    
    if (_manager.connection) {

        NSData *message = [APMDnsLoggingClearLog dataUsingEncoding:NSUTF8StringEncoding];

        NSError *err = nil;
        [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:nil];
        if (err) {

            DDLogError(@"(APVPNManager) Can't clear log of the DNS requests: %@, %ld, %@", err.domain, err.code, err.localizedDescription);
            _lastError = _standartError;
        }
        else
            return  YES;
    }
    else {
        
        DDLogError(@"(APVPNManager) Can't clear log of the DNS requests: VPN session connection is nil");
        _lastError = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_CONNECTION_HANDLER userInfo:nil];
    }
    
    return NO;
}

- (void)obtainDnsLogRecords:(void (^)(NSArray<APDnsLogRecord *> *records))completionBlock {

    _lastError = nil;
    
    if (completionBlock == nil) {
        return;
    }
    
    if (_manager.connection) {

        NSData *message = [APMDnsLoggingGiveRecords dataUsingEncoding:NSUTF8StringEncoding];

        NSError *err = nil;
        [(NETunnelProviderSession *)(_manager.connection) sendProviderMessage:message returnError:&err responseHandler:^(NSData *_Nullable responseData) {

            if (responseData.length) {

                NSArray<APDnsLogRecord *> *records = [NSKeyedUnarchiver unarchiveObjectWithData:responseData];
                dispatch_async(dispatch_get_main_queue(), ^{

                    completionBlock(records);
                });
                return;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                
                completionBlock(nil);
            });
        }];

        if (err) {

            DDLogError(@"(APVPNManager) Can't obtain log records of the DNS requests: %@, %ld, %@", err.domain, err.code, err.localizedDescription);
            _lastError = _standartError;
            return;
        }
    }
    else {
        
        DDLogError(@"(APVPNManager) Can't obtain log records of the DNS requests: VPN session connection is nil");
        _lastError = [NSError errorWithDomain:APVpnManagerErrorDomain code:APVPN_MANAGER_ERROR_CONNECTION_HANDLER userInfo:nil];
    }
}

/////////////////////////////////////////////////////////////////////
#pragma mark Helper Methods (Private)

//must be called on workingQueue
- (void)internalSetEnabled:(BOOL)enabled{
    
    if (enabled != _enabled) {
        
        if (_vpnMode == APVpnModeUndef) {
            // if we have initial state, when vpn configuration still was not loaded.
            _delayedSetEnabled = @(enabled);
            return;
        }
        
        
        [self updateConfigurationForMode:_vpnMode enabled:enabled];
    }
}

//must be called on workingQueue
- (void)internalSetMode:(APVpnMode)vpnMode{
    
    if (vpnMode > 0 && vpnMode != _vpnMode) {
        
        if (_vpnMode == APVpnModeUndef) {
            // if we have initial state, when vpn configuration still was not loaded.
            _delayedSetMode = @(vpnMode);
            return;
        }
        
        if (_enabled) {
            _delayedSetEnabled = @(_enabled);
        }
        [self updateConfigurationForMode:vpnMode enabled:NO];
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
            DDLogInfo(@"(APVPNManager) Loading vpn conviguration failured: %@", ([self modeDescription:_vpnMode]?: @"None"));
        }
        else{
            DDLogInfo(@"(APVPNManager) Vpn configuration successfully loaded: %@", ([self modeDescription:_vpnMode]?: @"None"));
        }
        
        [self sendNotification];
    }];
    
}

- (void)updateConfigurationForMode:(APVpnMode)vpnMode enabled:(BOOL)enabled{
    
    [_busyLock lock];
    _busy = YES;
    [_busyLock unlock];
    
    vpnMode = (vpnMode > 0 ? vpnMode : APVpnModeDNS);

    NETunnelProviderProtocol *protocol;
    NETunnelProviderManager *newManager;
    
    if (_protocolConfiguration) {
        protocol = _protocolConfiguration;
    }
    else{
        
        protocol = [NETunnelProviderProtocol new];
        protocol.providerBundleIdentifier =  AE_HOSTAPP_ID @".tunnel";
    }
    protocol.serverAddress = [self modeDescription:vpnMode];
    protocol.providerConfiguration = @{
                                       APVpnManagerParameterMode: @(vpnMode),
                                       APVpnManagerParameterIPv4DNSAddresses: _vpnModeIPv4DNSAddresses[vpnMode]
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
            
            DDLogInfo(@"(APVPNManager) Updating vpn conviguration failured: %@", ([self modeDescription:_vpnMode]?: @"None"));
            
            [self sendNotification];
            return;
        }
        
        DDLogInfo(@"(APVPNManager) Vpn configuration successfully updated: %@", ([self modeDescription:_vpnMode]?: @"None"));
        
        [self loadConfiguration];
    }];
}

- (void)setStatuses{
    
    _enabled = NO;
    
    if (_manager) {
        
        _vpnMode = [_protocolConfiguration.providerConfiguration[APVpnManagerParameterMode] intValue];
        
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
        _vpnMode = APVpnModeNone;
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
            _delayedSetEnabled = _delayedSetMode = nil;
        }
        
        int localValue = 0;
        if (_delayedSetMode) {
            localValue = [_delayedSetMode intValue];
            _delayedSetMode = nil;
            dispatch_async(workingQueue, ^{
               
                [self internalSetMode:localValue];
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

    _vpnModeDescription = @[
                            NSLocalizedString(@"Default system DNS", @"(APVPNManager) PRO version. It is title of the mode when fake VPN is desabled and iOS uses DNS from current network configuration")
                            , NSLocalizedString(@"Default", @"(APVPNManager) PRO version. It is title of the mode when fake VPN is enabled and iOS uses Adguard DNS, where only 'regular' ads will be blocked")
                            , NSLocalizedString(@"Family Protection", @"(APVPNManager) PRO version. It is title of the mode when fake VPN is enabled and iOS uses Adguard Famaly DNS")
                            ];
    _vpnModeIPv4DNSAddresses = @[
                             @[]
                             , @[@"176.103.130.130",@"176.103.130.131"]
                             , @[@"176.103.130.132", @"176.103.130.134"]
                             ];
}

- (void)sendNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:APVpnChangedNotification object:self];
        
        // Reset last ERROR!!!
        _lastError = nil;
    });

}

@end

