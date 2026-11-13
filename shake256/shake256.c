/* Based on the public domain implementation in
 * crypto_hash/keccakc512/simple/ from http://bench.cr.yp.to/supercop.html
 * by Ronny Van Keer
 * and the public domain "TweetFips202" implementation
 * from https://twitter.com/tweetfips202
 * by Gilles Van Assche, Daniel J. Bernstein, and Peter Schwabe */

#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "shake256.h"

#define NROUNDS 24
#define ROL(a, offset) (((a) << (offset)) ^ ((a) >> (64 - (offset))))

/*************************************************
 * Name:        load64
 *
 * Description: Load 8 bytes into uint64_t in little-endian order
 *
 * Arguments:   - const uint8_t *x: pointer to input byte array
 *
 * Returns the loaded 64-bit unsigned integer
 **************************************************/
static uint64_t load64(const uint8_t *x) {
    uint64_t r = 0;
    for (size_t i = 0; i < 8; ++i) {
        r |= (uint64_t)x[i] << 8 * i;
    }

    return r;
}

/*************************************************
 * Name:        store64
 *
 * Description: Store a 64-bit integer to a byte array in little-endian order
 *
 * Arguments:   - uint8_t *x: pointer to the output byte array
 *              - uint64_t u: input 64-bit unsigned integer
 **************************************************/
static void store64(uint8_t *x, uint64_t u) {
    for (size_t i = 0; i < 8; ++i) {
        x[i] = (uint8_t) (u >> 8 * i);
    }
}

static void to_bit_interleaved(uint64_t *state, uint32_t *interleaved_state) {
    uint32_t lo, hi, temp;

    for (int i = 0; i < 25; i++) {
        uint64_t lane = state[i];

        // Interleave low 32 bits of lane
        lo = (uint32_t)lane;
        temp = (lo ^ (lo >> 1)) & 0x22222222UL;
        lo = lo ^ temp ^ (temp << 1);
        temp = (lo ^ (lo >> 2)) & 0x0C0C0C0CUL;
        lo = lo ^ temp ^ (temp << 2);
        temp = (lo ^ (lo >> 4)) & 0x00F000F0UL;
        lo = lo ^ temp ^ (temp << 4);
        temp = (lo ^ (lo >> 8)) & 0x0000FF00UL;
        lo = lo ^ temp ^ (temp << 8);

        // Interleave high 32 bits of lane
        hi = (uint32_t)(lane >> 32);
        temp = (hi ^ (hi >> 1)) & 0x22222222UL;
        hi = hi ^ temp ^ (temp << 1);
        temp = (hi ^ (hi >> 2)) & 0x0C0C0C0CUL;
        hi = hi ^ temp ^ (temp << 2);
        temp = (hi ^ (hi >> 4)) & 0x00F000F0UL;
        hi = hi ^ temp ^ (temp << 4);
        temp = (hi ^ (hi >> 8)) & 0x0000FF00UL;
        hi = hi ^ temp ^ (temp << 8);

        interleaved_state[2 * i] = (lo & 0x0000FFFF) | (hi << 16);
        interleaved_state[2 * i + 1] = (lo >> 16) | (hi & 0xFFFF0000);
    }
}

static void from_bit_interleaved(uint32_t *interleaved_state, uint64_t *state) {
    for (int i = 0; i < 25; i++) {
        uint32_t e = interleaved_state[2*i];
        uint32_t o = interleaved_state[2*i+1];
        
	uint32_t hi = (e >> 16) | (o & 0xFFFF0000);
	uint32_t lo = (e & 0x0000FFFF) | (o << 16);
	

        // recover low 32 bits
        uint32_t temp = (lo ^ (lo >> 8)) & 0x0000FF00UL;
        lo = lo ^ temp ^ (temp << 8);
        temp = (lo ^ (lo >> 4)) & 0x00F000F0UL;
        lo = lo ^ temp ^ (temp << 4);
        temp = (lo ^ (lo >> 2)) & 0x0C0C0C0CUL;
        lo = lo ^ temp ^ (temp << 2);
        temp = (lo ^ (lo >> 1)) & 0x22222222UL;
        lo = lo ^ temp ^ (temp << 1);

        // recover high 32 bits
        temp = (hi ^ (hi >> 8)) & 0x0000FF00UL;
        hi = hi ^ temp ^ (temp << 8);
        temp = (hi ^ (hi >> 4)) & 0x00F000F0UL;
        hi = hi ^ temp ^ (temp << 4);
        temp = (hi ^ (hi >> 2)) & 0x0C0C0C0CUL;
        hi = hi ^ temp ^ (temp << 2);
        temp = (hi ^ (hi >> 1)) & 0x22222222UL;
        hi = hi ^ temp ^ (temp << 1);

        state[i] = ((uint64_t)hi << 32) | lo;
    }
}

/*************************************************
 * Name:        KeccakF1600_StatePermute
 *
 * Description: The Keccak F1600 Permutation
 *
 * Arguments:   - uint64_t *state: pointer to input/output Keccak state
 **************************************************/
void KeccakF1600_StatePermute(uint64_t *state) {
    uint32_t interleaved_state[50];

    to_bit_interleaved(state, interleaved_state);
    keccakf1600(interleaved_state);
    from_bit_interleaved(interleaved_state, state);
}

/*************************************************
 * Name:        keccak_absorb
 *
 * Description: Absorb step of Keccak;
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - uint64_t *s: pointer to (uninitialized) output Keccak state
 *              - uint32_t r: rate in bytes (e.g., 168 for SHAKE128)
 *              - const uint8_t *m: pointer to input to be absorbed into s
 *              - size_t mlen: length of input in bytes
 *              - uint8_t p: domain-separation byte for different
 *                                 Keccak-derived functions
 **************************************************/
static void keccak_absorb(uint64_t *s, uint32_t r, const uint8_t *m,
                          size_t mlen, uint8_t p) {
    size_t i;
    uint8_t t[200];

    /* Zero state */
    for (i = 0; i < 25; ++i) {
        s[i] = 0;
    }

    while (mlen >= r) {
        for (i = 0; i < r / 8; ++i) {
            s[i] ^= load64(m + 8 * i);
        }

        KeccakF1600_StatePermute(s);
        mlen -= r;
        m += r;
    }

    for (i = 0; i < r; ++i) {
        t[i] = 0;
    }
    for (i = 0; i < mlen; ++i) {
        t[i] = m[i];
    }
    t[i] = p;
    t[r - 1] |= 128;
    for (i = 0; i < r / 8; ++i) {
        s[i] ^= load64(t + 8 * i);
    }
}

/*************************************************
 * Name:        keccak_squeezeblocks
 *
 * Description: Squeeze step of Keccak. Squeezes full blocks of r bytes each.
 *              Modifies the state. Can be called multiple times to keep
 *              squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *h: pointer to output blocks
 *              - size_t nblocks: number of blocks to be
 *                                                squeezed (written to h)
 *              - uint64_t *s: pointer to input/output Keccak state
 *              - uint32_t r: rate in bytes (e.g., 168 for SHAKE128)
 **************************************************/
static void keccak_squeezeblocks(uint8_t *h, size_t nblocks,
                                 uint64_t *s, uint32_t r) {
    while (nblocks > 0) {
        KeccakF1600_StatePermute(s);
        for (size_t i = 0; i < (r >> 3); i++) {
            store64(h + 8 * i, s[i]);
        }
        h += r;
        nblocks--;
    }
}


/*************************************************
 * Name:        shake256_absorb
 *
 * Description: Absorb step of the SHAKE256 XOF.
 *              non-incremental, starts by zeroeing the state.
 *
 * Arguments:   - uint64_t *state: pointer to (uninitialized) output Keccak state
 *              - const uint8_t *input: pointer to input to be absorbed
 *                                            into s
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256_absorb(uint64_t state[25], const uint8_t *input, size_t inlen) {
    keccak_absorb(state, SHAKE256_RATE, input, inlen, 0x1F);
}

/*************************************************
 * Name:        shake256_squeezeblocks
 *
 * Description: Squeeze step of SHAKE256 XOF. Squeezes full blocks of
 *              SHAKE256_RATE bytes each. Modifies the state. Can be called
 *              multiple times to keep squeezing, i.e., is incremental.
 *
 * Arguments:   - uint8_t *output: pointer to output blocks
 *              - size_t nblocks: number of blocks to be squeezed
 *                                (written to output)
 *              - uint64_t *state: pointer to input/output Keccak state
 **************************************************/
void shake256_squeezeblocks(uint8_t *output, size_t nblocks, uint64_t state[25]) {
    keccak_squeezeblocks(output, nblocks, state, SHAKE256_RATE);
}

/*************************************************
 * Name:        shake256
 *
 * Description: SHAKE256 XOF with non-incremental API
 *
 * Arguments:   - uint8_t *output: pointer to output
 *              - size_t outlen: requested output length in bytes
 *              - const uint8_t *input: pointer to input
 *              - size_t inlen: length of input in bytes
 **************************************************/
void shake256(uint8_t *output, size_t outlen,
              const uint8_t *input, size_t inlen) {
    size_t nblocks = outlen / SHAKE256_RATE;
    uint8_t t[SHAKE256_RATE];
    uint64_t s[25];

    shake256_absorb(s, input, inlen);
    shake256_squeezeblocks(output, nblocks, s);

    output += nblocks * SHAKE256_RATE;
    outlen -= nblocks * SHAKE256_RATE;

    if (outlen) {
        shake256_squeezeblocks(t, 1, s);
        for (size_t i = 0; i < outlen; ++i) {
            output[i] = t[i];
        }
    }
}
