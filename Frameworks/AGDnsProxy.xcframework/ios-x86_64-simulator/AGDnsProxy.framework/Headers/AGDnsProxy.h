#import <Foundation/Foundation.h>

#import "AGDnsProxyEvents.h"

/**
 * DNS proxy error domain
 */
extern NSErrorDomain const AGDnsProxyErrorDomain;

/**
 * DNS error codes
 */
typedef NS_ENUM(NSInteger, AGDnsProxyError) {
    AGDPE_PARSE_DNS_STAMP_ERROR,
    AGDPE_TEST_UPSTREAM_ERROR,
    AGDPE_PROXY_INIT_ERROR,
    AGDPE_PROXY_INIT_WARNING,
};

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

/**
 * Blocking modes
 */
typedef NS_ENUM(NSInteger, AGBlockingMode) {
    AGBM_DEFAULT, // AdBlock-style filters -> REFUSED, hosts-style filters -> rule-specified or unspecified address
    AGBM_REFUSED, // Always return REFUSED
    AGBM_NXDOMAIN, // Always return NXDOMAIN
    AGBM_UNSPECIFIED_ADDRESS, // Always return unspecified address
    AGBM_CUSTOM_ADDRESS, // Always return custom configured IP address (see AGDnsProxyConfig)
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
@property(nonatomic, readonly) NSInteger timeoutMs;
/**
 * Resolver's IP address. In the case if it's specified,
 * bootstrap DNS servers won't be used at all.
 */
@property(nonatomic, readonly) NSData *serverIp;
/**
 * User-provided ID for this upstream
 */
@property(nonatomic, readonly) NSInteger id;
/**
 * Name of the network interface to route traffic through, nil is default
 */
@property(nonatomic, readonly) NSString *outboundInterfaceName;

- (instancetype) initWithAddress: (NSString *) address
        bootstrap: (NSArray<NSString *> *) bootstrap
        timeoutMs: (NSInteger) timeoutMs
        serverIp: (NSData *) serverIp
        id: (NSInteger) id
        outboundInterfaceName: (NSString *) outboundInterfaceName;
@end

@interface AGDns64Settings : NSObject

/**
 * The upstream to use for discovery of DNS64 prefixes
 */
@property(nonatomic, readonly) NSArray<AGDnsUpstream *> *upstreams;

/**
 * How many times, at most, to try DNS64 prefixes discovery before giving up
 */
@property(nonatomic, readonly) NSInteger maxTries;

/**
 * How long to wait before a dns64 prefixes discovery attempt, in milliseconds
 */
@property(nonatomic, readonly) NSInteger waitTimeMs;

- (instancetype) initWithUpstreams: (NSArray<AGDnsUpstream *> *) upstreams
            maxTries: (NSInteger) maxTries
            waitTimeMs: (NSInteger) waitTimeMs;

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
@property(nonatomic, readonly) NSInteger idleTimeoutMs;

- (instancetype) initWithAddress: (NSString *) address
                            port: (NSInteger) port
                           proto: (AGListenerProtocol) proto
                      persistent: (BOOL) persistent
                   idleTimeoutMs: (NSInteger) idleTimeoutMs;

@end

@interface AGDnsFilterParams : NSObject
/**
 * Filter identifier
 */
@property(nonatomic, readonly) NSInteger id;
/**
 * Filter data
 * Either path to file with rules, or rules as a string
 */
@property(nonatomic, readonly) NSString *data;
/**
 * If YES, data is rules, otherwise data is path to file with rules
 */
@property(nonatomic, readonly) BOOL inMemory;

- (instancetype) initWithId:(NSInteger)id
                       data:(NSString *)data
                   inMemory:(BOOL)inMemory;

@end

@interface AGDnsProxyConfig : NSObject
/**
 * Upstreams settings
 */
@property(nonatomic, readonly) NSArray<AGDnsUpstream *> *upstreams;
/**
 * Fallback upstreams settings
 */
@property(nonatomic, readonly) NSArray<AGDnsUpstream *> *fallbacks;
/**
 * Filters
 */
@property(nonatomic, readonly) NSArray<AGDnsFilterParams *> *filters;
/**
 * TTL of the record for the blocked domains (in seconds)
 */
@property(nonatomic, readonly) NSInteger blockedResponseTtlSecs;
/**
 * DNS64 settings. If nil, DNS64 is disabled
 */
@property(nonatomic, readonly) AGDns64Settings *dns64Settings;
/**
 * List of addresses/ports/protocols/etc... to listen on
 */
@property(nonatomic, readonly) NSArray<AGListenerSettings *> *listeners;
/**
 * If false, bootstrappers will fetch only A records.
 */
@property(nonatomic, readonly) BOOL ipv6Available;
/**
 * Block AAAA requests.
 */
@property(nonatomic, readonly) BOOL blockIpv6;
/**
 * Blocking mode.
 */
@property(nonatomic, readonly) AGBlockingMode blockingMode;
/**
 * Custom IPv4 address to return for filtered requests
 */
@property(nonatomic, readonly) NSString *customBlockingIpv4;
/**
 * Custom IPv6 address to return for filtered requests
 */
@property(nonatomic, readonly) NSString *customBlockingIpv6;
/**
 * Maximum number of cached responses
 */
@property(nonatomic, readonly) NSUInteger dnsCacheSize;
/**
 * Enable optimistic DNS caching
 */
@property(nonatomic, readonly) BOOL optimisticCache;

- (instancetype) initWithUpstreams: (NSArray<AGDnsUpstream *> *) upstreams
        fallbacks: (NSArray<AGDnsUpstream *> *) fallbacks
        filters: (NSArray<AGDnsFilterParams *> *) filters
        blockedResponseTtlSecs: (NSInteger) blockedResponseTtlSecs
        dns64Settings: (AGDns64Settings *) dns64Settings
        listeners: (NSArray<AGListenerSettings *> *) listeners
        ipv6Available: (BOOL) ipv6Available
        blockIpv6: (BOOL) blockIpv6
        blockingMode: (AGBlockingMode) blockingMode
        customBlockingIpv4: (NSString *) customBlockingIpv4
        customBlockingIpv6: (NSString *) customBlockingIpv6
        dnsCacheSize: (NSUInteger) dnsCacheSize
        optimisticCache: (BOOL) optimisticCache;

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
 * @param error  error reference
 */
- (instancetype) initWithConfig: (AGDnsProxyConfig *) config
                        handler: (AGDnsProxyEvents *) events
                          error: (NSError **) error NS_SWIFT_NOTHROW;

/**
 * @brief Process UDP/TCP packet payload
 *
 * @param packet data to process
 * @return Response packet payload
 */
- (NSData *) handlePacket: (NSData *) packet;

/**
* Check if string is a valid rule
* @param str string to check
* @return true if string is a valid rule, false otherwise
*/
+ (BOOL) isValidRule: (NSString *) str;
@end

typedef NS_ENUM(NSInteger, AGStampProtoType) {
    /** plain is plain DNS */
    AGSPT_PLAIN,
    /** dnscrypt is DNSCrypt */
    AGSPT_DNSCRYPT,
    /** doh is DNS-over-HTTPS */
    AGSPT_DOH,
    /** tls is DNS-over-TLS */
    AGSPT_TLS,
    /** doq is DNS-over-QUIC */
    AGSPT_DOQ,
};

@interface AGDnsStamp : NSObject

/**
 * Protocol
 */
@property(nonatomic, readonly) AGStampProtoType proto;
/**
 * Server address
 */
@property(nonatomic, readonly) NSString *serverAddr;
/**
 * Provider name
 */
@property(nonatomic, readonly) NSString *providerName;
/**
 * Path (for DOH)
 */
@property(nonatomic, readonly) NSString *path;

- (instancetype) initWithProto: (AGStampProtoType) proto
                    serverAddr: (NSString *) serverAddr
                  providerName: (NSString *) providerName
                          path: (NSString *) path;
@end

@interface AGDnsUtils : NSObject

/**
 * Parses a DNS stamp string and returns a instance
 * @param stampStr DNS stamp string
 * @error error error
 * @return stamp instance or nil if error
 */
+ (AGDnsStamp *) parseDnsStampWithStampStr: (NSString *) stampStr
                                     error: (NSError **) error NS_SWIFT_NOTHROW;

/**
 * Checks if upstream is valid and available
 * @param opts Upstream options
 * @return If it is, no error is returned. Otherwise this method returns an error with an explanation.
 */
+ (NSError *) testUpstream: (AGDnsUpstream *) opts;

@end
