

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ACDnsUtils : NSObject

+ (nullable NSArray<NSData*> *)ipv6AddressesForHostname:(NSString *)hostname;
+ (nullable NSArray<NSData*> *)ipv4AddressesForHostname:(NSString *)hostname;

@end

NS_ASSUME_NONNULL_END
