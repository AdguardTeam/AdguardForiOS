
#ifndef __EDNS_H__
#define __EDNS_H__ 1

#include <sys/types.h>

#include <stdint.h>
#include <stdlib.h>

#include "dnscrypt_proxy.h"

int edns_add_section(ProxyContext * const proxy_context,
                     uint8_t * const dns_packet,
                     size_t * const dns_packet_len_p,
                     size_t dns_packet_max_size,
                     size_t * const request_edns_payload_size);

#endif
