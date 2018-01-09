
#include <config.h>
#include <sys/types.h>
#ifdef _WIN32
# include <winsock2.h>
#else
# include <sys/socket.h>
# include <arpa/inet.h>
# include <netinet/in.h>
# include <netinet/ip.h>
#endif

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include <event2/event.h>
#include <event2/util.h>

#include "dnscrypt_client.h"
#include "dnscrypt_proxy.h"
#include "edns.h"
#include "logger.h"
#include "probes.h"
#include "queue.h"
#include "sandboxes.h"
#include "tcp_request.h"
#include "udp_request.h"
#include "udp_request_p.h"
#include "utils.h"
#ifdef PLUGINS
# include "plugin_support.h"
#endif

static void
udp_request_free(UDPRequest * const udp_request)
{
    ProxyContext *proxy_context;

    if (udp_request->timeout_timer != NULL) {
        event_free(udp_request->timeout_timer);
        udp_request->timeout_timer = NULL;
    }
    DNSCRYPT_PROXY_REQUEST_UDP_DONE(udp_request);
    proxy_context = udp_request->proxy_context;
    if (udp_request->status.is_in_queue != 0) {
        assert(! TAILQ_EMPTY(&proxy_context->udp_request_queue));
        TAILQ_REMOVE(&proxy_context->udp_request_queue, udp_request, queue);
        assert(proxy_context->connections_count > 0U);
        proxy_context->connections_count--;
        DNSCRYPT_PROXY_STATUS_REQUESTS_ACTIVE(proxy_context->connections_count,
                                              proxy_context->connections_count_max);
    }
    udp_request->proxy_context = NULL;
    free(udp_request);
}

static void
udp_request_kill(UDPRequest * const udp_request)
{
    if (udp_request == NULL || udp_request->status.is_dying) {
        return;
    }
    udp_request->status.is_dying = 1;
    udp_request_free(udp_request);
}

static int udp_send(SendtoWithRetryCtx * const ctx);

static int
udp_send(SendtoWithRetryCtx * const ctx)
{
    void              (*cb)(UDPRequest *udp_request);
    UDPRequest         *udp_request = ctx->udp_request;

    (void) sendto(ctx->handle, ctx->buffer, ctx->length, ctx->flags,
                  ctx->dest_addr, ctx->dest_len);
    cb = ctx->cb;
    if (cb) {
        cb(udp_request);
    }
    return 0;
}

static void
resolver_to_proxy_cb(evutil_socket_t proxy_resolver_handle, short ev_flags,
                     void * const proxy_context_)
{
    uint8_t                  dns_reply[DNS_MAX_PACKET_SIZE_UDP];
    ProxyContext            *proxy_context = proxy_context_;
    UDPRequest              *scanned_udp_request;
    UDPRequest              *udp_request = NULL;
    struct sockaddr_storage  resolver_sockaddr;
    ev_socklen_t             resolver_sockaddr_len = sizeof resolver_sockaddr;
    ssize_t                  nread;
    size_t                   dns_reply_len = (size_t) 0U;
    size_t                   uncurved_len;

    (void) ev_flags;
    nread = recvfrom(proxy_resolver_handle,
                     (void *) dns_reply, sizeof dns_reply, 0,
                     (struct sockaddr *) &resolver_sockaddr,
                     &resolver_sockaddr_len);
    if (nread < (ssize_t) 0) {
        const int err = evutil_socket_geterror(proxy_resolver_handle);
        if (!EVUTIL_ERR_RW_RETRIABLE(err)) {
            logger(proxy_context, LOG_WARNING,
                   "recvfrom(resolver): [%s]", evutil_socket_error_to_string(err));
        }
        DNSCRYPT_PROXY_REQUEST_UDP_NETWORK_ERROR(NULL);
        return;
    }
    if (evutil_sockaddr_cmp((const struct sockaddr *) &resolver_sockaddr,
                            (const struct sockaddr *)
                            &proxy_context->resolver_sockaddr, 1) != 0) {
        logger_noformat(proxy_context, LOG_DEBUG,
                        "Received a resolver reply from a different resolver");
        return;
    }
    TAILQ_FOREACH(scanned_udp_request,
                  &proxy_context->udp_request_queue, queue) {
        if (dnscrypt_cmp_client_nonce(scanned_udp_request->client_nonce,
                                      dns_reply, (size_t) nread) == 0) {
            udp_request = scanned_udp_request;
            break;
        }
    }
    if (udp_request == NULL) {
        logger(proxy_context, LOG_DEBUG,
               "Received a reply that doesn't match any active query");
        return;
    }
    if (nread < (ssize_t) (DNS_HEADER_SIZE + dnscrypt_response_header_size()) ||
        nread > (ssize_t) sizeof dns_reply) {
        logger_noformat(proxy_context, LOG_WARNING, "Short reply received");
        udp_request_kill(udp_request);
        return;
    }
    DNSCRYPT_PROXY_REQUEST_UDP_PROXY_RESOLVER_REPLIED(udp_request);
    dns_reply_len = (size_t) nread;
    assert(dns_reply_len <= sizeof dns_reply);

    uncurved_len = dns_reply_len;
    DNSCRYPT_PROXY_REQUEST_UNCURVE_START(udp_request, uncurved_len);
    if (dnscrypt_client_uncurve
        (&udp_request->proxy_context->dnscrypt_client,
            udp_request->client_nonce, dns_reply, &uncurved_len) != 0) {
        DNSCRYPT_PROXY_REQUEST_UNCURVE_ERROR(udp_request);
        DNSCRYPT_PROXY_REQUEST_UDP_PROXY_RESOLVER_GOT_INVALID_REPLY(udp_request);
        logger_noformat(udp_request->proxy_context, LOG_INFO,
                        "Received a corrupted reply from the resolver");
        udp_request_kill(udp_request);
        return;
    }
    DNSCRYPT_PROXY_REQUEST_UNCURVE_DONE(udp_request, uncurved_len);
    memset(udp_request->client_nonce, 0, sizeof udp_request->client_nonce);
    assert(uncurved_len <= dns_reply_len);
    dns_reply_len = uncurved_len;

    assert(dns_reply_len >= DNS_HEADER_SIZE);
    COMPILER_ASSERT(DNS_OFFSET_FLAGS < DNS_HEADER_SIZE);
    if ((dns_reply[DNS_OFFSET_FLAGS] & DNS_FLAGS_TC) != 0) {
        if (proxy_context->udp_current_max_size <
            proxy_context->udp_max_size) {
            COMPILER_ASSERT(DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND >=
                            DNSCRYPT_BLOCK_SIZE);
            if (proxy_context->udp_max_size -
                proxy_context->udp_current_max_size > DNSCRYPT_BLOCK_SIZE) {
                proxy_context->udp_current_max_size += DNSCRYPT_BLOCK_SIZE;
            } else {
                proxy_context->udp_current_max_size =
                    proxy_context->udp_max_size;
            }
        }
    }

#ifdef PLUGINS
    const size_t max_reply_size_for_filter = sizeof dns_reply;
    DCPluginDNSPacket dcp_packet = {
        .client_sockaddr = &udp_request->client_sockaddr,
        .dns_packet = dns_reply,
        .dns_packet_len_p = &dns_reply_len,
        .client_sockaddr_len_s = (size_t) udp_request->client_sockaddr_len,
        .dns_packet_max_len = max_reply_size_for_filter
    };
    DNSCRYPT_PROXY_REQUEST_PLUGINS_POST_START(udp_request, dns_reply_len,
                                              max_reply_size_for_filter);
    assert(proxy_context->app_context->dcps_context != NULL);
    const DCPluginSyncFilterResult res =
        plugin_support_context_apply_sync_post_filters
        (proxy_context->app_context->dcps_context, &dcp_packet);
    assert(dns_reply_len > (size_t) 0U &&
           dns_reply_len <= sizeof dns_reply &&
           dns_reply_len <= max_reply_size_for_filter);
    if (res != DCP_SYNC_FILTER_RESULT_OK) {
        DNSCRYPT_PROXY_REQUEST_PLUGINS_POST_ERROR(udp_request, res);
        udp_request_kill(udp_request);
        return;
    }
    DNSCRYPT_PROXY_REQUEST_PLUGINS_POST_DONE(udp_request, dns_reply_len,
                                             max_reply_size_for_filter);
#endif
    udp_send(& (SendtoWithRetryCtx) {
       .udp_request = udp_request,
       .handle = udp_request->client_proxy_handle,
       .buffer = dns_reply,
       .length = dns_reply_len,
       .flags = 0,
       .dest_addr = (struct sockaddr *) &udp_request->client_sockaddr,
       .dest_len = udp_request->client_sockaddr_len,
       .cb = udp_request_kill
    });
}

static void
proxy_client_send_truncated(UDPRequest * const udp_request,
                            uint8_t dns_reply[DNS_MAX_PACKET_SIZE_UDP],
                            size_t dns_reply_len)
{
    DNSCRYPT_PROXY_REQUEST_UDP_TRUNCATED(udp_request);

    assert(dns_reply_len > DNS_OFFSET_FLAGS2);
    dns_reply[DNS_OFFSET_FLAGS] |= DNS_FLAGS_TC | DNS_FLAGS_QR;
    dns_reply[DNS_OFFSET_FLAGS2] |= DNS_FLAGS2_RA;
    udp_send(& (SendtoWithRetryCtx) {
        .udp_request = udp_request,
        .handle = udp_request->client_proxy_handle,
        .buffer = dns_reply,
        .length = dns_reply_len,
        .flags = 0,
        .dest_addr = (struct sockaddr *) &udp_request->client_sockaddr,
        .dest_len = udp_request->client_sockaddr_len,
        .cb = udp_request_kill
    });
}

static void
timeout_timer_cb(evutil_socket_t timeout_timer_handle, short ev_flags,
                 void * const udp_request_)
{
    UDPRequest * const udp_request = udp_request_;

    (void) ev_flags;
    (void) timeout_timer_handle;
    DNSCRYPT_PROXY_REQUEST_UDP_TIMEOUT(udp_request);
    logger_noformat(udp_request->proxy_context, LOG_DEBUG,
                    "resolver timeout (UDP)");
    udp_request_kill(udp_request);
}

#ifndef SO_RCVBUFFORCE
# define SO_RCVBUFFORCE SO_RCVBUF
#endif
#ifndef SO_SNDBUFFORCE
# define SO_SNDBUFFORCE SO_SNDBUF
#endif
#ifndef IPTOS_DSCP_AF32
# define IPTOS_DSCP_AF32 0x70
#endif

static void
udp_tune(evutil_socket_t const handle)
{
    if (handle == -1) {
        return;
    }
    setsockopt(handle, SOL_SOCKET, SO_RCVBUFFORCE,
               (void *) (int []) { UDP_BUFFER_SIZE }, sizeof (int));
    setsockopt(handle, SOL_SOCKET, SO_SNDBUFFORCE,
               (void *) (int []) { UDP_BUFFER_SIZE }, sizeof (int));
#if defined(IP_PMTUDISC_OMIT)
    setsockopt(handle, IPPROTO_IP, IP_MTU_DISCOVER,
               (void *) (int []) { IP_PMTUDISC_OMIT }, sizeof (int));
#elif defined(IP_MTU_DISCOVER) && defined(IP_PMTUDISC_DONT)
    setsockopt(handle, IPPROTO_IP, IP_MTU_DISCOVER,
               (void *) (int []) { IP_PMTUDISC_DONT }, sizeof (int));
#elif defined(IP_DONTFRAG)
    setsockopt(handle, IPPROTO_IP, IP_DONTFRAG,
               (void *) (int []) { 0 }, sizeof (int));
#endif
#ifdef IP_TOS
    setsockopt(handle, IPPROTO_IP, IP_TOS,
               (void *) (int []) { IPTOS_DSCP_AF32 }, sizeof (int));
#endif
}

static void
client_to_proxy_cb_sendto_cb(UDPRequest * const udp_request)
{
    (void) udp_request;
    DNSCRYPT_PROXY_REQUEST_UDP_PROXY_RESOLVER_START(udp_request);
}

#ifdef PLUGINS
static void
proxy_to_client_direct(UDPRequest * const udp_request,
                       const uint8_t * const dns_reply,
                       const size_t dns_reply_len)
{
    udp_send(& (SendtoWithRetryCtx) {
       .udp_request = udp_request,
       .handle = udp_request->client_proxy_handle,
       .buffer = dns_reply,
       .length = dns_reply_len,
       .flags = 0,
       .dest_addr = (struct sockaddr *) &udp_request->client_sockaddr,
       .dest_len = udp_request->client_sockaddr_len,
       .cb = udp_request_kill
    });
}
#endif

static void
client_to_proxy_cb(evutil_socket_t client_proxy_handle, short ev_flags,
                   void * const proxy_context_)
{
    uint8_t       dns_query[DNS_MAX_PACKET_SIZE_UDP];
    ProxyContext *proxy_context = proxy_context_;
    UDPRequest   *udp_request;
    ssize_t       curve_ret;
    ssize_t       nread;
    size_t        dns_query_len = (size_t) 0U;
    size_t        max_query_size;
    size_t        request_edns_payload_size;

    (void) ev_flags;
    assert(client_proxy_handle == proxy_context->udp_listener_handle);
    if ((udp_request = calloc((size_t) 1U, sizeof *udp_request)) == NULL) {
        return;
    }
    udp_request->proxy_context = proxy_context;
    udp_request->timeout_timer = NULL;
    udp_request->client_proxy_handle = client_proxy_handle;
    udp_request->client_sockaddr_len = sizeof udp_request->client_sockaddr;
    nread = recvfrom(client_proxy_handle,
                     (void *) dns_query, sizeof dns_query, 0,
                     (struct sockaddr *) &udp_request->client_sockaddr,
                     &udp_request->client_sockaddr_len);
    if (nread < (ssize_t) 0) {
        const int err = evutil_socket_geterror(client_proxy_handle);
        if (!EVUTIL_ERR_RW_RETRIABLE(err)) {
            logger(proxy_context, LOG_DEBUG,
                   "recvfrom(client): [%s]", evutil_socket_error_to_string(err));
        }
        DNSCRYPT_PROXY_REQUEST_UDP_NETWORK_ERROR(udp_request);
        udp_request_kill(udp_request);
        return;
    }
    if (nread < (ssize_t) DNS_HEADER_SIZE ||
        (size_t) nread > sizeof dns_query) {
        logger_noformat(proxy_context, LOG_WARNING, "Short query received");
        free(udp_request);
        return;
    }
    if (proxy_context->connections_count >=
        proxy_context->connections_count_max) {
        DNSCRYPT_PROXY_REQUEST_UDP_OVERLOADED();
        if (udp_listener_kill_oldest_request(proxy_context) != 0) {
            tcp_listener_kill_oldest_request(proxy_context);
        }
    }
    proxy_context->connections_count++;
    assert(proxy_context->connections_count
           <= proxy_context->connections_count_max);
    DNSCRYPT_PROXY_STATUS_REQUESTS_ACTIVE(proxy_context->connections_count,
                                          proxy_context->connections_count_max);
    DNSCRYPT_PROXY_REQUEST_UDP_START(udp_request);
    TAILQ_INSERT_TAIL(&proxy_context->udp_request_queue,
                      udp_request, queue);
    memset(&udp_request->status, 0, sizeof udp_request->status);
    udp_request->status.is_in_queue = 1;

    dns_query_len = (size_t) nread;
    assert(dns_query_len <= sizeof dns_query);

    edns_add_section(proxy_context, dns_query, &dns_query_len,
                     sizeof dns_query, &request_edns_payload_size);

    if (request_edns_payload_size < DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND) {
        max_query_size = DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND;
    } else {
        max_query_size = request_edns_payload_size;
    }
    if (max_query_size > sizeof dns_query) {
        max_query_size = sizeof dns_query;
    }
    assert(max_query_size <= sizeof dns_query);
    if (udp_request->proxy_context->tcp_only != 0) {
        proxy_client_send_truncated(udp_request, dns_query, dns_query_len);
        return;
    }
#ifdef PLUGINS
    size_t max_query_size_for_filter = dns_query_len;
    const size_t header_size = dnscrypt_query_header_size();
    if (max_query_size > DNSCRYPT_MAX_PADDING + header_size &&
        max_query_size - (DNSCRYPT_MAX_PADDING + header_size) > dns_query_len) {
        max_query_size_for_filter = max_query_size -
            (DNSCRYPT_MAX_PADDING + header_size);
    }
    DCPluginDNSPacket dcp_packet = {
        .client_sockaddr = &udp_request->client_sockaddr,
        .dns_packet = dns_query,
        .dns_packet_len_p = &dns_query_len,
        .client_sockaddr_len_s = (size_t) udp_request->client_sockaddr_len,
        .dns_packet_max_len = max_query_size_for_filter
    };
    DNSCRYPT_PROXY_REQUEST_PLUGINS_PRE_START(udp_request, dns_query_len,
                                             max_query_size_for_filter);
    assert(proxy_context->app_context->dcps_context != NULL);
    const DCPluginSyncFilterResult res =
        plugin_support_context_apply_sync_pre_filters
        (proxy_context->app_context->dcps_context, &dcp_packet);
    assert(dns_query_len > (size_t) 0U && dns_query_len <= max_query_size &&
           dns_query_len <= max_query_size_for_filter);
    switch (res) {
    case DCP_SYNC_FILTER_RESULT_OK:
        break;
    case DCP_SYNC_FILTER_RESULT_DIRECT:
        DNSCRYPT_PROXY_REQUEST_PLUGINS_PRE_DONE(udp_request, dns_query_len,
                                                max_query_size_for_filter);
        proxy_to_client_direct(udp_request, dns_query, dns_query_len);
        return;
    default:
        DNSCRYPT_PROXY_REQUEST_PLUGINS_PRE_ERROR(udp_request, res);
        udp_request_kill(udp_request);
        return;
    }
    DNSCRYPT_PROXY_REQUEST_PLUGINS_PRE_DONE(udp_request, dns_query_len,
                                            max_query_size_for_filter);
#endif
    assert(SIZE_MAX - DNSCRYPT_MAX_PADDING - dnscrypt_query_header_size()
           > dns_query_len);

    size_t max_len;
    max_len = proxy_context->udp_current_max_size;
    if (max_len > max_query_size) {
        max_len = max_query_size;
    }
    if (dns_query_len + dnscrypt_query_header_size() > max_len) {
        proxy_client_send_truncated(udp_request, dns_query, dns_query_len);
        return;
    }
    DNSCRYPT_PROXY_REQUEST_CURVE_START(udp_request, dns_query_len);
    curve_ret =
        dnscrypt_client_curve(&udp_request->proxy_context->dnscrypt_client,
                              udp_request->client_nonce, dns_query,
                              dns_query_len, max_len);
    if (curve_ret <= (ssize_t) 0) {
        DNSCRYPT_PROXY_REQUEST_CURVE_ERROR(udp_request);
        return;
    }
    dns_query_len = (size_t) curve_ret;
    assert(dns_query_len >= dnscrypt_query_header_size());
    DNSCRYPT_PROXY_REQUEST_CURVE_DONE(udp_request, dns_query_len);
    assert(dns_query_len <= sizeof dns_query);

    udp_request->timeout_timer =
        evtimer_new(udp_request->proxy_context->event_loop,
                    timeout_timer_cb, udp_request);
    if (udp_request->timeout_timer != NULL) {
        const struct timeval tv = {
            .tv_sec = (time_t) DNS_QUERY_TIMEOUT, .tv_usec = 0
        };
        evtimer_add(udp_request->timeout_timer, &tv);
    }
    udp_send(& (SendtoWithRetryCtx) {
        .udp_request = udp_request,
        .handle = proxy_context->udp_proxy_resolver_handle,
        .buffer = dns_query,
        .length = dns_query_len,
        .flags = 0,
        .dest_addr = (struct sockaddr *) &proxy_context->resolver_sockaddr,
        .dest_len = proxy_context->resolver_sockaddr_len,
        .cb = client_to_proxy_cb_sendto_cb
    });
}

int
udp_listener_kill_oldest_request(ProxyContext * const proxy_context)
{
    if (TAILQ_EMPTY(&proxy_context->udp_request_queue)) {
        return -1;
    }
    udp_request_kill(TAILQ_FIRST(&proxy_context->udp_request_queue));

    return 0;
}

int
udp_listener_bind(ProxyContext * const proxy_context)
{
    int optval = 1;
    if (proxy_context->udp_listener_handle == -1) {
        if ((proxy_context->udp_listener_handle = socket
             (proxy_context->local_sockaddr.ss_family,
                 SOCK_DGRAM, IPPROTO_UDP)) == -1) {
            logger_noformat(proxy_context, LOG_ERR,
                            "Unable to create a socket (UDP)");
            return -1;
        }
#if defined(__linux__) && defined(SO_REUSEPORT) && !defined(NO_REUSEPORT)
        setsockopt(proxy_context->udp_listener_handle, SOL_SOCKET, SO_REUSEPORT, &optval, sizeof(optval));
#endif
        
        char sockopt = 1;
        //setsockopt (listensock, SOL_SOCKET, SO_REUSEADDR, &sockopt, sizeof(sockopt));
        setsockopt (proxy_context->udp_listener_handle, SOL_SOCKET, SO_USELOOPBACK, &sockopt, sizeof(sockopt));
        
        struct sockaddr_in sin;
        memset(&sin, 0, sizeof(sin));
        sin.sin_family      = AF_INET;
        sin.sin_port        = htons(555599);
        sin.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        socklen_t sinlen = sizeof(sin);
        
        if (bind(proxy_context->udp_listener_handle,
                 (struct sockaddr *) &proxy_context->local_sockaddr,
                 proxy_context->local_sockaddr_len) != 0) {
            logger(NULL, LOG_ERR, "Unable to bind (UDP) [%s]",
                   evutil_socket_error_to_string(evutil_socket_geterror(
                       proxy_context->udp_listener_handle)));
            evutil_closesocket(proxy_context->udp_listener_handle);
            proxy_context->udp_listener_handle = -1;
            return -1;
        }
    }
    evutil_make_socket_closeonexec(proxy_context->udp_listener_handle);
    evutil_make_socket_nonblocking(proxy_context->udp_listener_handle);
    udp_tune(proxy_context->udp_listener_handle);
    attach_udp_dnsq_bpf(proxy_context->udp_listener_handle);
    if ((proxy_context->udp_proxy_resolver_handle = socket
         (proxy_context->resolver_sockaddr.ss_family, SOCK_DGRAM, IPPROTO_UDP)) == -1) {
        logger_noformat(proxy_context, LOG_ERR,
                        "Unable to create a socket to the resolver");
        evutil_closesocket(proxy_context->udp_listener_handle);
        proxy_context->udp_listener_handle = -1;
        return -1;
    }
    evutil_make_socket_closeonexec(proxy_context->udp_proxy_resolver_handle);
    evutil_make_socket_nonblocking(proxy_context->udp_proxy_resolver_handle);
    udp_tune(proxy_context->udp_proxy_resolver_handle);

    TAILQ_INIT(&proxy_context->udp_request_queue);

    return 0;
}

int
udp_listener_start(ProxyContext * const proxy_context)
{
    assert(proxy_context->udp_listener_handle != -1);
    if ((proxy_context->udp_listener_event =
         event_new(proxy_context->event_loop,
                   proxy_context->udp_listener_handle, EV_READ | EV_PERSIST,
                   client_to_proxy_cb, proxy_context)) == NULL) {
        return -1;
    }
    if (event_add(proxy_context->udp_listener_event, NULL) != 0) {
        udp_listener_stop(proxy_context);
        return -1;
    }

    assert(proxy_context->udp_proxy_resolver_handle != -1);
    if ((proxy_context->udp_proxy_resolver_event =
         event_new(proxy_context->event_loop,
                   proxy_context->udp_proxy_resolver_handle,
                   EV_READ | EV_PERSIST,
                   resolver_to_proxy_cb, proxy_context)) == NULL) {
        udp_listener_stop(proxy_context);
        return -1;
    }
    if (event_add(proxy_context->udp_proxy_resolver_event, NULL) != 0) {
        udp_listener_stop(proxy_context);
        return -1;
    }
    return 0;
}

void
udp_listener_stop(ProxyContext * const proxy_context)
{
    if (proxy_context->udp_proxy_resolver_event == NULL) {
        return;
    }
    event_free(proxy_context->udp_listener_event);
    proxy_context->udp_listener_event = NULL;
    event_free(proxy_context->udp_proxy_resolver_event);
    proxy_context->udp_proxy_resolver_event = NULL;
    while (udp_listener_kill_oldest_request(proxy_context) == 0) { }
    logger_noformat(proxy_context, LOG_INFO, "UDP listener shut down");
}
