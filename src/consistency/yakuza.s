; Removes relevant RNG of Yakuza, by letting the patcher write a number on how many rounds Yakuza will additionally
; do in its first phase. Thus the final calculation ends up being: 1 + ProvidedNumber


; In YakuzaClosingMouth, hijack where it tries to adjust work0 on how many rounds to do
.org 0805C51Ah
.area 0xC
    bl @YakuzaClosingMouthHijack
.endarea


@YakuzaMagicNumber equ 0FFh

.org YakuzaRoundsPointer
.area 04h
    .dw     YakuzaRounds
.endarea

.autoregion
.align 2
YakuzaRounds:
.db @YakuzaMagicNumber

.align 2
.func @YakuzaClosingMouthHijack
; r0 is the value of work0 (after doing gSpriteRandomNumber/4)
; r1 at the end of the function has to point to work0

    mov     r1, r0  ; temp store the random number
    ldr     r0, =YakuzaRounds
    ldrb    r0, [r0, #0]
    cmp     r0, @YakuzaMagicNumber
    bne     @@ApplyOffset
    mov     r0, r1  ; get the random number back

@@ApplyOffset:
    add     r0, #1  ; Vanilla functionality of having 1 round at minumum
    ldr     r1, =CurrentSprite
    add     r1, Sprite_Work0
    strb    r0, [r1, #0]
    bl      0805C520h   ; end of the function where it tries to return
.pool
.endfunc
.endautoregion