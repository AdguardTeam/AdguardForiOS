#import <Foundation/Foundation.h>

/**
 * DNS request processed event
 */
@interface AGDnsRequestProcessedEvent : NSObject
@property(nonatomic, readonly) NSString *domain; /**< Queried domain name */
@property(nonatomic, readonly) NSString *type; /**< Query type */
@property(nonatomic, readonly) NSInteger startTime; /**< Time when dnsproxy started processing request (epoch in milliseconds) */
@property(nonatomic, readonly) NSInteger elapsed; /**< Time elapsed on processing (in milliseconds) */
@property(nonatomic, readonly) NSString *status; /**< DNS answer's status */
@property(nonatomic, readonly) NSString *answer; /**< DNS Answers string representation */
@property(nonatomic, readonly) NSString *originalAnswer; /**< If blocked by CNAME, here will be DNS original answer's string representation */
@property(nonatomic, readonly) NSNumber *upstreamId; /**< ID of the upstream that provided this answer */
@property(nonatomic, readonly) NSInteger bytesSent; /**< Number of bytes sent to a server */
@property(nonatomic, readonly) NSInteger bytesReceived; /**< Number of bytes received from a server */
@property(nonatomic, readonly) NSArray<NSString *> *rules; /**< Filtering rules texts */
@property(nonatomic, readonly) NSArray<NSNumber *> *filterListIds; /**< Filter lists IDs of corresponding rules */
@property(nonatomic, readonly) BOOL whitelist; /**< True if filtering rule is whitelist */
@property(nonatomic, readonly) NSString *error; /**< If not empty, contains the error text (occurred while processing the DNS query) */
@property(nonatomic, readonly) BOOL cacheHit; /**<True if this response was served from the cache */
@end

/**
 * Set of DNS proxy events
 */
@interface AGDnsProxyEvents : NSObject
/**
 * Raised right after a request is processed.
 * Notes:
 *  - if there are several upstreams in proxy configuration, the proxy tries each one
 *    consequently until it gets successful status, so in this case each failed upstream
 *    fires the event - i.e., several events will be raised for the request
 */
@property (nonatomic, copy) void (^onRequestProcessed)(const AGDnsRequestProcessedEvent *event);
@end
