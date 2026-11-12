.syntax unified
.global keccakf1600
.text

// void keccakf1600(uint64_t *state);
keccakf1600:

    push {r4-r11, lr} // preserve callee saved registers
    mov r2, #24
    adr r1, round_constants

// r0 - state pointer
// r1 - rodata pointer
// r2 - round index
// r3-r12, lr - working regs

round_start:
        ldr r3,  [r0, #0]
        ldr r4,  [r0, #8]
        ldr r5,  [r0, #16]
        ldr r6,  [r0, #24]
        ldr r7,  [r0, #32]

        ldr r8,  [r0, #40]
        ldr r9,  [r0, #48]
        ldr r10, [r0, #56]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10

        ldr r8,  [r0, #64]
        ldr r9,  [r0, #72]
        ldr r10, [r0, #80]
        eor r6, r6, r8
        eor r7, r7, r9
        eor r3, r3, r10

        ldr r8,  [r0, #88]
        ldr r9,  [r0, #96]
        ldr r10, [r0, #104]
        eor r4, r4, r8
        eor r5, r5, r9
        eor r6, r6, r10

        ldr r8,  [r0, #112]
        ldr r9,  [r0, #120]
        ldr r10, [r0, #128]
        eor r7, r7, r8
        eor r3, r3, r9
        eor r4, r4, r10

        ldr r8,  [r0, #136]
        ldr r9,  [r0, #144]
        ldr r10, [r0, #152]
        eor r5, r5, r8
        eor r6, r6, r9
        eor r7, r7, r10

        ldr r8,  [r0, #160]
        ldr r9,  [r0, #168]
        ldr r10, [r0, #176]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10

        ldr r8,  [r0, #184]
        ldr r9,  [r0, #192]
        eor r6, r6, r8
        eor r7, r7, r9

        push {r3-r7} // save even column parities
        
        // now compute odd column parities
        ldr r3,  [r0, #4]
        ldr r4,  [r0, #12]
        ldr r5,  [r0, #20]
        ldr r6,  [r0, #28]
        ldr r7,  [r0, #36]

        ldr r8,  [r0, #44]
        ldr r9,  [r0, #52]
        ldr r10, [r0, #60]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10

        ldr r8,  [r0, #68]
        ldr r9,  [r0, #76]
        ldr r10, [r0, #84]
        eor r6, r6, r8
        eor r7, r7, r9
        eor r3, r3, r10

        ldr r8,  [r0, #92]
        ldr r9,  [r0, #100]
        ldr r10, [r0, #108]
        eor r4, r4, r8
        eor r5, r5, r9
        eor r6, r6, r10

        ldr r8,  [r0, #116]
        ldr r9,  [r0, #124]
        ldr r10, [r0, #132]
        eor r7, r7, r8
        eor r3, r3, r9
        eor r4, r4, r10

        ldr r8,  [r0, #140]
        ldr r9,  [r0, #148]
        ldr r10, [r0, #156]
        eor r5, r5, r8
        eor r6, r6, r9
        eor r7, r7, r10

        ldr r8,  [r0, #164]
        ldr r9,  [r0, #172]
        ldr r10, [r0, #180]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10

        ldr r8,  [r0, #188]
        ldr r9,  [r0, #196]
        eor r6, r6, r8
        eor r7, r7, r9

        // now that were done computing the parities
        // we can pop the even parities and calculate
        // the mixing terms
        pop {r8-r12}
        push {r3-r7} // save odd column parities
        
        ldr r4, [sp, #0] 
        ldr r5, [sp, #4] 
        ldr r6, [sp, #8] 
        ldr r7, [sp, #12]
        ldr r3, [sp, #16]
        
        // calculate odd mixing terms
        eor r3, r3, r9
        eor r4, r4, r10
        eor r5, r5, r11
        eor r6, r6, r12
        eor r7, r7, r8

        // save odd mixing terms
        push {r3-r7}

        // load odd parities
        ldr r3, [sp, #20]
        ldr r4, [sp, #24]
        ldr r5, [sp, #28]
        ldr r6, [sp, #32]
        ldr r7, [sp, #36]

        ror r3, r3, #31
        ror r4, r4, #31
        ror r5, r5, #31
        ror r6, r6, #31
        ror r7, r7, #31

        eor r8, r8, r5
        eor r9, r9, r6
        eor r10, r10, r7
        eor r11, r11, r3
        eor r12, r12, r4

        // we calculated all mixing terms. we currently have
        // in r8-r12 the even terms. in the stack we have the odd
        // parities at sp+20 and the odd mixing terms parities at sp+0

        // now we start xor'ing the mixing terms into the state
        // starting with the even columns since we already have them in registers

        ldr r3,  [r0, #0]
        ldr r4,  [r0, #8]
        ldr r5,  [r0, #16]
        ldr r6,  [r0, #24]
        ldr r7,  [r0, #32]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #0]
        str r4,  [r0, #8]
        str r5,  [r0, #16]
        str r6,  [r0, #24]
        str r7,  [r0, #32]

        ldr r3,  [r0, #40]
        ldr r4,  [r0, #48]
        ldr r5,  [r0, #56]
        ldr r6,  [r0, #64]
        ldr r7,  [r0, #72]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #40]
        str r4,  [r0, #48]
        str r5,  [r0, #56]
        str r6,  [r0, #64]
        str r7,  [r0, #72]
        
        ldr r3,  [r0, #80]
        ldr r4,  [r0, #88]
        ldr r5,  [r0, #96]
        ldr r6,  [r0, #104]
        ldr r7,  [r0, #112]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #80]
        str r4,  [r0, #88]
        str r5,  [r0, #96]
        str r6,  [r0, #104]
        str r7,  [r0, #112]
        
        ldr r3,  [r0, #120]
        ldr r4,  [r0, #128]
        ldr r5,  [r0, #136]
        ldr r6,  [r0, #144]
        ldr r7,  [r0, #152]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #120]
        str r4,  [r0, #128]
        str r5,  [r0, #136]
        str r6,  [r0, #144]
        str r7,  [r0, #152]
        
        ldr r3,  [r0, #160]
        ldr r4,  [r0, #168]
        ldr r5,  [r0, #176]
        ldr r6,  [r0, #184]
        ldr r7,  [r0, #192]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #160]
        str r4,  [r0, #168]
        str r5,  [r0, #176]
        str r6,  [r0, #184]
        str r7,  [r0, #192]
        
        // and now the odd columns
        pop {r8-r12} // load odd mixing terms

        ldr r3,  [r0, #4]
        ldr r4,  [r0, #12]
        ldr r5,  [r0, #20]
        ldr r6,  [r0, #28]
        ldr r7,  [r0, #36]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #4]
        str r4,  [r0, #12]
        str r5,  [r0, #20]
        str r6,  [r0, #28]
        str r7,  [r0, #36]

        ldr r3,  [r0, #44]
        ldr r4,  [r0, #52]
        ldr r5,  [r0, #60]
        ldr r6,  [r0, #68]
        ldr r7,  [r0, #76]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #44]
        str r4,  [r0, #52]
        str r5,  [r0, #60]
        str r6,  [r0, #68]
        str r7,  [r0, #76]
        
        ldr r3,  [r0, #84]
        ldr r4,  [r0, #92]
        ldr r5,  [r0, #100]
        ldr r6,  [r0, #108]
        ldr r7,  [r0, #116]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #84]
        str r4,  [r0, #92]
        str r5,  [r0, #100]
        str r6,  [r0, #108]
        str r7,  [r0, #116]
        
        ldr r3,  [r0, #124]
        ldr r4,  [r0, #132]
        ldr r5,  [r0, #140]
        ldr r6,  [r0, #148]
        ldr r7,  [r0, #156]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #124]
        str r4,  [r0, #132]
        str r5,  [r0, #140]
        str r6,  [r0, #148]
        str r7,  [r0, #156]
        
        ldr r3,  [r0, #164]
        ldr r4,  [r0, #172]
        ldr r5,  [r0, #180]
        ldr r6,  [r0, #188]
        ldr r7,  [r0, #196]
        eor r3, r3, r8
        eor r4, r4, r9
        eor r5, r5, r10
        eor r6, r6, r11
        eor r7, r7, r12
        str r3,  [r0, #164]
        str r4,  [r0, #172]
        str r5,  [r0, #180]
        str r6,  [r0, #188]
        str r7,  [r0, #196]

        add sp, sp, #20 // remove odd parities from stack

        // thats the theta step done.

        subs r2, r2, #1
        bne round_start
round_end:

    pop {r4-r11, lr}  // recover callee saved registers
    bx lr                 // Return to the C caller

.section .rodata
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

~
