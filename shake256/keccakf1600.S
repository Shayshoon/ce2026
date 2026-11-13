.syntax unified
.global keccakf1600
.thumb
.text

.align 2
// access with:
// ldr rX, [r1], #4
// this loads word at r1 to rX and increments r1 by 4 bytes (next constant, accounting for bit interleaving)
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

.align 2
.thumb_func
.type keccakf1600 %function
// void keccakf1600(uint32_t *state);
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
        pop {r9-r12}
	pop {r8}
        push {r3-r7} // save odd column parities
        
        ldr r4, [sp, #0] 
        ldr r5, [sp, #4] 
        ldr r6, [sp, #8] 
        ldr r7, [sp, #12]
        ldr r3, [sp, #16]
        
        // calculate odd mixing terms
        eor r3, r3, r10
        eor r4, r4, r11
        eor r5, r5, r12
        eor r6, r6, r8
        eor r7, r7, r9

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

        eor r8, r8, r4
        eor r9, r9, r5
        eor r10, r10, r6
        eor r11, r11, r7
        eor r12, r12, r3

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
        // Now we have stored in memory theta(state)

        // we now need to do the rho and pi steps. we will do them together

        // lane 0,0 doesnt rotate in rho and doesnt change in pi, so we skip it
        // lanes 1,0 and 4,0 are the "furthest" from each other 
        // in the pi permutation, so we start with them
        // to minimize wait cycles during memory calls

        ldr r4, [r0, #8] // lane 1,0 (even)
        ldr r5, [r0, #12] // lane 1,0 (odd)
        ldr r6, [r0, #32] // lane 4,0 (even)
        ldr r7, [r0, #36] // lane 4,0 (odd)

        // This next part of the code was generated by a python script (included in the repo)
        // I created a csv file with offsets, addresses, and data needed for rho and pi functions
        // then fed that file into the script along with a template (f-string) to generate assembly
        // code instead of writing it by hand. this way i made sure to minimize human error.
        // the python script was generated by claude

        // rotate lane 1,0 by 1
        ror r8, r5, #31
        mov r5, r4
        mov r4, r8

        // rotate lane 4,0 by 27
        ror r8, r7, #18
        ror r7, r6, #19
        mov r6, r8

        // lanes 0,2 and 0,3 are next in the permutation
        ldr r8,  [r0, #80] // 0,2 even
        ldr r9,  [r0, #84]
        ldr r10, [r0, #120]  // 0,3 even
        ldr r11, [r0, #124]

        str r4, [r0, #80]
        str r5, [r0, #84]
        str r6, [r0, #120]
        str r7, [r0, #124]

        // rotate lane 0,2 by 3
        ror r4, r9, #30
        ror r9, r8, #31
        mov r8, r4

        // rotate lane 0,3 by 41
        ror r4, r11, #11
        ror r11, r10, #12
        mov r10, r4

        // lanes 2,1 and 3,4 are next in the permutation
        ldr r4,  [r0, #56]
        ldr r5,  [r0, #60]
        ldr r6, [r0, #184]
        ldr r7, [r0, #188]

        str r8, [r0, #56]
        str r9, [r0, #60]
        str r10, [r0, #184]
        str r11, [r0, #188]

        // rotate lane 2,1
        ror r5, r5, #29
        ror r4, r4, #29

        // rotate lane 3,4
        ror r6, r6, #4
        ror r7, r7, #4

        // lanes 1,2 and 4,3 are next in the permutation
        ldr r8,  [r0, #88] // 1,2 even
        ldr r9,  [r0, #92]
        ldr r10, [r0, #152]  // 4,3 even
        ldr r11, [r0, #156]

        str r4, [r0, #88]
        str r5, [r0, #92]
        str r6, [r0, #152]
        str r7, [r0, #156]

        // rotate lane 1,2 by 10
        ror r9, r9, #27
        ror r8, r8, #27

        // rotate lane 4,3 by 8
        ror r11, r11, #28
        ror r10, r10, #28

        // lanes 2,3 and 3,2 are next in the permutation
        ldr r4,  [r0, #136]
        ldr r5,  [r0, #140]
        ldr r6, [r0, #104]
        ldr r7, [r0, #108]

        str r8, [r0, #136]
        str r9, [r0, #140]
        str r10, [r0, #104]
        str r11, [r0, #108]
        
        // rotate lane 2,3 by 15
        ror r8, r5, #24
        ror r5, r4, #25
        mov r4, r8

        // rotate lane 3,2 by 21
        ror r8, r7, #19
        ror r7, r6, #20
        mov r6, r8

        // lanes 3,3 and 2,2 are next in the permutation
        ldr r8,  [r0, #144] // 3,3 even
        ldr r9,  [r0, #148]
        ldr r10, [r0, #96]  // 2,2 even
        ldr r11, [r0, #100]

        str r4, [r0, #144]
        str r5, [r0, #148]
        str r6, [r0, #96]
        str r7, [r0, #100]

        // rotate lane 3,3 by 21
        ror r4, r9, #21
        ror r9, r8, #22
        mov r8, r4

        // rotate lane 2,2 by 43
        ror r4, r11, #10
        ror r11, r10, #11
        mov r10, r4

        // lanes 3,0 and 2,0 are next in the permutation
        ldr r4,  [r0, #24]
        ldr r5,  [r0, #28]
        ldr r6, [r0, #16]
        ldr r7, [r0, #20]

        str r8, [r0, #24]
        str r9, [r0, #28]
        str r10, [r0, #16]
        str r11, [r0, #20]

        // rotate lane 3,0
        ror r5, r5, #18
        ror r4, r4, #18

        // rotate lane 2,0
        ror r6, r6, #1
        ror r7, r7, #1

        // lanes 0,1 and 0,4 are next in the permutation
        ldr r8,  [r0, #40] // 0,1 even
        ldr r9,  [r0, #44]
        ldr r10, [r0, #160]  // 0,4 even
        ldr r11, [r0, #164]

        str r4, [r0, #40]
        str r5, [r0, #44]
        str r6, [r0, #160]
        str r7, [r0, #164]

        // rotate lane 0,1 by 36
        ror r9, r9, #14
        ror r8, r8, #14

        // rotate lane 0,4 by 18
        ror r11, r11, #23
        ror r10, r10, #23

        // lanes 1,3 and 4,2 are next in the permutation
        ldr r4,  [r0, #128]
        ldr r5,  [r0, #132]
        ldr r6, [r0, #112]
        ldr r7, [r0, #116]

        str r8, [r0, #128]
        str r9, [r0, #132]
        str r10, [r0, #112]
        str r11, [r0, #116]
        
        // rotate lane 1,3 by 45
        ror r8, r5, #9
        ror r5, r4, #10
        mov r4, r8

        // rotate lane 4,2 by 39
        ror r8, r7, #12
        ror r7, r6, #13
        mov r6, r8

        // lanes 3,1 and 2,4 are next in the permutation
        ldr r8,  [r0, #64] // 3,1 even
        ldr r9,  [r0, #68]
        ldr r10, [r0, #176]  // 2,4 even
        ldr r11, [r0, #180]

        str r4, [r0, #64]
        str r5, [r0, #68]
        str r6, [r0, #176]
        str r7, [r0, #180]

        // rotate lane 3,1 by 55
        ror r4, r9, #4
        ror r9, r8, #5
        mov r8, r4

        // rotate lane 2,4 by 61
        ror r4, r11, #1
        ror r11, r10, #2
        mov r10, r4

        // lanes 1,4 and 4,1 are next in the permutation
        ldr r4,  [r0, #168]
        ldr r5,  [r0, #172]
        ldr r6, [r0, #72]
        ldr r7, [r0, #76]

        str r8, [r0, #168]
        str r9, [r0, #172]
        str r10, [r0, #72]
        str r11, [r0, #76]

        // rotate lane 1,4
        ror r5, r5, #31
        ror r4, r4, #31

        // rotate lane 4,1
        ror r6, r6, #22
        ror r7, r7, #22

        // lanes 4,4 and 1,1 are next in the permutation
        ldr r8,  [r0, #192] // 4,4 even
        ldr r9,  [r0, #196]
        ldr r10, [r0, #48]  // 1,1 even
        ldr r11, [r0, #52]

        str r4, [r0, #192]
        str r5, [r0, #196]
        str r6, [r0, #48]
        str r7, [r0, #52]

        // rotate lane 4,4 by 14
        ror r9, r9, #25
        ror r8, r8, #25

        // rotate lane 1,1 by 44
        ror r11, r11, #10
        ror r10, r10, #10

        str r8, [r0, #32]
        str r9, [r0, #36]
        str r10, [r0, #8]
        str r11, [r0, #12]

        // end of generated code for rho and pi steps
        // time for the chi step. We can do it inplace, idk why the instruction imply
        // we should not do inplace.

        // because in the chi function, the even bits only interact with the other even bits,
        // we can execute it seperately, iteratively over all rows.
        // first we load the even bits of the first row

       
        ldr r3,  [r0, #0]
        ldr r4,  [r0, #8]
        ldr r5,  [r0, #16]
        ldr r6,  [r0, #24]
        ldr r7,  [r0, #32]

        mov r8, r3      // save r3 and r4 to calculate r6 and r7
        mov r9, r4

        bic r10, r5, r4 // r10 = r4 and (not r5)
        eor r3, r3, r10 // r3 = r3 xor r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #0]
        str r4,  [r0, #8]
        str r5,  [r0, #16]
        str r6,  [r0, #24]
        str r7,  [r0, #32]

        // and now the odd bits

        ldr r3,  [r0, #4]
        ldr r4,  [r0, #12]
        ldr r5,  [r0, #20]
        ldr r6,  [r0, #28]
        ldr r7,  [r0, #36]

        mov r8, r3
        mov r9, r4

        bic r10, r5, r4
        eor r3, r3, r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #4]
        str r4,  [r0, #12]
        str r5,  [r0, #20]
        str r6,  [r0, #28]
        str r7,  [r0, #36]

        ldr r3,  [r0, #40]
        ldr r4,  [r0, #48]
        ldr r5,  [r0, #56]
        ldr r6,  [r0, #64]
        ldr r7,  [r0, #72]

        mov r8, r3      // save r3 and r4 to calculate r6 and r7
        mov r9, r4

        bic r10, r5, r4 // r10 = r4 and (not r5)
        eor r3, r3, r10 // r3 = r3 xor r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #40]
        str r4,  [r0, #48]
        str r5,  [r0, #56]
        str r6,  [r0, #64]
        str r7,  [r0, #72]

        // and now the odd bits

        ldr r3,  [r0, #44]
        ldr r4,  [r0, #52]
        ldr r5,  [r0, #60]
        ldr r6,  [r0, #68]
        ldr r7,  [r0, #76]

        mov r8, r3
        mov r9, r4

        bic r10, r5, r4
        eor r3, r3, r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #44]
        str r4,  [r0, #52]
        str r5,  [r0, #60]
        str r6,  [r0, #68]
        str r7,  [r0, #76]

        ldr r3,  [r0, #80]
        ldr r4,  [r0, #88]
        ldr r5,  [r0, #96]
        ldr r6,  [r0, #104]
        ldr r7,  [r0, #112]

        mov r8, r3      // save r3 and r4 to calculate r6 and r7
        mov r9, r4

        bic r10, r5, r4 // r10 = r4 and (not r5)
        eor r3, r3, r10 // r3 = r3 xor r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #80]
        str r4,  [r0, #88]
        str r5,  [r0, #96]
        str r6,  [r0, #104]
        str r7,  [r0, #112]

        // and now the odd bits

        ldr r3,  [r0, #84]
        ldr r4,  [r0, #92]
        ldr r5,  [r0, #100]
        ldr r6,  [r0, #108]
        ldr r7,  [r0, #116]

        mov r8, r3
        mov r9, r4

        bic r10, r5, r4
        eor r3, r3, r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #84]
        str r4,  [r0, #92]
        str r5,  [r0, #100]
        str r6,  [r0, #108]
        str r7,  [r0, #116]

        ldr r3,  [r0, #120]
        ldr r4,  [r0, #128]
        ldr r5,  [r0, #136]
        ldr r6,  [r0, #144]
        ldr r7,  [r0, #152]

        mov r8, r3      // save r3 and r4 to calculate r6 and r7
        mov r9, r4

        bic r10, r5, r4 // r10 = r4 and (not r5)
        eor r3, r3, r10 // r3 = r3 xor r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #120]
        str r4,  [r0, #128]
        str r5,  [r0, #136]
        str r6,  [r0, #144]
        str r7,  [r0, #152]

        // and now the odd bits

        ldr r3,  [r0, #124]
        ldr r4,  [r0, #132]
        ldr r5,  [r0, #140]
        ldr r6,  [r0, #148]
        ldr r7,  [r0, #156]

        mov r8, r3
        mov r9, r4

        bic r10, r5, r4
        eor r3, r3, r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #124]
        str r4,  [r0, #132]
        str r5,  [r0, #140]
        str r6,  [r0, #148]
        str r7,  [r0, #156]

        ldr r3,  [r0, #160]
        ldr r4,  [r0, #168]
        ldr r5,  [r0, #176]
        ldr r6,  [r0, #184]
        ldr r7,  [r0, #192]

        mov r8, r3      // save r3 and r4 to calculate r6 and r7
        mov r9, r4

        bic r10, r5, r4 // r10 = r4 and (not r5)
        eor r3, r3, r10 // r3 = r3 xor r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #160]
        str r4,  [r0, #168]
        str r5,  [r0, #176]
        str r6,  [r0, #184]
        str r7,  [r0, #192]

        // and now the odd bits

        ldr r3,  [r0, #164]
        ldr r4,  [r0, #172]
        ldr r5,  [r0, #180]
        ldr r6,  [r0, #188]
        ldr r7,  [r0, #196]

        mov r8, r3
        mov r9, r4

        bic r10, r5, r4
        eor r3, r3, r10

        bic r10, r6, r5
        eor r4, r4, r10

        bic r10, r7, r6
        eor r5, r5, r10

        bic r10, r8, r7
        eor r6, r6, r10

        bic r10, r9, r8
        eor r7, r7, r10

        str r3,  [r0, #164]
        str r4,  [r0, #172]
        str r5,  [r0, #180]
        str r6,  [r0, #188]
        str r7,  [r0, #196]

        // thats the chi step finished
        // iota step is just xoring the first lane with our current constant:

        ldr r3, [r1], #4
        ldr r5, [r0, #0]
        ldr r4, [r1], #4
        ldr r6, [r0, #4]

        eor r5, r5, r3
        eor r6, r6, r4

        str r5, [r0, #0]
        str r6, [r0, #4]
        
        // and there you go we finished the round :)
        
        subs r2, r2, #1
        bne round_start
round_end:

    pop {r4-r11, lr}  // recover callee saved registers
    bx lr                 // Return to the C caller

