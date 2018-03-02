
#ifndef __DNSCRYPT_PLUGIN_H__
#define __DNSCRYPT_PLUGIN_H__ 1

/** @file dnscrypt/plugin.h
 *
 * Interface for dnscrypt-proxy plugins.
 *
 * A plugin can inspect and modify a request before it is authenticated and
 * sent to the upstream server (pre-filters), or/and after a reply has been
 * received and verified (post-filters).
 *
 * Plugins are modules that have to implement (at least) dcplugin_init().
 *
 * Plugins can be dynamically loaded by dnscrypt-proxy using
 * --plugin=library[,arguments]
 * Ex:
 * --plugin=/usr/local/lib/dnscrypt-proxy/test.dll,-a,-H,--user=42
 *
 * Multiple plugins can be chained, and queries will be sequentially passed
 * through all of them.
 *
 * The only header file you should include in a plugin is <dnscrypt/plugin.h>
 */

#include <assert.h>
#include <string.h>

#include <dnscrypt/private.h>
#include <dnscrypt/version.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * This macro should be present once in every plugin.
 *
 * It basically defines all the symbols that have to be exported.
 *
 * @param ID a string identifier, only used for debugging. Can be __FILE__.
 */
#define DCPLUGIN_MAIN(ID) DCPLUGIN_MAIN_PRIVATE(ID)

/**
 * A dnscrypt-proxy plugin object. This is an opaque structure that gets
 * passed to all callbacks.
 *
 * It includes a pointer to arbitrary user-supplied data.
 *
 * @see dcplugin_get_user_data(), dcplugin_set_user_data()
 */
typedef struct DCPlugin_ DCPlugin;

/**
 * A DNS packet.
 *
 * It includes the data in wire format and the client address.
 * The data can be inspected or modified.
 */
typedef struct DCPluginDNSPacket_ DCPluginDNSPacket;

/**
 * The return code from a filter should be one of these.
 *
 * DCP_SYNC_FILTER_RESULT_OK indicates that the filter was able to process
 * the data and that the next filter should be called.
 *
 * DCP_SYNC_FILTER_RESULT_DIRECT indicates that the filter built a response
 * that should be directly sent to the client. The content of the current
 * packet is this response. post-filters will not be triggered.
 *
 * DCP_SYNC_FILTER_RESULT_KILL indicates that the filter asks for the
 * query to be immediately terminated. The client will not receive any reply.
 *
 * DCP_SYNC_FILTER_RESULT_ERROR indicates that an error occurred.
 * The proxy will not be stopped, but the connection will be dropped.
 *
 * DCP_SYNC_FILTER_RESULT_FATAL should not be used by plugins.
 */
typedef enum DCPluginSyncFilterResult_ {
    DCP_SYNC_FILTER_RESULT_OK,
    DCP_SYNC_FILTER_RESULT_DIRECT,
    DCP_SYNC_FILTER_RESULT_KILL,
    DCP_SYNC_FILTER_RESULT_ERROR,
    DCP_SYNC_FILTER_RESULT_FATAL
} DCPluginSyncFilterResult;

/**
 * This is the entry point for a plugin.
 *
 * @param dcplugin a plugin object
 * @param argc the number of command-line arguments for this plugin
 * @param argv the command-line arguments for this plugin
 * @return 0 on success
 *
 * These can be parsed by getopt().
 */
int dcplugin_init(DCPlugin *dcplugin, int argc, char *argv[]);

/**
 * This optional function is called when the plugin has to be unloaded.
 *
 * @param dcplugin a plugin object
 * @return 0 on success
 */
int dcplugin_destroy(DCPlugin *dcplugin);

/**
 * This optional function returns a one-ine description of the plugin.
 *
 * @param dcplugin a plugin object
 * @return a human-readable one-line description of the plugin
 */
const char *dcplugin_description(DCPlugin *dcplugin);

/**
 * This optional function returns a long description of the plugin.
 *
 * @param dcplugin a plugin object
 * @return a human-readable long, multiline description of the plugin
 */
const char *dcplugin_long_description(DCPlugin *dcplugin);

/**
 * This optional function implements a pre-filter, for a query.
 *
 * This filter will be called after a client has sent a query, and before
 * this query has been forwarded to an upstream server.
 *
 * @param dcplugin a plugin object
 * @param dcp_packet a DNS packet
 * @return a valid return code
 */
DCPluginSyncFilterResult
dcplugin_sync_pre_filter(DCPlugin *dcplugin, DCPluginDNSPacket *dcp_packet);

/**
 * This optional function implements a post-filter, for a reply.
 *
 * This filter will be called after a server has sent a reply, and before
 * this reply has been sent to the client.
 *
 * @param dcplugin a plugin object
 * @param dcp_packet a DNS packet
 * @return a valid return code
 */
DCPluginSyncFilterResult
dcplugin_sync_post_filter(DCPlugin *dcplugin, DCPluginDNSPacket *dcp_packet);

/**
 * Get the user data of a plugin object.
 *
 * @param P a plugin object
 * @return the user data
 */
#define dcplugin_get_user_data(P) ((P)->user_data)

/**
 * Set the user data of a plugin object.
 *
 * @param P a plugin object
 * @param V user data
 * @return the user data
 */
#define dcplugin_set_user_data(P, V) ((P)->user_data = (V))

/**
 * Retrieve the client address.
 *
 * @param D a DCPluginDNSPacket object
 * @return a sockaddr_storage pointer
 */
#define dcplugin_get_client_address(D) ((D)->client_sockaddr)

/**
 * Get the client address length.
 *
 * @param D a DCPluginDNSPacket object
 * @return the address length, as a size_t value
 */
#define dcplugin_get_client_address_len(D) ((D)->client_sockaddr_len_s)

/**
 * Get the raw (wire format) content of the DNS packet.
 *
 * @param D a DCPluginDNSPacket object
 * @return a pointer to a uint8_t buffer with the data in wire format
 *
 * @see dcplugin_get_wire_data_len()
 */
#define dcplugin_get_wire_data(D) ((D)->dns_packet)

/**
 * Change the content of the DNS packet.
 *
 * @param D a DCPluginDNSPacket object
 * @param V the new content as a pointer to a uint8_t * buffer
 * @param L the new length of the packet
 *
 * @see dcplugin_get_wire_data_len(), dcplugin_get_wire_data_max_len()
 */
#define dcplugin_set_wire_data(D, V, L) do { \
      dcplugin_set_wire_data_len((D), (L)); \
      memcpy(dcplugin_get_wire_data(D), (V), (L)); \
    } while(0)

/**
 * Get the number of bytes of the raw DNS packet.
 * @param D a DCPluginDNSPacket object
 * @return the number of bytes in the packet as a size_t object
 *
 * @see dcplugin_get_wire_data(), dcplugin_set_wire_data_len()
 */
#define dcplugin_get_wire_data_len(D) (*((D)->dns_packet_len_p))

/**
 * Update the size of the DNS packet.
 *
 * @param D a DCPluginDNSPacket object
 * @param L new size, that should always be smaller than the max allowed size
 *
 * @see dcplugin_get_wire_data_max_len(), dcplugin_get_wire_data_len()
 */
#define dcplugin_set_wire_data_len(D, L) do { \
      assert(dcplugin_get_wire_data_max_len(D) >= (L)); \
      (*((D)->dns_packet_len_p)) = (L); \
    } while(0)

/**
 * Get the maximum allowed number of bytes for the DNS packet.
 *
 * @param D a DCPluginDNSPacket object
 * @return the max number of bytes as a size_t object
 *
 * @see dcplugin_set_wire_data_len()
 */
#define dcplugin_get_wire_data_max_len(D) ((D)->dns_packet_max_len)

#ifdef __cplusplus
}
#endif

#endif
