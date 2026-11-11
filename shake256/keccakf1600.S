.global keccakf1600
.text

// void keccakf1600(uint64_t *state);
keccakf1600:
    // a is in x0, b is in x1
    add r0, r0, r1       // Add lower 32-bit words of x0 and x1, store result in w0
    bx lr                 // Return to the C caller

.data
.align 3
// access with:
// LDR     R0, [R1, R2, LSL #3]
round_constants:
    .quad    0x0000000000000001
    .quad    0x0000000000008082
    .quad    0x800000000000808a
    .quad    0x8000000080008000
    .quad    0x000000000000808b
    .quad    0x0000000080000001
    .quad    0x8000000080008081
    .quad    0x8000000000008009
    .quad    0x000000000000008a
    .quad    0x0000000000000088
    .quad    0x0000000080008009
    .quad    0x000000008000000a
    .quad    0x000000008000808b
    .quad    0x800000000000008b
    .quad    0x8000000000008089
    .quad    0x8000000000008003
    .quad    0x8000000000008002
    .quad    0x8000000000000080
    .quad    0x000000000000800a
    .quad    0x800000008000000a
    .quad    0x8000000080008081
    .quad    0x8000000000008080
    .quad    0x0000000080000001
    .quad    0x8000000080008008

