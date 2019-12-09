#import <Foundation/Foundation.h>

#import "AGDnsProxyEvents.h"


/**
 * Logging levels
 */
typedef NS_ENUM(NSInteger, AGLogLevel) {
    AGLL_TRACE,
    AGLL_DEBUG,
    AGLL_INFO,
    AGLL_WARN,
    AGLL_ERR,
};

/**
 * Listener protocols
 */
typedef NS_ENUM(NSInteger, AGListenerProtocol) {
    AGLP_UDP,
    AGLP_TCP,
};

@interface AGLogger : NSObject

/**
 * Set the default logging level
 *
 * @param level logging level to be set
 */
+ (void) setLevel: (AGLogLevel) level;

typedef void (^logCallback)(const char *msg, int length);

/**
 * Set log callback
 *
 * @param func logging function
 */
+ (void) setCallback: (logCallback) func;

@end


@interface AGDnsUpstream : NSObject
/**
 * A DNS server address:
 *      8.8.8.8:53 -- plain DNS
 *      tcp://8.8.8.8:53 -- plain DNS over TCP
 *      tls://1.1.1.1 -- DNS-over-TLS
 *      https://dns.adguard.com/dns-query -- DNS-over-HTTPS
 *      sdns://... -- DNS stamp (see https://dnscrypt.info/stamps-specifications)
 */
@property(nonatomic, readonly) NSString *address;
/**
 * List of plain DNS servers to be used to resolve DOH/DOT hostnames (if any)
 */
@property(nonatomic, readonly) NSArray<NSString *> *bootstrap;
/**
 * Default upstream timeout in milliseconds. Also used as a timeout for bootstrap DNS requests.
 * timeout = 0 means infinite timeout.
 */
@property(nonatomic, readonly) NSInteger timeout;
/**
 * Resolver's IP address. In the case if it's specified,
 * bootstrap DNS servers won't be used at all.
 */
@property(nonatomic, readonly) NSData *serverIp;

- (instancetype) initWithAddress: (NSString *) address
        bootstrap: (NSArray<NSString *> *) bootstrap
        timeout: (NSInteger) timeout
        serverIp: (NSData *) serverIp;
@end

@interface AGDns64Settings : NSObject

/**
 * The upstream to use for discovery of DNS64 prefixes
 */
@property(nonatomic, readonly) AGDnsUpstream *upstream;

/**
 * How many times, at most, to try DNS64 prefixes discovery before giving up
 */
@property(nonatomic, readonly) NSInteger maxTries;

/**
 * How long to wait before a dns64 prefixes discovery attempt, in milliseconds
 */
@property(nonatomic, readonly) NSInteger waitTime;

- (instancetype) initWithUpstream: (AGDnsUpstream *) upstream
            maxTries: (NSInteger) maxTries
            waitTime: (NSInteger) waitTime;

@end

@interface AGListenerSettings : NSObject

/**
 * The address to listen on
 */
@property(nonatomic, readonly) NSString *address;

/**
 * The port to listen on
 */
@property(nonatomic, readonly) NSInteger port;

/**
 * The protocol to listen for
 */
@property(nonatomic, readonly) AGListenerProtocol proto;

/**
 * Don't close the TCP connection after sending the first response
 */
@property(nonatomic, readonly) BOOL persistent;

/**
 * Close the TCP connection this long after the last request received, in milliseconds
 */
@property(nonatomic, readonly) NSInteger idleTimeout;

- (instancetype) initWithAddress: (NSString *) address
                            port: (NSInteger) port
                           proto: (AGListenerProtocol) proto
                      persistent: (BOOL) persistent
                     idleTimeout: (NSInteger) idleTimeout;

@end

@interface AGDnsProxyConfig : NSObject
/**
 * Upstreams settings
 */
@property(nonatomic, readonly) NSArray<AGDnsUpstream *> *upstreams;
/**
 * Filter files with identifiers
 */
@property(nonatomic, readonly) NSDictionary<NSNumber *,NSString *> *filters;
/**
 * TTL of the record for the blocked domains (in seconds)
 */
@property(nonatomic, readonly) NSInteger blockedResponseTtl;
/**
 * DNS64 settings. If nil, DNS64 is disabled
 */
@property(nonatomic, readonly) AGDns64Settings *dns64Settings;
/**
 * List of addresses/ports/protocols/etc... to listen on
 */
@property(nonatomic, readonly) NSArray<AGListenerSettings *> *listeners;

- (instancetype) initWithUpstreams: (NSArray<AGDnsUpstream *> *) upstreams
        filters: (NSDictionary<NSNumber *,NSString *> *) filters
        blockedResponseTtl: (NSInteger) blockedResponseTtl
        dns64Settings: (AGDns64Settings *) dns64Settings
        listeners: (NSArray<AGListenerSettings *> *) listeners;

/**
 * @brief Get default DNS proxy settings
 */
+ (instancetype) getDefault;
@end


@interface AGDnsProxy : NSObject
/**
 * @brief Initialize DNS proxy with the given configuration
 *
 * @param config proxy configuration
 * @param events proxy events handler
 */
- (instancetype) initWithConfig: (AGDnsProxyConfig *) config
        handler: (AGDnsProxyEvents *)events;

/**
 * @brief Process UDP/TCP packet payload
 *
 * @param packet data to process
 * @return Response packet payload
 */
- (NSData *) handlePacket: (NSData *) packet;
@end
