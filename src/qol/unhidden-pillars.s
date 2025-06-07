; Edits the extendable pillar functionality to allow showing additional graphics
; when the `RevealHiddenTilesFlag` is set to enabled

; `equ` cannot be used in files conditionally loaded.
.definelabel @VerticalVanillaPillarOamPointer, 0837A984h
.definelabel @HorizontalVanillaPillarOamPointer, 0837AB8Ch

.autoregion
    .aligna 4
@VerticalRevealedPillarOamPointer:
    .dw     @VerticalRevealedPillarOamData
    .dw     0FFh
    .dd     0
@HorizontalRevealedPillarOamPointer:
    .dw     @HorizontalRevealedPillarOamData
    .dw     0FFh
    .dd     0
.endautoregion

.autoregion
  .aligna 4
@VerticalRevealedPillarOamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F0h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 1F8h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 21Ah) | OBJ2_Priority_Highest | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)

@HorizontalRevealedPillarOamData:
    .dh     001h
    .dh     (OBJ0_YCoordinate & 0F8h) | OBJ0_Mode_Normal | OBJ0_Shape_Square
    .dh     (OBJ1_XCoordinate & 000h) | OBJ1_Size_16x16
    .dh     (OBJ2_Character   & 21Ch) | OBJ2_Priority_Highest | ((OBJ2_PaletteMask & 08h) << OBJ2_Palette)
.endautoregion


.org 08379AF8h
.incbin "data/pillar.gfx"

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


; Hijacks code in Pillar Extending code
.org 0804ABF4h
.area 6h, 0
    bl      @VerticalExtendingPillar
.endarea

.org 0804ABECh
.area 6h, 0
    bl      @HorizontalFlippedExtendingPillar
.endarea

.org 0804ABE0h
.area 6h, 0
    bl      @HorizontalExtendingPillar
.endarea

.autoregion
    .align 2
@VerticalExtendingPillar:
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
    bx      lr
    .pool

@HorizontalFlippedExtendingPillar:
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@horizontal_flipped_extending
    ldr     r1, =@HorizontalVanillaPillarOamPointer
    str     r1, [r2, #Sprite_OamPointer]
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    mov     r0, #2
    strb    r0, [r1]
@@horizontal_flipped_extending:
    ldrh    r0, [r2, #Sprite_XPosition]
    add     r0, #4
    strh    r0, [r2, #Sprite_XPosition]
    bx      lr
    .pool

@HorizontalExtendingPillar:
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@horizontal_flipped_extending
    ldr     r1, =@HorizontalVanillaPillarOamPointer
    str     r1, [r2, #Sprite_OamPointer]
    mov     r1, #Sprite_BgPriority
    add     r1, r2, r1
    mov     r0, #2
    strb    r0, [r1]
@@horizontal_flipped_extending:
    ldrh    r0, [r2, #Sprite_XPosition]
    sub     r0, #4
    strh    r0, [r2, #Sprite_XPosition]
    bx      lr
    .pool
.endautoregion
