
#include <config.h>
#include <assert.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "plugin_options.h"
#include "plugin_support.h"

int
plugin_options_parse_str(DCPluginSupportContext * const dcps_context,
                         char * const str)
{
    DCPluginSupport *dcps = NULL;
    char            *arg;
    char            *plugin_file;
    char            *tmp;

    assert(dcps_context != NULL);
    assert(str != NULL);
    if (*(plugin_file = str) == 0) {
        return -1;
    }
    arg = str;
    while (arg != NULL) {
        if ((tmp = strchr(arg, ',')) != NULL) {
            *tmp++ = 0;
        }
        if (dcps == NULL && (dcps = plugin_support_new(plugin_file)) == NULL) {
            return -1;
        }
        if (plugin_support_add_option(dcps, arg) != 0) {
            return -1;
        }
        arg = tmp;
    }
    return plugin_support_context_insert(dcps_context, dcps);
}
