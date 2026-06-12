; Enables the in-game debug menu, accessed via the Samus status screen.
.definelabel DebugFlag, 03000000h
.definelabel UpdateFreeMovement_Debug, 0800E684h
.definelabel ProcessPauseButtonPress, 08068870h
.definelabel DebugMenuDrawNumber, 0807E520h
.definelabel DebugSectionInfo, 0858211Ch
.definelabel DebugMenuHealthAndAmmoMaxValues, 0857618Ah

.sym off
.definelabel NonGameplayFlag_PauseScreen, 2
.definelabel NoneGameplay_DebugMenuEditingValue, 7

.definelabel DebugSectionInfo_Top, 0
.definelabel DebugSectionInfo_Bottom, 1
.definelabel DebugSectionInfo_Left, 2
.definelabel DebugSectionInfo_Right, 3
.definelabel DebugSectionInfo_Section,4
.definelabel DebugSectionInfo_Len, 5h

.definelabel DebugSection_Beam, 0h
.definelabel DebugSection_Missile, 01h
.definelabel DebugSection_Bomb, 02h
.definelabel DebugSection_Suit, 03h
.definelabel DebugSection_Misc, 04h
.definelabel DebugSection_EnergyCurrent, 05h
.definelabel DebugSection_EnergyMax, 06h
.definelabel DebugSection_SupplyUnused, 07h
.definelabel DebugSection_Metroid, 07h
.definelabel DebugSection_MissileCurrent, 08h
.definelabel DebugSection_MissileMax, 09h
.definelabel DebugSection_PBombCurrent, 0Ah
.definelabel DebugSection_PBombMax, 0Bh
.definelabel DebugSection_AbilityCount, 0Ch
.definelabel DebugSection_Security, 0Dh
.definelabel DebugSection_Map, 0Eh
.definelabel DebugSection_Event, 0Fh
.definelabel DebugSection_SubEvent, 10h
.definelabel DebugSection_InGameTime, 11h
.definelabel DebugSection_QuickSave, 12h
.definelabel DebugSection_All, 0FFh
.sym on

.org 08076A2Eh ; Modifies code in PauseScreenInit
    mov     r0, r9
    strb    r0, [r4, #2]

; Modifies code in GunshipInit (checks if debug is enabled, we remove the check)
; Otherwise, Samus's pose does not get set properly and you never "appear" on screen from the gunship. Instead you would be spawned into the world invisible and instantly. Several things don't seem to work when samus is not displayed, such as screen scrolling.
.org 0801FC84h
.area 0801FC8Ch-., 0
.endarea

; Edits the BG Data to show "METROID" instead of "SUPPLY" under health.
.org 08573EA0h
.area 25Ch, 0
.incbin "data/debug-menu-vram.bin"
.endarea

; Enable vanilla debug flag, this is used for various purposes, but in this case
; we will see the invisible targets and triggers used in the game (such as for)
; x-parasite targets or killing required enemies for opening a door in a puzzle.
.org 0800E4FCh ; Modifies code in InitAndLoadGenerics
.area 4
    bl      EnableDebug
.endarea

.org 080805E4h ; Modifies code in Sram_ResetForDemo
.area 4
    bl      EnableDebug
.endarea

.org 0808070Ch ; Modifies code in Sram_CheckLoadSaveFile
.area 4
    bl      EnableDebug
.endarea

.org 08000874h ; Modifies code in InitializeGame
.area 4
    bl      EnableDebug
.endarea

; Modifies InGameSubroutine to add a check for user-activated noclip.
; vanilla functionality is restored in the highjack
.org 0800DDE0h
.area 0800DE04h-., 0
    ldr     r0, =@CheckEnableNoClip
    mov     pc, r0
    .pool
.endarea
.definelabel @ReturnFromNoClipCheck, org()+1


; Make Unused Supply section for metroids, edits the jump table
.org 0807D4CCh
.area 4
    .dw     0807D5D4h ; Use same case as Sections for Energy/Ammo
.endarea

.org DebugSectionInfo + (DebugSection_Metroid * DebugSectionInfo_Len)
.area 5
    ; position is in BG tiles which are 8x8 pixels in width/height
    ;       top, bottom, left, right, section_id
    .db     4, 4, 1Bh, 1Ch, DebugSection_Metroid
.endarea

; Editing Health/Ammo/Metroid values
.org 0807E2A8h
.area 0807E2C0h-., 0
    bl      @DebugMenuModifyHealthAndAmmoHighjack
.endarea

; Drawing health/Ammo/Metroid values
.org 0807E4A8h
    sub     r0, #DebugSection_Metroid
.org 0807E4AEh
    cmp     r0, #2
.org 0807E4B6h
.area 0807E4C8h-., 0
    ldr     r4, =@DebugMenuDrawHealthAndAmmoHighjack
    mov     pc, r4
    .pool
.endarea
.definelabel @ReturnFromDebugMenuDrawingHighjack, org()+1


; Allow speeding or slowing noclip speed
.org 0800E6F0h
.area 0800E702h-., 0
    ldr     r0, =@NoClipSpeedHighjack
    mov     pc, r0
    .pool
.endarea
.definelabel @ReturnFromNoClipSpeedHighjack, org()+1

; changes max health and ammo limits in debug menu
.org DebugMenuHealthAndAmmoMaxValues
.area 6
    .dh 9999    ; Energy
    .dh 999     ; Missile
    .dh 99      ; pbomb
.endarea


.autoregion
    .align 2
.func EnableDebug
    push    { r0-r1, lr }
    ldr     r1, =DebugFlag
    mov     r0, #01h
    strb    r0, [r1]
    pop     { r0-r1, pc }
    .pool
.endfunc

/* NOTES
    Hold Button_L and Button_R, Press Button_Select to enable No Clip.
    While in No Clip mode:
    * hold Button_R to move quickly
    * hold Button_L to move slowly
    * press Button_B to give yourself a speedbooster timer
    * press Button_Start to center the camera on Samus and disable room scrolls.
      This lets you see all GFX of the room, including the normally hidden borders.
    * press Button_Select to exit No Clip mode.
    * Samus cannot be damaged.
    * Samus cannot interact with level geometry, door transitions, or sprites.

*/
    .align 2
@CheckEnableNoClip:
    ldr     r0, =DebugFlag
    ldrb    r0, [r0]
    cmp     r0, #00h
    beq     @@if_false
    ldr     r0, =ToggleInput
    ldrh    r0, [r0]
    mov     r1, #1 << Button_Select
    and     r0, r1                  ; If Button_Select Pressed ...
    cmp     r0, #00h
    beq     @@if_false
    ldr     r0, =HeldInput
    ldrh    r0, [r0]
    mov     r1, #(1 << (Button_L | Button_R)) >> 4
    lsl     r1, #04h
    mov     r2, r1
    and     r0, r2                  ; ... while holding Button_L and Button_R ...
    cmp     r0, r1
    bne     @@if_false

@@if_true:
    ldr     r0, =TimeStopTimer
    ldrh    r0, [r0]
    cmp     r0, #00h
    bne     @@if_false
    ldr     r0, =SubGameMode1
    mov     r1, #06h                 ; ... then enable no-clip mode.
    strh    r1, [r0]
    b       @@return

@@if_false: ; Restore vanilla functionality
    ldr     r0, =ToggleInput
    ldr     r1, =ButtonAssignments
    ldrh    r2, [r0]
    ldrh    r0, [r1, #ButtonAssignments_Pause]
    and     r0, r2
    cmp     r0, #00h
    beq     @@return
    bl      ProcessPauseButtonPress
    cmp     r0, #0
    beq     @@return
    ldr     r0, =SubGameMode1
    ldrh    r1, [r0]
    add     r1, #01h
    strh    r1, [r0]
    ldr     r0, =NonGameplayFlag
    mov     r1, #NonGameplayFlag_PauseScreen
    strb    r1, [r0]

@@return:
    ldr     r1, =@ReturnFromNoClipCheck
    bx      r1
    .pool

    .align 2
; r9 contains refill type used for upper bounds of user-selected value
@DebugMenuModifyHealthAndAmmoHighjack:
@@check_max_energy:
    cmp     r3, #06h
    bne     @@check_metroids
    ldr     r5, =SamusUpgrades+SamusUpgrades_MaxEnergy
    sub     r2, r5, #02h
    mov     r8, r2
    mov     r1, #03h    ; length of numbers you can choose left/right
    mov     r7, #02h    ; Seems to indicate if you are editing a current/max value, 1/2 is current/max energy, 1/2 is missile, 3/4 is pbombs. May not be accurate.
    mov     r0, #00h
    mov     r9, r0      ; type of refill, 0 = energy, 1 = missile/metroid, 2 = pbomb
    b       @@end_checks

@@check_metroids:
    cmp     r3, #07h
    bne     @@check_next
    ldr     r5, =TotalMetroidCount
    mov     r8, r5
    ldr     r5, =PermanentUpgrades+PermanentUpgrades_InfantMetroids
    mov     r1, #01h    ; length of numbers you can choose length left/right
    mov     r7, #00h
    mov     r0, #01h
    mov     r9, r0      ; type of refill, 0 = energy, 1 = missile/metroid, 2 = pbomb

; skips remaining checks if match is found
@@end_checks:
.definelabel @@ModifySelectedValue, 0807E314h+1
    push    { r7 }
    ldr     r7, =@@ModifySelectedValue
    mov     lr, r7
    pop     { r7 }
    b       @@return

; jumps to max missiles check
@@check_next:
.definelabel @@CheckModifyMissiles, 0807E2C0h+1
    push    { r7 }
    ldr     r7, =@@CheckModifyMissiles
    mov     lr, r7
    pop     { r7 }

@@return:
    bx      lr
    .pool

    .align 2
@DebugMenuDrawHealthAndAmmoHighjack:
    ldr     r4, =PermanentUpgrades
    ldrb    r0, [r4, #PermanentUpgrades_InfantMetroids]
    mov     r1, #DebugSection_Metroid
    bl      DebugMenuDrawNumber
    ldr     r4, =SamusUpgrades
    ldrh    r0, [r4, #SamusUpgrades_CurrMissiles]
    mov     r1, #DebugSection_MissileCurrent
    bl      DebugMenuDrawNumber
    ldrh    r0, [r4, #SamusUpgrades_MaxMissiles]
    mov     r1, #DebugSection_MissileMax
    bl      DebugMenuDrawNumber
    ldr     r0, =@ReturnFromDebugMenuDrawingHighjack
    bx      r0
    .pool

    .align 2
@NoClipSpeedHighjack:
    ; r1 contains HeldInput
    ; r5 contains X-axis movement
    ; r7 contains Y-axis movement

; doubles speed
@@speed_up_noclip:
    mov     r0, #(1 << Button_R) >> 4
    lsl     r0, #04h
    and     r0, r1
    cmp     r0, #00h
    beq     @@slow_down_noclip
    lsl     r5, #01h
    lsl     r7, #01h

; halves speed
@@slow_down_noclip:
    mov     r0, #(1 << Button_L) >> 4
    lsl     r0, #04h
    and     r0, r1
    cmp     r0, #00h
    beq     @@give_speedbooster
    ldr     r0, =0FFFFh ; set mask
    lsl     r5, #10h
    asr     r5, #11h
    and     r5, r0      ; remove upper 16 bits
    lsl     r7, #10h
    asr     r7, #11h
    and     r7, r0

; sets speedbooster timer to time you would have after pressing down to store it normally
@@give_speedbooster:
    ; We can't use Button_A because it would always be immediately applied.
    mov     r0, #1 << Button_B
    and     r0, r1
    cmp     r0, #0
    beq     @@return_from_highjack
    push    { r1 }
    ldr     r0, =SamusAnimations
    mov     r1, #0B4h
    strb    r1, [r0, #SamusAnimations_ShinesparkTimer]
    pop     { r1 }

@@return_from_highjack:
    ldr     r0, =@ReturnFromNoClipSpeedHighjack
    bx      r0
    .pool
.endautoregion
