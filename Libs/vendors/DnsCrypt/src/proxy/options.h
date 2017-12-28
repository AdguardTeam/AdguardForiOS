
#ifndef __OPTIONS_H__
#define __OPTIONS_H__ 1

int options_parse(AppContext * const app_context,
                  ProxyContext * const proxy_context, int *argc_p, char ***argv_p);

void options_free(ProxyContext * const proxy_context);

#define OPTIONS_RESOLVERS_LIST_MAX_COLS 50
#define OPTIONS_RESOLVERS_RANDOM "random"
#define OPTIONS_CLIENT_KEY_HEADER "\01\01"

#endif
