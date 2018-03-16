
#include <config.h>
#ifdef HAVE_SYS_CDEFS_H
# include <sys/cdefs.h>
#elif defined(HAVE_SYS_FEATURE_TESTS_H)
# include <sys/feature_tests.h>
#else
# include <sys/types.h>
#endif
#if !defined(_XOPEN_SOURCE) || _XOPEN_SOURCE < 500
# undef _XOPEN_SOURCE
# define _XOPEN_SOURCE 500
#endif
#ifndef _GNU_SOURCE
# define _GNU_SOURCE   1
#endif
#if !defined(HAVE_SYS_CDEFS_H) && !defined(HAVE_SYS_FEATURE_TESTS_H)
# include <sys/types.h>
#endif

#ifndef _WIN32
# include <dlfcn.h>
#endif
#ifdef HAVE_EXECINFO_H
# include <execinfo.h>
#endif
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "stack_trace.h"

#if defined(__OpenBSD__) || defined(__Bitrig__)
# undef HAVE_BACKTRACE
#endif

void
stack_trace(void)
{
#ifndef HAVE_BACKTRACE
    fputs("This platform doesn't support backtrace() yet.\n", stderr);
#else
    void  *trace[100];
    char **messages = NULL;
    int    i;
    int    trace_size = 0;

    trace_size = backtrace(trace, sizeof(trace) / sizeof(trace[0]));
    messages   = backtrace_symbols(trace, trace_size);
    fprintf(stderr, "======== Stack trace ========\n");
    for (i = 1; i < trace_size; ++i) {
        fprintf(stderr, "%s\n", messages[i]);
    }
#endif
}

#ifdef HAVE_BACKTRACE
static void
stack_trace_signal_handler(int sig, siginfo_t *info, void *f) {
    (void) info;
    (void) f;
    fprintf(stderr, "\nSignal [%d] received.\n\n", sig);
    stack_trace();
    kill(getpid(), sig);
    abort();
    /* NOTREACHED */
}
#endif

int
stack_trace_on_crash(void)
{
#ifdef HAVE_BACKTRACE
    struct sigaction act;

    sigemptyset(&act.sa_mask);
    act.sa_flags     = SA_NODEFER | SA_ONSTACK | SA_RESETHAND | SA_SIGINFO;
    act.sa_sigaction = stack_trace_signal_handler;
    sigaction(SIGABRT, &act, NULL);
    sigaction(SIGBUS,  &act, NULL);
    sigaction(SIGFPE,  &act, NULL);
# ifdef SIGILL
    sigaction(SIGILL,  &act, NULL);
# endif
    sigaction(SIGSEGV, &act, NULL);
#endif

    return 0;
}

#ifdef GCC_TRACE
# ifndef __APPLE__
#  define profile_func_enter(A, B) __cyg_profile_func_enter(A, B)
#  define profile_func_exit(A, B)  __cyg_profile_func_exit(A, B)
# endif

static unsigned int call_level = 0U;

void
profile_func_enter(void *this_fn, void *call_site)
__attribute__((no_instrument_function));

void profile_func_enter(void *this_fn, void *call_site)
{
    unsigned int level = 0U;

    (void) call_site;
    ++call_level;
    Dl_info info;
    this_fn = __builtin_return_address(0);
    if (dladdr(this_fn, &info) == 0) {
        return;
    }
    if (info.dli_sname != NULL &&
        info.dli_sname[0] == '_' && info.dli_sname[1] == '_') {
        return;
    }
    while (level < call_level) {
        fputs("┃ ", stderr);
        level++;
    }
    fputs("┣━━┈", stderr);
    if (info.dli_sname != NULL && info.dli_sname[0] != 0) {
        fprintf(stderr, "%s()\n", info.dli_sname);
    } else {
        fprintf(stderr, "<%p>()\n", this_fn);
    }
}

void
profile_func_exit(void *this_fn, void *call_site)
__attribute__((no_instrument_function));

void
profile_func_exit(void *this_fn, void *call_site)
{
    (void) this_fn;
    (void) call_site;
    if (call_level > 0U) {
        call_level--;
    }
}
#endif
