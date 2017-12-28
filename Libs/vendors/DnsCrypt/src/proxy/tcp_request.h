
#ifndef __TCP_REQUEST_H__
#define __TCP_REQUEST_H__ 1

#include "dnscrypt_proxy.h"

#define DNS_MAX_PACKET_SIZE_TCP (65535U + 2U)

#ifndef TCP_REQUEST_BACKLOG
# define TCP_REQUEST_BACKLOG 128
#endif
#ifndef TCP_FASTOPEN_QUEUES
# ifdef __APPLE__
#  define TCP_FASTOPEN_QUEUES 1
# else
#  define TCP_FASTOPEN_QUEUES 5
# endif
#endif

int tcp_listener_bind(ProxyContext * const proxy_context);
int tcp_listener_start(ProxyContext * const proxy_context);
void tcp_listener_stop(ProxyContext * const proxy_context);
int tcp_listener_kill_oldest_request(ProxyContext * const proxy_context);

#endif
