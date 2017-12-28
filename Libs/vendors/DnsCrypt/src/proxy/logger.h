
#ifndef __LOGGER_H__
#define __LOGGER_H__ 1

#ifndef _WIN32
# include <syslog.h>
#endif

#ifndef MAX_LOG_LINE
# define MAX_LOG_LINE 1024U
#endif

#ifndef LOGGER_DELAY_BETWEEN_IDENTICAL_LOG_ENTRIES
# define LOGGER_DELAY_BETWEEN_IDENTICAL_LOG_ENTRIES     60
#endif
#ifndef LOGGER_ALLOWED_BURST_FOR_IDENTICAL_LOG_ENTRIES
# define LOGGER_ALLOWED_BURST_FOR_IDENTICAL_LOG_ENTRIES 5U
#endif

#ifdef DEBUG
# define XDEBUG(X) do { X; } while(0)
#else
# define XDEBUG(X)
#endif

#ifdef _WIN32
# define LOG_EMERG   0
# define LOG_ALERT   1
# define LOG_CRIT    2
# define LOG_ERR     3
# define LOG_WARNING 4
# define LOG_NOTICE  5
# define LOG_INFO    6
# define LOG_DEBUG   7
#endif

struct ProxyContext_;

int logger_open_syslog(struct ProxyContext_ * const context);

int logger(struct ProxyContext_ * const context,
           const int crit, const char * const format, ...)
           __attribute__ ((format(printf, 3, 4)));

int logger_noformat(struct ProxyContext_ * const context,
                    const int crit, const char * const msg);

int logger_error(struct ProxyContext_ * const context,
                 const char * const msg);

void systemd_notify(struct ProxyContext_ * const context,
                    const char * const msg);

int logger_close(struct ProxyContext_ * const context);

#endif
