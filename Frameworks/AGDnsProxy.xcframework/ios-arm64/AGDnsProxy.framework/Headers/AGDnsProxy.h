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

- (instancetype) init: (NSString *) address
        bootstrap: (NSArray<NSString *> *) bootstrap
        timeout: (NSInteger) timeout;
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

- (instancetype) init: (NSArray<AGDnsUpstream *> *) upstreams
        filters: (NSDictionary<NSNumber *,NSString *> *) filters
        blockedResponseTtl: (NSInteger) blockedResponseTtl;

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
- (instancetype) init: (AGDnsProxyConfig *) config
        withHandler: (AGDnsProxyEvents *)events;

/**
 * @brief Process UDP/TCP packet payload
 *
 * @param packet data to process
 * @return Response packet payload
 */
- (NSData *) handlePacket: (NSData *) packet;
@end
