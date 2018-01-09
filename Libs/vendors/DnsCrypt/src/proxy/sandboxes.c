
#include <config.h>
#ifndef _WIN32
# include <sys/types.h>
# include <sys/socket.h>
# include <sys/time.h>
#endif

#ifdef HAVE_SANDBOX_H
# pragma GCC diagnostic ignored "-Wdeprecated-declarations"
# include <sandbox.h>
#endif

#include "sandboxes.h"

int
sandboxes_app(void)
{
    return 0;
}

int
sandboxes_pidproc(void)
{
#ifdef HAVE_SANDBOX_INIT
    char *errmsg;

    if (sandbox_init != NULL &&
        sandbox_init(kSBXProfileNoNetwork, SANDBOX_NAMED, &errmsg) != 0) {
        return -1;
    }
#endif
    return 0;
}

#if defined(SO_ATTACH_FILTER) && defined(HAVE_LINUX_FILTER_H)
# include <linux/filter.h>

/*
  ldh [x + 4]
  jlt #25, fail
  ldh [x + 10]
  and #0xfc8f
  jne #0, fail
  ldh [x + 12]
  jneq #1, fail
  ld [x + 14]
  jneq #0, fail
  ldh [x + 18]
  jgt #1, fail
  ret #0x40000

fail:
  ret #0
*/

int
attach_udp_dnsq_bpf(int fd)
{
    struct sock_filter code[] = {
       { 0x48,  0,  0, 0x00000004 },
       { 0x35,  0, 10, 0x00000019 },
       { 0x48,  0,  0, 0x0000000a },
       { 0x54,  0,  0, 0x0000fc8f },
       { 0x15,  0,  7, 0000000000 },
       { 0x48,  0,  0, 0x0000000c },
       { 0x15,  0,  5, 0x00000001 },
       { 0x40,  0,  0, 0x0000000e },
       { 0x15,  0,  3, 0000000000 },
       { 0x48,  0,  0, 0x00000012 },
       { 0x25,  1,  0, 0x00000001 },
       { 0x06,  0,  0, 0x00040000 },
       { 0x06,  0,  0, 0000000000 },
    };
    struct sock_fprog bpf = {
        .len = (sizeof code) / (sizeof code[0]),
        .filter = code
    };
    return setsockopt(fd, SOL_SOCKET, SO_ATTACH_FILTER, &bpf, sizeof bpf);
}

#else

int
attach_udp_dnsq_bpf(int fd) {
    (void) fd;
    return -1;
}

#endif
