; Allows the start location to be changed from the hangar bay to another room.

.org 08064B84h
    ; Prevent new game init from wiping door id
    nop

.autoregion
    .align 2
.func SetSamusExitPos
    ldr     r0, =03000BE3h
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@set_exit_pos
    ldr     r1, =StartingLocation
    ldrh    r0, [r1, StartingLocation_XPos]
    strh    r0, [r5, SamusState_PositionX]
    ldrh    r0, [r1, StartingLocation_YPos]
    strh    r0, [r5, SamusState_PositionY]
    ldrb    r0, [r1, StartingLocation_Area]
    ldrb    r1, [r1, StartingLocation_Room]
    cmp     r0, #Area_MainDeck
    bne     @@set_music
    cmp     r1, #00h
    beq     @@return
@@set_music:
    push    { lr }
    bl      SetRoomMusic
    bl      Music_CheckPlay
    pop     { pc }
    .pool
@@set_exit_pos:
    ldrb    r2, [r4, #02h]
    ldrb    r0, [r4, #05h]
    add     r3, r0, #1
    lsl     r1, r2, #6
    mov     r0, #7
    ldrsb   r0, [r4, r0]
    add     r0, #8
    lsl     r0, #2
    add     r1, r0
    strh    r1, [r5, SamusState_PositionX]
    lsl     r1, r3, #6
    mov     r0, #8
    ldrsb   r0, [r4, r0]
    lsl     r0, #2
    add     r1, r0
    sub     r1, #1
    strh    r1, [r5, SamusState_PositionY]
@@return:
    bx      lr
.endfunc
.endautoregion

.org 08064E38h
.area 24h
    ldr     r5, =SamusState
    bl      SetSamusExitPos
    b       08064E5Ch
    .pool
.endarea

.org InitStartingMap
.area 88h
    ; set starting minimap position
    push    { r4-r5, lr }
    ldr     r5, =03000B86h
    ldr     r4, =MinimapData
    ldrb    r0, [r5]
    mov     r1, r4
    bl      08077084h
    ldr     r1, =DMA3
    str     r4, [r1, DMA_SAD]
    ldr     r0, =DecompressedMinimapData
    str     r0, [r1, DMA_DAD]
    ldr     r0, =#80000400h
    str     r0, [r1, DMA_CNT]
    ldr     r0, [r1, DMA_CNT]
    ldrb    r0, [r5]
    bl      0807576Ch
    ldr     r3, =StartingLocation
    ldrh    r0, [r3, StartingLocation_XPos]
    lsr     r0, #6
    sub     r0, #2
    ldr     r1, =#unsigned_reciprocal(15, 14)
    mul     r0, r1
    lsr     r4, r0, #14
    ldrh    r0, [r3, StartingLocation_YPos]
    lsr     r0, #6
    sub     r0, #2
    mov     r1, #unsigned_reciprocal(10, 11)
    mul     r0, r1
    lsr     r5, r0, #11
    ldr     r2, =0879B8BCh
    ldrb    r0, [r3, StartingLocation_Area]
    lsl     r0, #2
    ldr     r2, [r2, r0]
    ldrb    r1, [r3, StartingLocation_Room]
    lsl     r0, r1, #4
    sub     r0, r1
    lsl     r0, #2
    add     r2, r0
    add     r2, #20h
    ldr     r1, =MinimapX
    ldrb    r0, [r2, LevelMeta_MapX - 20h]
    add     r0, r4
    strb    r0, [r1]
    ldrb    r0, [r2, LevelMeta_MapY - 20h]
    add     r0, r5
    strb    r0, [r1, MinimapY - MinimapX]
    bl      080750A8h
    pop     { r4-r5, pc }
    .pool
.endarea

.autoregion
    .align 2
.func @CheckLoadSaveOrNewGame
    push    { r1 }
    ldr     r0, =#03000B8Bh
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@return_true
    ldr     r0, =#03000BE3h
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@return_false
    ldr     r1, =SamusState + 20h
    mov     r0, #StandingFlag_Sprite
    strb    r0, [r1, SamusState_StandingFlag - 20h]
@@return_true:
    mov     r0, #1
    b       @@return
@@return_false:
    mov     r0, #0
@@return:
    pop     { r1 }
    bx      lr
    .pool
.endfunc
.endautoregion

.org 0801F40Ah ; Modifying code in SavePlatformInit
.area 0Ch, 0
    ; check if save pad should start lowered
    bl      @CheckLoadSaveOrNewGame
    cmp     r0, #0
    bne     0801F416h
    b       0801F466h
.endarea

.org 08060DF8h ; Modifying code in CheckOnEventWithNavigationDisabled
.area 24h
    ; check if navigation pad should start inactive
    push    { lr }
    ldr     r0, =03000BE3h
    ldrb    r0, [r0]
    lsr     r0, #1
    bcs     @@check_lock
    ldr     r1, =SamusState + SamusState_Pose
    mov     r0, #3Ah
    strb    r0, [r1]
@@check_lock:
    bl      CheckNavRoomLocked
@@return:
    pop     { pc }
    .pool
.endarea

.org 08064600h ; Modifying code in LoadRoom
.area 0Ch, 0
    ; force recalculate bg position when loading save
.endarea

.org StartingLocation
.area StartingLocation_Size
    .db     Area_MainDeck
    .db     00h
    .db     00h
    .skip 1
    .dh     640h
    .dh     1DFh
.endarea

; Set the starting location area into Non-Gameplay RAM when drawing file select screen

; Hijack the original code location - part of FileSelectDrawFileInfo
.org 080A059Eh
.area 0Ah, 0
    bl     @SetTitleStartingArea
.endarea

.autoregion
    .align 4
.func @SetTitleStartingArea
    push    { r0-r3 }
    ldr     r0, =03001722h ; Non-Gameplay RAM Location where File Screen Code reads Starting Area
    ldr     r1, =StartingLocation
    ldrb    r2, [r1, StartingLocation_Area]
    strb    r2, [r0]
    ; Preserve original functionality
    pop     { r0-r3 }
    mov     r3, #0A7h
    lsl     r3, #2h
    add     r3, r5
    mov     r9, r3
    bl      080A0694h ; Return to where the original function would have gone
    .pool
.endfunc
.endautoregion


; Ensure Warping to Start does not overwrite your most recent save location when
; continuing from a Game Over.

; Hijack GameOver subroutine. This branch is called when you select "yes" to reload
.org 08000634h
.area 4
    bl      @ReloadFromGameOver
.endarea

; Copies the Backup Save over the Current Save
.org Sram_RestoreBackupSaveFileAfterReload
.area 0807FB84h - Sram_RestoreBackupSaveFileAfterReload, 0
    push    { lr }
    sub     sp, #4
    ldr     r1, =BackupSaveData
    ldr     r0, =SaveSlot
    ldrb    r0, [r0]
    lsl     r0, #2
    add     r1, r0
    ldr     r1, [r1]    ; Current Backup Save
    ldr     r2, =SaveData
    add     r0, r2
    ldr     r2, [r0]    ; Current Save
    mov     r3, #SaveData_Size >> 8
    lsl     r3, #8
    mov     r0, #10h    ; 10h bits
    str     r0, [sp]
    mov     r0, #3      ; DMA 3
    bl      DmaTransfer
@@return:
    add     sp, #4
    pop     { r0 }
    bx      r0
    .pool
.endarea

.autoregion
    .align 2
.func @ReloadFromGameOver
    push    { lr }
    bl      Sram_RestoreBackupSaveFileAfterReload
    bl      Sram_CheckLoadSaveFileWithBlank
    pop     { pc }
.endfunc
.endautoregion
