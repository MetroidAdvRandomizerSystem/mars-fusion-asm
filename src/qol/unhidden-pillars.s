; Edits the extendable pillar functionality to allow showing additional graphics
; when the `RevealHiddenTilesFlag` is set to enabled

; `equ` cannot be used in files conditionally loaded.
.definelabel @VerticalVanillaPillarOamPointer, 0837A984h
.definelabel @HorizontalVanillaPillarOamPointer, 0837AB8Ch
.definelabel @HorizontalVanillaPillarExtendedOamPointer, 0837AB54h
.definelabel @HorizontalVanillaPillarExtendingOamPointer, 0837A9BCh

.autoregion DataFreeSpace
    .aligna 4
@VerticalRevealedPillarOamPointer:
    .dw     @VerticalRevealedPillarFrame1OamData
    .dw     0Eh
    .dw     @VerticalRevealedPillarFrame2OamData
    .dw     14h
    .dw     @VerticalRevealedPillarFrame1OamData
    .dw     0Eh
    .dw     @VerticalRevealedPillarFrame2OamData
    .dw     0Eh
    .dw     @VerticalRevealedPillarFrame3OamData
    .dw     4Bh
    .dw     @VerticalRevealedPillarFrame2OamData
    .dw     0Eh
    .dd     0
@HorizontalRevealedPillarOamPointer:
    .dw     @HorizontalRevealedPillarFrame1OamData
    .dw     0Eh
    .dw     @HorizontalRevealedPillarFrame2OamData
    .dw     14h
    .dw     @HorizontalRevealedPillarFrame1OamData
    .dw     0Eh
    .dw     @HorizontalRevealedPillarFrame2OamData
    .dw     0Eh
    .dw     @HorizontalRevealedPillarFrame3OamData
    .dw     4Bh
    .dw     @HorizontalRevealedPillarFrame2OamData
    .dw     0Eh
    .dd     0
@HorizontalPillarHiddenGfxOamPointer:
    ; This mimics the "vanilla" pillar animation cycle with blank gfx.
    ; Doing this fixes a bug where the the animation reads into other OAM data
    ; if the counters are not 0.
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     0Eh
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     14h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     0Eh
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     0Eh
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     32h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     0Eh
    .dd     0
@HorizontalRevealedPillarExtendingOamPointer:
    ; All these are necessary so that the sprite hitbox extends to its correct length
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrameZeroOamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame1OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame2OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame3OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame4OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame5OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame6OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame7OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame8OamData
    .dw     02h
    .dw     @HorizontalExtendingPillarFrame9OamData
    .dw     02h
    .dd     0
@HorizontalRevealedPillarExtendedOamPointer:
    .dw     @HorizontalExtendedPillarFrame1OamData
    .dw     0Eh
    .dw     @HorizontalExtendedPillarFrame2OamData
    .dw     14h
    .dw     @HorizontalExtendedPillarFrame1OamData
    .dw     0Eh
    .dw     @HorizontalExtendedPillarFrame3OamData
    .dw     0Eh
    .dw     @HorizontalExtendedPillarFrame4OamData
    .dw     32h
    .dw     @HorizontalExtendedPillarFrame3OamData
    .dw     0Eh
    .dd     0
.endautoregion

; Note: OBJ Priority for sprites is forced through the sprite rendering function
; and has no effect on the OAM pieces defined. Thus it is not necessary to include
; them here.
.autoregion DataFreeSpace
  .aligna 4
@VerticalRevealedPillarFrame1OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 218h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 218h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 21Bh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 21Bh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@VerticalRevealedPillarFrame2OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 219h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 219h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 21Ch) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 21Ch) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@VerticalRevealedPillarFrame3OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 21Ah) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 21Ah) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 21Dh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F7h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_8x8 | OBJ1_XFlip
    .dh     (OBJ2_Character   & 21Dh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)

@HorizontalRevealedPillarFrame1OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 238h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 238h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 23Bh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 23Bh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalRevealedPillarFrame2OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 239h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 239h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 23Ch) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 23Ch) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalRevealedPillarFrame3OamData:
    .dh     004h
    ;--- top side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 23Ah) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 008h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 23Ah) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    ;--- bottom side
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8
    .dh     (OBJ2_Character   & 23Dh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 001h) | OBJ1_Size_8x8 | OBJ1_YFlip
    .dh     (OBJ2_Character   & 23Dh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)

@HorizontalExtendingPillarFrameZeroOamData:
    .dh     001h
    ;---    Transparent graphic
    .dh     (OBJ0_YCoordinate & 000h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 21Eh) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame1OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Vertical
    .dh     (OBJ1_XCoordinate & 02Ah) | OBJ1_Size_8x16
    .dh     (OBJ2_Character   & 211h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame2OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Vertical
    .dh     (OBJ1_XCoordinate & 02Ch) | OBJ1_Size_8x16
    .dh     (OBJ2_Character   & 213h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame3OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Vertical
    .dh     (OBJ1_XCoordinate & 02Ch) | OBJ1_Size_8x16
    .dh     (OBJ2_Character   & 213h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame4OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Vertical
    .dh     (OBJ1_XCoordinate & 02Eh) | OBJ1_Size_8x16
    .dh     (OBJ2_Character   & 213h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame5OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Vertical
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_8x16
    .dh     (OBJ2_Character   & 213h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame6OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 02Ah) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 214h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame7OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 02Ch) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 214h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame8OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 02Eh) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 212h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendingPillarFrame9OamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 210h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)

@HorizontalExtendedPillarFrame1OamData:
    .dh     001
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 212h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendedPillarFrame2OamData:
    .dh     001
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 214h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendedPillarFrame3OamData:
    .dh     001
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 210h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
@HorizontalExtendedPillarFrame4OamData:
    .dh     001
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 030h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 216h) | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)

.endautoregion


.org 08379AF8h
.area 800h
.incbin "data/pillar.gfx"
.endarea

; Rewrites the vanilla PillarInit function. Allows dynamic loading of OAM data
; when RevealHiddenTilesFlag is true.
.org 0804AA48h
.area 118h, 0
    .align  2
.func PillarInit
    push    { r4-r6, lr }
    ldr     r6, =CurrentSprite
    mov     r5, #0
    ldr     r4, =RevealHiddenTilesFlag
    ldrb    r4, [r4]
    mov     r0, #Sprite_SpritesetSlotAndProperties
    add     r1, r0, r6
    ldrb    r1, [r1]
    cmp     r1, 12h
    beq     @@horizontal
    cmp     r1, 12h
    bgt     @@check_flipped
    cmp     r1, 11h
    beq     @@vertical

@@check_flipped:
    cmp     r1, 13h
    beq     @@horizontal_flipped
    b       @@no_match

@@vertical:
    strh    r5, [r6, #Sprite_BboxBottom]
    mov     r1, #40h
    mov     r2, #Sprite_DrawDistanceTop
    add     r2, r2, r6
    strb    r1, [r2]
    strb    r5, [r2, #Sprite_DrawDistanceBottom - Sprite_DrawDistanceTop]
    mov     r1, #8
    strb    r1, [r2, #Sprite_DrawDistanceHorizontal - Sprite_DrawDistanceTop]
    strb    r5, [r2, #Sprite_Work0 - Sprite_DrawDistanceTop]
    sub     r1, #1
    lsl     r1, #2
    strh    r1, [r6, #Sprite_BboxRight]
    neg     r1, r1
    lsl     r1, #10h
    lsr     r1, #10h
    strh    r1, [r6, #Sprite_BboxLeft]
    sub     r1, #20h
    strh    r1, [r6, #Sprite_BboxTop]
    cmp     r4, #1
    bne     @@load_vanilla_vertical_pillar_oam
@@load_revealed_vertical_pillar_oam:
    mov     r1, #SpriteStatus_IgnoreProjectiles >> 8
    lsl     r1, 8
    ldr     r3, =@VerticalRevealedPillarOamPointer
    mov     r0, #1
    mov     r2, #Sprite_BgPriority
    add     r2, r2, r6
    strb    r0, [r2]
    b       @@cont_vertical
@@load_vanilla_vertical_pillar_oam:
    ldr     r1, =SpriteStatus_NotDrawn|SpriteStatus_IgnoreProjectiles
    ldr     r3, =@VerticalVanillaPillarOamPointer
@@cont_vertical:
    ldr     r0, [r6]
    orr     r1, r0
    strh    r1, [r6, #Sprite_Status]
    b       @@all_common

@@horizontal_flipped:
    strh    r5, [r6, #Sprite_BboxLeft]
    mov     r1, #40h
    strh    r1, [r6, #Sprite_BboxRight]
    ldrh    r0, [r6, #Sprite_XPosition]
    sub     r0, #20h
    strh    r0, [r6, #Sprite_XPosition]
    b       @@horizontal_common

@@horizontal:
    mov     r1, #40h
    neg     r1, r1
    lsl     r1, #10h
    lsr     r1, #10h
    strh    r1, [r6, #Sprite_BboxLeft]
    strh    r5, [r6, #Sprite_BboxRight]
    ldrh    r0, [r6, #Sprite_XPosition]
    add     r0, #20h
    strh    r0, [r6, #Sprite_XPosition]
    mov     r1, #SpriteStatus_XFlip
    ldrh    r0, [r6, #Sprite_Status]
    orr     r1, r0
    strh    r1, [r6, #Sprite_Status]

@@horizontal_common:
    mov     r1, #8
    mov     r2, #Sprite_DrawDistanceTop
    add     r2, r2, r6
    strb    r1, [r2, #Sprite_DrawDistanceTop - Sprite_DrawDistanceTop]
    strb    r1, [r2, #Sprite_DrawDistanceBottom - Sprite_DrawDistanceTop]
    sub     r1, #7
    strb    r1, [r2, #Sprite_Work0 - Sprite_DrawDistanceTop]
    mov     r1, #40h
    strb    r1, [r2, #Sprite_DrawDistanceHorizontal - Sprite_DrawDistanceTop]
    mov     r1, #1Ch
    strh    r1, [r6, #Sprite_BboxBottom]
    neg     r1, r1
    lsl     r1, 10h
    lsr     r1, 10h
    strh    r1, [r6, #Sprite_BboxTop]
    ldrh    r0, [r6, #Sprite_YPosition]
    sub     r0, #20h
    strh    r0, [r6, #Sprite_YPosition]
    cmp     r4, #1
    bne     @@load_vanilla_horizontal_pillar_oam
@@load_revealed_horizontal_pillar_oam:
    mov     r1, #SpriteStatus_IgnoreProjectiles >> 8
    lsl     r1, 8
    ldr     r3, =@HorizontalRevealedPillarOamPointer
    mov     r0, #1
    mov     r2, #Sprite_BgPriority
    add     r2, r2, r6
    strb    r0, [r2]
    b       @@cont_horizontal
@@load_vanilla_horizontal_pillar_oam:
    ldr     r1, =SpriteStatus_NotDrawn|SpriteStatus_IgnoreProjectiles
    ldr     r3, =@HorizontalVanillaPillarOamPointer

@@cont_horizontal:
    ldr     r0, [r6]
    orr     r1, r0
    strh    r1, [r6, #Sprite_Status]
    b       @@all_common

@@all_common:
    str     r3, [r6, #Sprite_OamPointer]
    mov     r3, #Sprite_Health
    add     r2, r6, r3
    strh    r5, [r2]
    strb    r5, [r2, #Sprite_AnimationFrame - Sprite_Health]
    strb    r5, [r2, #Sprite_AnimationCounter - Sprite_Health]
    strb    r5, [r2, #Sprite_SamusCollision - Sprite_Health]
    add     r5, #1
    strb    r5, [r2, #Sprite_Pose - Sprite_Health]
    b       @@return

@@no_match:
    mov     r0, #0
    strh    r5, [r6]

@@return:
    pop     { r4-r6 }
    pop     { r0 }
    bx      r0
    .pool
.endfunc
.endarea

; Hijacks code in PillarIdle
.org 0804AB88h
.area 4
    bl      @PillarExtendedIdle
.endarea

; Hijacks code in Pillar Extending code
.org 0804ABF4h
.area 6h, 0
    bl      @VerticalExtendingPillarPosition
.endarea

.org 0804ABECh
.area 6h, 0
    bl      @HorizontalFlippedExtendingPillarPosition
.endarea

.org 0804ABE0h
.area 6h, 0
    bl      @HorizontalExtendingPillarPosition
.endarea

.org 0804AC1Ch
.area 0Ch, 0
    bl      @HorizontalExtendingPillarGfx
    b       0804AD5Ah
.endarea

.org 0804ACA4h
.area 4
    bl      @HorizontalExtendedPillarGfx
.endarea

.autoregion 08000000h, DataFreeSpace
    .align 2
@HorizontalExtendedPillarGfx:
    push    { r1, lr }
    mov     r0, #Area_NOC
    mov     r1, #26h
    bl      CheckCurrentAreaAndRoom
    cmp     r0, #1
    bne     @@vanilla
    ldr     r0, =@HorizontalRevealedPillarExtendedOamPointer
    b       @@cont
@@vanilla:
    ldr     r0, =@HorizontalVanillaPillarOamPointer
@@cont:
    str     r0, [r3, #Sprite_OamPointer]
    pop     { r1, pc }

@VerticalExtendingPillarPosition:
    push    { lr }
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@vertical_extending
    ldr     r1, =@VerticalVanillaPillarOamPointer
    str     r1, [r2, #Sprite_OamPointer]
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    mov     r0, #2
    strb    r0, [r1]
@@vertical_extending:
    ldrh    r0, [r2, #Sprite_YPosition]
    sub     r0, #4
    strh    r0, [r2, #Sprite_YPosition]
    pop     { pc }
    .pool

@HorizontalFlippedExtendingPillarPosition:
    push    { lr }
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@horizontal_flipped_extending
    mov     r0, #Area_NOC
    mov     r1, #26h
    bl      CheckCurrentAreaAndRoom
    cmp     r0, 1
    bne     @@vanilla
    ldr     r1, =@HorizontalPillarHiddenGfxOamPointer
    b       @@cont
@@vanilla:
   ldr     r1, =@HorizontalVanillaPillarOamPointer
@@cont:
    str     r1, [r2, #Sprite_OamPointer]
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    mov     r0, #2
    strb    r0, [r1]
@@horizontal_flipped_extending:
    ldrh    r0, [r2, #Sprite_XPosition]
    add     r0, #4
    strh    r0, [r2, #Sprite_XPosition]
    pop     { pc }
    .pool

@HorizontalExtendingPillarPosition:
    push    { lr }
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@horizontal_extending
    mov     r0, #Area_NOC
    mov     r1, #26h
    bl      CheckCurrentAreaAndRoom
    cmp     r0, 1
    bne     @@vanilla
    ldr     r1, =@HorizontalPillarHiddenGfxOamPointer
    b       @@cont
@@vanilla:
    ldr     r1, =@HorizontalVanillaPillarOamPointer
@@cont:
    str     r1, [r2, #Sprite_OamPointer]
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    mov     r0, #2
    strb    r0, [r1]
@@horizontal_extending:
    ldrh    r0, [r2, #Sprite_XPosition]
    sub     r0, #4
    strh    r0, [r2, #Sprite_XPosition]
    pop     { pc }
    .pool

@PillarExtendedIdle:
    push    { r0-r2 }
    mov     r0, #2
    ldr     r2, =CurrentSprite
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    strb    r0, [r1]
    strb    r0, [r1, #Sprite_Pose - Sprite_BgPriority]
    pop     { r0-r2 }
    bx      lr
    .pool

@HorizontalExtendingPillarGfx:
    push    { r0-r2, lr }
    ldr     r2, =CurrentSprite
    mov     r0, #Area_NOC
    ldr     r1, =CurrArea
    ldrb    r1, [r1]
    cmp     r1, r0
    bne     @@vanilla
    mov     r0, #26h
    ldr     r1, =CurrRoom
    ldrb    r1, [r1]
    cmp     r1, r0
    beq     @@revealed
@@vanilla:
    ldr     r1, =@HorizontalVanillaPillarExtendingOamPointer
    mov     r0, #Sprite_OamPointer
    add     r2, r2, r0
    str     r1, [r2]
    b       @@return
@@revealed:
    ldr     r1, =@HorizontalRevealedPillarExtendingOamPointer
    mov     r0, #Sprite_OamPointer
    add     r2, r2, r0
    str     r1, [r2]

@@return:
    pop     { r0-r2, pc }
    bx      lr
    .pool

.endautoregion
