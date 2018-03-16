
#include <config.h>
#include <sys/types.h>

#include <assert.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <event2/util.h>
#include <sodium.h>

#include "dnscrypt.h"
#include "utils.h"

size_t
dnscrypt_response_header_size(void)
{
    return sizeof DNSCRYPT_MAGIC_RESPONSE - 1U
        + crypto_box_NONCEBYTES + crypto_box_MACBYTES;
}

size_t
dnscrypt_query_header_size(void)
{
    return DNSCRYPT_MAGIC_QUERY_LEN
        + crypto_box_PUBLICKEYBYTES + crypto_box_HALF_NONCEBYTES
        + crypto_box_MACBYTES;
}

int
dnscrypt_cmp_client_nonce(const uint8_t client_nonce[crypto_box_HALF_NONCEBYTES],
                          const uint8_t * const buf, const size_t len)
{
    const size_t client_nonce_offset = sizeof DNSCRYPT_MAGIC_RESPONSE - 1U;

    if (len < client_nonce_offset + crypto_box_HALF_NONCEBYTES ||
        sodium_memcmp(client_nonce, buf + client_nonce_offset,
                      crypto_box_HALF_NONCEBYTES) != 0) {
        return -1;
    }
    return 0;
}

size_t
dnscrypt_pad(uint8_t *buf, const size_t len, const size_t max_len)
{
    uint8_t  *buf_padding_area = buf + len;
    size_t    padded_len, padding_len;

    if (max_len < len + DNSCRYPT_MIN_PAD_LEN) {
        return len;
    }
#ifdef RANDOM_LENGTH_PADDING
    padded_len = len + DNSCRYPT_MIN_PAD_LEN + randombytes_uniform
        ((uint32_t) (max_len - len - DNSCRYPT_MIN_PAD_LEN + 1U));
    padded_len += DNSCRYPT_BLOCK_SIZE - padded_len % DNSCRYPT_BLOCK_SIZE;
    if (padded_len > max_len) {
        padded_len = max_len;
    }
#else
    padded_len = max_len;
#endif
    assert(padded_len >= len);
    padding_len = padded_len - len;
    memset(buf_padding_area, 0, padding_len);
    *buf_padding_area = 0x80;
    assert(max_len >= padded_len);

    return padded_len;
}

void
dnscrypt_key_to_fingerprint(char fingerprint[80U], const uint8_t * const key)
{
    const size_t fingerprint_size = 80U;
    size_t       fingerprint_pos = (size_t) 0U;
    size_t       key_pos = (size_t) 0U;

    COMPILER_ASSERT(crypto_box_PUBLICKEYBYTES == 32U);
    COMPILER_ASSERT(crypto_box_SECRETKEYBYTES == 32U);
    for (;;) {
        assert(fingerprint_size > fingerprint_pos);
        evutil_snprintf(&fingerprint[fingerprint_pos],
                        fingerprint_size - fingerprint_pos, "%02X%02X",
                        key[key_pos], key[key_pos + 1U]);
        key_pos += 2U;
        if (key_pos >= crypto_box_PUBLICKEYBYTES) {
            break;
        }
        fingerprint[fingerprint_pos + 4U] = ':';
        fingerprint_pos += 5U;
    }
}

int
dnscrypt_fingerprint_to_key(const char * const fingerprint,
                            uint8_t key[crypto_box_PUBLICKEYBYTES])
{
    size_t key_len;

    if (fingerprint != NULL &&
        sodium_hex2bin(key, crypto_box_PUBLICKEYBYTES,
                       fingerprint, strlen(fingerprint),
                       ": \t\r\n", &key_len, NULL) == 0 &&
        key_len == crypto_box_PUBLICKEYBYTES) {
        return 0;
    }
    return -1;
}
