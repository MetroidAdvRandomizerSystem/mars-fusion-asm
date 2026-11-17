; Sub-zero containment changes
; Make Ridley crumble when Samus approaches from right
; Do not spawn Ridley Core-X
; Change environmental type to cold with knockback
; Remove crumble exit from room
; Make Door Lock Yellow, including in Dark Stairwell
; Remove wall near Ridley

;TODO Change other Hatch to Yellow.

; Set Environment type to cold with knockback
.org MainDeckLevels + 2Eh * LevelMeta_Size + LevelMeta_Effect
.db 0x5

; Modify Clipdata to remove wall, crumble exit, and change locks
.org readptr(MainDeckLevels + 2Eh * LevelMeta_Size + LevelMeta_Clipdata)
.area 05Ch
.incbin "data/rooms/S0-2E-Clip.rlebg"
.endarea

; Modify BG1 to remove wall and change locks
.org readptr(MainDeckLevels + 2Eh * LevelMeta_Size + LevelMeta_Bg1)
.area 137h
.incbin "data/rooms/S0-2E-BG1.rlebg"
.endarea


; Modify Clipdata to change locks
.org readptr(MainDeckLevels + 14h * LevelMeta_Size + LevelMeta_Clipdata)
.area 0D6h
.incbin "data/rooms/S0-14-Clip.rlebg"
.endarea

; Modify BG1 to change locks
.org readptr(MainDeckLevels + 14h * LevelMeta_Size + LevelMeta_Bg1)
.area 283h
.incbin "data/rooms/S0-14-BG1.rlebg"
.endarea


; Modify Spriteset to change Ridley GFX Position (Core-X does not spawn)
.org 082E609Ah
    .skip 3
    .db 4


; Check event
.org 08056E3Eh
    bl      @CheckRidleyCrumbledEvent

.codeautoregion
.align 2
.func @CheckRidleyCrumbledEvent
    ldr     r1, =MiscProgress
    ldr     r0, [r1, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_RidleyCrumbled
    cmp     r0, #1
    beq     @@RidleyAlreadyCrumbled
    bl      08056E4Ah ; Prep for Ridley to crumble
@@RidleyAlreadyCrumbled:    
    bl      08056E78h ; Ridley has crumbled already, go to that branch of logic
    .pool
.endfunc
.endautoregion

.org 08056F38h ; Modifying code in FrozenRidleySpawningX
    ; Don't actually spawn the X
    nop
    nop

.org 08056FE0h ; Don't reveal the block under Ridley, instead store that Ridley has Crumbled
    bl      @StoreRidleyHasCrumbled

.codeautoregion
.align 2
.func @StoreRidleyHasCrumbled
    push    { r0 - r2 }
    ldr     r2, =MiscProgress
    ldrh    r1, [r2, MiscProgress_StoryFlags]
    mov     r0, #1
    lsl     r0, StoryFlag_RidleyCrumbled
    orr     r0, r1
    strh    r0, [r2, MiscProgress_StoryFlags]
    pop     { r0 - r2 }
    bx      lr
    .pool
.endfunc
.endautoregion


.org 08056EC4h ; Modifying code in FrozenRidleyWaitForSamus
    ; Check if Samus is close to Ridley on the right instead of the left
    cmp     r0, #8