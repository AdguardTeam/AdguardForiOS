
#ifndef __PLUGIN_SUPPORT_H__
#define __PLUGIN_SUPPORT_H__ 1

#include <dnscrypt/plugin.h>

#include "queue.h"

typedef struct DCPluginSupportContext_ DCPluginSupportContext;
typedef struct DCPluginSupport_ DCPluginSupport;

DCPluginSupportContext *plugin_support_context_new(void);

void plugin_support_context_free(DCPluginSupportContext * const dcps_context);

int plugin_support_context_insert(DCPluginSupportContext * const dcps_context,
                                  DCPluginSupport * const dcps);

int plugin_support_context_remove(DCPluginSupportContext * const dcps_context,
                                  DCPluginSupport * const dcps);

int plugin_support_context_reload(DCPluginSupportContext * const dcps_context);

DCPluginSupport * plugin_support_new(const char * const plugin_file);

void plugin_support_free(DCPluginSupport *dcps);

int plugin_support_add_option(DCPluginSupport * const dcps, char * const arg);

int plugin_support_context_load(DCPluginSupportContext * const dcps_context);

DCPluginSyncFilterResult
plugin_support_context_apply_sync_post_filters(DCPluginSupportContext *dcps_context,
                                               DCPluginDNSPacket *dcp_packet);

DCPluginSyncFilterResult
plugin_support_context_apply_sync_pre_filters(DCPluginSupportContext *dcps_context,
                                              DCPluginDNSPacket *dcp_packet);
#endif
