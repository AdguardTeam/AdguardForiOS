
#ifndef __DNSCRYPT_CLIENT_H__
#define __DNSCRYPT_CLIENT_H__ 1

#include <sys/types.h>
#include <stdint.h>

#include "dnscrypt.h"

typedef enum Cipher_ {
    CIPHER_UNDEFINED,
    CIPHER_XSALSA20POLY1305,
    CIPHER_XCHACHA20POLY1305
} Cipher;

typedef struct DNSCryptClient_ {
    uint8_t  magic_query[DNSCRYPT_MAGIC_QUERY_LEN];
    uint8_t  publickey[crypto_box_PUBLICKEYBYTES];
    uint8_t  secretkey[crypto_box_SECRETKEYBYTES];
    uint8_t  nmkey[crypto_box_BEFORENMBYTES];
    uint8_t  nonce_pad[crypto_box_HALF_NONCEBYTES];
    uint64_t nonce_ts_last;
    Cipher   cipher;
    _Bool    ephemeral_keys;
} DNSCryptClient;

ssize_t dnscrypt_client_curve(DNSCryptClient * const client,
                              uint8_t client_nonce[crypto_box_HALF_NONCEBYTES],
                              uint8_t *buf, size_t len, const size_t max_len);

int dnscrypt_client_uncurve(const DNSCryptClient * const client,
                            const uint8_t client_nonce[crypto_box_HALF_NONCEBYTES],
                            uint8_t * const buf, size_t * const lenp);

int dnscrypt_client_init_with_key_pair(DNSCryptClient * const client,
                                       const uint8_t client_publickey[crypto_box_PUBLICKEYBYTES],
                                       const uint8_t client_secretkey[crypto_box_SECRETKEYBYTES]);

int dnscrypt_client_create_key_pair(DNSCryptClient * const client,
                                    uint8_t client_publickey[crypto_box_PUBLICKEYBYTES],
                                    uint8_t client_secretkey[crypto_box_SECRETKEYBYTES]);

int dnscrypt_client_init_with_new_session_key(DNSCryptClient * const client);

int dnscrypt_client_init_with_new_key_pair(DNSCryptClient * const client);

int dnscrypt_client_init_with_client_key(DNSCryptClient * const client);

int dnscrypt_client_init_magic_query(DNSCryptClient * const client,
                                     const uint8_t magic_query[DNSCRYPT_MAGIC_QUERY_LEN],
                                     Cipher cipher);

int dnscrypt_client_init_resolver_publickey(DNSCryptClient * const client,
                                            const uint8_t resolver_publickey[crypto_box_PUBLICKEYBYTES]);
#endif
