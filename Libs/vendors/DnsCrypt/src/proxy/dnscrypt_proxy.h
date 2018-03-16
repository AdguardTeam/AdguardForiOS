
#ifndef __DNSCRYPT_PROXY_H__
#define __DNSCRYPT_PROXY_H__ 1

#include <sys/types.h>

#include <stdint.h>
#include <stdio.h>
#include <time.h>

#include <event2/event.h>
#include <event2/listener.h>
#include <sodium.h>

#include "app.h"
#include "cert.h"
#include "dnscrypt_client.h"
#include "queue.h"

#ifndef DNS_QUERY_TIMEOUT
# define DNS_QUERY_TIMEOUT 10
#endif

#define DNS_MAX_PACKET_SIZE_UDP_RECV (65536U - 20U - 8U)
#define DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND 512U

#if DNS_MAX_PACKET_SIZE_UDP_RECV > DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND
# define DNS_MAX_PACKET_SIZE_UDP DNS_MAX_PACKET_SIZE_UDP_RECV
#else
# define DNS_MAX_PACKET_SIZE_UDP DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND
#endif

#ifndef DNS_DEFAULT_STANDARD_DNS_PORT
# define DNS_DEFAULT_STANDARD_DNS_PORT "53"
#endif
#ifndef DNS_DEFAULT_LOCAL_PORT
# define DNS_DEFAULT_LOCAL_PORT DNS_DEFAULT_STANDARD_DNS_PORT
#endif
#ifndef DNS_DEFAULT_RESOLVER_PORT
# define DNS_DEFAULT_RESOLVER_PORT "443"
#endif

#ifndef DEFAULT_RESOLVERS_LIST
# ifdef _WIN32
#  define DEFAULT_RESOLVERS_LIST "dnscrypt-resolvers.csv"
# else
#  define DEFAULT_RESOLVERS_LIST "" "/dnscrypt-resolvers.csv"
# endif
#endif

#define DNS_HEADER_SIZE  12U
#define DNS_FLAGS_TC      2U
#define DNS_FLAGS_QR    128U
#define DNS_FLAGS2_RA   128U

#define DNS_CLASS_IN      1U
#define DNS_TYPE_TXT     16U
#define DNS_TYPE_OPT     41U

#define DNS_OFFSET_QUESTION DNS_HEADER_SIZE
#define DNS_OFFSET_FLAGS    2U
#define DNS_OFFSET_FLAGS2   3U
#define DNS_OFFSET_QDCOUNT  4U
#define DNS_OFFSET_ANCOUNT  6U
#define DNS_OFFSET_NSCOUNT  8U
#define DNS_OFFSET_ARCOUNT 10U

#define DNS_OFFSET_EDNS_TYPE         0U
#define DNS_OFFSET_EDNS_PAYLOAD_SIZE 2U

#define DNS_DEFAULT_EDNS_PAYLOAD_SIZE 1252U

#define DNSCRYPT_PROTOCOL_VERSIONS "2"

#define DNSCRYPT_EXIT_CERT_NOCERTS 2
#define DNSCRYPT_EXIT_CERT_TIMEOUT 3
#define DNSCRYPT_EXIT_CERT_MARGIN  4

typedef TAILQ_HEAD(TCPRequestQueue_, TCPRequest_) TCPRequestQueue;
typedef TAILQ_HEAD(UDPRequestQueue_, UDPRequest_) UDPRequestQueue;

typedef struct ProxyContext_ {
    uint8_t                  dnscrypt_magic_query[DNSCRYPT_MAGIC_QUERY_LEN];
    uint8_t                  provider_publickey[crypto_sign_ed25519_PUBLICKEYBYTES];
    uint8_t                  resolver_publickey[crypto_box_PUBLICKEYBYTES];
    DNSCryptClient           dnscrypt_client;
    CertUpdater              cert_updater;
    struct sockaddr_storage  local_sockaddr;
    struct sockaddr_storage  resolver_sockaddr;
    TCPRequestQueue          tcp_request_queue;
    UDPRequestQueue          udp_request_queue;
    AppContext              *app_context;
    struct event_base       *event_loop;
    FILE                    *log_fp;
    const char              *client_key_file;
    const char              *local_ip;
    const char              *log_file;
    const char              *pid_file;
    const char              *provider_name;
    const char              *provider_publickey_s;
    const char              *resolvers_list;
    const char              *resolver_name;
    const char              *resolver_ip;
    const char              *syslog_prefix;
#ifndef _WIN32
    char                    *user_dir;
    char                    *user_name;
#endif
    struct evconnlistener   *tcp_conn_listener;
    struct event            *tcp_accept_timer;
    struct event            *udp_listener_event;
    struct event            *udp_proxy_resolver_event;
    ev_socklen_t             local_sockaddr_len;
    ev_socklen_t             resolver_sockaddr_len;
    size_t                   edns_payload_size;
    size_t                   udp_current_max_size;
    size_t                   udp_max_size;
    evutil_socket_t          tcp_listener_handle;
    evutil_socket_t          udp_listener_handle;
    evutil_socket_t          udp_proxy_resolver_handle;
#ifndef _WIN32
    uid_t                    user_id;
    gid_t                    user_group;
#endif
    time_t                   test_cert_margin;
    unsigned int             connections_count;
    unsigned int             connections_count_max;
    int                      max_log_level;
    _Bool                    daemonize;
    _Bool                    ephemeral_keys;
    _Bool                    ignore_timestamps;
    _Bool                    listeners_started;
    _Bool                    syslog;
    _Bool                    tcp_only;
    _Bool                    test_only;
} ProxyContext;

int dnscrypt_proxy_start_listeners(ProxyContext * const proxy_context);

#endif
