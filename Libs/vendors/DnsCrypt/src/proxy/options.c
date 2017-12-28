
#include <config.h>
#include <sys/types.h>
#ifdef _WIN32
# include <winsock2.h>
#else
# include <sys/socket.h>
#endif

#include <assert.h>
#include <fcntl.h>
#include <getopt.h>
#include <limits.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <event2/util.h>
#include <sodium.h>

#include "dnscrypt_proxy.h"
#include "getpwnam.h"
#include "options.h"
#include "logger.h"
#include "minicsv.h"
#include "pid_file.h"
#include "shims.h"
#include "simpleconf.h"
#include "simpleconf_dnscrypt.h"
#include "utils.h"

#ifdef PLUGINS
# include "plugin_options.h"
#endif

static struct option getopt_long_options[] = {
    { "resolver-name", 1, NULL, 'R' },
    { "local-address", 1, NULL, 'a' },
#ifndef _WIN32
    { "daemonize", 0, NULL, 'd' },
#endif
    { "ephemeral-keys", 0, NULL, 'E' },
    { "client-key", 1, NULL, 'K' },
    { "resolvers-list", 1, NULL, 'L' },
    { "logfile", 1, NULL, 'l' },
    { "loglevel", 1, NULL, 'm' },
#ifndef _WIN32
    { "pidfile", 1, NULL, 'p' },
#endif
    { "plugin", 1, NULL, 'X' },
    { "provider-name", 1, NULL, 'N' },
    { "provider-key", 1, NULL, 'k' },
    { "resolver-address", 1, NULL, 'r' },
#ifndef _WIN32
    { "syslog", 0, NULL, 'S' },
    { "syslog-prefix", 1, NULL, 'Z' },
#endif
    { "max-active-requests", 1, NULL, 'n' },
    { "user", 1, NULL, 'u' },
    { "test", 1, NULL, 't' },
    { "tcp-only", 0, NULL, 'T' },
    { "edns-payload-size", 1, NULL, 'e' },
    { "ignore-timestamps", 0, NULL, 'I' },
    { "version", 0, NULL, 'V' },
    { "help", 0, NULL, 'h' },
#ifdef _WIN32
    { "install", 0, NULL, WIN_OPTION_INSTALL },
    { "install-with-config-file", 1, NULL, WIN_OPTION_INSTALL_WITH_CONFIG_FILE },
    { "reinstall", 0, NULL, WIN_OPTION_REINSTALL },
    { "reinstall-with-config-file", 1, NULL, WIN_OPTION_REINSTALL_WITH_CONFIG_FILE },
    { "uninstall", 0, NULL, WIN_OPTION_UNINSTALL },
    { "service-name", 1, NULL, WIN_OPTION_SERVICE_NAME },
#endif
    { NULL, 0, NULL, 0 }
};
#ifndef _WIN32
static const char *getopt_options = "a:de:EhIk:K:L:l:m:n:p:r:R:St:u:N:TVX:Z:";
#else
static const char *getopt_options = "a:e:EhIk:K:L:l:m:n:r:R:t:u:N:TVX:";
#endif

#ifndef DEFAULT_CONNECTIONS_COUNT_MAX
# define DEFAULT_CONNECTIONS_COUNT_MAX 250U
#endif

static void
options_version(void)
{
#ifdef PACKAGE_VENDOR
    puts(PACKAGE_STRING "-" PACKAGE_VENDOR);
#else
    puts(PACKAGE_STRING);
#endif
    puts("");
    printf("Compilation date: %s\n", __DATE__);
#ifdef PLUGINS
    puts("Support for plugins: present");
#endif
#if defined(PLUGINS_ROOT) && !defined(_WIN32)
    printf("Plugins root directory: [%s]\n", PLUGINS_ROOT);
#endif
#ifdef ENABLE_PLUGINS_ROOT
    puts("Plugins restricted to the default plugins directory: yes");
#endif
#ifdef RELAXED_PLUGINS_PERMISSIONS
    puts("Relaxed plugins permissions: yes");
#endif
#ifdef USE_LDNS
    puts("Support for ldns-based plugins: present");
#endif
#ifdef HAVE_LIBSYSTEMD
    puts("Support for systemd socket activation: present");
#endif
#ifdef HAVE_XCHACHA20
    puts("Support for the XChaCha20-Poly1305 cipher: present");
#endif
}

static void
options_usage(void)
{
    const struct option *options = getopt_long_options;

    options_version();
    puts("\nOptions:\n");
    do {
        if (options->val < 256) {
            printf("  -%c\t--%s%s\n", options->val, options->name,
                   options->has_arg ? "=..." : "");
        } else {
            printf("    \t--%s%s\n", options->name,
                   options->has_arg ? "=..." : "");
        }
        options++;
    } while (options->name != NULL);
#ifndef _WIN32
    puts("\nPlease consult the dnscrypt-proxy(8) man page for details.\n");
#endif
}

static
void options_init_with_default(AppContext * const app_context,
                               ProxyContext * const proxy_context)
{
    assert(proxy_context->event_loop == NULL);
    proxy_context->app_context = app_context;
    proxy_context->connections_count = 0U;
    proxy_context->connections_count_max = DEFAULT_CONNECTIONS_COUNT_MAX;
    proxy_context->edns_payload_size = (size_t) DNS_DEFAULT_EDNS_PAYLOAD_SIZE;
    proxy_context->client_key_file = NULL;
    proxy_context->local_ip = "127.0.0.1:53";
    proxy_context->log_fp = NULL;
    proxy_context->log_file = NULL;
    proxy_context->pid_file = NULL;
    proxy_context->resolvers_list = DEFAULT_RESOLVERS_LIST;
    proxy_context->resolver_name = NULL;
    proxy_context->provider_name = NULL;
    proxy_context->provider_publickey_s = NULL;
    proxy_context->resolver_ip = NULL;
    proxy_context->syslog = 0;
    proxy_context->syslog_prefix = NULL;
#ifndef _WIN32
    proxy_context->user_name = NULL;
    proxy_context->user_id = (uid_t) 0;
    proxy_context->user_group = (uid_t) 0;
    proxy_context->user_dir = NULL;
#endif
    proxy_context->daemonize = 0;
    proxy_context->test_cert_margin = (time_t) -1;
    proxy_context->test_only = 0;
    proxy_context->tcp_only = 0;
    proxy_context->ephemeral_keys = 0;
    proxy_context->ignore_timestamps = 0;
}

static int
options_check_protocol_versions(const char * const provider_name)
{
    const size_t dnscrypt_protocol_versions_len =
        sizeof DNSCRYPT_PROTOCOL_VERSIONS - (size_t) 1U;

    if (strncmp(provider_name, DNSCRYPT_PROTOCOL_VERSIONS,
                dnscrypt_protocol_versions_len) != 0 ||
        provider_name[dnscrypt_protocol_versions_len] != '.') {
        return -1;
    }
    return 0;
}

static char *
options_read_file(const char * const file_name)
{
    FILE   *fp;
    char   *file_buf;
    size_t  file_size = (size_t) 0U;

    assert(file_name != NULL);
    if ((fp = fopen(file_name, "rb")) == NULL) {
        return NULL;
    }
    while (fgetc(fp) != EOF && file_size < SIZE_MAX) {
        file_size++;
    }
    if (feof(fp) == 0 || file_size <= (size_t) 0U) {
        fclose(fp);
        return NULL;
    }
    rewind(fp);
    if ((file_buf = malloc(file_size + 1U)) == NULL) {
        fclose(fp);
        return NULL;
    }
    if (fread(file_buf, file_size, (size_t) 1U, fp) != 1U) {
        fclose(fp);
        free(file_buf);
        return NULL;
    }
    (void) fclose(fp);
    file_buf[file_size] = 0;

    return file_buf;
}

static const char *
options_get_col(char * const * const headers, const size_t headers_count,
                char * const * const cols, const size_t cols_count,
                const char * const header)
{
    size_t i = (size_t) 0U;

    while (i < headers_count) {
        if (strcmp(header, headers[i]) == 0) {
            if (i < cols_count) {
                return cols[i];
            }
            break;
        }
        i++;
    }
    return NULL;
}

static int
options_parse_candidate(ProxyContext * const proxy_context,
                        char * const * const headers, const size_t headers_count,
                        char * const * const cols, const size_t cols_count,
                        uint32_t * const candidate_count_p)
{
    const char *dnssec;
    const char *nologs;
    const char *resolver_ip;
    const char *resolver_name;

    resolver_name = options_get_col(headers, headers_count,
                                    cols, cols_count, "Name");
    if (resolver_name == NULL || *resolver_name == 0) {
        return -1;
    }
    nologs = options_get_col(headers, headers_count,
                             cols, cols_count, "No logs");
    if (nologs == NULL || evutil_ascii_strcasecmp(nologs, "no") == 0) {
        return 0;
    }
    dnssec = options_get_col(headers, headers_count,
                             cols, cols_count, "DNSSEC validation");
    if (dnssec == NULL || evutil_ascii_strcasecmp(dnssec, "no") == 0) {
        return 0;
    }
    resolver_ip = options_get_col(headers, headers_count,
                                  cols, cols_count, "Resolver address");
    if (*resolver_ip == '[') {
        return 0;
    }
    (*candidate_count_p)++;
    if (randombytes_uniform(*candidate_count_p) > 0U) {
        return 0;
    }
    free((void *) proxy_context->resolver_name);
    if ((proxy_context->resolver_name = strdup(resolver_name)) == NULL) {
        return -1;
    }
    return 1;
}

static int
options_parse_resolver(ProxyContext * const proxy_context,
                       char * const * const headers, const size_t headers_count,
                       char * const * const cols, const size_t cols_count)
{
    const char *dnssec;
    const char *namecoin;
    const char *nologs;
    const char *provider_name;
    const char *provider_publickey_s;
    const char *resolver_ip;
    const char *resolver_name;

    resolver_name = options_get_col(headers, headers_count,
                                    cols, cols_count, "Name");
    if (resolver_name == NULL) {
        logger(proxy_context, LOG_ERR,
               "Invalid resolvers list file: missing 'Name' column");
        exit(1);
    }
    if (*resolver_name == 0) {
        logger(proxy_context, LOG_ERR, "Resolver with an empty name");
        return -1;
    }
    if (evutil_ascii_strcasecmp(resolver_name,
                                proxy_context->resolver_name) != 0) {
        return 0;
    }
    provider_name = options_get_col(headers, headers_count,
                                    cols, cols_count, "Provider name");
    provider_publickey_s = options_get_col(headers, headers_count,
                                           cols, cols_count,
                                           "Provider public key");
    resolver_ip = options_get_col(headers, headers_count,
                                  cols, cols_count, "Resolver address");
    if (provider_name == NULL || *provider_name == 0) {
        logger(proxy_context, LOG_ERR,
               "Resolvers list is missing a provider name for [%s]",
               resolver_name);
        return -1;
    }
    if (provider_publickey_s == NULL || *provider_publickey_s == 0) {
        logger(proxy_context, LOG_ERR,
               "Resolvers list is missing a public key for [%s]",
               resolver_name);
        return -1;
    }
    if (resolver_ip == NULL || *resolver_ip == 0) {
        logger(proxy_context, LOG_ERR,
               "Resolvers list is missing a resolver address for [%s]",
               resolver_name);
        return -1;
    }
    dnssec = options_get_col(headers, headers_count,
                             cols, cols_count, "DNSSEC validation");
    if (dnssec != NULL && evutil_ascii_strcasecmp(dnssec, "yes") != 0) {
        logger(proxy_context, LOG_INFO,
               "- [%s] does not support DNS Security Extensions",
               resolver_name);
    } else {
        logger(proxy_context, LOG_INFO,
               "+ DNS Security Extensions are supported");
    }
    namecoin = options_get_col(headers, headers_count,
                               cols, cols_count, "Namecoin");
    if (namecoin != NULL && evutil_ascii_strcasecmp(namecoin, "yes") == 0) {
        logger(proxy_context, LOG_INFO,
               "+ Namecoin domains can be resolved");
    }
    nologs = options_get_col(headers, headers_count,
                             cols, cols_count, "No logs");
    if (nologs != NULL && evutil_ascii_strcasecmp(nologs, "no") == 0) {
        logger(proxy_context, LOG_WARNING,
               "- [%s] logs your activity - "
               "a different provider might be better a choice if privacy is a concern",
               resolver_name);
    } else {
        logger(proxy_context, LOG_INFO,
               "+ Provider supposedly doesn't keep logs");
    }

    proxy_context->provider_name = strdup(provider_name);
    proxy_context->provider_publickey_s = strdup(provider_publickey_s);
    if (proxy_context->resolver_ip == NULL) {
        proxy_context->resolver_ip = strdup(resolver_ip);
    } else {
        logger(proxy_context, LOG_INFO,
               "Resolver address forced to [%s]", proxy_context->resolver_ip);
    }
    if (proxy_context->provider_name == NULL ||
        proxy_context->provider_publickey_s == NULL ||
        proxy_context->resolver_ip == NULL) {
        logger_noformat(proxy_context, LOG_EMERG, "Out of memory");
        exit(1);
    }
    return 1;
}

static int
options_pick_random_resolver(ProxyContext * const proxy_context, const char *buf_)
{
    char     *buf;
    char     *buf_local;
    char     *cols[OPTIONS_RESOLVERS_LIST_MAX_COLS];
    char     *headers[OPTIONS_RESOLVERS_LIST_MAX_COLS];
    size_t    cols_count;
    size_t    headers_count;
    uint32_t  candidate_count = 0U;

    if ((buf_local = strdup(buf_)) == NULL) {
        return -1;
    }
    buf = minicsv_parse_line(buf_local, headers, &headers_count,
                             sizeof headers / sizeof headers[0]);
    if (headers_count < 4U || headers_count > OPTIONS_RESOLVERS_LIST_MAX_COLS) {
        free(buf_local);
        return -1;
    }
    do {
        buf = minicsv_parse_line(buf, cols, &cols_count,
                                 sizeof cols / sizeof cols[0]);
        if (cols_count < 4U || cols_count > OPTIONS_RESOLVERS_LIST_MAX_COLS) {
            continue;
        }
        minicsv_trim_cols(cols, cols_count);
        if (*cols[0] == 0 || *cols[0] == '#') {
            continue;
        }
        if (options_parse_candidate(proxy_context, headers, headers_count,
                                    cols, cols_count, &candidate_count) < 0) {
            free(buf_local);
            return -1;
        }
    } while (*buf != 0);
    free(buf_local);

    return 0;
}

static int
options_parse_resolvers_list(ProxyContext * const proxy_context, char *buf)
{
    char   *cols[OPTIONS_RESOLVERS_LIST_MAX_COLS];
    char   *headers[OPTIONS_RESOLVERS_LIST_MAX_COLS];
    size_t  cols_count;
    size_t  headers_count;

    assert(proxy_context->resolver_name != NULL);
    buf = minicsv_parse_line(buf, headers, &headers_count,
                             sizeof headers / sizeof headers[0]);
    if (headers_count < 4U || headers_count > OPTIONS_RESOLVERS_LIST_MAX_COLS) {
        return -1;
    }
    do {
        buf = minicsv_parse_line(buf, cols, &cols_count,
                                 sizeof cols / sizeof cols[0]);
        if (cols_count < 4U || cols_count > OPTIONS_RESOLVERS_LIST_MAX_COLS) {
            continue;
        }
        minicsv_trim_cols(cols, cols_count);
        if (*cols[0] == 0 || *cols[0] == '#') {
            continue;
        }
        if (options_parse_resolver(proxy_context, headers, headers_count,
                                   cols, cols_count) > 0) {
            return 0;
        }
    } while (*buf != 0);

    return -1;
}

static int
options_use_resolver_name(ProxyContext * const proxy_context)
{
    char *file_buf;
    char *resolvers_list_rebased;

    if ((resolvers_list_rebased =
         path_from_app_folder(proxy_context->resolvers_list)) == NULL) {
        logger_noformat(proxy_context, LOG_EMERG, "Out of memory");
        exit(1);
    }
    file_buf = options_read_file(resolvers_list_rebased);
    if (file_buf == NULL) {
        logger(proxy_context, LOG_ERR, "Unable to read [%s]",
               resolvers_list_rebased);
        exit(1);
    }
    if (evutil_ascii_strcasecmp(proxy_context->resolver_name,
                                OPTIONS_RESOLVERS_RANDOM) == 0) {
        free((void *) proxy_context->resolver_name);
        proxy_context->resolver_name = NULL;
        options_pick_random_resolver(proxy_context, file_buf);
        if (proxy_context->resolver_name == NULL) {
            logger_noformat(proxy_context, LOG_ERR,
                            "No suitable candidates found for a random selection");
            exit(1);
        }
        logger(proxy_context, LOG_INFO, "Randomly chosen resolver: [%s]",
               proxy_context->resolver_name);
    }
    assert(proxy_context->resolver_name != NULL);
    if (options_parse_resolvers_list(proxy_context, file_buf) < 0) {
        logger(proxy_context, LOG_ERR,
               "No resolver named [%s] found in the [%s] list",
               proxy_context->resolver_name, resolvers_list_rebased);
        exit(1);
    }
    free(file_buf);
    free(resolvers_list_rebased);

    return 0;
}

static int
options_use_client_key_file(ProxyContext * const proxy_context)
{
    unsigned char *key;
    char          *key_s;
    const size_t   header_len = (sizeof OPTIONS_CLIENT_KEY_HEADER) - 1U;
    size_t         key_s_len;

    if ((key_s = options_read_file(proxy_context->client_key_file)) == NULL) {
        logger_error(proxy_context, "Unable to read the client key file");
        return -1;
    }
    if ((key = sodium_malloc(header_len + crypto_box_SECRETKEYBYTES)) == NULL) {
        logger_noformat(proxy_context, LOG_EMERG, "Out of memory");
        free(key_s);
        return -1;
    }
    if (sodium_hex2bin(key, header_len + crypto_box_SECRETKEYBYTES,
                       key_s, strlen(key_s), ": -", &key_s_len, NULL) != 0 ||
        key_s_len < (header_len + crypto_box_SECRETKEYBYTES) ||
        memcmp(key, OPTIONS_CLIENT_KEY_HEADER, header_len) != 0) {
        logger_noformat(proxy_context, LOG_ERR,
                        "The client key file doesn't seem to contain a supported key format");
        sodium_free(key);
        free(key_s);
        return -1;
    }
    sodium_memzero(key_s, strlen(key_s));
    free(key_s);
    assert(sizeof proxy_context->dnscrypt_client.secretkey <=
           key_s_len - header_len);
    memcpy(proxy_context->dnscrypt_client.secretkey, key + header_len,
           sizeof proxy_context->dnscrypt_client.secretkey);
    sodium_free(key);

    return 0;
}

static int
options_apply(ProxyContext * const proxy_context)
{
    if (proxy_context->client_key_file != NULL) {
        if (proxy_context->ephemeral_keys != 0) {
            logger_noformat(proxy_context, LOG_ERR,
                            "--client-key and --ephemeral-keys are mutually exclusive");
            return -1;
        }
        if (options_use_client_key_file(proxy_context) != 0) {
            logger(proxy_context, LOG_ERR,
                   "Client key file [%s] could not be used", proxy_context->client_key_file);
            return -1;
        }
    }
    if (proxy_context->resolver_name != NULL) {
        if (proxy_context->resolvers_list == NULL) {
            logger_noformat(proxy_context, LOG_ERR,
                            "Resolvers list (-L command-line switch) required");
            return -1;
        }
        if (options_use_resolver_name(proxy_context) != 0) {
            logger(proxy_context, LOG_ERR,
                   "Resolver name (-R command-line switch) required. "
                   "See [%s] for a list of public resolvers.",
                   proxy_context->resolvers_list);
            return -1;
        }
    }
    if (proxy_context->resolver_ip == NULL ||
        *proxy_context->resolver_ip == 0 ||
        proxy_context->provider_name == NULL ||
        *proxy_context->provider_name == 0 ||
        proxy_context->provider_publickey_s == NULL ||
        *proxy_context->provider_publickey_s == 0) {
        logger_noformat(proxy_context, LOG_ERR,
                        "Error: no resolver name given, no configuration file either.");
        logger_noformat(proxy_context, LOG_ERR,
                        "The easiest way to get started is to edit the example configuration file");
        logger_noformat(proxy_context, LOG_ERR,
                        "and to append the full path to that file to the dnscrypt-proxy command.");
        logger_noformat(proxy_context, LOG_ERR,
                        "Example: dnscrypt-proxy /usr/local/etc/dnscrypt-proxy.conf");
        logger(proxy_context, LOG_ERR,
               "The local list of public resolvers is loaded from: [%s]",
               proxy_context->resolvers_list);
        logger_noformat(proxy_context, LOG_ERR,
                        "Consult https://dnscrypt.org for more information about dnscrypt-proxy.");
        return -1;
    }
    if (proxy_context->provider_name == NULL ||
        *proxy_context->provider_name == 0) {
        logger_noformat(proxy_context, LOG_ERR, "Provider name required");
        return -1;
    }
//    if (options_check_protocol_versions(proxy_context->provider_name) != 0) {
//        logger_noformat(proxy_context, LOG_ERR,
//                        "Unsupported server protocol version");
//        exit(1);
//    }
    if (proxy_context->provider_publickey_s == NULL) {
        logger_noformat(proxy_context, LOG_ERR, "Provider key required");
        return -1;
    }
    if (dnscrypt_fingerprint_to_key(proxy_context->provider_publickey_s,
                                    proxy_context->provider_publickey) != 0) {
        logger_noformat(proxy_context, LOG_ERR, "Invalid provider key");
        return -1;
    }
    if (proxy_context->daemonize != 0) {
        if (proxy_context->log_file == NULL) {
            proxy_context->syslog = 1;
        }
        do_daemonize();
    }
#ifndef _WIN32
    if (proxy_context->pid_file != NULL &&
        pid_file_create(proxy_context->pid_file,
                        proxy_context->user_id != (uid_t) 0) != 0) {
        logger_error(proxy_context, "Unable to create pid file");
        return -1;
    }
#endif
    if (proxy_context->log_file != NULL && proxy_context->syslog != 0) {
        logger_noformat(proxy_context, LOG_ERR,
                        "--logfile and --syslog are mutually exclusive");
        return -1;
    }
    if (proxy_context->log_file != NULL &&
        (proxy_context->log_fp = fopen(proxy_context->log_file, "a")) == NULL) {
        logger_error(proxy_context, "Unable to open log file");
        return -1;
    }
    if (proxy_context->syslog != 0) {
        assert(proxy_context->log_fp == NULL);
        logger_open_syslog(proxy_context);
    }
    return 0;
}

static SimpleConfSpecialHandlerResult
simpleconf_special_handler(void **output, const char *arg, void *user_data)
{
    char *file_name;

    if ((file_name = strdup(arg)) == NULL) {
        logger((ProxyContext *) user_data, LOG_EMERG, "Out of memory");
        exit(1);
    }
    *output = (void *) file_name;

    return SC_SPECIAL_HANDLER_RESULT_INCLUDE;
}

int
options_parse(AppContext * const app_context,
              ProxyContext * const proxy_context, int *argc_p, char ***argv_p)
{
    SimpleConfConfig  simpleconf_config = {
        proxy_context, simpleconf_special_handler
    };
    const char       *service_config_file = NULL;
    int               opt_flag;
    int               option_index = 0;
#ifdef _WIN32
    _Bool             option_install = 0;
#endif

    options_init_with_default(app_context, proxy_context);
    if (*argc_p == 2 && *(*argv_p)[1] != '-') {
        if (sc_build_command_line_from_file((*argv_p)[1], &simpleconf_config,
                                            simpleconf_options,
                                            (sizeof simpleconf_options) /
                                            (sizeof simpleconf_options[0]),
                                            *(argv_p)[0], argc_p, argv_p) != 0) {
            logger_noformat(proxy_context, LOG_ERR,
                            "Unable to read the configuration file");
            return -1;
        }
        app_context->allocated_args = 1;
    }
    while ((opt_flag = getopt_long(*argc_p, *argv_p,
                                   getopt_options, getopt_long_options,
                                   &option_index)) != -1) {
        switch (opt_flag) {
        case 'a':
            proxy_context->local_ip = optarg;
            break;
        case 'd':
            proxy_context->daemonize = 1;
            break;
        case 'e': {
            char *endptr;
            const unsigned long edns_payload_size = strtoul(optarg, &endptr, 10);

            if (*optarg == 0 || *endptr != 0 ||
                edns_payload_size > DNS_MAX_PACKET_SIZE_UDP_RECV) {
                logger(proxy_context, LOG_ERR,
                       "Invalid EDNS payload size: [%s]", optarg);
                exit(1);
            }
            if (edns_payload_size <= DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND) {
                proxy_context->edns_payload_size = (size_t) 0U;
                proxy_context->udp_max_size = DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND;
            } else {
                proxy_context->edns_payload_size = (size_t) edns_payload_size;
                assert(proxy_context->udp_max_size >=
                       DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND);
                if (proxy_context->edns_payload_size > DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND) {
                    proxy_context->udp_max_size =
                        proxy_context->edns_payload_size;
                }
            }
            break;
        }
        case 'E':
            proxy_context->ephemeral_keys = 1;
            break;
        case 'h':
            options_usage();
            exit(0);
        case 'I':
            proxy_context->ignore_timestamps = 1;
            break;
        case 'k':
            free((void *) proxy_context->provider_publickey_s);
            proxy_context->provider_publickey_s = strdup(optarg);
            break;
        case 'K':
            proxy_context->client_key_file = optarg;
            break;
        case 'l':
            proxy_context->log_file = optarg;
            break;
        case 'L':
            proxy_context->resolvers_list = optarg;
            break;
        case 'R':
            free((void *) proxy_context->resolver_name);
            proxy_context->resolver_name = strdup(optarg);
            break;
#ifndef _WIN32
        case 'S':
            proxy_context->syslog = 1;
            break;
        case 'Z':
            proxy_context->syslog_prefix = optarg;
            break;
#endif
        case 'm': {
            char *endptr;
            const long max_log_level = strtol(optarg, &endptr, 10);

            if (*optarg == 0 || *endptr != 0 || max_log_level < 0) {
                logger(proxy_context, LOG_ERR,
                       "Invalid max log level: [%s]", optarg);
                exit(1);
            }
            proxy_context->max_log_level = max_log_level;
            break;
        }
        case 'n': {
            char *endptr;
            const unsigned long connections_count_max =
                strtoul(optarg, &endptr, 10);

            if (*optarg == 0 || *endptr != 0 ||
                connections_count_max <= 0U ||
                connections_count_max > UINT_MAX) {
                logger(proxy_context, LOG_ERR,
                       "Invalid max number of active request: [%s]", optarg);
                exit(1);
            }
            proxy_context->connections_count_max =
                (unsigned int) connections_count_max;
            break;
        }
        case 'p':
            proxy_context->pid_file = optarg;
            break;
        case 'r':
            free((void *) proxy_context->resolver_ip);
            proxy_context->resolver_ip = strdup(optarg);
            break;
        case 't': {
            char *endptr;
            const unsigned long margin =
                strtoul(optarg, &endptr, 10);

            if (*optarg == 0 || *endptr != 0 ||
                margin > UINT32_MAX / 60U) {
                logger(proxy_context, LOG_ERR,
                       "Invalid certificate grace period: [%s]", optarg);
                exit(1);
            }
            proxy_context->test_cert_margin = (time_t) margin * (time_t) 60U;
            proxy_context->test_only = 1;
            break;
        }
#ifdef HAVE_GETPWNAM
        case 'u': {
            const struct passwd * const pw = getpwnam(optarg);
            if (pw == NULL) {
                logger(proxy_context, LOG_ERR, "Unknown user: [%s]", optarg);
                exit(1);
            }
            free((void *) proxy_context->user_name);
            proxy_context->user_name = strdup(pw->pw_name);
            proxy_context->user_id = pw->pw_uid;
            proxy_context->user_group = pw->pw_gid;
            free((void *) proxy_context->user_dir);
            proxy_context->user_dir = strdup(pw->pw_dir);
            break;
        }
#endif
        case 'N':
            free((void *) proxy_context->provider_name);
            proxy_context->provider_name = strdup(optarg);
            break;
        case 'T':
            proxy_context->tcp_only = 1;
            break;
        case 'V':
            options_version();
            exit(0);
        case 'X':
#ifndef PLUGINS
            logger_noformat(proxy_context, LOG_ERR,
                            "Support for plugins hasn't been compiled in");
            exit(1);
#else
            if (plugin_options_parse_str
                (proxy_context->app_context->dcps_context, optarg) != 0) {
                logger_noformat(proxy_context, LOG_ERR,
                                "Error while parsing plugin options");
                return -1;
            }
#endif
            break;
#ifdef _WIN32
        case WIN_OPTION_INSTALL:
        case WIN_OPTION_REINSTALL:
            option_install = 1;
            break;
        case WIN_OPTION_INSTALL_WITH_CONFIG_FILE:
        case WIN_OPTION_REINSTALL_WITH_CONFIG_FILE:
            option_install = 1;
            service_config_file = optarg;
            break;
        case WIN_OPTION_UNINSTALL:
            if (windows_service_uninstall() != 0) {
                logger_noformat(NULL, LOG_ERR, "Unable to uninstall the service");
                exit(1);
            } else {
                logger(NULL, LOG_INFO,
                       "The [%s] service has been removed from this system",
                       get_windows_service_name());
                exit(0);
            }
            break;
        case WIN_OPTION_SERVICE_NAME:
            break;
#endif
        default:
            options_usage();
            return -1;
        }
    }
    if (service_config_file == NULL && options_apply(proxy_context) != 0) {
        return -1;
    }
#ifdef _WIN32
    if (option_install != 0) {
        int ret;

        if (service_config_file != NULL) {
            ret = windows_service_install_with_config_file(proxy_context,
                                                           service_config_file);
        } else {
            ret = windows_service_install(proxy_context);
        }
        if (ret != 0) {
            logger_noformat(NULL, LOG_ERR, "Unable to install the service");
            logger_noformat(NULL, LOG_ERR,
                            "Make sure that you are using an elevated command prompt "
                            "and that the service hasn't been already installed");
            exit(1);
        }
        logger(NULL, LOG_INFO,
               "The [%s] service has been installed and started",
               get_windows_service_name());
        logger(NULL, LOG_INFO, "The registry key used for this "
               "service is [%s]", windows_service_registry_parameters_key());
        if (service_config_file == NULL) {
            logger(NULL, LOG_INFO, "Now, change your resolver settings to %s",
                   proxy_context->local_ip);
        } else {
            logger_noformat(NULL, LOG_INFO, "Now, change your resolver settings");
        }
        exit(0);
    }
#endif
    return 0;
}

void
options_free(ProxyContext * const proxy_context)
{
    (void) proxy_context;
#ifndef _WIN32
    free(proxy_context->user_name);
    proxy_context->user_name = NULL;
    free(proxy_context->user_dir);
    proxy_context->user_dir = NULL;
#endif
    free((void *) proxy_context->resolver_name);
    proxy_context->resolver_name = NULL;
    free((void *) proxy_context->provider_name);
    proxy_context->provider_name = NULL;
    free((void *) proxy_context->provider_publickey_s);
    proxy_context->provider_publickey_s = NULL;
    free((void *) proxy_context->resolver_ip);
    proxy_context->resolver_ip = NULL;
}
