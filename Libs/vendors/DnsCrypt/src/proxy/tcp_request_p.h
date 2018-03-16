
#ifndef __TCP_REQUEST_H_P__
#define __TCP_REQUEST_H_P__ 1

#include <sys/types.h>

#include <stdint.h>

#include <event2/event.h>

#include "dnscrypt.h"
#include "queue.h"

typedef struct TCPRequestStatus_ {
    _Bool has_dns_query_len : 1;
    _Bool has_dns_reply_len : 1;
    _Bool is_in_queue : 1;
    _Bool is_dying : 1;
} TCPRequestStatus;

typedef struct TCPRequest_ {
    uint8_t                  client_nonce[crypto_box_HALF_NONCEBYTES];
    TAILQ_ENTRY(TCPRequest_) queue;
#ifdef PLUGINS
    struct sockaddr_storage  client_sockaddr;
#endif
    struct bufferevent      *client_proxy_bev;
    struct bufferevent      *proxy_resolver_bev;
    struct evbuffer         *proxy_resolver_query_evbuf;
    ProxyContext            *proxy_context;
    struct event            *timeout_timer;
#ifdef PLUGINS
    ev_socklen_t             client_sockaddr_len;
#endif
    TCPRequestStatus         status;
    size_t                   dns_query_len;
    size_t                   dns_reply_len;
} TCPRequest;

#endif
