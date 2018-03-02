
#include <config.h>
#include <sys/types.h>
#include <sys/time.h>

#include <assert.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <event2/util.h>

#include "logger.h"
#include "pathnames.h"
#include "utils.h"

uint64_t
dnscrypt_hrtime(void)
{
    struct timeval tv;
    uint64_t       ts = (uint64_t) 0U;
    int            ret;

    ret = evutil_gettimeofday(&tv, NULL);
    assert(ret == 0);
    if (ret == 0) {
        ts = (uint64_t) tv.tv_sec * 1000000U + (uint64_t) tv.tv_usec;
    }
    return ts;
}

#ifndef _WIN32
static unsigned int
open_max(void)
{
    long z;

    if ((z = (long) sysconf(_SC_OPEN_MAX)) < 0L) {
        logger_error(NULL, "_SC_OPEN_MAX");
        return 2U;
    }
    return (unsigned int) z;
}

int
closedesc_all(const int closestdin)
{
    int fodder;

    if (closestdin != 0) {
        (void) close(0);
        if ((fodder = open(_PATH_DEVNULL, O_RDONLY)) == -1) {
            return -1;
        }
        (void) dup2(fodder, 0);
        if (fodder > 0) {
            (void) close(fodder);
        }
    }
    if ((fodder = open(_PATH_DEVNULL, O_WRONLY)) == -1) {
        return -1;
    }
    (void) dup2(fodder, 1);
    (void) dup2(1, 2);
    if (fodder > 2) {
        (void) close(fodder);
    }

    return 0;
}

int
do_daemonize(void)
{
    pid_t        child;
    unsigned int i;

    if ((child = fork()) == (pid_t) -1) {
        logger_error(NULL, "Unable to fork() in order to daemonize");
        return -1;
    } else if (child != (pid_t) 0) {
        _exit(0);
    }
    if (setsid() == (pid_t) -1) {
        logger_error(NULL, "Unable to setsid()");
    }
    i = open_max();
    do {
        if (isatty((int) i)) {
            (void) close((int) i);
        }
        i--;
    } while (i > 2U);
    if (closedesc_all(1) != 0) {
        logger_error(NULL, _PATH_DEVNULL " duplication");
        return -1;
    }
    return 0;
}

#else /* _WIN32 */

int
closedesc_all(const int closestdin)
{
    (void) closestdin;
    return 0;
}

int
do_daemonize(void)
{
    return 0;
}

#endif

#ifndef _WIN32
char *
path_from_app_folder(const char *file_name)
{
    assert(file_name != NULL);

    return strdup(file_name);
}
#else
char *
path_from_app_folder(const char *file_name)
{
    WCHAR       utf16_buf[16383 + 1];
    char        utf8_buf[65535 + 1];
    char       *utf8_buf_copy;
    char       *chr_revpathsep;
    const char *chr_column;
    const char *chr_pathsep;
    size_t      utf8_buf_copy_len;
    DWORD       utf16_buf_len = (DWORD) sizeof utf16_buf;
    int         utf8_buf_len = (int) sizeof utf8_buf;

    assert(file_name != NULL);
    if (((chr_pathsep = strchr(file_name, '/')) != NULL ||
         (chr_pathsep = strchr(file_name, '\\')) != NULL) &&
        (chr_pathsep == file_name ||
         ((chr_column = strchr(file_name, ':')) != NULL &&
           chr_column - file_name < chr_pathsep - file_name))) {
        return strdup(file_name);
    }
    if ((utf16_buf_len =
         GetModuleFileNameW(NULL, utf16_buf, utf16_buf_len - 1)) <= (DWORD) 0) {
        return NULL;
    }
    utf16_buf[utf16_buf_len] = (WCHAR) 0;
    utf8_buf_len = WideCharToMultiByte(CP_UTF8, 0, utf16_buf, -1, utf8_buf,
                                       utf8_buf_len, NULL, NULL);
    if (utf8_buf_len <= 0) {
        return NULL;
    }
    assert(utf8_buf[utf8_buf_len - 1] == 0);
    if ((chr_revpathsep = strrchr(utf8_buf, '/')) == NULL &&
        (chr_revpathsep = strrchr(utf8_buf, '\\')) == NULL) {
        return strdup(file_name);
    }
    *(chr_revpathsep + 1U) = 0;
    utf8_buf_copy_len = strlen(utf8_buf) + strlen(file_name) + (size_t) 1U;
    if ((utf8_buf_copy = malloc(utf8_buf_copy_len)) == NULL) {
        return NULL;
    }
    evutil_snprintf(utf8_buf_copy, utf8_buf_copy_len, "%s%s",
                    utf8_buf, file_name);

    return utf8_buf_copy;
}
#endif
