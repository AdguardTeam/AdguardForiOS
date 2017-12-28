
#ifndef __SAFE_RW_H__
#define __SAFE_RW_H__ 1

#include <sys/types.h>

ssize_t safe_write(const int fd, const void * const buf_, size_t count,
                   const int timeout);

ssize_t safe_read(const int fd, void * const buf_, size_t count);

ssize_t safe_read_partial(const int fd, void * const buf_,
                          const size_t max_count);

#endif
