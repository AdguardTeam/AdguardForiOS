
#ifndef __CERT_H__
#define __CERT_H__ 1

#include <event2/dns.h>
#include <event2/event.h>

#define CERT_QUERY_RETRY_MIN_DELAY           1
#define CERT_QUERY_RETRY_MAX_DELAY           (5 * 60)
#define CERT_QUERY_RETRY_STEPS               100
#define CERT_QUERY_RETRY_DELAY_AFTER_SUCCESS_MIN_DELAY (60 * 60)
#define CERT_QUERY_RETRY_DELAY_AFTER_SUCCESS_JITTER 100

#ifndef CERT_QUERY_TEST_RETRY_STEPS
# define CERT_QUERY_TEST_RETRY_STEPS         2
#endif

#define CERT_RECOMMENDED_MAX_KEY_ROTATION_PERIOD 86400

typedef struct CertUpdater_ {
    struct evdns_base *evdns_base;
    struct event      *cert_timer;
    unsigned int       query_retry_step;
} CertUpdater;

struct ProxyContext_;
int cert_updater_init(struct ProxyContext_ * const proxy_context);
int cert_updater_start(struct ProxyContext_ * const proxy_context);
void cert_updater_stop(struct ProxyContext_ * const proxy_context);
void cert_updater_free(struct ProxyContext_ * const proxy_context);

#endif
