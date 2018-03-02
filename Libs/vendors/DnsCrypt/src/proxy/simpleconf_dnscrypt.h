#ifndef __SIMPLECONF_DNSCRYPT_H__
#define __SIMPLECONF_DNSCRYPT_H__ 1

#include "simpleconf.h"

#define PLUGIN_LIB(X) LT_LIBPREFIX "dcplugin_example_" X LT_MODULE_EXT

static const SimpleConfEntry simpleconf_options[] = {
    {"ClientKey (<any*>)",                                    "--client-key=$0"},
    {"Daemonize? <bool>",                                     "--daemonize"},
    {"EDNSPayloadSize (<digits>)",                            "--edns-payload-size=$0"},
    {"EphemeralKeys? <bool>",                                 "--ephemeral-keys"},
    {"IgnoreTimestamps? <bool>",                              "--ignore-timestamps"},
    {"LocalAddress (<nospace>)",                              "--local-address=$0"},
    {"LogFile (<any*>)",                                      "--logfile=$0"},
    {"LogLevel (<digits>)",                                   "--loglevel=$0"},
    {"MaxActiveRequests (<digits>)",                          "--max-active-requests=$0"},
    {"PidFile (<any*>)",                                      "--pidfile=$0"},
    {"ProviderKey (<any>)",                                   "--provider-key=$0"},
    {"ProviderName (<any*>)",                                 "--provider-name=$0"},
    {"ResolverAddress (<nospace>)",                           "--resolver-address=$0"},
    {"ResolverName (<nospace>)",                              "--resolver-name=$0"},
    {"ResolversList (<any*>)",                                "--resolvers-list=$0"},
    {"SyslogPrefix (<nospace>)",                              "--syslog-prefix=$0"},
    {"Syslog? <bool>",                                        "--syslog"},
    {"TCPOnly? <bool>",                                       "--tcp-only"},
    {"Test (<digits>)",                                       "--test=$0"},
    {"User (<nospace>)",                                      "--user=$0"},
    {"BlackList domains:(<any>) logfile:(<any>)",             "--plugin=" PLUGIN_LIB("ldns_blocking") ",--domains=$0,--logfile=$1" },
    {"BlackList ips:(<any>) logfile:(<any>)",                 "--plugin=" PLUGIN_LIB("ldns_blocking") ",--ips=$0,--logfile=$1" },
    {"BlackList domains:(<any>) ips:(<any>) logfile:(<any>)", "--plugin=" PLUGIN_LIB("ldns_blocking") ",--domains=$0,--ips=$1,--logfile=$2" },
    {"BlackList domains:(<any>)",                             "--plugin=" PLUGIN_LIB("ldns_blocking") ",--domains=$0" },
    {"BlackList ips:(<any>)",                                 "--plugin=" PLUGIN_LIB("ldns_blocking") ",--ips=$0" },
    {"BlackList domains:(<any>) ips:(<any>)",                 "--plugin=" PLUGIN_LIB("ldns_blocking") ",--domains=$0,--ips=$1" },
    {"BlockIPv6? <bool>",                                     "--plugin=" PLUGIN_LIB("ldns_aaaa_blocking") },
    {"QueryLogFile (<any*>)",                                 "--plugin=" PLUGIN_LIB("logging") ",$0" },
    {"Forward domains:(<any>) to:(<any>)",                    "--plugin=" PLUGIN_LIB("ldns_forwarding") ",--domains=$0,--resolvers=$1" },
    {"LocalCache? <bool> min-ttl:(<digits>)",                 "--plugin=" PLUGIN_LIB("cache") ",--min-ttl=$0" },
    {"LocalCache? <bool>",                                    "--plugin=" PLUGIN_LIB("cache") },
    {"OpenDNSIP (<nospace>)",                                 "--plugin=" PLUGIN_LIB("ldns_opendns_set_client_ip") ",$0" },
    {"OpenDNSPasswordFile (<any*>)",                          "--plugin=" PLUGIN_LIB("ldns_opendns_deviceid") ",$0" },
    {"Plugin (<any*>)",                                       "--plugin=$0" },

    {"!Include (<any*>)",                                     "$0"}
};

#endif
