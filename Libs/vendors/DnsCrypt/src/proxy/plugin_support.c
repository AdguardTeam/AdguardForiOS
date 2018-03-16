
#include <config.h>

#include <sys/types.h>
#ifndef _WIN32
# include <sys/stat.h>
#endif

#include <assert.h>
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef _WIN32
# include <unistd.h>
#endif

#include <dnscrypt/plugin.h>
#include <ltdl.h>

#include "logger.h"
#include "plugin_support.h"
#include "plugin_support_p.h"
#include "queue.h"
#include "utils.h"

int
plugin_support_add_option(DCPluginSupport * const dcps, char * const arg)
{
    char **argv;

    if (dcps->argc >= INT_MAX) {
        return -1;
    }
    if (SIZE_MAX / sizeof *argv <= (unsigned int) (dcps->argc + 2U) ||
        (argv = realloc(dcps->argv, (unsigned int) (dcps->argc + 2U) *
                        sizeof *argv)) == NULL) {
        return -1;
    }
    argv[dcps->argc++] = arg;
    argv[dcps->argc] = NULL;
    dcps->argv = argv;

    return 0;
}

static void *
plugin_support_load_symbol(DCPluginSupport * const dcps,
                           const char * const symbol)
{
    assert(dcps->handle != NULL);

    return lt_dlsym(dcps->handle, symbol);
}

static void *
plugin_support_load_symbol_err(DCPluginSupport * const dcps,
                               const char * const symbol)
{
    void *fn;

    if ((fn = plugin_support_load_symbol(dcps, symbol)) == NULL) {
        logger(NULL, LOG_ERR, "Plugin: symbol [%s] not found in [%s]",
               symbol, dcps->plugin_file);
    }
    return fn;
}

static const char *
plugin_support_description(DCPluginSupport * const dcps)
{
    DCPluginDescription  dcplugin_description;
    const char          *description;

    assert(dcps != NULL);
    if ((dcplugin_description =
         plugin_support_load_symbol(dcps, "dcplugin_description")) == NULL) {
        return NULL;
    }
    if ((description = dcplugin_description(dcps->plugin)) == NULL ||
        *description == 0) {
        return NULL;
    }
    return description;
}

static int
plugin_support_call_init(DCPluginSupport * const dcps)
{
    DCPluginInit  dcplugin_init;
    const char   *description;

    if ((dcplugin_init =
         plugin_support_load_symbol_err(dcps, "dcplugin_init")) == NULL) {
        return -1;
    }
    assert(dcps->argc > 0 && dcps->argv != NULL);
    if (dcplugin_init(dcps->plugin, dcps->argc, dcps->argv) != 0) {
        logger(NULL, LOG_ERR, "Unable to initialize plugin [%s]",
               dcps->plugin_file);
        return -1;
    }
    dcps->sync_post_filter =
        plugin_support_load_symbol(dcps, "dcplugin_sync_post_filter");
    dcps->sync_pre_filter =
        plugin_support_load_symbol(dcps, "dcplugin_sync_pre_filter");
    if ((description = plugin_support_description(dcps)) == NULL) {
        logger_noformat(NULL, LOG_INFO, "Plugin loaded");
    } else {
        logger(NULL, LOG_INFO, "Loaded plugin: [%s]", description);
    }
    return 0;
}

static int
plugin_support_check_permissions(const char * const plugin_file)
{
    assert(plugin_file != NULL);

#ifndef _WIN32
    struct stat st;

    if (stat(plugin_file, &st) != 0 || !S_ISREG(st.st_mode)) {
        return -1;
    }
# ifndef RELAXED_PLUGINS_PERMISSIONS
    const uid_t uid = getuid();

    if (st.st_uid != (uid_t) 0) {
        if (uid == (uid_t) 0) {
            errno = EPERM;
            return -1;
        }
        if (access(plugin_file, W_OK) != 0) {
            return -1;
        }
    }
# endif
#endif

    return 0;
}

static int
plugin_support_load(DCPluginSupport * const dcps)
{
    lt_dladvise advise;
    lt_dlhandle handle;

    assert(dcps != NULL && dcps->plugin_file != NULL);
    assert(dcps->handle == NULL);
    if (lt_dladvise_init(&advise) != 0) {
        return -1;
    }
    lt_dladvise_local(&advise);
    lt_dladvise_ext(&advise);
    logger(NULL, LOG_INFO, "Loading plugin [%s]", dcps->plugin_file);

    if (plugin_support_check_permissions(dcps->plugin_file) != 0) {
        logger(NULL, LOG_ERR, "Plugin [%s] can't be loaded: [%s]",
               dcps->plugin_file, strerror(errno));
        lt_dladvise_destroy(&advise);
        return -1;
    }
    if ((handle = lt_dlopenadvise(dcps->plugin_file, advise)) == NULL) {
        logger(NULL, LOG_ERR, "Unable to load [%s]: [%s]",
               dcps->plugin_file, lt_dlerror());
        lt_dladvise_destroy(&advise);
        return -1;
    }
    lt_dladvise_destroy(&advise);
    dcps->handle = handle;

    return plugin_support_call_init(dcps);
}

static int
plugin_support_call_destroy(DCPluginSupport * const dcps)
{
    DCPluginDestroy dcplugin_destroy;

    if (dcps->handle == NULL) {
        return 0;
    }
    dcplugin_destroy = plugin_support_load_symbol(dcps, "dcplugin_destroy");
    if (dcplugin_destroy != NULL) {
        dcplugin_destroy(dcps->plugin);
    }
    return 0;
}

static int
plugin_support_unload(DCPluginSupport * const dcps)
{
    if (plugin_support_call_destroy(dcps) != 0) {
        return -1;
    }
    if (lt_dlclose(dcps->handle) != 0) {
        return -1;
    }
    dcps->handle = NULL;

    return 0;
}

static char *
plugin_support_expand_plugin_file(const char * const plugin_file)
{
    char   *expanded_plugin_file;
    size_t  plugin_file_len;
    size_t  plugins_root_len = sizeof PLUGINS_ROOT - (size_t) 1U;
    size_t  sizeof_expanded_plugin_file;

#ifdef ENABLE_PLUGINS_ROOT
    if (strstr(plugin_file, "..") != NULL) {
        return NULL;
    }
    if (strncmp(plugin_file, PLUGINS_ROOT, plugins_root_len) == 0) {
        return strdup(plugin_file);
    }
#elif !defined(_WIN32)
    if (*plugin_file == '/') {
        return strdup(plugin_file);
    }
#endif
#ifdef _WIN32
    if ((expanded_plugin_file =
         path_from_app_folder(plugin_file)) == NULL) {
        logger_noformat(NULL, LOG_EMERG, "Out of memory");
        exit(1);
    }
    (void) plugin_file_len;
    (void) sizeof_expanded_plugin_file;
#else
    assert(PLUGINS_ROOT[plugins_root_len - (size_t) 1U] == '/');
    plugin_file_len = strlen(plugin_file);
    assert(SIZE_MAX - plugins_root_len > plugin_file_len);
    sizeof_expanded_plugin_file = plugins_root_len + plugin_file_len + 1U;
    if ((expanded_plugin_file = malloc(sizeof_expanded_plugin_file)) == NULL) {
        return NULL;
    }
    memcpy(expanded_plugin_file, PLUGINS_ROOT, plugins_root_len);
    memcpy(expanded_plugin_file + plugins_root_len, plugin_file,
           plugin_file_len + 1U);
#endif

    return expanded_plugin_file;
}

DCPluginSupport *
plugin_support_new(const char * const plugin_file)
{
    DCPluginSupport *dcps;

    if ((dcps = calloc((size_t) 1U, sizeof *dcps)) == NULL) {
        return NULL;
    }
    if ((dcps->plugin = calloc((size_t) 1U, sizeof *dcps->plugin)) == NULL) {
        free(dcps);
        return NULL;
    }
    assert(plugin_file != NULL && *plugin_file != 0);
    if ((dcps->plugin_file =
         plugin_support_expand_plugin_file(plugin_file)) == NULL) {
        free(dcps);
        return NULL;
    }
    dcps->argv = NULL;
    dcps->handle = NULL;
    dcps->sync_post_filter = NULL;
    dcps->sync_pre_filter = NULL;

    return dcps;
}

void
plugin_support_free(DCPluginSupport * const dcps)
{
    plugin_support_unload(dcps);
    assert(dcps->plugin_file != NULL && *dcps->plugin_file != 0);
    assert(dcps->plugin != NULL);
    free(dcps->plugin);
    free(dcps->plugin_file);
    dcps->plugin_file = NULL;
    free(dcps->argv);
    dcps->argv = NULL;
    free(dcps);
}

DCPluginSupportContext *
plugin_support_context_new(void)
{
    DCPluginSupportContext *dcps_context;

    if ((dcps_context = calloc((size_t) 1U, sizeof *dcps_context)) == NULL) {
        return NULL;
    }
    SLIST_INIT(&dcps_context->dcps_list);

    return dcps_context;
}

int
plugin_support_context_insert(DCPluginSupportContext * const dcps_context,
                              DCPluginSupport * const dcps)
{
    assert(dcps_context != NULL);
    assert(dcps != NULL);
    SLIST_INSERT_HEAD(&dcps_context->dcps_list, dcps, next);

    return 0;
}

int
plugin_support_context_remove(DCPluginSupportContext * const dcps_context,
                              DCPluginSupport * const dcps)
{
    assert(! SLIST_EMPTY(&dcps_context->dcps_list));
    SLIST_REMOVE(&dcps_context->dcps_list, dcps, DCPluginSupport_, next);

    return 0;
}

int
plugin_support_context_reload(DCPluginSupportContext * const dcps_context)
{
    DCPluginSupport *dcps;
    DCPluginSupport *dcps_tmp;
    int              ret = 0;
    int              ret_ = 0;

    SLIST_FOREACH_SAFE(dcps, &dcps_context->dcps_list, next, dcps_tmp) {
        if ((ret_ = plugin_support_call_destroy(dcps)) == 0) {
            ret_ = plugin_support_call_init(dcps);
        }
        ret |= ret_;
    }
    return ret;
}

void
plugin_support_context_free(DCPluginSupportContext * const dcps_context)
{
    DCPluginSupport *dcps;
    DCPluginSupport *dcps_tmp;

    SLIST_FOREACH_SAFE(dcps, &dcps_context->dcps_list, next, dcps_tmp) {
        plugin_support_free(dcps);
    }
    if (dcps_context->lt_enabled != 0) {
        lt_dlexit();
    }
    free(dcps_context);
}

int
plugin_support_context_load(DCPluginSupportContext * const dcps_context)
{
    DCPluginSupport *dcps;
    _Bool            failed = 0;

    assert(dcps_context != NULL);
    if (dcps_context->lt_enabled == 0 && lt_dlinit() != 0) {
        return -1;
    }
    SLIST_FOREACH(dcps, &dcps_context->dcps_list, next) {
        if (plugin_support_load(dcps) != 0) {
            failed = 1;
        }
    }
    if (failed != 0) {
        return -1;
    }
    return 0;
}

static DCPluginSyncFilterResult
plugin_support_context_get_result_from_dcps(DCPluginSyncFilterResult result,
                                            DCPluginSyncFilterResult result_dcps)
{
    switch (result_dcps) {
    case DCP_SYNC_FILTER_RESULT_OK:
        break;
    case DCP_SYNC_FILTER_RESULT_DIRECT:
        if (result == DCP_SYNC_FILTER_RESULT_OK) {
            result = DCP_SYNC_FILTER_RESULT_DIRECT;
        }
        break;
    case DCP_SYNC_FILTER_RESULT_KILL:
        if (result == DCP_SYNC_FILTER_RESULT_OK) {
            result = DCP_SYNC_FILTER_RESULT_KILL;
        }
        break;
    case DCP_SYNC_FILTER_RESULT_ERROR:
        if (result != DCP_SYNC_FILTER_RESULT_FATAL) {
            result = DCP_SYNC_FILTER_RESULT_ERROR;
        }
        break;
    case DCP_SYNC_FILTER_RESULT_FATAL:
    default:
        result = DCP_SYNC_FILTER_RESULT_FATAL;
    }
    return result;
}

DCPluginSyncFilterResult
plugin_support_context_apply_sync_post_filters(DCPluginSupportContext *dcps_context,
                                               DCPluginDNSPacket *dcp_packet)
{
    DCPluginSupport          *dcps;
    const size_t              dns_packet_max_len = dcp_packet->dns_packet_max_len;
    DCPluginSyncFilterResult  result = DCP_SYNC_FILTER_RESULT_OK;
    DCPluginSyncFilterResult  result_dcps;

    assert(dcp_packet->dns_packet != NULL &&
           dcp_packet->dns_packet_len_p != NULL &&
           *dcp_packet->dns_packet_len_p > (size_t) 0U);
    SLIST_FOREACH(dcps, &dcps_context->dcps_list, next) {
        if (dcps->sync_post_filter != NULL) {
            result_dcps = dcps->sync_post_filter(dcps->plugin, dcp_packet);
            result = plugin_support_context_get_result_from_dcps(result,
                                                                 result_dcps);
            assert(*dcp_packet->dns_packet_len_p <= dns_packet_max_len);
            assert(*dcp_packet->dns_packet_len_p > (size_t) 0U);
        }
    }
    return result;
}

DCPluginSyncFilterResult
plugin_support_context_apply_sync_pre_filters(DCPluginSupportContext *dcps_context,
                                              DCPluginDNSPacket *dcp_packet)
{
    DCPluginSupport          *dcps;
    const size_t              dns_packet_max_len = dcp_packet->dns_packet_max_len;
    DCPluginSyncFilterResult  result = DCP_SYNC_FILTER_RESULT_OK;
    DCPluginSyncFilterResult  result_dcps;

    assert(dcp_packet->dns_packet != NULL &&
           dcp_packet->dns_packet_len_p != NULL &&
           *dcp_packet->dns_packet_len_p > (size_t) 0U);
    SLIST_FOREACH(dcps, &dcps_context->dcps_list, next) {
        if (dcps->sync_pre_filter != NULL) {
            result_dcps = dcps->sync_pre_filter(dcps->plugin, dcp_packet);
            result = plugin_support_context_get_result_from_dcps(result,
                                                                 result_dcps);
        }
        assert(*dcp_packet->dns_packet_len_p <= dns_packet_max_len);
        assert(*dcp_packet->dns_packet_len_p > (size_t) 0U);
    }
    return result;
}
