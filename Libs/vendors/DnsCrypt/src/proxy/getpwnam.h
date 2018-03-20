
#ifndef __GETPWNAM_H__
#define __GETPWNAM_H__ 1

#include <config.h>
#include <sys/types.h>

#ifdef HAVE_PWD_H
# include <pwd.h>
# ifdef HAVE_UUID_UUID_H
#  include <uuid/uuid.h>
# endif

#elif defined(HAVE_GETPWNAM)

# include <time.h>
# ifdef HAVE_UUID_UUID_H
#  include <uuid/uuid.h>
# endif

struct passwd {
    char   *pw_name;
    char   *pw_passwd;
    uid_t   pw_uid;
    gid_t   pw_gid;
    time_t  pw_change;
    char   *pw_class;
    char   *pw_gecos;
    char   *pw_dir;
    char   *pw_shell;
    time_t  pw_expire;
};
struct passwd *getpwnam(const char *);

#endif

#endif
