; Rewrites the credits format for space optimization and more flexibility.

.org 080A1EDCh
.area 78h
    ldr     r0, =@CreditsFont
    str     r0, [r4, DMA_SAD]
    mov     r0, #06h
    lsl     r0, #18h
    str     r0, [r4, DMA_DAD]
    ldr     r0, =80001A00h
    str     r0, [r4, DMA_CNT]
    ldr     r0, [r4, DMA_CNT]
    ldr     r0, =087478A0h
    str     r0, [r4, DMA_SAD]
    mov     r0, #05h
    lsl     r0, #18h
    str     r0, [r4, DMA_DAD]
    ldr     r0, =80000030h
    str     r0, [r4, DMA_CNT]
    ldr     r0, [r4, DMA_CNT]
    b       080A1F54h
.endarea

.org 080A2138h
.area 8Ch
    ldrb    r1, [r4, #08h]
    cmp     r1, #07Fh
    bls     @@increment_scroll_counter
    mov     r0, #07Fh
    and     r0, r1
    strb    r0, [r4, #08h]
    bl      @IncrementRow
    ldrh    r0, [r4, #02h]
    ldrh    r1, [r4, #04h]
    cmp     r0, r1
    bne     @@check_twoline
    ldrh    r0, [r4, #06h]
    bl      @DrawCreditsLine
    cmp     r0, #0
    bge     @@set_next_row
    ldrb    r0, [r4, #01h]
    add     r0, #1
    strb    r0, [r4, #01h]
    b       @@increment_row_counter
@@set_next_row:
    ldrh    r1, [r4, #04h]
    add     r0, r1
    strh    r0, [r4, #04h]
    ldrh    r0, [r4, #06h]
    add     r0, #1
    strh    r0, [r4, #06h]
    b       @@queue_draw
@@check_twoline:
    ldrb    r0, [r4, #09h]
    cmp     r0, #0
    beq     @@queue_draw
    mov     r0, #0
    strb    r0, [r4, #09h]
    b       @@increment_row_counter
@@queue_draw:
    ldrb    r0, [r4]
    add     r0, #1
    strb    r0, [r4]
@@increment_row_counter:
    ldrh    r0, [r4, #02h]
    add     r0, #1
    strh    r0, [r4, #02h]
@@increment_scroll_counter:
    ldr     r1, =CreditsScrollSpeed
    ldrb    r1, [r1]
    ldrb    r0, [r4, #08h]
    add     r0, r1
    strb    r0, [r4, #08h]
    ldr     r2, =03001226h
    ldrh    r0, [r2]
    add     r0, r1
    strh    r0, [r2]
    b       080A22D8h
    .pool
.endarea

.org 080A21C4h
    ldr     r0, =03001484h
.org 080A21E8h
.area 30h
    ldr     r1, =CreditsEndDelay
    ldrh    r1, [r1]
    cmp     r0, r1
    bls     080A22D8h
    ldr     r1, =BLDCNT
    ldr     r3, =#1FDFh
    strh    r3, [r1]
    mov     r0, #0
    ldr     r1, =0300121Eh
    strh    r0, [r1]
    strh    r0, [r2]
    b       080A22C2h
    .pool
.endarea

.org CreditsScrollSpeed
.area 01h
    .db     9
.endarea

.org CreditsEndDelay
.area 02h
    .dh     512
.endarea

.org 080A22E0h
.area 26Ch
.func @IncrementRow
    ; clear current row vram
    mov     r0, #0
    mov     r1, #1Fh << 1
    ldr     r2, =03001484h
    mov     r3, r2
    add     r2, #4Ah
    add     r3, #0Ah
@@bitfill_loop:
    strh    r0, [r2, r1]
    strh    r0, [r3, r1]
    sub     r1, #2
    cmp     r1, #0
    bge     @@bitfill_loop
    ; increment row counters
    ldr     r3, =03001484h
    ldrh    r0, [r3, #02h]
    lsl     r2, r0, #6
    add     r3, #8Ch
    mov     r0, #50h
    lsl     r0, #04h
    add     r0, r2
    lsl     r0, #15h
    lsr     r0, #15h
    mov     r1, #80h
    lsl     r1, #08h
    add     r0, r1
    str     r0, [r3]
    mov     r0, #54h
    lsl     r0, #04h
    add     r0, r2
    lsl     r0, #15h
    lsr     r0, #15h
    mov     r1, #80h
    lsl     r1, #08h
    add     r0, r1
    str     r0, [r3, #4]
    bx      lr
    .pool
.endfunc

.func @DrawCreditsLine
    push    { r4-r5 }
    ldr     r2, =Credits
    lsl     r1, r0, #3
    add     r0, r1
    lsl     r0, #2
    add     r2, r0
    mov     r5, r2
    ldrb    r1, [r5, CreditsLine_Type]
    cmp     r1, #CreditsLineType_Copyright4
    bls     @@switch_line_type
    b       @@return_skip
@@switch_line_type:
    add     r0, =@@branch_table
    ldrb    r0, [r0, r1]
    lsl     r0, #1
@@branch:
    add     pc, r0
    .align 4
@@branch_table:
    .db     (@@case_blue - @@branch - 4) >> 1
    .db     (@@case_red - @@branch - 4) >> 1
    .db     (@@case_tallwhite - @@branch - 4) >> 1
    .db     (@@case_smallwhite - @@branch - 4) >> 1
    .db     (@@return_skip - @@branch - 4) >> 1
    .db     (@@return_skip - @@branch - 4) >> 1
    .db     (@@case_end - @@branch - 4) >> 1
    .db     (@@return_skip - @@branch - 4) >> 1
    .db     (@@return_skip - @@branch - 4) >> 1
    .db     (@@return_skip - @@branch - 4) >> 1
    .db     (@@case_copyright1 - @@branch - 4) >> 1
    .db     (@@case_copyright2 - @@branch - 4) >> 1
    .db     (@@case_copyright3 - @@branch - 4) >> 1
    .db     (@@case_copyright4 - @@branch - 4) >> 1
.if ((@@return_skip - @@branch - 4) >> 1) >= (1 << 8)
    .error "Branch table overflowed"
.endif
    .align 2
@@case_smallwhite:
    mov     r4, #0
    b       @@write_oneline
@@case_blue:
    mov     r4, #1
    lsl     r4, #0Ch
    b       @@write_oneline
@@case_red:
    mov     r4, #2
    lsl     r4, #0Ch
@@write_oneline:
    add     r2, #CreditsLine_Text
    ldr     r3, =03001484h
    add     r3, #0Ah
@@write_oneline_loop:
    ldrb    r1, [r2]
    cmp     r1, #0
    bne     @@write_oneline_check_uppercase
    b       @@return_skip
@@write_oneline_check_uppercase:
    mov     r0, r1
    sub     r0, #20h
    beq     @@write_oneline_loop_inc
    cmp     r0, #7Eh - 20h
    bhi     @@write_oneline_loop_inc
    add     r0, r4
    strh    r0, [r3]
@@write_oneline_loop_inc:
    add     r2, #1
    add     r3, #2
    b       @@write_oneline_loop
@@case_tallwhite:
    add     r2, #CreditsLine_Text
    ldr     r3, =03001484h
    mov     r0, #1
    strb    r0, [r3, #09h]
    mov     r4, r3
    add     r3, #0Ah
    add     r4, #4Ah
@@write_twoline_loop:
    ldrb    r1, [r2]
    cmp     r1, #0
    beq     @@return_twoline_skip
    ; check uppercase letters
    mov     r0, r1
    sub     r0, #20h
    beq     @@write_twoline_loop_inc
    cmp     r0, #7Eh - 20h
    bhi     @@write_twoline_loop_inc
    lsr     r1, r0, #5
    lsl     r1, #6
    lsl     r0, #20h - 5
    lsr     r0, #20h - 5
    add     r0, r1
    add     r0, #60h
    strh    r0, [r3]
    add     r0, #20h
    strh    r0, [r4]
@@write_twoline_loop_inc:
    add     r2, #1
    add     r3, #2
    add     r4, #2
    b       @@write_twoline_loop
@@case_end:
    mov     r0, #1
    neg     r0, r0
    b       @@return
@@case_copyright1:
    mov     r1, #0
    ldr     r2, =03001484h
    add     r2, #1Ah
@@case_copyright1_write_loop:
    mov     r0, r1
    add     r0, #0FFh
    add     r0, #120h - 0FFh
    strh    r0, [r2]
    add     r1, #1
    add     r2, #2
    cmp     r1, #0Dh
    ble     @@case_copyright1_write_loop
    b       @@return_skip
@@case_copyright2:
    mov     r1, #0
    ldr     r2, =03001484h
    add     r2, #16h
@@case_copyright2_write_loop:
    mov     r0, r1
    add     r0, #0FFh
    add     r0, #140h - 0FFh
    strh    r0, [r2]
    add     r1, #1
    add     r2, #2
    cmp     r1, #11h
    ble     @@case_copyright2_write_loop
    b       @@return_skip
@@case_copyright3:
    mov     r1, #0
    ldr     r2, =03001484h
    add     r2, #12h
@@case_copyright3_write_loop:
    mov     r0, r1
    add     r0, #0FFh
    add     r0, #160h - 0FFh
    strh    r0, [r2]
    add     r1, #1
    add     r2, #2
    cmp     r1, #15h
    ble     @@case_copyright3_write_loop
    b       @@return_skip
@@case_copyright4:
    mov     r1, #0
    ldr     r2, =03001484h
    add     r2, #17h
@@case_copyright4_write_loop:
    mov     r0, r1
    add     r0, #0FFh
    add     r0, #180h - 0FFh
    strh    r0, [r2]
    add     r1, #1
    add     r2, #2
    cmp     r1, #11h
    ble     @@case_copyright4_write_loop
    b       @@return_skip
@@return_skip:
    ldrb    r0, [r5, CreditsLine_Skip]
    add     r0, #1
    b       @@return
@@return_twoline_skip:
    ldrb    r0, [r5, CreditsLine_Skip]
    add     r0, #2
@@return:
    pop     { r4-r5 }
    bx      lr
    .pool
.endfunc
.endarea

.org Credits
.area 2B98h
.incbin "data/credits.bin"
.endarea

.defineregion 08747900h, 1AC0h

.autoregion
    .align 2
@CreditsFont:
.incbin "data/credits-font.gfx"
.endautoregion

; Credits music changes

; Looping Credits Track replacement
.org CreditsMusicSpace
.area 0A70h
    .incbin "data/music/loopingcredits.bin"
.endarea

; Replace track 85 (Credits) with the new header at the end of the above bin file
.org 080A8FE4h
    .dw     087F0A4Ch

; start Samus Image music when credits are over
.autoregion
    .align 2
.func @PlaySamusImageMusic
    push    { r0-r3 }
    mov     r0, #50h
    mov     r1, #0Eh
    bl      Music_Play
    pop     { r0-r3 }
    ldr     r0, =#80A1CFDh
    bl      08000B88h ; A function call in the original code, purpose unknown
    bl      080A2554h ; Return to where the original function would have gone
    .pool
.endfunc
.endautoregion

; Hijack the original code location that starts the Samus Image display, to change the music
.org 080A254Eh
.area 06h, 0
    bl     @PlaySamusImageMusic
.endarea

.org CreditsMusicSpace + 0A70h
.area 750h
    .incbin "data/music/endscreen.bin"
.endarea

; Replace track 80 (unused) with the new header at the end of the above bin file
.org 080A8FBCh
    .dw     087F116Ch

; Replace track 79 (unused) with the credits finale. In the future we may
; try to include this at the very end of the credits.

.org CreditsMusicSpace + 11C0h
.area 320h
    .incbin "data/music/creditsfinale.bin"
.endarea

.org 080A8FB4h
    .dw     087F14C8h