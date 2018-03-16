
#include <config.h>
#include <sys/types.h>

#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "dnscrypt_proxy.h"
#include "edns.h"

#define DNS_MAX_HOSTNAME_LEN 256U

static int
_skip_name(const uint8_t * const dns_packet, const size_t dns_packet_len,
           size_t * const offset_p)
{
    size_t  offset = *offset_p;
    size_t  name_len = (size_t) 0U;
    uint8_t label_len;

    if (dns_packet_len < (size_t) 1U ||
        offset >= dns_packet_len - (size_t) 1U) {
        return -1;
    }
    for (;;) {
        label_len = dns_packet[offset];
        if ((label_len & 0xC0) == 0xC0) {
            if (2U > dns_packet_len - offset) {
                return -1;
            }
            offset += 2U;
            break;
        }
        if (label_len >= dns_packet_len - offset - 1U) {
            return -1;
        }
        name_len += (size_t) label_len + (size_t) 1U;
        if (name_len > DNS_MAX_HOSTNAME_LEN) {
            return -1;
        }
        offset += label_len + 1U;
        if (label_len == 0U) {
            break;
        }
    }
    if (offset >= dns_packet_len) {
        return -1;
    }
    *offset_p = offset;

    return 0;
}

#define DNS_QTYPE_PLUS_QCLASS_LEN 4U

static ssize_t
edns_get_payload_size(const uint8_t * const dns_packet,
                      const size_t dns_packet_len)
{
    size_t       offset;
    size_t       payload_size;
    unsigned int arcount;

    assert(dns_packet_len >= DNS_HEADER_SIZE);
    arcount = (dns_packet[DNS_OFFSET_ARCOUNT] << 8) |
        dns_packet[DNS_OFFSET_ARCOUNT + 1U];
    assert(arcount > 0U);
    assert(DNS_OFFSET_QUESTION <= DNS_HEADER_SIZE);
    if (dns_packet[DNS_OFFSET_QDCOUNT] != 0U ||
        dns_packet[DNS_OFFSET_QDCOUNT + 1U] != 1U ||
        (dns_packet[DNS_OFFSET_ANCOUNT] |
         dns_packet[DNS_OFFSET_ANCOUNT + 1U]) != 0U ||
        (dns_packet[DNS_OFFSET_NSCOUNT] |
         dns_packet[DNS_OFFSET_NSCOUNT + 1U]) != 0U) {
        return (ssize_t) -1;
    }
    offset = DNS_OFFSET_QUESTION;
    if (_skip_name(dns_packet, dns_packet_len, &offset) != 0) {
        return (ssize_t) -1;
    }
    assert(dns_packet_len > (size_t) DNS_QTYPE_PLUS_QCLASS_LEN);
    if (offset >= dns_packet_len - (size_t) DNS_QTYPE_PLUS_QCLASS_LEN) {
        return (ssize_t) -1;
    }
    offset += DNS_QTYPE_PLUS_QCLASS_LEN;
    assert(dns_packet_len >= DNS_OFFSET_EDNS_PAYLOAD_SIZE + 2U);
    if (_skip_name(dns_packet, dns_packet_len, &offset) != 0 ||
        offset >= dns_packet_len - DNS_OFFSET_EDNS_PAYLOAD_SIZE - 2U) {
        return (ssize_t) -1;
    }
    assert(DNS_OFFSET_EDNS_PAYLOAD_SIZE > DNS_OFFSET_EDNS_TYPE);
    if (dns_packet[offset + DNS_OFFSET_EDNS_TYPE] != 0U ||
        dns_packet[offset + DNS_OFFSET_EDNS_TYPE + 1U] != DNS_TYPE_OPT) {
        return (ssize_t) -1;
    }
    payload_size = (dns_packet[offset + DNS_OFFSET_EDNS_PAYLOAD_SIZE] << 8) |
        dns_packet[offset + DNS_OFFSET_EDNS_PAYLOAD_SIZE + 1U];
    if (payload_size < DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND) {
        payload_size = DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND;
    }
    return (ssize_t) payload_size;
}

int
edns_add_section(ProxyContext * const proxy_context,
                 uint8_t * const dns_packet, size_t * const dns_packet_len_p,
                 size_t dns_packet_max_size,
                 size_t * const request_edns_payload_size)
{
    const size_t edns_payload_size = proxy_context->edns_payload_size;

    assert(edns_payload_size <= (size_t) 0xFFFF);
    assert(DNS_OFFSET_ARCOUNT + 2U <= DNS_HEADER_SIZE);
    if (edns_payload_size <= DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND ||
        *dns_packet_len_p <= DNS_HEADER_SIZE) {
        *request_edns_payload_size = (size_t) 0U;
        return -1;
    }
    if ((dns_packet[DNS_OFFSET_ARCOUNT] |
         dns_packet[DNS_OFFSET_ARCOUNT + 1U]) != 0U) {
        const ssize_t edns_payload_ssize =
            edns_get_payload_size(dns_packet, *dns_packet_len_p);
        if (edns_payload_ssize <= (ssize_t) 0U) {
            *request_edns_payload_size = (size_t) 0U;
            return -1;
        }
        *request_edns_payload_size = (size_t) edns_payload_ssize;
        return 1;
    }
    assert(dns_packet_max_size >= *dns_packet_len_p);

    assert(DNS_OFFSET_EDNS_TYPE == 0U);
    assert(DNS_OFFSET_EDNS_PAYLOAD_SIZE == 2U);
    uint8_t opt_rr[] = {
        0U,               /* name */
        0U, DNS_TYPE_OPT, /* type */
        (edns_payload_size >> 8) & 0xFF, edns_payload_size & 0xFF,
        0U, 0U, 0U, 0U,   /* rcode */
        0U, 0U            /* rdlen */
    };
    if (dns_packet_max_size - *dns_packet_len_p < sizeof opt_rr) {
        *request_edns_payload_size = (size_t) 0U;
        return -1;
    }
    assert(dns_packet[DNS_OFFSET_ARCOUNT + 1U] == 0U);
    dns_packet[DNS_OFFSET_ARCOUNT + 1U] = 1U;
    memcpy(dns_packet + *dns_packet_len_p, opt_rr, sizeof opt_rr);
    *dns_packet_len_p += sizeof opt_rr;
    *request_edns_payload_size = edns_payload_size;
    assert(*dns_packet_len_p <= dns_packet_max_size);
    assert(*dns_packet_len_p <= 0xFFFF);

    return 0;
}
