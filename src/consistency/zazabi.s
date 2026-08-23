; Removes relevant RNG of Zazabi:
; Each phase can have its own number assigned by the patcher on how much to offset the base result by. 
; For phase 1 to 3, this number denotes how many additional jumps Zazabi does where it cannot be hit.
; Thus the calculation on how many extra jumps to do ends up as: (CurrentPhase-1) + ProvidedNumber
; For phase 4, the number denotes how many additional frames to crawl more. The final calculation ends up as: 60 + ProvidedNumber


; In ZazabiCrawling, Hijack where it tries to adjust work3 for amount of jumps in first 3 phases
.org 08045A6Ah 
.area 8
    bl @ZazabiCrawlingHijack
.endarea

; In ZazabiCrawlingInit, hijack where it tries to adjust work1 on how long to crawl for in last phase
.org 08045980h
.area 8
    bl @ZazabiCrawlingInitHijack
.endarea


@ZazabiMagicNumber equ 0FFh

.org ZazabiTablePointer
.area 04h
    .dw     ZazabiLookupTable
.endarea

.autoregion
.align 2
ZazabiLookupTable:
.fill 4, @ZazabiMagicNumber   ; 4 distinct phases

.func @ZazabiCrawlingHijack
; r0 is value of work3 (after doing gSpriteRandomNumber/4), r1 points to work3, r2 is gSubSpriteData1.health, r4 is gCurrentSprite
; At the end of the function, r0 has to be the new value work3 and r1 has to point to work3

; We do essentially 5 - (gSubSpriteData1.health / 20), and use that as an offset to our table.
; The subsprite health goes from 40 to 100, in steps of 20.
    push    { r1 }
    mov     r4, r0
    mov     r0, r2
    mov     r1, #20
    bl DivideUnsigned
    mov     r1, #5
    sub     r0, r1, r0
    ldr     r1, =ZazabiLookupTable
    ldrb    r0, [r1, r0]
    pop     { r1 }      ; restore r1 to point to work3
    cmp     r0, #@ZazabiMagicNumber
    bne     @@ApplyOffsets
    mov     r0, r4      ; If offset was magic number, restore the original random number

@@ApplyOffsets:
    ; Vanilla functionality on each phase having one more jump
    cmp     r2, #60
    bne     @@Check80HealthCase
    add     r0, #2
    b       @@Exit

@@Check80HealthCase:
    cmp     r2, #80
    bne     @@Exit
    add     r0, #1

@@Exit:
    bl      08045A7Eh    ; return back to original function which stores r0 back into work3 (r1). 

.pool
.endfunc

.func @ZazabiCrawlingInitHijack
; r0 is the value of work1 (after doing gSpriteRandomNumber*8), r3 is gCurrentSprite
; At the end of the function, r0 has to be the value of work1 and r1 has to point to work1
    mov     r1, r0      ; temp store the random value in r1
    ldr     r0, =ZazabiLookupTable
    ldrb    r0, [r0, #3]
    cmp     r0, @ZazabiMagicNumber
    bne     @@Exit
    mov     r0, r1      ; offset was magic number, so restore it back to random number

@@Exit:
    ; Vanilla functionality of the minimum being 60 frames
    add     r0, #60
    mov     r1, r3
    add     r1, Sprite_Work1
    bl      0804599Ah   ; return back to original function which stores r0 back into work1 (r1)

.pool
.endfunc
.endautoregion
