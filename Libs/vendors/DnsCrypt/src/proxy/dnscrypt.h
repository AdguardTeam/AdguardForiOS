
#ifndef __DNSCRYPT_H__
#define __DNSCRYPT_H__ 1

#include <sys/types.h>
#include <stdint.h>

#include <sodium.h>

#define DNSCRYPT_MAGIC_QUERY_LEN 8U
#define DNSCRYPT_MAGIC_RESPONSE  "r6fnvWj8"

#ifndef DNSCRYPT_MAX_PADDING
# define DNSCRYPT_MAX_PADDING 256U
#endif
#ifndef DNSCRYPT_BLOCK_SIZE
# define DNSCRYPT_BLOCK_SIZE 64U
#endif
#ifndef DNSCRYPT_MIN_PAD_LEN
# define DNSCRYPT_MIN_PAD_LEN 8U
#endif
#define crypto_box_HALF_NONCEBYTES (crypto_box_NONCEBYTES / 2U)

size_t dnscrypt_response_header_size(void);
size_t dnscrypt_query_header_size(void);

int dnscrypt_cmp_client_nonce(const uint8_t
                              client_nonce[crypto_box_HALF_NONCEBYTES],
                              const uint8_t * const buf, const size_t len);

size_t dnscrypt_pad(uint8_t *buf, const size_t len, const size_t max_len);

void dnscrypt_key_to_fingerprint(char fingerprint[80U],
                                 const uint8_t * const key);

int dnscrypt_fingerprint_to_key(const char * const fingerprint,
                                uint8_t key[crypto_box_PUBLICKEYBYTES]);

#endif
