
#include <config.h>
#include <sys/types.h>
#ifndef _WIN32
# include <sys/wait.h>
#endif

#include <assert.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <event2/util.h>

#include "logger.h"
#include "pid_file.h"
#include "safe_rw.h"
#include "sandboxes.h"
#include "utils.h"

#ifndef _WIN32

static volatile sig_atomic_t  exit_requested;
static pid_t                  _child = (pid_t) -1;
static const char            *_pid_file;

static void
pid_file_remove_pid_file(void)
{
    if (_pid_file != NULL) {
        unlink(_pid_file);
        _pid_file = NULL;
    }
}

static void
pid_file_wait_for_app(void)
{
    if (_child != (pid_t) -1) {
        while (waitpid(_child, NULL, 0) > (pid_t) 0);
        _child = (pid_t) -1;
    }
    pid_file_remove_pid_file();
}

static void
pid_file_parent_sig_exit_handler(int sig)
{
    (void) sig;
    if (exit_requested) {
        return;
    }
    exit_requested = 1;
    if (_child != (pid_t) -1) {
        kill(SIGTERM, _child);
    }
}

static void
pid_file_sig_exit_handler(int sig)
{
    (void) sig;
    if (exit_requested) {
        return;
    }
    exit_requested = 1;
    exit(0);
}

static void
pid_file_atexit_handler(void)
{
    pid_file_remove_pid_file();
}

static void
pid_file_install_signal_handlers(void (*handler) (int))
{
    signal(SIGPIPE, SIG_IGN);
    signal(SIGALRM, handler);
    signal(SIGHUP , handler);
    signal(SIGINT,  handler);
    signal(SIGQUIT, handler);
    signal(SIGTERM, handler);
#ifdef SIGXCPU
    signal(SIGXCPU, handler);
#endif
}

static int
pid_file_write(const int fd, const pid_t child)
{
    char pid_buf[50U];
    int  pid_buf_len;

    pid_buf_len = evutil_snprintf(pid_buf, sizeof pid_buf, "%llu",
                                  (unsigned long long) child);
    assert((size_t) pid_buf_len < sizeof pid_buf);
    if (safe_write(fd, pid_buf, (size_t) pid_buf_len, -1) !=
        (ssize_t) pid_buf_len) {
        (void) ftruncate(fd, (off_t) 0);
        (void) close(fd);
        return -1;
    }
    return close(fd);
}

static void
pid_file_write_and_wait_for_app(const int fd, const pid_t child)
{
    _child = child;
    pid_file_write(fd, child);
    closedesc_all(1);
    pid_file_wait_for_app();
}

static int
pid_file_create_for_chroot(const int fd)
{
    pid_t child;

    child = fork();
    if (child == (pid_t) -1) {
        (void) close(fd);
        return -1;
    }
    if (child == (pid_t) 0) {
        (void) close(fd);
        return 0;
    }
    if (sandboxes_pidproc() != 0) {
        _exit(1);
    }
    pid_file_install_signal_handlers(pid_file_parent_sig_exit_handler);
    pid_file_write_and_wait_for_app(fd, child);
    _exit(0);

/* NOTREACHED */

    return -2;
}

int
pid_file_create(const char * const pid_file, const _Bool will_chroot)
{
    int fd;

    _pid_file = pid_file;
    if ((fd = open(pid_file, O_CREAT | O_TRUNC | O_WRONLY, 0644)) == -1) {
        return -1;
    }
    if (will_chroot != 0) {
        return pid_file_create_for_chroot(fd);
    }
    atexit(pid_file_atexit_handler);
    pid_file_install_signal_handlers(pid_file_sig_exit_handler);
    if (pid_file_write(fd, getpid()) != 0) {
        _pid_file = NULL;
        unlink(pid_file);
        return -1;
    }
    return 0;
}

#else /* _WIN32 */

int
pid_file_create(const char * const pid_file, const _Bool will_chroot)
{
    (void) pid_file;
    (void) will_chroot;

    return 0;
}

#endif
