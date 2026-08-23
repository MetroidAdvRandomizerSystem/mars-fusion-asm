; Removes the RNG of the Gadoras:
; - The Gadora will not wait randomly before registering Samus in front of it
; - Each Gadora can have its own number assigned by the patcher on how many times it will 
;   shoot before it will open its vulnerable eye. If its not replaced, it will fall back to
;   its original behaviour

; In GadoraIdleInit, patch out the Work1 += 61 call to just = 61 to ignore the rng value it assigned before
.org 08043032h
.area 2
    mov r0, #61
.endarea

; Same for GadoraIdle. 
.org 08043082h
.area 2
    mov r0, #61
.endarea


; In GadoraOpeningEye, hijack condition for opening eye 
.org 080430D4h
.area 0xC, 0
    bl @GadoraOpeningEyeHijack
.endarea 

@GadoraMagicNumber equ 0FFh

.org GadoraTablePointer
.area 04h
    .dw     GadoraLookupTable
.endarea

.autoregion
.align 2

GadoraLookupTable:
; GadoraArachnus_Id to GadoraYakuza_Id, not counting the unused ones.
.fill 10, @GadoraMagicNumber

.func @GadoraOpeningEyeHijack
; We hijack the opening function to read from a custom table on how many times
; a specific Gadora should shoot. If that number is our magic number, we execute 
; the vanilla code instead.

; at start of hijack: r0 contains gSpriteRandomNumber, r4 contains CurrentSprite
    push    { r0 }  ; storing this for the original behaviour

; All Gadora sprite ids are next to each other numerically, so 
; subtracting by the first gadora id offsets the id to start at 0 for our lookup table
    ldrb    r0, [r4, Sprite_Id]
    sub     r0, #GadoraArachnus_Id
    ldr     r1, =GadoraLookupTable
    ldrb    r1, [r1, r0]
    cmp     r1, #@GadoraMagicNumber
    beq      @@OriginalCode

    pop     { r0 }  ; don't need it anymore, can remove it from the stack
    mov     r0, r4
    add     r0, Sprite_Work2
    ldrb    r0, [r0, #0]
    cmp     r0, r1
    blt     @@ShootingCase
    b       @@OpeningCase
    .pool

@@OriginalCode:
    pop     { r0 }
    cmp     r0, #6
    bls     @@OpeningCase
    mov     r0, r4
    add     r0, Sprite_Work2
    ldrb    r0, [r0, #0]
    cmp     r0, #3
    bhi     @@OpeningCase
    b       @@ShootingCase

@@ShootingCase:
    ; Needs r1 to point to work2!
    ; Also needs r0 to be the value of Work2, but we already did that above in both cases.
    mov     r1, r4
    add     r1, Sprite_Work2
    bl      080430E2h   ; shooting case in original function

@@OpeningCase:
    ; We don't need to do anything special
    bl      08043118h   ; opening case in original function

.endfunc
.endautoregion