
#ifndef __PLUGIN_SUPPORT_P_H__
#define __PLUGIN_SUPPORT_P_H__ 1

#include <ltdl.h>

#include <dnscrypt/plugin.h>

#include "queue.h"

typedef int (*DCPluginInit)(DCPlugin * const dcplugin, int argc, char *argv[]);
typedef int (*DCPluginDestroy)(DCPlugin * const dcplugin);
typedef const char *(*DCPluginDescription)(DCPlugin * const dcplugin);

typedef DCPluginSyncFilterResult (*DCPluginSyncFilter)
(DCPlugin * const dcplugin, DCPluginDNSPacket *dcp_packet);

struct DCPluginSupport_ {
    SLIST_ENTRY(DCPluginSupport_) next;
    DCPluginSyncFilter  sync_post_filter;
    DCPluginSyncFilter  sync_pre_filter;
    lt_dlhandle         handle;
    DCPlugin           *plugin;
    char               *plugin_file;
    char              **argv;
    int                 argc;
};

struct DCPluginSupportContext_ {
    SLIST_HEAD(DCPluginSupportList_, DCPluginSupport_) dcps_list;
    _Bool lt_enabled;
};

#endif
