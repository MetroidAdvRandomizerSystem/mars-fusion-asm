; Patches the post-credits cutscene completion percentage.
; Extends the vanilla behavior of counting all 100 minor items by adding
; major items and security level unlocks to the calculation.

.autoregion
    .align 2
.func PopCount
    ; divide and conquer population count
    ldr     r2, =#55555555h
    lsr     r1, r0, #1
    and     r1, r2
    sub     r0, r1
    ldr     r2, =#33333333h
    lsr     r1, r0, #2
    and     r1, r2
    and     r0, r2
    add     r0, r1
    ldr     r2, =#0F0F0F0Fh
    lsr     r1, r0, #4
    add     r0, r1
    and     r0, r2
    lsr     r1, r0, #8
    add     r0, r1
    lsr     r1, r0, #16
    add     r0, r1
    lsl     r0, #1Fh - 5
    lsr     r0, #1Fh - 5
    bx      lr
    .pool
.endfunc
.endautoregion

.org 080A1FB6h
    ; select clear time "score" (0-2)
    ; score = max(0, 2 - floor(hours / 2))
.area 1Ah, 0
    ldrb    r0, [r2, GameTimer_Hours]
    lsr     r0, #1
    mov     r1, #2
    sub     r0, r1, r0
    asr     r1, r0, #1Fh    ; \ minimum of 0
    bic     r0, r1          ; /
    add     r7, #99h
    strb    r0, [r7]
    mov     r4, #0
    ldr     r5, =TanksCollected
    mov     r6, #(MinorLocations_Len / 32) * 4
    b       @@cont
.endarea
    .skip 9Ch
.area 58h, 0
@@cont:
.if MinorLocations_Len % 32 != 0
    ldr     r0, [r5, r6]
    lsl     r0, #20h - MinorLocations_Len % 32
    lsr     r0, #20h - MinorLocations_Len % 32
    bl      PopCount
    add     r4, r0
    sub     r6, #4
.endif
.if MinorLocations_Len / 32 > 0
@@loop:
    ldr     r0, [r5, r6]
    bl      PopCount
    add     r4, r0
    sub     r6, #4
    bpl     @@loop
.endif
    ldr     r0, =MiscProgress
    ldr     r0, [r0, MiscProgress_MajorLocations]
    bl      PopCount
    add     r0, r4
    ; calculate completion percentage rounded down to nearest integer
    ; total items = 118 in vanilla, 116 in MFOR, +4 for security levels
    mov     r1, #100
    mul     r0, r1
    mov     r1, #MinorLocations_Len + MajorLocations_Len - 1
    bl      Divide
    sub     r0, #100        ; \
    asr     r1, r0, #1Fh    ; | maximum of 100
    and     r0, r1          ; |
    add     r0, #100        ; /
    strb    r0, [r7, #1h]
    b       080A20C4h
    .pool
.endarea
