
#include <config.h>
#include <sys/types.h>
#ifdef _WIN32
# include <winsock2.h>
#else
# include <sys/socket.h>
# include <arpa/inet.h>
#endif

#include <assert.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <event2/dns.h>
#include <event2/event.h>

#include <sodium.h>

#include "cert.h"
#include "cert_p.h"
#include "dnscrypt_proxy.h"
#include "logger.h"
#include "probes.h"
#include "shims.h"
#include "utils.h"

static int cert_updater_update(ProxyContext * const proxy_context);

static int
cert_parse_version(ProxyContext * const proxy_context,
                   const SignedBincert * const signed_bincert,
                   const size_t signed_bincert_len)
{
    if (signed_bincert_len < (size_t) (signed_bincert->signed_data -
                                       signed_bincert->magic_cert) ||
        memcmp(signed_bincert->magic_cert, CERT_MAGIC_CERT,
               sizeof signed_bincert->magic_cert) != 0) {
        logger_noformat(proxy_context, LOG_DEBUG,
                        "TXT record with no certificates received");
        return -1;
    }
    if (signed_bincert->version_major[0] != 0U ||
        (signed_bincert->version_major[1] != 1U
#ifdef HAVE_XCHACHA20
         && signed_bincert->version_major[1] != 2U
#endif
        )) {
        logger(proxy_context, LOG_INFO,
               "Unsupported certificate version: %u.%u",
               signed_bincert->version_major[1],
               signed_bincert->version_major[0]);
        return -1;
    }
    return 0;
}

static int
cert_parse_bincert(ProxyContext * const proxy_context,
                   const Bincert * const bincert,
                   const Bincert * const previous_bincert)
{
    uint32_t serial;
    memcpy(&serial, bincert->serial, sizeof serial);
    serial = htonl(serial);
    if (serial >= 0x30303030 && serial <= 0x30303039) {
        logger(proxy_context, LOG_INFO,
               "Server certificate with serial '%c%c%c%c' received",
               (serial >> 24) & 0xff, (serial >> 16) & 0xff,
               (serial >> 8) & 0xff, serial & 0xff);
    } else {
        logger(proxy_context, LOG_INFO,
               "Server certificate with serial #%" PRIu32 " received", serial);
    }
    uint32_t ts_begin;
    memcpy(&ts_begin, bincert->ts_begin, sizeof ts_begin);
    ts_begin = htonl(ts_begin);

    uint32_t ts_end;
    memcpy(&ts_end, bincert->ts_end, sizeof ts_end);
    ts_end = htonl(ts_end);

    if (ts_end <= ts_begin) {
        logger_noformat(proxy_context, LOG_WARNING,
                        "This certificate has a bogus validity period");
        return -1;
    }

    const uint32_t now_u32 = (uint32_t) time(NULL);

    if (now_u32 < ts_begin) {
        if (proxy_context->ignore_timestamps != 0) {
            logger_noformat(proxy_context, LOG_WARNING,
                            "Clock might be off - "
                            "Pretending that this certificate is valid no matter what");
        } else {
            logger_noformat(proxy_context, LOG_INFO,
                            "This certificate has not been activated yet");
            return -1;
        }
    }
    if (now_u32 > ts_end) {
        logger_noformat(proxy_context, LOG_INFO,
                        "This certificate has expired");
        return -1;
    }
    logger_noformat(proxy_context, LOG_INFO, "This certificate is valid");
    if (previous_bincert == NULL) {
        return 0;
    }

    const uint32_t version =
        (((uint32_t) bincert->version_major[0]) << 24) +
        (((uint32_t) bincert->version_major[1]) << 16) +
        (((uint32_t) bincert->version_minor[0]) << 8) +
        (((uint32_t) bincert->version_minor[1]));

    const uint32_t previous_version =
        (((uint32_t) previous_bincert->version_major[0]) << 24) +
        (((uint32_t) previous_bincert->version_major[1]) << 16) +
        (((uint32_t) previous_bincert->version_minor[0]) << 8) +
        (((uint32_t) previous_bincert->version_minor[1]));

    uint32_t previous_serial;
    memcpy(&previous_serial, previous_bincert->serial, sizeof previous_serial);
    previous_serial = htonl(previous_serial);

    if (previous_version > version) {
        logger(proxy_context, LOG_INFO, "Keeping certificate #%" PRIu32 " "
               "which is for a more recent version than #%" PRIu32,
               previous_serial, serial);
        return -1;
    } else if (previous_version < version) {
        logger(proxy_context, LOG_INFO,
               "Favoring version #%" PRIu32 " over version #%" PRIu32,
               version, previous_version);
        return 0;
    }
    if (previous_serial > serial) {
        logger(proxy_context, LOG_INFO, "Certificate #%" PRIu32 " "
               "has been superseded by certificate #%" PRIu32,
               previous_serial, serial);
        return -1;
    }
    logger(proxy_context, LOG_INFO,
           "This certificate supersedes certificate #%" PRIu32,
           previous_serial);

    return 0;
}

static int
cert_open_bincert(ProxyContext * const proxy_context,
                  const SignedBincert * const signed_bincert,
                  const size_t signed_bincert_len,
                  Bincert ** const bincert_p)
{
    Bincert            *bincert;
    unsigned long long  bincert_data_len_ul;
    size_t              bincert_size;
    size_t              signed_data_len;

    if (cert_parse_version(proxy_context,
                           signed_bincert, signed_bincert_len) != 0) {
        DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_COMMUNICATION();
        return -1;
    }
    bincert_size = signed_bincert_len;
    if ((bincert = malloc(bincert_size)) == NULL) {
        DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_COMMUNICATION();
        return -1;
    }
    assert(signed_bincert_len > (size_t) (signed_bincert->signed_data -
                                          signed_bincert->magic_cert));
    signed_data_len = signed_bincert_len -
        (size_t) (signed_bincert->signed_data - signed_bincert->magic_cert);
    assert(bincert_size - (size_t) (bincert->server_publickey -
                                    bincert->magic_cert) == signed_data_len);
    memcpy(bincert, signed_bincert, signed_bincert_len - signed_data_len);
    if (crypto_sign_ed25519_open(bincert->server_publickey, &bincert_data_len_ul,
                                 signed_bincert->signed_data, signed_data_len,
                                 proxy_context->provider_publickey) != 0) {
        free(bincert);
        logger_noformat(proxy_context, LOG_ERR,
                        "Suspicious certificate received");
        DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_SECURITY();
        return -1;
    }
    if (cert_parse_bincert(proxy_context, bincert, *bincert_p) != 0) {
        sodium_memzero(bincert, sizeof *bincert);
        free(bincert);
        return -1;
    }
    if (*bincert_p != NULL) {
        sodium_memzero(*bincert_p, sizeof **bincert_p);
        free(*bincert_p);
    }
    *bincert_p = bincert;

    return 0;
}

static void
cert_print_bincert_info(ProxyContext * const proxy_context,
                        const Bincert * const bincert)
{
#ifdef HAVE_GMTIME_R
    struct tm ts_begin_tm;
    struct tm ts_end_tm;
    time_t    ts_begin_t;
    time_t    ts_end_t;
    uint32_t  serial;
    uint32_t  ts_begin;
    uint32_t  ts_end;
    _Bool     gm_ret;

    assert(bincert != NULL);

    memcpy(&ts_begin, bincert->ts_begin, sizeof ts_begin);
    ts_begin_t = (time_t) htonl(ts_begin);
    assert(ts_begin_t > (time_t) 0);

    memcpy(&ts_end, bincert->ts_end, sizeof ts_end);
    ts_end_t = (time_t) htonl(ts_end);
    assert(ts_end_t > (time_t) 0);

    gm_ret = (gmtime_r(&ts_begin_t, &ts_begin_tm) != NULL &&
              gmtime_r(&ts_end_t, &ts_end_tm) != NULL);
    assert(gm_ret != 0);
    assert(ts_end_t >= ts_begin_t);

    memcpy(&serial, bincert->serial, sizeof serial);

    logger(proxy_context, LOG_INFO,
           "Chosen certificate #%" PRIu32 " is valid "
           "from [%d-%02d-%02d] to [%d-%02d-%02d]",
           htonl(serial),
           ts_begin_tm.tm_year + 1900,
           ts_begin_tm.tm_mon + 1, ts_begin_tm.tm_mday,
           ts_end_tm.tm_year + 1900,
           ts_end_tm.tm_mon + 1, ts_end_tm.tm_mday);
#endif
    if (bincert->version_major[1] > 1U) {
        const unsigned int version_minor =
            bincert->version_minor[0] * 256 + bincert->version_minor[1];
        logger(proxy_context, LOG_INFO,
               "Using version %u.%u of the DNSCrypt protocol",
               bincert->version_major[1], version_minor);
    }
}

static void
cert_print_server_key(ProxyContext * const proxy_context)
{
    char fingerprint[80U];

    dnscrypt_key_to_fingerprint(fingerprint,
                                proxy_context->resolver_publickey);
    logger(proxy_context, LOG_INFO,
           "Server key fingerprint is %s", fingerprint);
}

static void
cert_timer_cb(evutil_socket_t handle, const short event,
              void * const proxy_context_)
{
    ProxyContext * const proxy_context = proxy_context_;

    (void) handle;
    (void) event;
    logger_noformat(proxy_context, LOG_INFO,
                    "Refetching server certificates");
    cert_updater_update(proxy_context);
}

static void
cert_reschedule_query(ProxyContext * const proxy_context,
                      const time_t query_retry_delay)
{
    CertUpdater *cert_updater = &proxy_context->cert_updater;

    if (evtimer_pending(cert_updater->cert_timer, NULL)) {
        return;
    }
    const struct timeval tv = { .tv_sec = query_retry_delay, .tv_usec = 0 };
    evtimer_add(cert_updater->cert_timer, &tv);
}

static void
cert_reschedule_query_after_failure(ProxyContext * const proxy_context)
{
    CertUpdater *cert_updater = &proxy_context->cert_updater;
    time_t       query_retry_delay;

    if (evtimer_pending(cert_updater->cert_timer, NULL)) {
        return;
    }
    query_retry_delay = (time_t)
        (CERT_QUERY_RETRY_MIN_DELAY +
            (time_t) cert_updater->query_retry_step *
            (CERT_QUERY_RETRY_MAX_DELAY - CERT_QUERY_RETRY_MIN_DELAY) /
            CERT_QUERY_RETRY_STEPS);
    if (cert_updater->query_retry_step < CERT_QUERY_RETRY_STEPS) {
        cert_updater->query_retry_step++;
    }
    cert_reschedule_query(proxy_context, query_retry_delay);
    DNSCRYPT_PROXY_CERTS_UPDATE_RETRY();
    if (proxy_context->test_only != 0 &&
        cert_updater->query_retry_step > CERT_QUERY_TEST_RETRY_STEPS) {
        exit(DNSCRYPT_EXIT_CERT_TIMEOUT);
    }
}

static void
cert_reschedule_query_after_success(ProxyContext * const proxy_context)
{
    if (evtimer_pending(proxy_context->cert_updater.cert_timer, NULL)) {
        return;
    }
    cert_reschedule_query(proxy_context, (time_t)
                          CERT_QUERY_RETRY_DELAY_AFTER_SUCCESS_MIN_DELAY
                          + (time_t) randombytes_uniform
                          (CERT_QUERY_RETRY_DELAY_AFTER_SUCCESS_JITTER));
}

static void
cert_check_key_rotation_period(ProxyContext * const proxy_context,
                               const Bincert * const bincert)
{
    uint32_t ts_begin;
    uint32_t ts_end;

    memcpy(&ts_begin, bincert->ts_begin, sizeof ts_begin);
    ts_begin = htonl(ts_begin);
    memcpy(&ts_end, bincert->ts_end, sizeof ts_end);
    ts_end = htonl(ts_end);
    assert(ts_end > ts_begin);
    if (ts_end - ts_begin > CERT_RECOMMENDED_MAX_KEY_ROTATION_PERIOD) {
        logger_noformat(proxy_context, LOG_INFO,
                        "The key rotation period for this server may exceed the recommended value. "
                        "This is bad for forward secrecy.");
    }
}

static void
cert_query_cb(int result, char type, int count, int ttl,
              void * const txt_records_, void * const arg)
{
    Bincert                 *bincert = NULL;
    ProxyContext            *proxy_context = arg;
    const struct txt_record *txt_records = txt_records_;
    Cipher                   cipher = CIPHER_UNDEFINED;
    int                      i = 0;

    (void) type;
    (void) ttl;
    DNSCRYPT_PROXY_CERTS_UPDATE_RECEIVED();
    evdns_base_free(proxy_context->cert_updater.evdns_base, 0);
    proxy_context->cert_updater.evdns_base = NULL;
    if (result != DNS_ERR_NONE) {
        logger_noformat(proxy_context, LOG_ERR,
                        "Unable to retrieve server certificates");
        cert_reschedule_query_after_failure(proxy_context);
        DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_COMMUNICATION();
        return;
    }
    assert(count >= 0);
    while (i < count) {
        cert_open_bincert(proxy_context,
                          (const SignedBincert *) txt_records[i].txt,
                          txt_records[i].len, &bincert);
        i++;
    }
    if (bincert == NULL) {
        logger_noformat(proxy_context, LOG_ERR,
                        "No useable certificates found");
        DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_NOCERTS();
        if (proxy_context->test_only) {
            exit(DNSCRYPT_EXIT_CERT_NOCERTS);
        }
        cert_reschedule_query_after_failure(proxy_context);
        return;
    }
    switch (bincert->version_major[1]) {
    case 1:
        cipher = CIPHER_XSALSA20POLY1305;
        break;
#ifdef HAVE_XCHACHA20
    case 2:
        cipher = CIPHER_XCHACHA20POLY1305;
        break;
#endif
    default:
        logger_noformat(proxy_context, LOG_ERR,
                        "Unsupported certificate version");
        cert_reschedule_query_after_failure(proxy_context);
        return;
    }
    if (proxy_context->test_only != 0) {
        const uint32_t now_u32 = (uint32_t) time(NULL);
        uint32_t       ts_begin;
        uint32_t       ts_end;
        uint32_t       safe_end;

        memcpy(&ts_begin, bincert->ts_begin, sizeof ts_begin);
        ts_begin = htonl(ts_begin);
        memcpy(&ts_end, bincert->ts_end, sizeof ts_end);
        safe_end = ts_end = htonl(ts_end);
        if (safe_end > (uint32_t) proxy_context->test_cert_margin) {
            safe_end -= (uint32_t) proxy_context->test_cert_margin;
        } else {
            safe_end = ts_begin;
        }
        if (safe_end < ts_begin) {
            logger_noformat(proxy_context, LOG_WARNING,
                            "Safety margin wider than the certificate validity period");
            safe_end = ts_begin;
        }
        if (now_u32 < ts_begin || now_u32 > safe_end) {
            logger(proxy_context, LOG_WARNING,
                   "The certificate is not valid for the given safety margin (%lu-%lu not within [%lu..%lu])",
                   (unsigned long) now_u32, (unsigned long) proxy_context->test_cert_margin,
                   (unsigned long) ts_begin, (unsigned long) safe_end);
            DNSCRYPT_PROXY_CERTS_UPDATE_ERROR_NOCERTS();
            exit(DNSCRYPT_EXIT_CERT_MARGIN);
        }
    }
    COMPILER_ASSERT(sizeof proxy_context->resolver_publickey ==
                    sizeof bincert->server_publickey);
    memcpy(proxy_context->resolver_publickey, bincert->server_publickey,
           sizeof proxy_context->resolver_publickey);
    COMPILER_ASSERT(sizeof proxy_context->dnscrypt_magic_query ==
                    sizeof bincert->magic_query);
    memcpy(proxy_context->dnscrypt_magic_query, bincert->magic_query,
           sizeof proxy_context->dnscrypt_magic_query);
    cert_print_bincert_info(proxy_context, bincert);
    cert_check_key_rotation_period(proxy_context, bincert);
    cert_print_server_key(proxy_context);
    dnscrypt_client_init_magic_query(&proxy_context->dnscrypt_client,
                                     bincert->magic_query, cipher);
    sodium_memzero(bincert, sizeof *bincert);
    free(bincert);
    if (proxy_context->test_only) {
        DNSCRYPT_PROXY_CERTS_UPDATE_DONE((unsigned char *)
                                         proxy_context->resolver_publickey);
        exit(0);
    }
    if (dnscrypt_client_init_resolver_publickey
        (&proxy_context->dnscrypt_client, proxy_context->resolver_publickey) != 0) {
        logger_noformat(proxy_context, LOG_ERR, "Suspicious public key");
        exit(DNSCRYPT_EXIT_CERT_NOCERTS);
    }
    dnscrypt_proxy_start_listeners(proxy_context);
    proxy_context->cert_updater.query_retry_step = 0U;
    cert_reschedule_query_after_success(proxy_context);
    DNSCRYPT_PROXY_CERTS_UPDATE_DONE((unsigned char *)
                                     proxy_context->resolver_publickey);
}

int
cert_updater_init(ProxyContext * const proxy_context)
{
    CertUpdater *cert_updater = &proxy_context->cert_updater;

    memset(cert_updater, 0, sizeof *cert_updater);
    assert(proxy_context->event_loop != NULL);
    assert(cert_updater->cert_timer == NULL);
    if ((cert_updater->cert_timer =
         evtimer_new(proxy_context->event_loop,
                     cert_timer_cb, proxy_context)) == NULL) {
        return -1;
    }
    cert_updater->query_retry_step = 0U;
    cert_updater->evdns_base = NULL;

    return 0;
}

static int
cert_updater_update(ProxyContext * const proxy_context)
{
    CertUpdater *cert_updater = &proxy_context->cert_updater;

    DNSCRYPT_PROXY_CERTS_UPDATE_START();
    if (cert_updater->evdns_base != NULL) {
        evdns_base_free(cert_updater->evdns_base, 0);
    }
    if ((cert_updater->evdns_base =
         evdns_base_new(proxy_context->event_loop, 0)) == NULL) {
        return -1;
    }
    if (evdns_base_nameserver_sockaddr_add(cert_updater->evdns_base,
                                           (struct sockaddr *)
                                           &proxy_context->resolver_sockaddr,
                                           proxy_context->resolver_sockaddr_len,
                                           DNS_QUERY_NO_SEARCH) != 0) {
        return -1;
    }
    if (proxy_context->tcp_only != 0) {
        (void) evdns_base_set_option(cert_updater->evdns_base, "use-tcp", "always");
    } else {
        (void) evdns_base_set_option(cert_updater->evdns_base, "use-tcp", "on-tc");
    }
    if (evdns_base_resolve_txt(cert_updater->evdns_base,
                               proxy_context->provider_name,
                               DNS_QUERY_NO_SEARCH,
                               cert_query_cb,
                               proxy_context) == NULL) {
        return -1;
    }
    return 0;
}

int
cert_updater_start(ProxyContext * const proxy_context)
{
    evdns_set_random_init_fn(NULL);
    evdns_set_random_bytes_fn(randombytes_buf);
    cert_updater_update(proxy_context);

    return 0;
}

void
cert_updater_stop(ProxyContext * const proxy_context)
{
    CertUpdater * const cert_updater = &proxy_context->cert_updater;

    assert(cert_updater->cert_timer != NULL);
    evtimer_del(cert_updater->cert_timer);
}

void
cert_updater_free(ProxyContext * const proxy_context)
{
    CertUpdater * const cert_updater = &proxy_context->cert_updater;

    event_free(cert_updater->cert_timer);
    cert_updater->cert_timer = NULL;
    if (cert_updater->evdns_base != NULL) {
        evdns_base_free(cert_updater->evdns_base, 0);
        cert_updater->evdns_base = NULL;
    }
}
