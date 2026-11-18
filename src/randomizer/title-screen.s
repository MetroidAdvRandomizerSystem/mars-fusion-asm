.org TitleScreenTextPointersPointer
    .dw     TitleScreenTextPointers

.org 08086ADCh ; Unused Title Screen Debug Text Pointer Pointer
    .dw     TitleScreenTextPointers

.org 080871C0h ; Title Screen Debug Text Pointer Pointer
    .dw     TitleScreenTextPointers

;.org 0879C2C8h ; Title Screen Debug Text Pointer (vanilla)
;    .dw 08590C98h

.dataautoregion
    .align 4
TitleScreenTextPointers:
    .dw     TitleScreenText00, TitleScreenText01
    .dw     TitleScreenText02, TitleScreenText03
    .dw     TitleScreenText04, TitleScreenText05
    .dw     TitleScreenText06, TitleScreenText07
    .dw     TitleScreenText08, TitleScreenText09
    .dw     TitleScreenText0A, TitleScreenText0B
    .dw     TitleScreenText0C, TitleScreenText0D
    .dw     TitleScreenText0E, TitleScreenText0F
    .dw     TitleScreenText10, TitleScreenText11
    .dw     TitleScreenText12, TitleScreenText13
    .dw     0
    titlescreentext TitleScreenText00, ""
    titlescreentext TitleScreenText01, ""
    titlescreentext TitleScreenText02, ""
    titlescreentext TitleScreenText03, ""
    titlescreentext TitleScreenText04, ""
    titlescreentext TitleScreenText05, ""
    titlescreentext TitleScreenText06, ""
    titlescreentext TitleScreenText07, ""
    titlescreentext TitleScreenText08, ""
    titlescreentext TitleScreenText09, ""
    titlescreentext TitleScreenText0A, ""
    titlescreentext TitleScreenText0B, ""
    titlescreentext TitleScreenText0C, ""
    titlescreentext TitleScreenText0D, ""
    titlescreentext TitleScreenText0E, ""
    titlescreentext TitleScreenText0F, "" ; Leave empty for no OBJ Overlap
    titlescreentext TitleScreenText10, "" ; Leave empty for no OBJ overlap
.if DEBUG
    titlescreentext TitleScreenText11, "          DEBUG BUILD"
.else
    titlescreentext TitleScreenText11, ""
.endif
    titlescreentext TitleScreenText12, "" ; Leave empty for no OBJ Overlap
    titlescreentext TitleScreenText13, "" ; Leave empty for no OBJ overlap

    .dw 0
.endautoregion


; Modifying TitleScreenInit
.org 080870FCh
.area 08087108h - 080870FCh, 0
    bl  @TitleScreenInitHighjack
    b   08087108h
.endarea

; Modifying TitleScreenSpawningIn
.org 08087342h
.area 4
    ; fade-in BG2 as well as OBJ
    mov     r3, #1400h >> 5 ; DisplayBG2 | DisplayOBJ
    lsl     r3, #05
.endarea
.org 0808749Ah
.area 4
    ; when A or START is pressed to skip fade-in
    mov     r4, #1E00h >> 5
    lsl     r4, #05
.endarea
.org 0808751Ah
.area 4
    ; when A or START is pressed to skip fade-in
    mov     r2, #1E00h >> 5
    lsl     r2, #05
.endarea
.org 0808738Ch
.area 4
    ; Enables BG2 in Blending Control
    ;BG2_Target1|OBJ_Target1|AlphaBlending|BG0_Target2|BG1_Target2|BG3_Target2|BD_Target2
    .dw     2B54h
.endarea


; Modifying TitleScreenLoadDebugText
.org 080875D6h
    mov     r5, #(3A0h - 20h) >> 2 ; Where to search in VRAM for characters
.org 080875E2h
    nop ; Use ASCII Value as character offset
.org 08087604h
    .dw @TitleScreenDebugFont
.org 08087608h ; Changes location of loaded gfx in VRAM
    .dw 06007400h
.org 0808760Ch
    .dw DMA_ENABLE | DMA_TYPE_32BIT | 300h ; Size of GFX to load

.codeautoregion
.align 2
@TitleScreenInitHighjack:
    ; repurposes some VRAM to use BG2 instead of BG3 for writing text
    push    { lr }
    sub     sp, #4
    mov     r0, #10h ; bitSize
    str     r0, [sp]
    mov     r0, #3 ; DMA Channel
    mov     r1, #3A0h >> 4 ; Value
    lsl     r1, 4
    ldr     r2, =06005800h ; Dest
    mov     r3, #800h >> 4 ; Dest Size
    lsl     r3, #4
    bl      BitFill ; Fill allocated VRAM with a default character value
    add     sp, #4
    ldr     r0, =TitleScreenTextPointers
    ldr     r0, [r0]
    ldr     r1, =06005800h ; Dest of new VRAM Map Data
    mov     r2, #0
    bl      TitleScreenLoadDebugText
    ldr     r0, =(0Bh << 8) ; Enable BG2 with appropriate
    ldr     r1, =BG2CNT
    strh    r0, [r1]
    pop     { pc }
    .pool
.endautoregion

.dataautoregion
    .align 4
@TitleScreenDebugFont:
.incbin "data/titlescreendebugfont.gfx"
.endautoregion
