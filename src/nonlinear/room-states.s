; Changes room state checks and door lock checks to check various
; progression flags instead of comparing against the linear event counter.

; NOTES:
; uninterruptable sequences:
;   operations deck escape (08-0A)
;   security robot in sector 3 (26-27)

; super missiles downloaded (26):
;   S3-06 => S3-18, S3-07 => S3-16
; security robot destroying data room (27):
;   S3-12 => S3-17
; en route to gunship (45):
;   S0-22 => S0-2B
; sector 5 flooded (4F):
;   S5-03 => S5-06, S5-05 => S5-10, S5-07 => S5-0F, S5-0D => S5-2C

.autoregion
    .align 2
.func CheckEvent
    ; WARNING: registers are not preserved. Take caution when relying on values
    ; prior to calling this function.
    ; Returns one if the passed event should be considered active or complete,
    ; otherwise returns zero.
    cmp     r0, #Event_GameEnd
    bhi     @@case_default
    mov     r1, r0
    ldr     r3, =@@eventCases
    mov     r2, #1 << (log2(35) - 1)
    ldrb    r0, [r3, 35 - (1 << log2(35))]
    cmp     r0, r1
    bhi     @@bsearch_loop
    add     r3, #35 - (1 << log2(35))
@@bsearch_loop:
    ldrb    r0, [r3, r2]
    cmp     r0, r1
    bhi     @@bsearch_iter
    add     r3, r2
@@bsearch_iter:
    lsr     r2, #1
    bne     @@bsearch_loop
    ldrb    r0, [r3]
    cmp     r0, r1
    bne     @@case_default
    add     r3, @@eventBranchTable - @@eventCases
    ldrb    r0, [r3]
    lsl     r0, #1
    ldr     r3, =MiscProgress
    ldr     r2, =PermanentUpgrades
    b       @@branch
@@case_default:
    mov     r0, #0
    bx      lr
    .pool
    .align 4
@@eventCases:
    .db     Event_OperationsElevatorOutage, Event_ArachnusAbsorbed
    .db     Event_MainElevatorOutage,       Event_ChargeCoreXAbsorbed
    .db     Event_StabilizersOnline,        Event_BombsDownloaded
    .db     Event_ZazabiAbsorbed,           Event_SerrisAbsorbed
    .db     Event_WaterLevelLowered,        Event_SerrisDebrief
    .db     Event_Lv2SecurityUnlock,        Event_BoxDefeated
    .db     Event_NocSaxEscaped,            Event_NocDataDestroyed
    .db     Event_MegaCoreXAbsorbed,        Event_IceMissilesDownloaded
    .db     Event_BoilerReactivated,        Event_BoilerMeltdownDebrief
    .db     Event_PowerBombsDownloaded,     Event_ArcSaxEscaped
    .db     Event_TrappedInElevator,        Event_ReactorOutage
    .db     Event_YakuzaAbsorbed,           Event_YakuzaDebrief
    .db     Event_TroSaxEscaped,            Event_NettoriAbsorbed
    .db     Event_NightmareAbsorbed,        Event_NoEntryWithoutAuthorization
    .db     Event_XboxAbsorbed,             Event_RestrictedSectorBreached
    .db     Event_RestrictedSectorDebrief,  Event_RidleyAbsorbed
    .db     Event_GoMode,                   Event_SaxDefeated
    .db     Event_EscapeSequence
.if 35 != @@eventBranchTable - @@eventCases
    ; can't treat this as a variable b/c armips is really dumb
    .error "Binary search tree size not updated"
.endif
@@eventBranchTable:
    .db     (@@case_08 - @@branch - 4) >> 1, (@@case_0A - @@branch - 4) >> 1
    .db     (@@case_0D - @@branch - 4) >> 1, (@@case_0F - @@branch - 4) >> 1
    .db     (@@case_10 - @@branch - 4) >> 1, (@@case_16 - @@branch - 4) >> 1
    .db     (@@case_19 - @@branch - 4) >> 1, (@@case_1D - @@branch - 4) >> 1
    .db     (@@case_20 - @@branch - 4) >> 1, (@@case_21 - @@branch - 4) >> 1
    .db     (@@case_23 - @@branch - 4) >> 1, (@@case_28 - @@branch - 4) >> 1
    .db     (@@case_31 - @@branch - 4) >> 1, (@@case_32 - @@branch - 4) >> 1
    .db     (@@case_33 - @@branch - 4) >> 1, (@@case_3A - @@branch - 4) >> 1
    .db     (@@case_3D - @@branch - 4) >> 1, (@@case_3E - @@branch - 4) >> 1
    .db     (@@case_42 - @@branch - 4) >> 1, (@@case_44 - @@branch - 4) >> 1
    .db     (@@case_46 - @@branch - 4) >> 1, (@@case_47 - @@branch - 4) >> 1
    .db     (@@case_49 - @@branch - 4) >> 1, (@@case_4B - @@branch - 4) >> 1
    .db     (@@case_4D - @@branch - 4) >> 1, (@@case_4E - @@branch - 4) >> 1
    .db     (@@case_51 - @@branch - 4) >> 1, (@@case_59 - @@branch - 4) >> 1
    .db     (@@case_5B - @@branch - 4) >> 1, (@@case_5C - @@branch - 4) >> 1
    .db     (@@case_5F - @@branch - 4) >> 1, (@@case_60 - @@branch - 4) >> 1
    .db     (@@case_63 - @@branch - 4) >> 1, (@@case_66 - @@branch - 4) >> 1
    .db     (@@case_67 - @@branch - 4) >> 1
.if ((@@case_67 - @@branch - 4) >> 1) >= (1 << 8)
    .error "Branch table overflowed"
.endif
    .align 2
@@branch:
    add     pc, r0
    nop
@@case_08:
    ; operations deck elevator sabotaged
    ; spritesets: S0-3C
    ; room states: S0-0D => S0-4A
    mov     r0, #0
    bx      lr
@@case_0A:
    ; arachnus defeated
    ; spritesets: S0-3C, S0-46
    ; locks: S0-26
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Arachnus
    lsr     r0, #1Fh
    bx      lr
@@case_0D:
    ; TODO (non-rando): main deck elevator door destroyed by SA-X
    ; room states: S0-29 => S0-2A, S0-4A => S0-0D
    mov     r0, #1
    bx      lr
@@case_0F:
    ; charge core-x defeated
    ; locks: S1-28
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_ChargeCoreX
    lsr     r0, #1Fh
    bx      lr
@@case_10:
    ; all atmospheric stabilizers reactivated
    ; spritesets: S1-05, S1-07
    ldrb    r0, [r3, MiscProgress_AtmoStabilizers]
    mov     r1, #11111b - 1
    sub     r0, r1, r0
    lsr     r0, #1Fh
    bx      lr
@@case_16:
    ; downloaded bombs
    ; room states: S2-03 => S2-1E, S2-07 => S2-1F
    ldrb    r0, [r2, PermanentUpgrades_ExplosiveUpgrades]
    lsl     r0, #1Fh - ExplosiveUpgrade_Bombs
    lsr     r0, #1Fh
    bx      lr
@@case_19:
    ; zazabi defeated, zoros in cocoons
    ; spritesets: S2-00, S2-04, S2-05, S2-09, S2-0A, S2-11, S2-13, S2-1F
    ; room states: S2-0D => S2-2E, S2-0E => S2-2C
    ; locks: S2-12
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Zazabi
    lsr     r0, #1Fh
    bx      lr
@@case_1D:
    ; serris defeated
    ; locks: S4-2A
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Serris
    lsr     r0, #1Fh
    bx      lr
@@case_20:
    ; sector 4 water level lowered
    ; spritesets: S4-03, S4-05, S4-06, S4-14, S4-15, S4-21, S4-24
    ldrh    r0, [r3, MiscProgress_StoryFlags]
    lsl     r0, #1Fh - StoryFlag_WaterLowered
    lsr     r0, #1Fh
    bx      lr
@@case_21:
    ; TODO (non-rando): sector 4 complete, gold crab locks inactive
    ; spritesets: S4-05
    mov     r0, #1
    bx      lr
@@case_23:
    ; green doors unlocked, sector 3 awakened
    ; spritesets: S3-00, S3-03, S3-05, S3-06, S3-0A, S3-1B, S3-1E
    mov     r0, #1
    bx      lr
@@case_28:
    ; box defeated
    ; locks: S3-17
    ldrh    r0, [r3, MiscProgress_StoryFlags]
    lsl     r0, #1Fh - StoryFlag_BoxDefeated
    ldr     r1, [r3, MiscProgress_MajorLocations]
    lsl     r1, #1Fh - MajorLocation_XBox
    orr     r0, r1
    lsr     r0, #1Fh
    bx      lr
@@case_31:
    ; TODO (non-rando): escaped sector 6 SA-X
    ; spritesets: S6-1C
    mov     r0, #1
    bx      lr
@@case_32:
    ; sector 6 data room destroyed
    ; spritesets: S6-19
    ldr     r0, [r3, MiscProgress_StoryFlags]
    lsl     r0, #1Fh - StoryFlag_NocDataDestroyed
    ldrh    r1, [r3, MiscProgress_MajorLocations]
    lsl     r1, #1Fh - MajorLocation_MegaCoreX
    orr     r0, r1
    lsr     r0, #1Fh
    bx      lr
@@case_33:
    ; defeated mega core-x
    ; spritesets: S6-03, S6-04, S6-05, S6-06, S6-07, S6-08, S6-0A
    ; room states: S6-09 => S6-21
    ; locks: S6-0D
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_MegaCoreX
    lsr     r0, #1Fh
    bx      lr
@@case_3A:
    ; downloaded ice missiles
    ; spritesets: S5-08, S5-18, S5-27
    ; maybe split S5-18 and S5-27
    mov     r0, #0
    bx      lr
@@case_3D:
    ; boiler cooling reactivated
    ; spritesets: S3-05, S3-0A, S5-00
    ; room states: S3-11 => S3-1D
    ; locks: S3-19
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_WideCoreX
    lsr     r0, #1Fh
    bx      lr
@@case_3E:
    ; save the animals
    ; spritesets: S0-0C, S0-12, S0-18
    mov     r0, #0
    bx      lr
@@case_42:
    ; downloaded power bombs
    ; spritesets: S5-08 (non-Randomized), S5-09, S5-18
    ; room states: S5-15 => S5-16, S5-27 => S5-28
    ldrb    r0, [r2, PermanentUpgrades_ExplosiveUpgrades]
    lsl     r0, #1Fh - ExplosiveUpgrade_PowerBombs
    lsr     r0, #1Fh
    bx      lr
@@case_44:
    ; escaped sector 5 SA-X
    ; spritesets: S5-2B
    mov     r0, #1
    bx      lr
@@case_46:
    ; main reactor shutdown
    ; spritesets: S0-15
    ; room states: S0-2B => S0-22
    mov     r0, #0
    bx      lr
@@case_47:
    ; en route to main reactor
    ; spritesets: S0-06, S0-30, S2-00, S2-04, S2-05, S2-09, S2-0A, S2-11,
    ;             S2-13, S2-1E, S2-1F, S2-2C, S2-2E
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r1, r0, #1Fh - MajorLocation_Yakuza
    lsl     r0, #1Fh - MajorLocation_Nettori
    orr     r0, r1
    lsr     r0, #1Fh
    bx      lr
@@case_49:
    ; yakuza defeated
    ; locks: S0-56 -> S0-33
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Yakuza
    lsr     r0, #1Fh
    bx      lr
@@case_4B:
    ; auxiliary power active
    ; spritesets: S0-31
@@case_4D:
    ; escaped main reactor SA-X
    ; spritesets: S2-3B
    mov     r0, #1
    bx      lr
@@case_4E:
    ; nettori defeated
    ; spritesets: S2-1B, S2-1C
    ; room states: S0-31 => S0-3B, S2-20 => S2-23, S2-39 => S2-3A
    ; locks: S2-0C -> S2-16, S2-16
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Nettori
    lsr     r0, #1Fh
    bx      lr
@@case_51:
    ; nightmare defeated
    ; spritesets: S4-24, S4-26 (removed in rando)
    ; locks: S5-14
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Nightmare
    lsr     r0, #1Fh
    bx      lr
@@case_59:
    ; no entry without authorization
    ; spritesets: S6-10
    ldr     r0, [r3, MiscProgress_MajorLocations]
    mvn     r0, r0
    lsl     r0, #1Fh - MajorLocation_XBox
    lsr     r0, #1Fh
    bx      lr
@@case_5B:
    ; xbox defeated
    ; locks: S6-10 -> S6-12, S6-10 -> S6-13
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_XBox
    lsr     r0, #1Fh
    bx      lr
@@case_5C:
    ; restricted sector invaded by sa-x (5C)
    ; S0-4E => S0-4F
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_RestrictedSectorBreached
    beq     @@return_true
    b       @@return_false
@@case_5F:
    ; restricted sector detached
    ; room states: S0-4D => S0-11
    mov     r0, #1
    bx      lr
@@case_60:
    ; ridley defeated
    ; spritesets: S1-04, S1-0C, S1-0F, S1-14 (moved to event 63 in rando)
    ; locks: S1-1B
    ldr     r0, [r3, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Ridley
    lsr     r0, #1Fh
    bx      lr
@@case_63:
    ; permission for orbit change granted
    ; spritesets: S0-0C, S0-0D, S0-0E, S0-15
    ; room states: S0-0D => S0-55
    ldrb    r0, [r2, PermanentUpgrades_InfantMetroids]
    ldr     r2, =RequiredMetroidCount
    ldrb    r2, [r2]
    cmp     r0, r2
    bge     @@return_true
    b       @@return_false
@@case_66:
    ; sa-x defeated
    ; locks: S0-06 -> S0-52
    ldr     r0, [r3, MiscProgress_StoryFlags]
    lsl     r0, #1Fh - StoryFlag_SaxDefeated
    lsr     r0, #1Fh
    bx      lr
@@case_67:
    ; escape sequence
    ; spritesets: S0-06, S0-07, S0-26, S0-2E
    ; room states: S0-03 => S0-04, S0-30 => S0-53
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_EscapeSequence
    bhs     @@return_true
@@return_false:
    mov     r0, #0
    bx      lr
@@return_true:
    mov     r0, #1
    bx      lr
    .pool
.endfunc
.endautoregion

.org 080648DAh
.area 26h, 0
    ; change spriteset handling to call custom event function
    mov     r5, r1
    cmp     r0, #0
    beq     @@check_spriteset_1
    bl      CheckEvent
    cmp     r0, #0
    beq     @@check_spriteset_1
    mov     r0, #2
    b       @@set_spriteset
@@check_spriteset_1:
    add     r0, sp, #20h
    ldrb    r0, [r0, LevelMeta_Spriteset1Event - 20h]
    cmp     r0, #0
    beq     @@set_spriteset_0
    bl      CheckEvent
    cmp     r0, #0
    beq     @@set_spriteset_0
    mov     r0, #1
    b       @@set_spriteset
.endarea
    .skip   0Ch
.area 38h, 0
@@set_spriteset_0:
    mov     r0, #0
@@set_spriteset:
    strb    r0, [r4]
    lsl     r0, #3
    add     r1, sp, #20h
    add     r1, r0
    ldrb    r0, [r1, LevelMeta_Spriteset0Id - 20h]
    ldr     r2, =SpritesetId
    strb    r0, [r2]
    ldr     r0, [r1, LevelMeta_Spriteset0 - 20h]
    str     r0, [r5, #08h]
    b       08064944h
    .pool
.endarea

.org 08069508h
.area 64h
    ; change door transition to call custom event function
    push    { r4-r7, lr }
    lsl     r4, r0, #18h
    lsr     r4, #18h
    ldr     r5, =VariableConnections
    mov     r6, #0
    ldr     r0, =CurrArea
    ldrb    r7, [r0]
@@loop:
    add     r1, r5, r6
    ldrb    r0, [r1, VariableConnection_Area]
    cmp     r0, r7
    bne     @@loop_inc
    ldrb    r0, [r1, VariableConnection_SourceDoor]
    cmp     r0, r4
    bne     @@loop_inc
    ldrb    r0, [r1, VariableConnection_Event]
    bl      CheckEvent
    cmp     r0, #0
    beq     @@loop_inc
    add     r0, r5, r6
    ldrb    r0, [r0, VariableConnection_DestinationDoor]
    b       @@return
@@loop_inc:
    add     r6, #VariableConnection_Size
    cmp     r6, #VariableConnections_Len * VariableConnection_Size
    blt     @@loop
    mov     r0, #0FFh
@@return:
    pop     { r4-r7, pc }
    .pool
.endarea

.org 08063D40h
.area 0A8h
    ; change door lock handling to call custom event function
    push    { r4-r7, lr }
    ldr     r4, =DoorLockEvents
    mov     r5, #DoorLockEvents_Len
    ldr     r0, =CurrArea
    ldrb    r6, [r0]
    ldr     r0, =CurrRoom
    ldrb    r7, [r0]
@@loop:
    ldrb    r0, [r4, DoorLockEvent_Area]
    cmp     r0, r6
    bne     @@loop_inc
    ldrb    r0, [r4, DoorLockEvent_Room]
    sub     r0, #1
    cmp     r0, r7
    bne     @@loop_inc
    ldrb    r0, [r4, DoorLockEvent_Event]
    bl      CheckEvent
    ldrb    r1, [r4, DoorLockEvent_Value]
    cmp     r0, r1
    bne     @@loop_inc
    ldrb    r0, [r4, DoorLockEvent_Bitmask]
    lsl     r0, #20h - 6
    lsr     r0, #20h - 6
    bl      LockHatches
    mov     r0, #1
    b       @@return
@@loop_inc:
    add     r4, #DoorLockEvent_Size
    sub     r5, #1
    bne     @@loop
    mov     r0, #0
@@return:
    pop     { r4-r7, pc }
    .pool
.endarea

.org DoorLockEvents
.region 12Ch
    .db     Event_ArachnusAbsorbed
    .db     Area_MainDeck, 26h + 1
    .db     111111b, 0
    .db     Event_ChargeCoreXAbsorbed
    .db     Area_SRX, 28h + 1
    .db     111111b, 0
    .db     Event_ZazabiAbsorbed
    .db     Area_TRO, 12h + 1
    .db     111111b, 0
    .db     Event_SerrisAbsorbed
    .db     Area_AQA, 2Ah + 1
    .db     111111b, 0
    .db     Event_BoxDefeated
    .db     Area_PYR, 17h + 1
    .db     111111b, 0
    .db     Event_MegaCoreXAbsorbed
    .db     Area_NOC, 0Dh + 1
    .db     111111b, 0
    .db     Event_BoilerReactivated
    .db     Area_PYR, 19h + 1
    .db     111111b, 0
    .db     Event_YakuzaAbsorbed
    .db     Area_MainDeck, 56h + 1
    .db     111111b, 0
    .db     Event_NettoriAbsorbed
    .db     Area_TRO, 0Ch + 1
    .db     000010b, 0
    .db     Event_NettoriAbsorbed
    .db     Area_TRO, 16h + 1
    .db     111111b, 0
    .db     Event_NightmareAbsorbed
    .db     Area_ARC, 14h + 1
    .db     111111b, 0
    .db     Event_XboxAbsorbed
    .db     Area_NOC, 10h + 1
    .db     111110b, 0
    .db     Event_RidleyAbsorbed
    .db     Area_SRX, 1Bh + 1
    .db     111111b, 0
    .db     Event_SaxDefeated
    .db     Area_MainDeck, 0Dh + 1
    .db     001000b, 0
    .db     Event_EscapeSequence
    .db     Area_MainDeck, 3Fh + 1
    .db     111111b, 1
.endregion

.autoregion
    .align 2
.func CheckLevelLayerOverrides
    ; TODO: override bg0 for boiler meltdown
    push    { r4, lr }
    mov     r4, r0
    ldr     r1, =CurrArea
    ldrb    r0, [r1]
    ldrb    r1, [r1, CurrRoom - CurrArea]
    cmp     r0, #Area_AQA
    bne     @@return
    cmp     r1, #1Ch
    bne     @@return
    mov     r0, #Event_WaterLevelLowered
    bl      CheckEvent
    cmp     r0, #0
    bne     @@return
    ldr     r1, =LevelData
    mov     r0, #46h
    strb    r0, [r1, LevelData_Bg0Props]
    ldr     r0, =08542384h
    str     r0, [r4, LevelMeta_Bg0 + LevelLayer_Data]
    mov     r0, #28h
    strb    r0, [r1, LevelData_Transparency]
    mov     r0, #01h
    strb    r0, [r1, LevelData_RoomEffect]
    mov     r0, #158h >> 1
    lsl     r0, #1
    strh    r0, [r1, LevelData_RoomEffectHeight]
    b       @@return
@@return:
    pop     { r4, pc }
    .pool
.endfunc
.endautoregion

.org 0806499Ch
.area 2Eh
    ; override bg0 for certain rooms
    mov     r0, sp
    bl      CheckLevelLayerOverrides
    b       080649CAh
.endarea

.org 08077084h
.area 30h
    ; change main deck minimap after lab detachment
    push    { r4, lr }
    mov     r4, r1
    cmp     r0, #Area_MainDeck
    bne     @@deflateMinimap
    mov     r0, #Event_RestrictedSectorDebrief
    bl      CheckEvent
    cmp     r0, #0
    beq     @@deflateMinimap
    mov     r0, #Area_Debug3
@@deflateMinimap:
    ldr     r1, =MinimapDataPointers
    lsl     r0, #2
    ldr     r0, [r1, r0]
    mov     r1, r4
    bl      DeflateVram
    pop     { r4, pc }
    .pool
.endarea
