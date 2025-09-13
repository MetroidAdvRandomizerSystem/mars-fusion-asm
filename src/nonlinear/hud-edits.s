; Allows drawing health greater than 2099 without graphical glitches
.org 0807276Ah
.area 4
    bl      @DrawEnergyForHud
.endarea

.if DEBUG
; increases max-health in debug menu
.org 0857618Ah
    .dh 9999
.endif

.autoregion
/*
    if (MaxEnergy < 2100) {
        DrawHudEnergy() //vanilla
        if (leftmost digit of current energy not clear (by checking contents of tile at 06010E0Dh)) {
            // This clears the "thousands" digit if health is decreasing from >=2100
            BitFill Tile with 00h
        }
    } else {
        Draw 4-digit energy value
    }
*/
    .align  2
.func @DrawEnergyForHud
    push    { lr }

    ldr     r0, =SamusUpgrades
    ldrh    r0, [r0, SamusUpgrades_MaxEnergy]
    ldr     r1, =2099
    cmp     r0, r1
    bgt     @@draw_numbers
    bl      DrawHudEnergy
    ldr     r0, =ExcessEnergyFlag
    mov     r1, #0
    strb    r1, [r0]

    ; Clear "Thousands" digit if health is decreasing
    ldr     r0, =06010E0Eh  ; Center Line of Tile
    ldr     r0, [r0]
    mov     r1, #00h
    mvn     r1, r1
    and     r0, r1          ; if data is all zeros
    beq     @@return
    sub     sp, #04h
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #03h
    mov     r1, #00h
    ldr     r2, =06010E00h
    mov     r3, #20h
    bl      BitFill
    add     sp, #04h
    b       @@return

@@draw_numbers:
    bl      DrawHudNumbers

@@return:
    pop     { r0 }
    bx      r0
    .pool
.endfunc

.func DrawHudNumbers
    push    { r4-r7, lr }
    mov     r4, r8
    mov     r5, r9
    mov     r6, r10
    push    { r4-r6 }
    sub     sp, #04
    mov     r0, #00
    str     r0, [sp]

    ldr     r4, =SamusUpgrades
    ldrh    r3, [r4, SamusUpgrades_MaxEnergy]
    mov     r9, r3
    ldrh    r3, [r4, SamusUpgrades_CurrEnergy]
    mov     r8, r3

    ldr     r0, =ExcessEnergyFlag
    ldrb    r0, [r0]
    mov     r10, r0
    cmp     r0, #0
    bne     @@max_thousands
    /*
    if (ExcessEnergyFlag != 0) {
        // ExcessEnergyFlag has been set so the appropraite graphics have already been cleared
        goto @@max_thousands
    } else {
        // ExcessEnergyFlag has not been set yet so we need to clear graphics first
        // and load the new "/MAX" text that goes next to "ENERGY"
    }
    */

@@clear_gfx:
    ; clear top e-tanks line
    ldr     r0, =083E851Ch
    ldr     r1, =06010A60h
    ldr     r2, =DMA_ENABLE | 10h * 5
    ldr     r6, =DMA3
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r2, [r6, DMA_CNT]
    ; clear bottom e-tanks line
    ldr     r1, =06010E00h
    ldr     r2, =DMA_ENABLE | 10h * 8
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r2, [r6, DMA_CNT]
    ; load new "max" text"
    ldr     r0, =@EnergyMaxText
    ldr     r1, =06010A60h
    ldr     r2, =DMA_ENABLE | 10h * 2
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r2, [r6, DMA_CNT]

; separate and load digits into RAM
@@max_thousands:
    ldr     r5, =MaxEnergyDigits
    mov     r0, r9
    mov     r1, #1000 >> 2
    lsl     r1, #02h
    bl      DivideUnsigned
    lsl     r0, #18h
    lsr     r0, #18h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

@@check_max_thousands_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Thousands]
    cmp     r0, r1
    beq     @@max_hundreds ; if thousands digit doesn't change, no need to store
    ; if it did change, store a bitflag indicating that we need to reload gfx
    strb    r0, [r5, EnergyDigits_Thousands]
    mov     r1, #1 << EnergyDigits_Thousands
    ldr     r0, [sp]
    orr     r0, r1
    str     r0, [sp]

@@max_hundreds:
    mov     r0, r9
    mov     r1, #100
    bl      DivideUnsigned
    lsl     r0, #10h
    lsr     r0, #10h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

@@check_max_hundreds_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Hundreds]
    cmp     r0, r1
    beq     @@max_tens ; if hundreds digit doesn't change, no need to store
    ; if it did change, store a bitflag indicating that we need to reload gfx
    strb    r0, [r5, EnergyDigits_Hundreds]
    mov     r1, #1 << EnergyDigits_Hundreds
    ldr     r0, [sp]
    orr     r0, r1
    str     r0, [sp]

@@max_tens:
    mov     r0, r9
    mov     r1, #10
    bl      DivideUnsigned
    lsl     r0, #10h
    lsr     r0, #10h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

@@check_max_tens_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Tens]
    cmp     r0, r1
    beq     @@max_ones ; if tens digit doesn't change, no need to store
    ; if it did change, store a bitflag indicating that we need to reload gfx
    strb    r0, [r5, EnergyDigits_Tens]
    mov     r1, #1 << EnergyDigits_Tens
    ldr     r0, [sp]
    orr     r0, r1
    str     r0, [sp]

@@max_ones:
    mov     r0, r9
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

@@check_max_ones_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Ones]
    cmp     r0, r1
    beq     @@start_draw_max_digits ; if tens digit doesn't change, no need to store
    ; if it did change, store a bitflag indicating that we need to reload gfx
    strb    r0, [r5, EnergyDigits_Ones]
    mov     r1, #1 << EnergyDigits_Ones
    ldr     r0, [sp]
    orr     r0, r1
    str     r0, [sp]

@@start_draw_max_digits:
    ; Check if we need to reload max digits graphics
    ldr     r0, [sp]
    mov     r1, #1111b
    bic     r1, r0
    beq     @@skip_drawing_max_digits

    ; Load "Max" graphics pointers
    ldr     r7, =AmmoDigitsGfx+AmmoDigitsGfx_Alt
    ldr     r6, =MaxEnergyDigitsGfxWRAM

    ; Draw digits of max health, 1st loop
    mov     r2, #00h    ; Tile Row
    mov     r3, r2      ; VRAM Offset
    ldrb    r4, [r5, EnergyDigits_Thousands]
    ldrb    r5, [r5, EnergyDigits_Hundreds]
    lsl     r4, #15h
    lsr     r4, #10h
    lsl     r5, #15h
    lsr     r5, #10h
    b       @@loop_left_digits

@@skip_drawing_max_digits:
    b       @@curr_energy

@@loop_left_digits:
/*
    This draws the graphics one row at a time to a temporary spot in IWRAM, then
    copies it into VRAM using DMA. This is effectively how vanilla draws ammo
    digits.
*/
    ; Max Health Thousands Digit
    ; The comments for this section also apply to the other digits
    add     r0, r4, r7  ; source graphics offset = digit offset + gfx ptr
    add     r1, r3, r6  ; dest = tile offset + wram
    ldrb    r0, [r0]    ; load gfx pixels from ROM (first 2 pixels)
    strb    r0, [r1]    ; store gfx pixels in RAM (first 2 pixels)
    add     r3, #01h    ; increment pixel offset within target tile (dst offset)
    lsl     r3, #18h    ; Ensure we only have 1 byte,
    lsr     r3, #18h    ;   otherwise we may inadvertently jump too far in memory.
    add     r4, #01h    ; increment pixel offset within thousands digit source tile (src offset)
    lsl     r4, #10h    ; ensure we only have 2 byte,
    lsr     r4, #10h    ;   otherwise we may incorrectly align to the source tile
    add     r0, r4, r7  ; src = digit + gfx
    add     r1, r3, r6  ; dest = tile offset + wram
    ldrb    r0, [r0]    ; load gfx pixels from ROM (second 2 pixels)
    strb    r0, [r1]    ; store gfx pixels in RAM
    add     r3, #01h    ; increment pixel offset within target tile
    lsl     r3, #18h    ; Ensure we only have 1 byte
    lsr     r3, #18h    ;   otherwise we may inadvertently jump too far in memory.
    add     r4, #03h    ; increment to next row of pixels for thousands digit
    lsl     r4, #10h
    lsr     r4, #10h    ; ensure we are properly aligned to the source graphics

    ; Max Health Hundreds Digit
    add     r0, r5, r7
    add     r1, r3, r6
    ldrb    r0, [r0]    ; load gfx pixels from ROM (first 2 pixels)
    strb    r0, [r1]    ; store gfx pixels in RAM (first 2 pixels)
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r5, #01h    ; increment pixel ofset within hundreds digit source tile (src offset)
    lsl     r5, #10h
    lsr     r5, #10h    ; ensure we are properly aligned to source graphics
    add     r0, r5, r7
    add     r1, r3, r6
    ldrb    r0, [r0]    ; load gfx pixels from ROM (second 2 pixels)
    strb    r0, [r1]    ; store gfx pixels in RAM (second 2 pixels)
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r5, #03h    ; increment to next row of pixels for hundreds digit
    lsl     r5, #10h
    lsr     r5, #10h

    add     r2, #01h
    cmp     r2, #07h    ; if < 8, loop again
    bls     @@loop_left_digits

    ; 2nd loop
    mov     r2, #00h
    mov     r3, #GFX_TILE
    ldr     r5, =MaxEnergyDigits
    ldrb    r4, [r5, EnergyDigits_Tens]
    ldrb    r5, [r5, EnergyDigits_Ones]
    lsl     r4, #15h
    lsr     r4, #10h
    lsl     r5, #15h
    lsr     r5, #10h

@@loop_right_digits:
    ; Max Health Tens Digit
    add     r0, r4, r7
    add     r1, r3, r6
    ldrb    r0, [r0]
    strb    r0, [r1]
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r4, #01h
    lsl     r4, #10h
    lsr     r4, #10h
    add     r0, r4, r7
    add     r1, r3, r6
    ldrb    r0, [r0]
    strb    r0, [r1]
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r4, #03h
    lsl     r4, #10h
    lsr     r4, #10h

    ; Max Health Ones Digit
    add     r0, r5, r7
    add     r1, r3, r6
    ldrb    r0, [r0]
    strb    r0, [r1]
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r5, #01h
    lsl     r5, #10h
    lsr     r5, #10h
    add     r0, r5, r7
    add     r1, r3, r6
    ldrb    r0, [r0]
    strb    r0, [r1]
    add     r3, #01h
    lsl     r3, #18h
    lsr     r3, #18h
    add     r5, #03h
    lsl     r5, #10h
    lsr     r5, #10h

    add     r2, #01h
    cmp     r2, #07h
    bls     @@loop_right_digits

    ; draws a static line to the right of max energy digits
    mov     r2, #01h                ; Tile Row
    mov     r3, #(GFX_TILE * 2) + 4 ; VRAM Offset

@@ending_line:
    mov     r0, #0Eh
    add     r1, r3, r6
    strb    r0, [r1]
    add     r3, #04h
    lsl     r3, #18h
    lsr     r3, #18h

    add     r2, #01h
    cmp     r2, #07h
    bls     @@ending_line

    ldr     r6, =DMA3
    ldr     r0, =MaxEnergyDigitsGfxWRAM
    ldr     r1, =06010AA0h ; Directly to the right of "Energy"
    ldr     r2, =DMA_ENABLE | 30h
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r0, [r6, DMA_CNT]

    b       @@curr_energy
    .pool

@@curr_energy:
    ldr     r5, =EnergyDigits
    ldr     r6, =DMA3
    ldr     r7, =EnergyDigitsGfx
@@curr_thousands:
    mov     r0, r8
    mov     r1, #1000 >> 2
    lsl     r1, #02h
    ; r0 / r1
    bl      DivideUnsigned
    lsl     r0, #18h
    lsr     r0, #18h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

    mov     r2, r10
    cmp     r2, #01
    beq     @@check_curr_thousands_digit_is_same
    b       @@load_curr_thousands_gfx
@@check_curr_thousands_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Thousands]
    cmp     r0, r1
    beq     @@curr_hundreds ; if thousands digit doesn't change, skip DMA
    strb    r0, [r5, EnergyDigits_Thousands]
@@load_curr_thousands_gfx:
    lsl     r0, #05h        ; r0 * 20h (length of 8x8 tile)
    add     r0, r7
    ldr     r1, =06010E00h
    ldr     r2, =DMA_ENABLE | 10h
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r0, [r6, DMA_CNT]

@@curr_hundreds:
    mov     r0, r8
    mov     r1, #100
    ; r0 / r1
    bl      DivideUnsigned
    lsl     r0, #10h
    lsr     r0, #10h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

    mov     r2, r10
    cmp     r2, #01
    beq     @@check_curr_hundreds_digit_is_same
    b       @@load_curr_hundreds_gfx
@@check_curr_hundreds_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Hundreds]
    cmp     r0, r1
    beq     @@curr_tens     ; if hundreds digit doesn't change, skip DMA
    strb    r0, [r5, EnergyDigits_Hundreds]
@@load_curr_hundreds_gfx:
    lsl     r0, #05h        ; r0 * 20h (length of 8x8 tile)
    add     r0, r7
    ldr     r1, =06010E20h
    ldr     r2, =DMA_ENABLE | 10h
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r0, [r6, DMA_CNT]

@@curr_tens:
    mov     r0, r8
    mov     r1, #10
    ; r0 / r1
    bl      DivideUnsigned
    lsl     r0, #10h
    lsr     r0, #10h
    mov     r1, #10
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

    mov     r2, r10
    cmp     r2, #01
    beq     @@check_curr_tens_digit_is_same
    b       @@load_curr_tens_gfx
@@check_curr_tens_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Tens]
    cmp     r0, r1
    beq     @@curr_ones     ; if tens digit doesn't change, skip DMA
    strb    r0, [r5, EnergyDigits_Tens]
@@load_curr_tens_gfx:
    lsl     r0, #05h        ; r0 * 20h (length of 8x8 tile)
    add     r0, r7
    ldr     r1, =06010E40h
    ldr     r2, =DMA_ENABLE | 10h
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r0, [r6, DMA_CNT]

@@curr_ones:
    mov     r0, r8
    mov     r1, #10
    ; r0 % r1
    bl      ModuloUnsigned
    lsl     r0, #18h
    lsr     r0, #18h

    mov     r2, r10
    cmp     r2, #01
    beq     @@check_curr_ones_digit_is_same
    b       @@load_curr_ones_gfx
@@check_curr_ones_digit_is_same:
    ldrb    r1, [r5, EnergyDigits_Ones]
    cmp     r0, r1
    beq     @@return    ; if ones digit doesn't change, skip DMA
    strb    r0, [r5, EnergyDigits_Ones]
@@load_curr_ones_gfx:
    lsl     r0, #05h    ; r0 * 20h (length of 8x8 tile)
    add     r0, r7
    ldr     r1, =06010E60h
    ldr     r2, =DMA_ENABLE | 10h
    str     r0, [r6, DMA_SAD]
    str     r1, [r6, DMA_DAD]
    str     r2, [r6, DMA_CNT]
    ldr     r0, [r6, DMA_CNT]


@@return:
    ldr     r0, =ExcessEnergyFlag
    mov     r1, #1
    strb    r1, [r0]
    add     sp, #04
    pop     { r4-r6 }
    mov     r10, r6
    mov     r9, r5
    mov     r8, r4
    pop     { r4-r7 }
    pop     { r0 }
    bx      r0
    .pool
.endfunc

    .align 4
@EnergyMaxText:
    .incbin "data/energy-max.gfx"


.endautoregion
