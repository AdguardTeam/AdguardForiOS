
/* Shims for ancient versions of libsodium */

#include <stddef.h>
#include <string.h>

#include <sodium.h>

/*
 * Debian Jessie ships an old version of libsodium that doesn't support
 * overlapping buffers. Use temporary buffers to work around this.
 */
#if 0
# warning The installed libsodium version is very old and will not be supported in the future.
# warning Support for the XChaCha20 cipher will also not be available in that build.
static int
crypto_box_easy_nooverlap(unsigned char *c, const unsigned char *m,
                          unsigned long long mlen, const unsigned char *n,
                          const unsigned char *pk, const unsigned char *sk)
{
    unsigned char tmp[65536];

    if (crypto_box_MACBYTES + mlen > sizeof tmp) {
        return -1;
    }
    if (crypto_box_easy(tmp, m, mlen, n, pk, sk) != 0) {
        return -1;
    }
    memcpy(c, tmp, crypto_box_MACBYTES + mlen);

    return 0;
}

static int
crypto_box_open_easy_nooverlap(unsigned char *m, const unsigned char *c,
                               unsigned long long clen, const unsigned char *n,
                               const unsigned char *pk, const unsigned char *sk)
{
    unsigned char tmp[65536];

    if (clen < crypto_box_MACBYTES || clen - crypto_box_MACBYTES > sizeof tmp) {
        return -1;
    }
    if (crypto_box_open_easy(tmp, c, clen, n, pk, sk) != 0) {
        return -1;
    }
    memcpy(m, tmp, clen - crypto_box_MACBYTES);

    return 0;
}

# define crypto_box_easy      crypto_box_easy_nooverlap
# define crypto_box_open_easy crypto_box_open_easy_nooverlap
#endif

#if 0
static int
crypto_box_detached_afternm(unsigned char *c, unsigned char *mac,
                            const unsigned char *m, unsigned long long mlen,
                            const unsigned char *n, const unsigned char *k)
{
    unsigned char tmp[65536];

    if (mlen > sizeof tmp) {
        return -1;
    }
    if (crypto_secretbox_detached(tmp, mac, m, mlen, n, k) != 0) {
        return -1;
    }
    memcpy(c, tmp, mlen);

    return 0;
}

static int
crypto_box_easy_afternm(unsigned char *c, const unsigned char *m,
                        unsigned long long mlen, const unsigned char *n,
                        const unsigned char *k)
{
    if (mlen > SIZE_MAX - crypto_box_MACBYTES) {
        return -1;
    }
    return crypto_box_detached_afternm(c + crypto_box_MACBYTES, c, m, mlen, n,
                                       k);
}

static int
crypto_box_open_detached_afternm(unsigned char *m, const unsigned char *c,
                                 const unsigned char *mac,
                                 unsigned long long clen,
                                 const unsigned char *n,
                                 const unsigned char *k)
{
    unsigned char tmp[65536];

    if (clen > sizeof tmp) {
        return -1;
    }
    if (crypto_secretbox_open_detached(tmp, c, mac, clen, n, k) != 0) {
        return -1;
    }
    memcpy(m, tmp, clen);

    return 0;
}

static int
crypto_box_open_easy_afternm(unsigned char *m, const unsigned char *c,
                             unsigned long long clen, const unsigned char *n,
                             const unsigned char *k)
{
    if (clen < crypto_box_MACBYTES) {
        return -1;
    }
    return crypto_box_open_detached_afternm(m, c + crypto_box_MACBYTES, c,
                                            clen - crypto_box_MACBYTES,
                                            n, k);
}
#endif

#if 1
# define HAVE_XCHACHA20 1

#elif defined(HAVE_CRYPTO_CORE_HCHACHA20)
# define HAVE_XCHACHA20 1

# define crypto_secretbox_xchacha20poly1305_ZEROBYTES 32U
# define crypto_secretbox_xchacha20poly1305_MACBYTES 16U
# define crypto_box_curve25519xchacha20poly1305_MACBYTES 16U

static int
crypto_secretbox_xchacha20poly1305_detached(unsigned char *c,
                                            unsigned char *mac,
                                            const unsigned char *m,
                                            unsigned long long mlen,
                                            const unsigned char *n,
                                            const unsigned char *k)
{
    crypto_onetimeauth_poly1305_state state;
    unsigned char                     block0[64U];
    unsigned char                     subkey[crypto_stream_chacha20_KEYBYTES];
    unsigned long long                i;
    unsigned long long                mlen0;

    crypto_core_hchacha20(subkey, n, k, NULL);

    if (((uintptr_t) c >= (uintptr_t) m &&
         (uintptr_t) c - (uintptr_t) m < mlen) ||
        ((uintptr_t) m >= (uintptr_t) c &&
         (uintptr_t) m - (uintptr_t) c < mlen)) {
        memmove(c, m, mlen);
        m = c;
    }
    memset(block0, 0U, crypto_secretbox_xchacha20poly1305_ZEROBYTES);
    (void) sizeof(int[64U >= crypto_secretbox_xchacha20poly1305_ZEROBYTES ?
                      1 : -1]);
    mlen0 = mlen;
    if (mlen0 > 64U - crypto_secretbox_xchacha20poly1305_ZEROBYTES) {
        mlen0 = 64U - crypto_secretbox_xchacha20poly1305_ZEROBYTES;
    }
    for (i = 0U; i < mlen0; i++) {
        block0[i + crypto_secretbox_xchacha20poly1305_ZEROBYTES] = m[i];
    }
    crypto_stream_chacha20_xor(block0, block0,
                               mlen0 + crypto_secretbox_xchacha20poly1305_ZEROBYTES,
                               n + 16, subkey);
    (void) sizeof(int[crypto_secretbox_xchacha20poly1305_ZEROBYTES >=
                      crypto_onetimeauth_poly1305_KEYBYTES ? 1 : -1]);
    crypto_onetimeauth_poly1305_init(&state, block0);

    for (i = 0U; i < mlen0; i++) {
        c[i] = block0[crypto_secretbox_xchacha20poly1305_ZEROBYTES + i];
    }
    sodium_memzero(block0, sizeof block0);
    if (mlen > mlen0) {
        crypto_stream_chacha20_xor_ic(c + mlen0, m + mlen0, mlen - mlen0,
                                      n + 16, 1U, subkey);
    }
    sodium_memzero(subkey, sizeof subkey);

    crypto_onetimeauth_poly1305_update(&state, c, mlen);
    crypto_onetimeauth_poly1305_final(&state, mac);
    sodium_memzero(&state, sizeof state);

    return 0;
}

static int
crypto_secretbox_xchacha20poly1305_open_detached(unsigned char *m,
                                                 const unsigned char *c,
                                                 const unsigned char *mac,
                                                 unsigned long long clen,
                                                 const unsigned char *n,
                                                 const unsigned char *k)
{
    unsigned char      block0[64U];
    unsigned char      subkey[crypto_stream_chacha20_KEYBYTES];
    unsigned long long i;
    unsigned long long mlen0;

    crypto_core_hchacha20(subkey, n, k, NULL);
    crypto_stream_chacha20(block0, crypto_stream_chacha20_KEYBYTES,
                           n + 16, subkey);
    if (crypto_onetimeauth_poly1305_verify(mac, c, clen, block0) != 0) {
        sodium_memzero(subkey, sizeof subkey);
        return -1;
    }
    if (m == NULL) {
        return 0;
    }
    if (((uintptr_t) c >= (uintptr_t) m &&
         (uintptr_t) c - (uintptr_t) m < clen) ||
        ((uintptr_t) m >= (uintptr_t) c &&
         (uintptr_t) m - (uintptr_t) c < clen)) {
        memmove(m, c, clen);
        c = m;
    }
    mlen0 = clen;
    if (mlen0 > 64U - crypto_secretbox_xchacha20poly1305_ZEROBYTES) {
        mlen0 = 64U - crypto_secretbox_xchacha20poly1305_ZEROBYTES;
    }
    for (i = 0U; i < mlen0; i++) {
        block0[crypto_secretbox_xchacha20poly1305_ZEROBYTES + i] = c[i];
    }
    crypto_stream_chacha20_xor(block0, block0,
                              crypto_secretbox_xchacha20poly1305_ZEROBYTES + mlen0,
                              n + 16, subkey);
    for (i = 0U; i < mlen0; i++) {
        m[i] = block0[i + crypto_secretbox_xchacha20poly1305_ZEROBYTES];
    }
    if (clen > mlen0) {
        crypto_stream_chacha20_xor_ic(m + mlen0, c + mlen0, clen - mlen0,
                                      n + 16, 1U, subkey);
    }
    sodium_memzero(subkey, sizeof subkey);

    return 0;
}

static int
crypto_box_curve25519xchacha20poly1305_detached_afternm(unsigned char *c,
                                                        unsigned char *mac,
                                                        const unsigned char *m,
                                                        unsigned long long mlen,
                                                        const unsigned char *n,
                                                        const unsigned char *k)
{
    return crypto_secretbox_xchacha20poly1305_detached(c, mac, m, mlen, n, k);
}

static int
crypto_box_curve25519xchacha20poly1305_easy_afternm(unsigned char *c,
                                                    const unsigned char *m,
                                                    unsigned long long mlen,
                                                    const unsigned char *n,
                                                    const unsigned char *k)
{
    if (mlen > SIZE_MAX - crypto_box_curve25519xchacha20poly1305_MACBYTES) {
        return -1;
    }
    return crypto_box_curve25519xchacha20poly1305_detached_afternm(
        c + crypto_box_curve25519xchacha20poly1305_MACBYTES, c, m, mlen, n, k);
}

static int
crypto_box_curve25519xchacha20poly1305_open_detached_afternm(unsigned char *m,
                                                             const unsigned char *c,
                                                             const unsigned char *mac,
                                                             unsigned long long clen,
                                                             const unsigned char *n,
                                                             const unsigned char *k)
{
    return crypto_secretbox_xchacha20poly1305_open_detached(m, c, mac, clen, n, k);
}

static int
crypto_box_curve25519xchacha20poly1305_open_easy_afternm(unsigned char *m,
                                                         const unsigned char *c,
                                                         unsigned long long clen,
                                                         const unsigned char *n,
                                                         const unsigned char *k)
{
    if (clen < crypto_box_curve25519xchacha20poly1305_MACBYTES) {
        return -1;
    }
    return crypto_box_curve25519xchacha20poly1305_open_detached_afternm(
        m, c + crypto_box_curve25519xchacha20poly1305_MACBYTES, c,
        clen - crypto_box_curve25519xchacha20poly1305_MACBYTES, n, k);
}

static int
crypto_box_curve25519xchacha20poly1305_beforenm(unsigned char *k,
                                                const unsigned char *pk,
                                                const unsigned char *sk)
{
    static const unsigned char n[16] = { 0 };
    unsigned char s[32];

    if (crypto_scalarmult_curve25519(s, sk, pk) != 0) {
        return -1;
    }
    return crypto_core_hchacha20(k, n, s, NULL);
}

static int
crypto_box_curve25519xchacha20poly1305_detached(unsigned char *c,
                                                unsigned char *mac,
                                                const unsigned char *m,
                                                unsigned long long mlen,
                                                const unsigned char *n,
                                                const unsigned char *pk,
                                                const unsigned char *sk)
{
    unsigned char k[crypto_box_BEFORENMBYTES];
    int           ret;

    (void) sizeof(int[crypto_box_BEFORENMBYTES
                      >= crypto_secretbox_KEYBYTES ?
                      1 : -1]);
    if (crypto_box_curve25519xchacha20poly1305_beforenm(k, pk, sk) != 0) {
        return -1;
    }
    ret = crypto_box_curve25519xchacha20poly1305_detached_afternm(c, mac, m,
                                                                  mlen, n, k);
    sodium_memzero(k, sizeof k);

    return ret;
}

static int
crypto_box_curve25519xchacha20poly1305_easy(unsigned char *c,
                                            const unsigned char *m,
                                            unsigned long long mlen,
                                            const unsigned char *n,
                                            const unsigned char *pk,
                                            const unsigned char *sk)
{
    if (mlen > SIZE_MAX - crypto_box_curve25519xchacha20poly1305_MACBYTES) {
        return -1;
    }
    return crypto_box_curve25519xchacha20poly1305_detached(
        c + crypto_box_curve25519xchacha20poly1305_MACBYTES, c, m, mlen, n, pk,
        sk);
}

static int
crypto_box_curve25519xchacha20poly1305_open_detached(unsigned char *m,
                                                     const unsigned char *c,
                                                     const unsigned char *mac,
                                                     unsigned long long clen,
                                                     const unsigned char *n,
                                                     const unsigned char *pk,
                                                     const unsigned char *sk)
{
    unsigned char k[crypto_box_BEFORENMBYTES];
    int           ret;

    if (crypto_box_curve25519xchacha20poly1305_beforenm(k, pk, sk) != 0) {
        return -1;
    }
    ret = crypto_box_curve25519xchacha20poly1305_open_detached_afternm(
        m, c, mac, clen, n, k);
    sodium_memzero(k, sizeof k);

    return ret;
}

static int
crypto_box_curve25519xchacha20poly1305_open_easy(unsigned char *m,
                                                 const unsigned char *c,
                                                 unsigned long long clen,
                                                 const unsigned char *n,
                                                 const unsigned char *pk,
                                                 const unsigned char *sk)
{
    if (clen < crypto_box_curve25519xchacha20poly1305_MACBYTES) {
        return -1;
    }
    return crypto_box_curve25519xchacha20poly1305_open_detached(
        m, c + crypto_box_curve25519xchacha20poly1305_MACBYTES, c,
        clen - crypto_box_curve25519xchacha20poly1305_MACBYTES, n, pk, sk);
}

#endif
