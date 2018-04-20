/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © 2015-2017 Performix LLC. All rights reserved.
 
    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
 
    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
 
    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "APDnscryptService.h"
#import "ACLLogger.h"

#include "dnscrypt_proxy.h"
#include "udp_request.h"
#include "tcp_request.h"
#include "thread.h"
#include "simpleconf.h"
#include "options.h"
#include "logger.h"

@interface APDnscryptService() {

    NSString* _ip;
    NSString* _port;
    dispatch_queue_t _dnsCryptDispatchQueue;
    void (^_dnsCryptEndBlock)();
}
@end

@implementation APDnscryptService

- (instancetype)initWithIp:(NSString*)ip port:(NSString *)port {
    
    self = [super init];
    
    if(self) {
        _ip = ip;
        _port = port;
        
        _dnsCryptDispatchQueue = dispatch_queue_create("dns_crypt_queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}


- (BOOL)startWithRemoteServer:(APDnsServerObject *)server completionBlock:(void (^)())completionBlock {

    dispatch_async(_dnsCryptDispatchQueue, ^{

        NSString* localAddress = [NSString stringWithFormat:@"%@:%@", _ip, _port];

        const char* argv[] = { "proxy",
            "--local-address", localAddress.UTF8String,
            "--provider-name", server.dnsCryptProviderName.UTF8String,
            "--provider-key", server.dnsCryptProviderPublicKey.UTF8String,
            "--resolver-address", server.dnsCryptResolverAddress.UTF8String,
        };

        int argc = 9;

        NSMutableString* args = [NSMutableString new];

        for(int i = 0; i < argc; ++i) {

            [args appendFormat:@"%s ", (char*) argv[i]];
        }

        DDLogInfo(@"(PacketTunnelProvider) start dns crypt proxy with args: %@", args);

        //if(dnscrypt_proxy_main(argc, (char **)argv) != 0) {
        if([self dnscrypt_proxy_main:argc argv:(char**)argv completionBlock:^{
            if(completionBlock)
                completionBlock();
        }] != 0) {

            DDLogError(@"(PacketTunnelProvider) can't start dns crypt proxy");
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            if(_dnsCryptEndBlock) {
                _dnsCryptEndBlock();

                _dnsCryptEndBlock = nil;
            }
        });
    });
    
    return YES;
}


- (BOOL)stopWithCompletionBlock:(void (^)())completionBlock {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        _dnsCryptEndBlock = ^void() {

            if(completionBlock) {
                completionBlock();
            }
        };

        dnscrypt_proxy_loop_break();
    });
    
    return YES;
}


/**
 The functions below are a modified copy of the functions from app.c file from dnscrypt sources
 */
#pragma mark modified dnscrypt functions

static AppContext            app_context;
static volatile sig_atomic_t skip_dispatch;

/**
 We add completion block to dnscrypt_proxy_main() function and transform it to method.
 completionBlock called in main thread after initialization is completed
 */
- (int) dnscrypt_proxy_main:(int) argc argv:(char *[]) argv completionBlock:(void (^)())completionBlock {
    
    ProxyContext  proxy_context;
    struct event *sigint_event;
    struct event *sigterm_event;
#ifdef SIGHUP
    struct event *sighup_event;
#endif
    
    setvbuf(stdout, NULL, _IOLBF, BUFSIZ);
    if (sodium_init() < 0) {
        return -1;
    }
    app_context.allocated_args = 0;

    if (proxy_context_init(&proxy_context, &argc, &argv) != 0) {
        DDLogError(@"Unable to start dnscrypt proxy");
        return -1;
    }
    sodium_mlock(&proxy_context, sizeof proxy_context);
    randombytes_set_implementation(&randombytes_salsa20_implementation);
    
    app_context.proxy_context = &proxy_context;
    proxy_context.dnscrypt_client.ephemeral_keys =
    proxy_context.ephemeral_keys;
    if (proxy_context.dnscrypt_client.ephemeral_keys != 0) {
        dnscrypt_client_init_with_new_session_key(&proxy_context.dnscrypt_client);
    } else if (proxy_context.client_key_file != NULL) {
        dnscrypt_client_init_with_client_key(&proxy_context.dnscrypt_client);
    } else {
        dnscrypt_client_init_with_new_key_pair(&proxy_context.dnscrypt_client);
    }
    
    if (cert_updater_init(&proxy_context) != 0) {
        return -1;
    }

    if (proxy_context.test_only == 0 &&
        (udp_listener_bind(&proxy_context) != 0 ||
         tcp_listener_bind(&proxy_context) != 0)) {
            return -1;
        }
#ifdef SIGPIPE
    signal(SIGPIPE, SIG_IGN);
#endif
    
    revoke_privileges(&proxy_context);
    if (cert_updater_start(&proxy_context) != 0) {
        return -1;
    }
    
    sigint_event  = evsignal_new(proxy_context.event_loop, SIGINT,
                                 sigterm_cb, &proxy_context);
    sigterm_event = evsignal_new(proxy_context.event_loop, SIGTERM,
                                 sigterm_cb, &proxy_context);
    if (sigint_event  == NULL || event_add(sigint_event,  NULL) != 0 ||
        sigterm_event == NULL || event_add(sigterm_event, NULL) != 0) {
        return -1;
    }
#ifdef SIGHUP
    sighup_event = evsignal_new(proxy_context.event_loop, SIGHUP,
                                sighup_cb, &proxy_context);
    if (sighup_event  == NULL || event_add(sighup_event,  NULL) != 0) {
        return -1;
    }
#endif
#ifdef HAVE_LIBSYSTEMD
    sd_notifyf(0, "MAINPID=%lu", (unsigned long) getpid());
#endif
    
    // this modification was made for AdGuard ====================================
    // dnscrypt_proxy_loop_break does not stop dnscrypt while the tunnel is stopped without these changes
    if(evthread_make_base_notifiable(proxy_context.event_loop)) {
        return -1;
    }
    // ===========================================================================
    
    // this modification was made for AdGuard ====================================
    // add completionBlock call
    if(completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    }
    // ===========================================================================
    
    // start event loop
    if (skip_dispatch == 0) {
        event_base_dispatch(proxy_context.event_loop);
    }
    
    // stop proxy
    DDLogInfo(@"Stopping proxy");
    
    cert_updater_free(&proxy_context);
    udp_listener_stop(&proxy_context);
    tcp_listener_stop(&proxy_context);
    event_free(sigint_event);
    event_free(sigterm_event);
#ifdef SIGHUP
    event_free(sighup_event);
#endif
    event_base_free(proxy_context.event_loop);
#ifdef PLUGINS
    plugin_support_context_free(app_context.dcps_context);
#endif
    proxy_context_free(&proxy_context);
    sodium_munlock(&proxy_context, sizeof proxy_context);
    app_context.proxy_context = NULL;
    randombytes_close();
    if (app_context.allocated_args != 0) {
        sc_argv_free(argc, argv);
    }
    return 0;
}

static int
proxy_context_init(ProxyContext * const proxy_context, int *argc_p, char ***argv_p)
{
    memset(proxy_context, 0, sizeof *proxy_context);
    proxy_context->event_loop = NULL;
    proxy_context->log_file = NULL;
    proxy_context->max_log_level = LOG_INFO;
    proxy_context->tcp_accept_timer = NULL;
    proxy_context->tcp_conn_listener = NULL;
    proxy_context->udp_current_max_size = DNS_MAX_PACKET_SIZE_UDP_NO_EDNS_SEND;
    proxy_context->udp_max_size = (size_t) DNS_DEFAULT_EDNS_PAYLOAD_SIZE;
    proxy_context->udp_listener_event = NULL;
    proxy_context->udp_proxy_resolver_event = NULL;
    proxy_context->udp_proxy_resolver_handle = -1;
    proxy_context->udp_listener_handle = -1;
    proxy_context->tcp_listener_handle = -1;
    sodium_mlock(&proxy_context->dnscrypt_client,
                 sizeof proxy_context->dnscrypt_client);
    if (options_parse(&app_context, proxy_context, argc_p, argv_p) != 0) {
        return -1;
    }
#ifdef _WIN32
    WSADATA wsa_data;
    WSAStartup(MAKEWORD(2, 2), &wsa_data);
#endif
    if ((proxy_context->event_loop = event_base_new()) == NULL) {
        logger(NULL, LOG_ERR, "Unable to initialize the event loop");
        return -1;
    }
    if (sockaddr_from_ip_and_port(&proxy_context->resolver_sockaddr,
                                  &proxy_context->resolver_sockaddr_len,
                                  proxy_context->resolver_ip,
                                  DNS_DEFAULT_RESOLVER_PORT,
                                  "Unsupported resolver address") != 0) {
        return -1;
    }
    if (sockaddr_from_ip_and_port(&proxy_context->local_sockaddr,
                                  &proxy_context->local_sockaddr_len,
                                  proxy_context->local_ip,
                                  DNS_DEFAULT_LOCAL_PORT,
                                  "Unsupported local address") != 0) {
        return -1;
    }
    return 0;
}

static void
proxy_context_free(ProxyContext * const proxy_context)
{
    if (proxy_context == NULL) {
        return;
    }
    options_free(proxy_context);
    logger_close(proxy_context);
}

static void
revoke_privileges(ProxyContext * const proxy_context)
{
    (void) proxy_context;
    
    init_locale();
    init_tz();
    (void) strerror(ENOENT);
#ifndef DEBUG
    randombytes_stir();
# ifndef _WIN32
    if (proxy_context->user_dir != NULL) {
        if (chdir(proxy_context->user_dir) != 0 ||
            chroot(proxy_context->user_dir) != 0 || chdir("/") != 0) {
            logger(proxy_context, LOG_ERR, "Unable to chroot to [%s]",
                   proxy_context->user_dir);
            exit(1);
        }
    }
    if (sandboxes_app() != 0) {
        logger_noformat(proxy_context, LOG_ERR,
                        "Unable to sandbox the main process");
        exit(1);
    }
    if (proxy_context->user_id != (uid_t) 0) {
#  ifdef HAVE_INITGROUPS
        if (initgroups(proxy_context->user_name,
                       proxy_context->user_group) != 0) {
            logger(proxy_context, LOG_ERR, "Unable to initialize groups for user [%s]",
                   proxy_context->user_name);
            exit(1);
        }
#  endif
        if (setgid(proxy_context->user_group) != 0 ||
            setegid(proxy_context->user_group) != 0 ||
            setuid(proxy_context->user_id) != 0 ||
            seteuid(proxy_context->user_id) != 0) {
            logger(proxy_context, LOG_ERR, "Unable to switch to user id [%lu]",
                   (unsigned long) proxy_context->user_id);
            exit(1);
        }
    }
# endif
#endif
}

static void
sigterm_cb(evutil_socket_t sig, short events, void *fodder)
{
    (void) events; (void) fodder; (void) sig;
    dnscrypt_proxy_loop_break();
}

#ifdef SIGHUP
static void
sighup_cb(evutil_socket_t sig, short events, void *fodder)
{
    (void) events; (void) fodder; (void) sig;
# ifdef PLUGINS
    (void) plugin_support_context_reload(app_context.dcps_context);
# endif
}
#endif

static int
sockaddr_from_ip_and_port(struct sockaddr_storage * const sockaddr,
                          ev_socklen_t * const sockaddr_len_p,
                          const char * const ip, const char * const port,
                          const char * const error_msg)
{
    char   sockaddr_port[INET6_ADDRSTRLEN + sizeof "[]:65535"];
    int    sockaddr_len_int;
    char  *pnt;
    _Bool  has_column = 0;
    _Bool  has_columns = 0;
    _Bool  has_brackets = *ip == '[';
    
    if ((pnt = strchr(ip, ':')) != NULL) {
        has_column = 1;
        if (strchr(pnt + 1, ':') != NULL) {
            has_columns = 1;
        }
    }
    sockaddr_len_int = (int) sizeof *sockaddr;
    if ((has_brackets != 0 || has_column != has_columns) &&
        evutil_parse_sockaddr_port(ip, (struct sockaddr *) sockaddr,
                                   &sockaddr_len_int) == 0) {
            *sockaddr_len_p = (ev_socklen_t) sockaddr_len_int;
            return 0;
        }
    if (has_columns != 0 && has_brackets == 0) {
        evutil_snprintf(sockaddr_port, sizeof sockaddr_port, "[%s]:%s",
                        ip, port);
    } else {
        evutil_snprintf(sockaddr_port, sizeof sockaddr_port, "%s:%s",
                        ip, port);
    }
    sockaddr_len_int = (int) sizeof *sockaddr;
    if (evutil_parse_sockaddr_port(sockaddr_port, (struct sockaddr *) sockaddr,
                                   &sockaddr_len_int) != 0) {
        logger(NULL, LOG_ERR, "%s: %s", error_msg, sockaddr_port);
        *sockaddr_len_p = (ev_socklen_t) 0U;
        
        return -1;
    }
    *sockaddr_len_p = (ev_socklen_t) sockaddr_len_int;
    
    return 0;
}

static int
init_locale(void)
{
    setlocale(LC_CTYPE, "C");
    setlocale(LC_COLLATE, "C");
    
    return 0;
}

static int
init_tz(void)
{
    static char  default_tz_for_putenv[] = "TZ=UTC+00:00";
    char         stbuf[10U];
    struct tm   *tm;
    time_t       now;
    
    tzset();
    time(&now);
    if ((tm = localtime(&now)) != NULL &&
        strftime(stbuf, sizeof stbuf, "%z", tm) == (size_t) 5U) {
        evutil_snprintf(default_tz_for_putenv, sizeof default_tz_for_putenv,
                        "TZ=UTC%c%c%c:%c%c", (*stbuf == '-' ? '+' : '-'),
                        stbuf[1], stbuf[2], stbuf[3], stbuf[4]);
    }
    putenv(default_tz_for_putenv);
    (void) localtime(&now);
    (void) gmtime(&now);
    
    return 0;
}

int
dnscrypt_proxy_loop_break(void)
{
    if (app_context.proxy_context != NULL &&
        app_context.proxy_context->event_loop != NULL) {
        event_base_loopbreak(app_context.proxy_context->event_loop);
    } else {
        skip_dispatch = 1;
    }
    return 0;
}

int
dnscrypt_proxy_start_listeners(ProxyContext * const proxy_context)
{
    char local_addr_s[INET6_ADDRSTRLEN + sizeof "[]:65535"];
    char resolver_addr_s[INET6_ADDRSTRLEN + sizeof "[]:65535"];
    
    if (proxy_context->listeners_started != 0) {
        return 0;
    }
    if (udp_listener_start(proxy_context) != 0 ||
        tcp_listener_start(proxy_context) != 0) {
        exit(1);
    }
    evutil_format_sockaddr_port((const struct sockaddr *)
                                &proxy_context->local_sockaddr,
                                local_addr_s, sizeof local_addr_s);
    evutil_format_sockaddr_port((const struct sockaddr *)
                                &proxy_context->resolver_sockaddr,
                                resolver_addr_s, sizeof resolver_addr_s);
    logger(proxy_context, LOG_NOTICE, "Proxying from %s to %s",
           local_addr_s, resolver_addr_s);
    proxy_context->listeners_started = 1;
    systemd_notify(proxy_context, "READY=1");
    return 0;
}

@end
