; Repurposes nav room briefings for hints.

.org 0807A2E8h
.area 32h
    ; Use current nav room to index nav briefing array
    ldr     r0, =CurrentNavRoom
    ldrb    r2, [r0]
    lsl     r0, r2, #2
    lsl     r1, r2, #3
    add     r0, r1
    add     r0, r3, r0
    ldrb    r1, [r0, NavBriefing_Dialogue]
    cmp     r2, #1
    b       0807A31Ah
    .pool
.endarea

.org 0807A6D2h
    ; Don't set previous conversation flag for hints
    cmp     r0, #1
    bgt     0807A6E6h

.autoregion
    .align 2
.func CheckNavRoomLocked
    ldr     r1, =HintSecurityLevels
    ldr     r0, =CurrentNavRoom
    ldrb    r0, [r0]
    ldrb    r1, [r1, r0]
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_SecurityLevel]
    mvn     r0, r0
    lsr     r0, r1
    lsl     r0, #1Fh
    lsr     r0, #1Fh
    bx      lr
    .pool
.endfunc
.endautoregion

.org HintSecurityLevelsPointer
.area 04h
    .dw     HintSecurityLevels
.endarea

.autoregion
HintSecurityLevels:
    .fill 12, 0
.endautoregion

; Placeholder hint
.org 086CECB2h
.area 8Ch
    .stringn "No traces of your equipment\n"
    .string  "from this Navigation Room."
.endarea

.org 0879D514h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h
    .dw     086CECB2h, 086CECB2h

; Disable minimap targets by default
.org HintTargets
    .fill 8 * 11

.org 08575A6Ch
    ; Repurpose nav briefing array as a nav room lookup
    .db     Area_MainDeck, 11h
    .db     00h, 00h, 00h, 00h
    .db     02h
    .db     01h
    .db     00h
    .skip 3
    .db     Area_MainDeck, 0Ah
    .db     00h, 00h, 00h, 00h
    .db     03h
    .db     02h
    .db     00h
    .skip 3
    .db     Area_MainDeck, 21h
    .db     00h, 00h, 00h, 00h
    .db     04h
    .db     03h
    .db     00h
    .skip 3
    .db     Area_SRX, 03h
    .db     00h, 00h, 00h, 00h
    .db     05h
    .db     04h
    .db     00h
    .skip 3
    .db     Area_ARC, 03h
    .db     00h, 00h, 00h, 00h
    .db     06h
    .db     05h
    .db     00h
    .skip 3
    .db     Area_TRO, 03h
    .db     00h, 00h, 00h, 00h
    .db     07h
    .db     06h
    .db     00h
    .skip 3
    .db     Area_AQA, 03h
    .db     00h, 00h, 00h, 00h
    .db     08h
    .db     07h
    .db     00h
    .skip 3
    .db     Area_PYR, 03h
    .db     00h, 00h, 00h, 00h
    .db     09h
    .db     08h
    .db     00h
    .skip 3
    .db     Area_NOC, 03h
    .db     00h, 00h, 00h, 00h
    .db     0Ah
    .db     09h
    .db     00h
    .skip 3
    .db     Area_MainDeck, 39h
    .db     00h, 00h, 00h, 00h
    .db     0Bh
    .db     0Ah
    .db     00h
    .skip 3
    .db     Area_MainDeck, 43h
    .db     00h, 00h, 00h, 00h
    .db     0Ch
    .db     0Bh
    .db     00h
    .skip 3


; Navigation hint graphics

.autoregion

SpawnNavLockSprite:
    push    r14
    add     sp, #-0Ch
    ; Spawn lock sprite
    ldr     r1, =CurrentSprite
    ldrh    r0, [r1, #2]
    sub     r0, #0F0h
    str     r0, [sp]        ; Y position
    ldrh    r0, [r1, #4]
    str     r0, [sp, #4]    ; X position
    mov     r0, #0
    str     r0, [sp, #8]    ; Status
    mov     r0, NavLockSpriteId
    mov     r1, #0          ; Room slot
    mov     r2, NavLockGfxRow
    mov     r3, #20h        ; Property | spriteset slot
    bl      SpawnPrimarySprite
    ; Load graphics and palette
    mov     r4, #0
@@LoadGfxLoop:
    mov     r0, NavLockSpriteId
    mov     r1, NavLockGfxRow
    mov     r2, r4
    bl      LoadNewSpriteGfx
    add     r4, 1
    cmp     r4, NavLockGfxRowCount * 8
    bcc     @@LoadGfxLoop
    mov     r0, NavLockSpriteId
    mov     r1, NavLockGfxRow
    mov     r2, NavLockGfxRowCount
    bl      LoadNewSpritePal
    ; Overwritten code
    ldr     r5, =CurrentSprite
    mov     r2, r5
    ; Return
    add     sp, #0Ch
    pop     r15

NavLockAi:
    push    r4
    ldr     r3, =CurrentSprite
    mov     r4, r3
    add     r4, Sprite_Pose
    ; Check pose
    ldrb    r0, [r4]
    cmp     r0, #0
    beq     @@PoseInit
    cmp     r0, #1
    beq     @@PoseIdle
    b       @@Return
@@PoseInit:
    ; Get hint level for navigation room
    ldr     r2, =CurrentNavRoom
    ldrb    r0, [r2]
    ldr     r2, =HintSecurityLevels
    add     r2, r2, r0
    ldrb    r0, [r2]
    cmp     r0, #4
    bhi     @@RemoveAndReturn
    ; Get OAM address based on hint level
    ldr     r2, =NavLockOamPtrs
    lsl     r0, r0, #2
    add     r2, r2, r0
    ldr     r0, [r2]
    str     r0, [r3, Sprite_OamPointer]
    mov     r0, #0
    strb    r0, [r3, Sprite_AnimationCounter]
    strh    r0, [r3, Sprite_AnimationFrame]
    ; Update status
    ldrh    r0, [r3, Sprite_Status]
    mov     r1, #80h
    lsl     r1, r1, #8
    orr     r0, r1          ; Set "Ignore projectiles"
    mov     r1, SpriteStatus_NotDrawn
    mvn     r1, r1
    and     r0, r1          ; Remove "Not drawn"
    strh    r0, [r3, Sprite_Status]
    ; Set property
    mov     r2, r3
    add     r2, Sprite_Properties
    ldrb    r0, [r2]
    mov     r1, 1 << SpriteProps_NoCollision
    orr     r0, r1
    strb    r0, [r2]
    ; Set Samus property
    mov     r2, r3
    add     r2, Sprite_SamusCollision
    mov     r0, #0
    strb    r0, [r2]
    ; Set draw order
    mov     r2, r3
    add     r2, Sprite_DrawOrder
    mov     r0, #0Dh
    strb    r0, [r2]
    ; Set draw boundaries
    mov     r2, r3
    add     r2, Sprite_DrawDistanceTop
    mov     r0, #16
    strb    r0, [r2]
    add     r2, Sprite_DrawDistanceBottom - Sprite_DrawDistanceTop
    strb    r0, [r2]
    mov     r0, #32
    add     r2, Sprite_DrawDistanceHorizontal - Sprite_DrawDistanceBottom
    strb    r0, [r2]
    ; Set hitbox
    mov     r0, #4
    strh    r0, [r3, Sprite_BboxBottom]
    strh    r0, [r3, Sprite_BboxRight]
    mvn     r0, r0
    strh    r0, [r3, Sprite_BboxTop]
    strh    r0, [r3, Sprite_BboxLeft]
    ; Set pose to 1
    mov     r0, #1
    strb    r0, [r4]
    b       @@Return
@@RemoveAndReturn:
    mov     r0, #0
    strh    r0, [r3, Sprite_Status]
    b       @@Return
@@PoseIdle:
    ; Nothing to do for now
@@Return:
    pop     r4
    bx      r14
    .pool

; New data

.align 4
NavLockGfx:
    .incbin "data/nav-lock/nav-lock.gfx"
NavLockGfx_End:

.align 4
NavLockPal:
    .incbin "data/nav-lock/nav-lock-pal.bin"

.align 2
NavLockOam_L0_Frame0:
    nav_lock_oam_frame 0
NavLockOam_L1_Frame0:
    nav_lock_oam_frame 1
NavLockOam_L2_Frame0:
    nav_lock_oam_frame 2
NavLockOam_L3_Frame0:
    nav_lock_oam_frame 3
NavLockOam_L4_Frame0:
    nav_lock_oam_frame 4

.align 4
NavLockOam_L0:
    .dw NavLockOam_L0_Frame0, 0FFh
    .dw 0, 0
NavLockOam_L1:
    .dw NavLockOam_L1_Frame0, 0FFh
    .dw 0, 0
NavLockOam_L2:
    .dw NavLockOam_L2_Frame0, 0FFh
    .dw 0, 0
NavLockOam_L3:
    .dw NavLockOam_L3_Frame0, 0FFh
    .dw 0, 0
NavLockOam_L4:
    .dw NavLockOam_L4_Frame0, 0FFh
    .dw 0, 0

.align 4
NavLockOamPtrs:
    .dw NavLockOam_L0
    .dw NavLockOam_L1
    .dw NavLockOam_L2
    .dw NavLockOam_L3
    .dw NavLockOam_L4

.endautoregion

; Modified code

; Hijack NavigationPad_Init to spawn nav lock sprite
.org 0802A120h
    bl      SpawnNavLockSprite

; Modified data

.org SpriteGfxLengths + ((NavLockSpriteId - 10h) * 4)
    .dw NavLockGfx_End - NavLockGfx

.org PrimarySpriteAiPtrs + (NavLockSpriteId * 4)
    .dw NavLockAi + 1

.org SpriteGfxPtrs + ((NavLockSpriteId - 10h) * 4)
    .dw NavLockGfx

.org SpritePalettePtrs + ((NavLockSpriteId - 10h) * 4)
    .dw NavLockPal
