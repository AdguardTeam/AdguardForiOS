
#ifndef __DNSCRYPT_PRIVATE_H__
#define __DNSCRYPT_PRIVATE_H__ 1

#include <sys/types.h>

#include <stdint.h>
#include <stdlib.h>

#include <dnscrypt/version.h>

#ifdef __cplusplus
extern "C" {
#endif

struct DCPlugin_ {
    void *user_data;
};

struct DCPluginDNSPacket_ {
    struct sockaddr_storage *client_sockaddr;
    uint8_t                 *dns_packet;
    size_t                  *dns_packet_len_p;
    size_t                   client_sockaddr_len_s;
    size_t                   dns_packet_max_len;
};

#define DCPLUGIN_MAIN_PRIVATE(ID) \
    int dcplugin_interface_version_major = DCP_INTERFACE_VERSION_MAJOR; \
    int dcplugin_interface_version_minor = DCP_INTERFACE_VERSION_MINOR

#ifdef __cplusplus
}
#endif

#endif
