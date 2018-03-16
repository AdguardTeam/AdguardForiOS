
#ifndef __SANDBOXES_H__
#define __SANDBOXES_H__ 1

int sandboxes_app(void);
int sandboxes_pidproc(void);

int attach_udp_dnsq_bpf(int fd);

#endif
