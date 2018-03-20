
#include <config.h>
#include <sys/types.h>

#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#ifndef _WIN32
# include <syslog.h>
#endif
#include <stdarg.h>
#include <time.h>
#include <unistd.h>

#ifdef HAVE_LIBSYSTEMD
# include <sys/socket.h>
# include <systemd/sd-daemon.h>
#endif

#include <event2/util.h>

#include "dnscrypt_proxy.h"
#include "logger.h"
#include "safe_rw.h"

int
logger_open_syslog(struct ProxyContext_ * const context)
{
    assert(context->syslog != 0);
#ifndef _WIN32
    openlog(PACKAGE_TARNAME, LOG_NDELAY | LOG_PID, LOG_DAEMON);
#endif
    return 0;
}

static int
timestamp_fprint(FILE * const fp)
{
    char now_s[128];

    time_t     now;
    struct tm *tm;

    if (time(&now) == (time_t) -1) {
        fprintf(fp, "- ");
        return -1;
    }
    tm = localtime(&now);
    strftime(now_s, sizeof now_s, "%c", tm);
    fprintf(fp, "%s ", now_s);

    return 0;
}

int
logger(struct ProxyContext_ * const context,
       const int crit, const char * const format, ...)
{
    static char         previous_line[MAX_LOG_LINE];
    static time_t       last_log_ts = (time_t) 0;
    static unsigned int burst_counter = 0U;
    char                line[MAX_LOG_LINE];
    FILE               *log_fp;
    const char         *urgency;
    va_list             va;
    time_t              now = time(NULL);
    size_t              len;

    if (context != NULL) {
        if (crit > context->max_log_level) {
            return 0;
        }
    } else {
#ifndef DEBUG
        if (crit > LOG_INFO) {
            return 0;
        }
#endif
    }
    switch (crit) {
    case LOG_INFO:
        urgency = "[INFO] ";
        break;
    case LOG_WARNING:
        urgency = "[WARNING] ";
        break;
    case LOG_ERR:
        urgency = "[ERROR] ";
        break;
    case LOG_NOTICE:
        urgency = "[NOTICE] ";
        break;
    case LOG_DEBUG:
        urgency = "[DEBUG] ";
        break;
    default:
        urgency = "";
    }
    va_start(va, format);
    len = (size_t) evutil_vsnprintf(line, sizeof line, format, va);
    va_end(va);

    if (len >= sizeof line) {
        assert(sizeof line > (size_t) 0U);
        len = sizeof line - (size_t) 1U;
    }
    line[len++] = 0;
#ifndef _WIN32
    if (context != NULL && context->log_fp == NULL && context->syslog != 0) {
        if (context->syslog_prefix != NULL) {
            syslog(crit, "%s %s", context->syslog_prefix, line);
        } else {
            syslog(crit, "%s", line);
        }
        return 0;
    }
#endif
    if (memcmp(previous_line, line, len) == 0) {
        burst_counter++;
        if (burst_counter > LOGGER_ALLOWED_BURST_FOR_IDENTICAL_LOG_ENTRIES &&
            now - last_log_ts < LOGGER_DELAY_BETWEEN_IDENTICAL_LOG_ENTRIES) {
            return 1;
        }
    } else {
        burst_counter = 0U;
    }
    last_log_ts = now;
    assert(sizeof previous_line >= sizeof line);
    memcpy(previous_line, line, len);
    if (context == NULL || context->log_fp == NULL) {
        log_fp = crit >= LOG_NOTICE ? stdout : stderr;
    } else {
        log_fp = context->log_fp;
    }
    timestamp_fprint(log_fp);
    if (context != NULL && context->syslog_prefix) {
        fprintf(log_fp, "%s%s %s\n", urgency, context->syslog_prefix, line);
    } else {
        fprintf(log_fp, "%s%s\n", urgency, line);
    }
    fflush(log_fp);

    return 0;
}

int
logger_noformat(struct ProxyContext_ * const context,
                 const int crit, const char * const msg)
{
    return logger(context, crit, "%s", msg);
}

int
logger_error(struct ProxyContext_ * const context,
              const char * const msg)
{
    const char *const err_msg = strerror(errno);

    return logger(context, LOG_ERR, "%s: %s", msg, err_msg);
}

void systemd_notify(struct ProxyContext_ * const context,
                    const char * const msg) {
#ifdef HAVE_LIBSYSTEMD
    const int err = sd_notify(0, msg);

    if (err < 0) {
        logger(context, LOG_DEBUG, "sd_notify failed: %s", strerror(-err));
    }
#endif
}

int
logger_close(struct ProxyContext_ * const context)
{
#ifndef _WIN32
    if (context->syslog != 0) {
        closelog();
    }
#endif
    if (context->log_fp != NULL) {
        return fclose(context->log_fp);
    }
    return 0;
}
