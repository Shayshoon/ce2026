// Fused Keccak-f[1600] rounds on a bit-interleaved state, Cortex-M4 (ARMv7E-M)
.syntax unified
.thumb
.text

.align 2
round_constants:
    .word 0x00000001
    .word 0x00000000
    .word 0x00000000
    .word 0x00000089
    .word 0x00000000
    .word 0x8000008b
    .word 0x00000000
    .word 0x80008080
    .word 0x00000001
    .word 0x0000008b
    .word 0x00000001
    .word 0x00008000
    .word 0x00000001
    .word 0x80008088
    .word 0x00000001
    .word 0x80000082
    .word 0x00000000
    .word 0x0000000b
    .word 0x00000000
    .word 0x0000000a
    .word 0x00000001
    .word 0x00008082
    .word 0x00000000
    .word 0x00008003
    .word 0x00000001
    .word 0x0000808b
    .word 0x00000001
    .word 0x8000000b
    .word 0x00000001
    .word 0x8000008a
    .word 0x00000001
    .word 0x80000081
    .word 0x00000000
    .word 0x80000081
    .word 0x00000000
    .word 0x80000008
    .word 0x00000000
    .word 0x00000083
    .word 0x00000000
    .word 0x80008003
    .word 0x00000001
    .word 0x80008088
    .word 0x00000000
    .word 0x80000088
    .word 0x00000001
    .word 0x00008000
    .word 0x00000000
    .word 0x80008082

.global keccakf1600
.align 2
.thumb_func
.type keccakf1600, %function
// void keccakf1600(uint32_t *state);  r0 = 50 words, bit-interleaved (even word, odd word per lane), in place
keccakf1600:
    push {r4-r11, lr}
    sub sp, sp, #252
    mov r1, sp                    // r1 = destination buffer (stack), r0 = source
    adr r2, round_constants
    str r2, [sp, #240]
    add r3, r2, #192
    str r3, [sp, #244]
.align 2
2:
    // ---- theta: column parities
    ldr r3, [r0, #0]
    ldr r4, [r0, #8]
    ldr r5, [r0, #16]
    ldr r6, [r0, #24]
    ldr r7, [r0, #32]
    ldr r8, [r0, #4]
    ldr r9, [r0, #12]
    ldr r10, [r0, #20]
    ldr r11, [r0, #28]
    ldr r12, [r0, #36]
    ldr r2, [r0, #40]
    ldr lr, [r0, #48]
    eor r3, r3, r2
    ldr r2, [r0, #56]
    eor r4, r4, lr
    ldr lr, [r0, #64]
    eor r5, r5, r2
    ldr r2, [r0, #72]
    eor r6, r6, lr
    ldr lr, [r0, #44]
    eor r7, r7, r2
    ldr r2, [r0, #52]
    eor r8, r8, lr
    ldr lr, [r0, #60]
    eor r9, r9, r2
    ldr r2, [r0, #68]
    eor r10, r10, lr
    ldr lr, [r0, #76]
    eor r11, r11, r2
    ldr r2, [r0, #80]
    eor r12, r12, lr
    ldr lr, [r0, #88]
    eor r3, r3, r2
    ldr r2, [r0, #96]
    eor r4, r4, lr
    ldr lr, [r0, #104]
    eor r5, r5, r2
    ldr r2, [r0, #112]
    eor r6, r6, lr
    ldr lr, [r0, #84]
    eor r7, r7, r2
    ldr r2, [r0, #92]
    eor r8, r8, lr
    ldr lr, [r0, #100]
    eor r9, r9, r2
    ldr r2, [r0, #108]
    eor r10, r10, lr
    ldr lr, [r0, #116]
    eor r11, r11, r2
    ldr r2, [r0, #120]
    eor r12, r12, lr
    ldr lr, [r0, #128]
    eor r3, r3, r2
    ldr r2, [r0, #136]
    eor r4, r4, lr
    ldr lr, [r0, #144]
    eor r5, r5, r2
    ldr r2, [r0, #152]
    eor r6, r6, lr
    ldr lr, [r0, #124]
    eor r7, r7, r2
    ldr r2, [r0, #132]
    eor r8, r8, lr
    ldr lr, [r0, #140]
    eor r9, r9, r2
    ldr r2, [r0, #148]
    eor r10, r10, lr
    ldr lr, [r0, #156]
    eor r11, r11, r2
    ldr r2, [r0, #160]
    eor r12, r12, lr
    ldr lr, [r0, #168]
    eor r3, r3, r2
    ldr r2, [r0, #176]
    eor r4, r4, lr
    ldr lr, [r0, #184]
    eor r5, r5, r2
    ldr r2, [r0, #192]
    eor r6, r6, lr
    ldr lr, [r0, #164]
    eor r7, r7, r2
    ldr r2, [r0, #172]
    eor r8, r8, lr
    ldr lr, [r0, #180]
    eor r9, r9, r2
    ldr r2, [r0, #188]
    eor r10, r10, lr
    ldr lr, [r0, #196]
    eor r11, r11, r2
    eor r12, r12, lr
    // ---- theta: D values to stack
    eor r2, r7, r9, ror #31
    str r2, [sp, #200]
    eor lr, r12, r4
    str lr, [sp, #220]
    eor r2, r3, r10, ror #31
    str r2, [sp, #204]
    eor lr, r8, r5
    str lr, [sp, #224]
    eor r2, r4, r11, ror #31
    str r2, [sp, #208]
    eor lr, r9, r6
    str lr, [sp, #228]
    eor r2, r5, r12, ror #31
    str r2, [sp, #212]
    eor lr, r10, r7
    str lr, [sp, #232]
    eor r2, r6, r8, ror #31
    str r2, [sp, #216]
    eor lr, r11, r3
    str lr, [sp, #236]
    ldr r2, [sp, #240]
    // ---- row 0, even words
    ldr r3, [r0, #0]
    ldr r4, [r0, #48]
    ldr r5, [r0, #100]
    ldr r6, [r0, #148]
    ldr r7, [r0, #192]
    ldr r8, [sp, #200]
    ldr r9, [sp, #204]
    ldr r10, [sp, #228]
    ldr r11, [sp, #232]
    ldr r12, [sp, #216]
    ldr lr, [r2], #4
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r4, r4, #10
    ror r5, r5, #10
    ror r6, r6, #21
    ror r7, r7, #25
    bic r8, r5, r4
    eor r8, r8, r3
    eor r8, r8, lr
    str r8, [r1, #0]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #8]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #16]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #24]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #32]
    // ---- row 0, odd words
    ldr r3, [r0, #4]
    ldr r4, [r0, #52]
    ldr r5, [r0, #96]
    ldr r6, [r0, #144]
    ldr r7, [r0, #196]
    ldr r8, [sp, #220]
    ldr r9, [sp, #224]
    ldr r10, [sp, #208]
    ldr r11, [sp, #212]
    ldr r12, [sp, #236]
    ldr lr, [r2], #4
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r4, r4, #10
    ror r5, r5, #11
    ror r6, r6, #22
    ror r7, r7, #25
    bic r8, r5, r4
    eor r8, r8, r3
    eor r8, r8, lr
    str r8, [r1, #4]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #12]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #20]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #28]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #36]
    // ---- row 1, even words
    ldr r3, [r0, #24]
    ldr r4, [r0, #72]
    ldr r5, [r0, #84]
    ldr r6, [r0, #132]
    ldr r7, [r0, #180]
    ldr r8, [sp, #212]
    ldr r9, [sp, #216]
    ldr r10, [sp, #220]
    ldr r11, [sp, #224]
    ldr r12, [sp, #228]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #18
    ror r4, r4, #22
    ror r5, r5, #30
    ror r6, r6, #9
    ror r7, r7, #1
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #40]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #48]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #56]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #64]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #72]
    // ---- row 1, odd words
    ldr r3, [r0, #28]
    ldr r4, [r0, #76]
    ldr r5, [r0, #80]
    ldr r6, [r0, #128]
    ldr r7, [r0, #176]
    ldr r8, [sp, #232]
    ldr r9, [sp, #236]
    ldr r10, [sp, #200]
    ldr r11, [sp, #204]
    ldr r12, [sp, #208]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #18
    ror r4, r4, #22
    ror r5, r5, #31
    ror r6, r6, #10
    ror r7, r7, #2
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #44]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #52]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #60]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #68]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #76]
    // ---- row 2, even words
    ldr r3, [r0, #12]
    ldr r4, [r0, #56]
    ldr r5, [r0, #108]
    ldr r6, [r0, #152]
    ldr r7, [r0, #160]
    ldr r8, [sp, #224]
    ldr r9, [sp, #208]
    ldr r10, [sp, #232]
    ldr r11, [sp, #216]
    ldr r12, [sp, #200]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #31
    ror r4, r4, #29
    ror r5, r5, #19
    ror r6, r6, #28
    ror r7, r7, #23
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #80]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #88]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #96]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #104]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #112]
    // ---- row 2, odd words
    ldr r3, [r0, #8]
    ldr r4, [r0, #60]
    ldr r5, [r0, #104]
    ldr r6, [r0, #156]
    ldr r7, [r0, #164]
    ldr r8, [sp, #204]
    ldr r9, [sp, #228]
    ldr r10, [sp, #212]
    ldr r11, [sp, #236]
    ldr r12, [sp, #220]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r4, r4, #29
    ror r5, r5, #20
    ror r6, r6, #28
    ror r7, r7, #23
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #84]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #92]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #100]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #108]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #116]
    // ---- row 3, even words
    ldr r3, [r0, #36]
    ldr r4, [r0, #40]
    ldr r5, [r0, #88]
    ldr r6, [r0, #140]
    ldr r7, [r0, #184]
    ldr r8, [sp, #236]
    ldr r9, [sp, #200]
    ldr r10, [sp, #204]
    ldr r11, [sp, #228]
    ldr r12, [sp, #212]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #18
    ror r4, r4, #14
    ror r5, r5, #27
    ror r6, r6, #24
    ror r7, r7, #4
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #120]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #128]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #136]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #144]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #152]
    // ---- row 3, odd words
    ldr r3, [r0, #32]
    ldr r4, [r0, #44]
    ldr r5, [r0, #92]
    ldr r6, [r0, #136]
    ldr r7, [r0, #188]
    ldr r8, [sp, #216]
    ldr r9, [sp, #220]
    ldr r10, [sp, #224]
    ldr r11, [sp, #208]
    ldr r12, [sp, #232]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #19
    ror r4, r4, #14
    ror r5, r5, #27
    ror r6, r6, #25
    ror r7, r7, #4
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #124]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #132]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #140]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #148]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #156]
    // ---- row 4, even words
    ldr r3, [r0, #16]
    ldr r4, [r0, #68]
    ldr r5, [r0, #116]
    ldr r6, [r0, #124]
    ldr r7, [r0, #168]
    ldr r8, [sp, #208]
    ldr r9, [sp, #232]
    ldr r10, [sp, #236]
    ldr r11, [sp, #220]
    ldr r12, [sp, #204]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #1
    ror r4, r4, #4
    ror r5, r5, #12
    ror r6, r6, #11
    ror r7, r7, #31
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #160]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #168]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #176]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #184]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #192]
    // ---- row 4, odd words
    ldr r3, [r0, #20]
    ldr r4, [r0, #64]
    ldr r5, [r0, #112]
    ldr r6, [r0, #120]
    ldr r7, [r0, #172]
    ldr r8, [sp, #228]
    ldr r9, [sp, #212]
    ldr r10, [sp, #216]
    ldr r11, [sp, #200]
    ldr r12, [sp, #224]
    eor r3, r3, r8
    eor r4, r4, r9
    eor r5, r5, r10
    eor r6, r6, r11
    eor r7, r7, r12
    ror r3, r3, #1
    ror r4, r4, #5
    ror r5, r5, #13
    ror r6, r6, #12
    ror r7, r7, #31
    bic r8, r5, r4
    eor r8, r8, r3
    str r8, [r1, #164]
    bic r9, r6, r5
    eor r9, r9, r4
    str r9, [r1, #172]
    bic r10, r7, r6
    eor r10, r10, r5
    str r10, [r1, #180]
    bic r11, r3, r7
    eor r11, r11, r6
    str r11, [r1, #188]
    bic r12, r4, r3
    eor r12, r12, r7
    str r12, [r1, #196]
    // ---- swap source/destination, loop
    mov r3, r0
    mov r0, r1
    mov r1, r3
    str r2, [sp, #240]
    ldr lr, [sp, #244]
    cmp r2, lr
    bne 2b
    add sp, sp, #252
    pop {r4-r11, pc}

.size keccakf1600, .-keccakf1600

