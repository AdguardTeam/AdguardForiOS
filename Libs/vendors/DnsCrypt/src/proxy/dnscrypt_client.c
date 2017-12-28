
#include <config.h>
#include <sys/types.h>
#include <sys/time.h>
#ifdef _WIN32
# include <winsock2.h>
#else
# include <arpa/inet.h>
#endif

#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <event2/event.h>
#include <sodium.h>

#include "dnscrypt.h"
#include "dnscrypt_client.h"
#include "utils.h"
#include "shims.h"

static void
dnscrypt_make_client_nonce(DNSCryptClient * const client,
                           uint8_t client_nonce[crypto_box_HALF_NONCEBYTES])
{
    uint64_t ts;
    uint64_t tsn;
    uint32_t suffix;

    ts = dnscrypt_hrtime();
    if (ts <= client->nonce_ts_last) {
        ts = client->nonce_ts_last + (uint64_t) 1U;
    }
    client->nonce_ts_last = ts;

    tsn = (ts << 10) | (randombytes_random() & 0x3ff);
#ifdef WORDS_BIGENDIAN
    tsn = (((uint64_t) htonl((uint32_t) tsn)) << 32) |
        htonl((uint32_t) (tsn >> 32));
#endif
    COMPILER_ASSERT(crypto_box_HALF_NONCEBYTES == 12U);
    memcpy(client_nonce, &tsn, 8U);
    suffix = randombytes_random();
    memcpy(client_nonce + 8U, &suffix, 4U);
}

//  8 bytes: magic_query
// 32 bytes: the client's DNSCurve public key (crypto_box_PUBLICKEYBYTES)
// 12 bytes: a client-selected nonce for this packet (crypto_box_NONCEBYTES / 2)
// 16 bytes: Poly1305 MAC (crypto_box_MACBYTES)

ssize_t
dnscrypt_client_curve(DNSCryptClient * const client,
                      uint8_t client_nonce[crypto_box_HALF_NONCEBYTES],
                      uint8_t *buf, size_t len, const size_t max_len)
{
    uint8_t  eph_publickey[crypto_box_PUBLICKEYBYTES];
    uint8_t  eph_secretkey[crypto_box_SECRETKEYBYTES];
    uint8_t  eph_nonce[crypto_stream_NONCEBYTES];
    uint8_t  nonce[crypto_box_NONCEBYTES];
    uint8_t *publickey;
    uint8_t *boxed;
    int      res;

    if (max_len < len || max_len - len < dnscrypt_query_header_size()) {
        return (ssize_t) -1;
    }
    assert(max_len > dnscrypt_query_header_size());
    boxed = buf + sizeof client->magic_query
        + crypto_box_PUBLICKEYBYTES + crypto_box_HALF_NONCEBYTES;
    assert((boxed - buf) + crypto_box_MACBYTES <= dnscrypt_query_header_size());
    memmove(boxed, buf, len);
    len = dnscrypt_pad(boxed, len, max_len - dnscrypt_query_header_size());
    dnscrypt_make_client_nonce(client, nonce);
    memcpy(client_nonce, nonce, crypto_box_HALF_NONCEBYTES);
    memset(nonce + crypto_box_HALF_NONCEBYTES, 0, crypto_box_HALF_NONCEBYTES);
    if (client->ephemeral_keys == 0) {
        publickey = client->publickey;
        if (client->cipher == CIPHER_XSALSA20POLY1305) {
            res = crypto_box_easy_afternm(boxed, boxed, len, nonce,
                                          client->nmkey);
#ifdef HAVE_XCHACHA20
        } else if (client->cipher == CIPHER_XCHACHA20POLY1305) {
            res = crypto_box_curve25519xchacha20poly1305_easy_afternm(boxed, boxed, len, nonce,
                                                                      client->nmkey);
#endif
        } else {
            return (ssize_t) -1;
        }
    } else {
        COMPILER_ASSERT(crypto_box_HALF_NONCEBYTES < sizeof eph_nonce);
        memcpy(eph_nonce, client_nonce, crypto_box_HALF_NONCEBYTES);
        memcpy(eph_nonce + crypto_box_HALF_NONCEBYTES, client->nonce_pad,
               crypto_box_HALF_NONCEBYTES);
        crypto_stream(eph_secretkey, sizeof eph_secretkey,
                      eph_nonce, client->secretkey);
        crypto_scalarmult_base(eph_publickey, eph_secretkey);
        publickey = eph_publickey;
        if (client->cipher == CIPHER_XSALSA20POLY1305) {
            res = crypto_box_easy(boxed, boxed, len, nonce,
                                  client->publickey, eph_secretkey);
#ifdef HAVE_XCHACHA20
        } else if (client->cipher == CIPHER_XCHACHA20POLY1305) {
            res = crypto_box_curve25519xchacha20poly1305_easy(boxed, boxed, len, nonce,
                                                              client->publickey, eph_secretkey);
#endif
        } else {
            return (ssize_t) -1;
        }
        sodium_memzero(eph_secretkey, sizeof eph_secretkey);
    }
    if (res != 0) {
        return (ssize_t) -1;
    }
    memcpy(buf, client->magic_query, sizeof client->magic_query);
    memcpy(buf + sizeof client->magic_query, publickey,
           crypto_box_PUBLICKEYBYTES);
    memcpy(buf + sizeof client->magic_query + crypto_box_PUBLICKEYBYTES,
           nonce, crypto_box_HALF_NONCEBYTES);

    return (ssize_t) (len + dnscrypt_query_header_size());
}

//  8 bytes: the string r6fnvWJ8 (DNSCRYPT_MAGIC_RESPONSE)
// 12 bytes: the client's nonce (crypto_box_NONCEBYTES / 2)
// 12 bytes: a server-selected nonce extension (crypto_box_NONCEBYTES / 2)
// 16 bytes: Poly1305 MAC (crypto_box_MACBYTES)

#define DNSCRYPT_SERVER_BOX_OFFSET \
    (sizeof DNSCRYPT_MAGIC_RESPONSE - 1U + crypto_box_NONCEBYTES)

int
dnscrypt_client_uncurve(const DNSCryptClient * const client,
                        const uint8_t client_nonce[crypto_box_HALF_NONCEBYTES],
                        uint8_t * const buf, size_t * const lenp)
{
    uint8_t eph_publickey[crypto_box_PUBLICKEYBYTES];
    uint8_t eph_secretkey[crypto_box_SECRETKEYBYTES];
    uint8_t eph_nonce[crypto_stream_NONCEBYTES];
    uint8_t nonce[crypto_box_NONCEBYTES];
    size_t  len = *lenp;
    size_t  ciphertext_len;
    size_t  message_len;
    int     res;

    if (len <= dnscrypt_response_header_size() ||
        memcmp(buf, DNSCRYPT_MAGIC_RESPONSE,
               sizeof DNSCRYPT_MAGIC_RESPONSE - 1U)) {
        return -1;
    }
    if (dnscrypt_cmp_client_nonce(client_nonce, buf, len) != 0) {
        return -1;
    }
    if (len <= DNSCRYPT_SERVER_BOX_OFFSET + crypto_box_MACBYTES) {
        return -1;
    }
    ciphertext_len = len - DNSCRYPT_SERVER_BOX_OFFSET;
    message_len = ciphertext_len - crypto_box_MACBYTES;
    memcpy(nonce, buf + sizeof DNSCRYPT_MAGIC_RESPONSE - 1U,
           crypto_box_NONCEBYTES);
    if (client->ephemeral_keys == 0) {
        if (client->cipher == CIPHER_XSALSA20POLY1305) {
            res = crypto_box_open_easy_afternm
                (buf, buf + DNSCRYPT_SERVER_BOX_OFFSET, ciphertext_len,
                    nonce, client->nmkey);
#ifdef HAVE_XCHACHA20
        } else if (client->cipher == CIPHER_XCHACHA20POLY1305) {
            res = crypto_box_curve25519xchacha20poly1305_open_easy_afternm
                (buf, buf + DNSCRYPT_SERVER_BOX_OFFSET, ciphertext_len,
                    nonce, client->nmkey);
#endif
        } else {
            return -1;
        }
    } else {
        memcpy(eph_nonce, client_nonce, crypto_box_HALF_NONCEBYTES);
        memcpy(eph_nonce + crypto_box_HALF_NONCEBYTES, client->nonce_pad,
               crypto_box_HALF_NONCEBYTES);
        crypto_stream(eph_secretkey, sizeof eph_secretkey,
                      eph_nonce, client->secretkey);
        crypto_scalarmult_base(eph_publickey, eph_secretkey);
        if (client->cipher == CIPHER_XSALSA20POLY1305) {
            res = crypto_box_open_easy
                (buf, buf + DNSCRYPT_SERVER_BOX_OFFSET, ciphertext_len,
                    nonce, client->publickey, eph_secretkey);
#ifdef HAVE_XCHACHA20
        } else if (client->cipher == CIPHER_XCHACHA20POLY1305) {
            res = crypto_box_curve25519xchacha20poly1305_open_easy
                (buf, buf + DNSCRYPT_SERVER_BOX_OFFSET, ciphertext_len,
                    nonce, client->publickey, eph_secretkey);
#endif
        } else {
            return -1;
        }
        sodium_memzero(eph_secretkey, sizeof eph_secretkey);
    }
    sodium_memzero(nonce, sizeof nonce);
    if (res != 0) {
        return -1;
    }
    while (message_len > 0U && buf[--message_len] == 0U) { }
    if (buf[message_len] != 0x80) {
        return -1;
    }
    *lenp = message_len;

    return 0;
}

int
dnscrypt_client_init_magic_query(DNSCryptClient * const client,
                                 const uint8_t magic_query[DNSCRYPT_MAGIC_QUERY_LEN],
                                 Cipher cipher)
{
    COMPILER_ASSERT(DNSCRYPT_MAGIC_QUERY_LEN == sizeof client->magic_query);
    memcpy(client->magic_query, magic_query, sizeof client->magic_query);
    client->cipher = cipher;

    return 0;
}

int
dnscrypt_client_init_resolver_publickey(DNSCryptClient * const client,
                                        const uint8_t resolver_publickey[crypto_box_PUBLICKEYBYTES])
{
    int res = -1;

#if crypto_box_BEFORENMBYTES != crypto_box_PUBLICKEYBYTES
# error crypto_box_BEFORENMBYTES != crypto_box_PUBLICKEYBYTES
#endif
    if (client->ephemeral_keys == 0) {
        if (client->cipher == CIPHER_XSALSA20POLY1305) {
            res = crypto_box_beforenm
                (client->nmkey, resolver_publickey, client->secretkey);
#ifdef HAVE_XCHACHA20
        } else if (client->cipher == CIPHER_XCHACHA20POLY1305) {
            res = crypto_box_curve25519xchacha20poly1305_beforenm
                (client->nmkey, resolver_publickey, client->secretkey);
#endif
        }
    } else {
        memcpy(client->publickey, resolver_publickey, sizeof client->publickey);
        res = 0;
    }
    return res;
}

int
dnscrypt_client_init_with_new_session_key(DNSCryptClient * const client)
{
    assert(client->ephemeral_keys != 0);
    randombytes_buf(client->nonce_pad, sizeof client->nonce_pad);
    randombytes_buf(client->secretkey, sizeof client->secretkey);
    randombytes_stir();

    return 0;
}

int
dnscrypt_client_init_with_new_key_pair(DNSCryptClient * const client)
{
    assert(client->ephemeral_keys == 0);
    crypto_box_keypair(client->publickey, client->secretkey);
    randombytes_stir();

    return 0;
}

int
dnscrypt_client_init_with_client_key(DNSCryptClient * const client)
{
    if (crypto_scalarmult_base(client->publickey, client->secretkey) != 0) {
        return -1;
    }
    return 0;
}
