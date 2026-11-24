; Converts floating-point arithmetic to fixed-point reciprocal multiplication
; for calculating the size of a power bomb explosion. Saves an average of
; 10050 cycles per frame.

; Near start of PowerBombExplosion
.org 08068126h
.area 34h
    ; Multiply by 19/20 using fixed-point reciprocal multiplication
    ; r7 contains gCurrentPowerBomb
    ; At the end, r8 has to point to verticalAxis and r6 to horizontalAxis
    ldrb    r0, [r7, #2]
    lsl     r0, #3
    ldr     r1, =#19 * unsigned_reciprocal(20, 20)
    mul     r0, r1
    lsr     r0, #20
    mov     r6, r0
    lsr     r0, #1
    mov     r8, r0
    b       0806815Ah   ; In the same function, jumps after having calculated the two axis
    .pool
.endarea


