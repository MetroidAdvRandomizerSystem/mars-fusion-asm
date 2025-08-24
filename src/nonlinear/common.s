; Common functions for use in other non-linearity patches.

.autoregion
    .align 2
.func ObtainMajorLocation
    ldr     r3, =MiscProgress
    mov     r2, #1
    lsl     r2, r0
    ldr     r1, [r3, MiscProgress_MajorLocations]
    orr     r1, r2
    str     r1, [r3, MiscProgress_MajorLocations]
    ldr     r1, =MajorLocationItems
    lsl     r0, log2(MajorLocation_Size)
    add     r1, r0
    ; Store Location Jingle
    ldrb    r0, [r1, MajorLocation_Jingle]
    ldr     r3, =ItemJingleFlag
    strb    r0, [r3]
    ; Load Location Information
    ldrb    r0, [r1, MajorLocation_Upgrade]
    ldrb    r1, [r1, MajorLocation_Message]
    b       ObtainUpgrade
    .pool
.endfunc

.func ObtainMinorLocation
    ldr     r1, =MinorLocations
    lsl     r0, log2(MinorLocation_Size)
    add     r1, r0
    ; Store Location Jingle
    ldrb    r0, [r1, MinorLocation_Jingle]
    ldr     r3, =ItemJingleFlag
    strb    r0, [r3]
    ; Load Location Information
    ldrb    r0, [r1, MinorLocation_Upgrade]
    ldrb    r1, [r1, MinorLocation_Message]
    b       ObtainUpgrade
    .pool
.endfunc

.func IncrementMissileCount
; r0 contains the increment value.
    push    { r0 - r4 }
    ldr     r4, =SamusUpgrades
    ldrh    r3, [r4, SamusUpgrades_CurrMissiles]
    add     r3, r0
    asr     r2, r3, #1Fh
    bic     r3, r2
    ldr     r1, =#0FFFFh
    sub     r1, r3
    asr     r1, #1Fh
    orr     r3, r1
    strh    r3, [r4, SamusUpgrades_CurrMissiles]
    ldrh    r3, [r4, SamusUpgrades_MaxMissiles]
    add     r3, r0
    asr     r2, r3, #1Fh
    bic     r3, r2
    ldr     r1, =#0FFFFh
    sub     r1, r3
    asr     r1, #1Fh
    orr     r3, r1
    strh    r3, [r4, SamusUpgrades_MaxMissiles]
    pop     { r0 - r4 }
    bx      lr
    .pool
.endfunc

.func IncrementPBCount
; r0 contains the increment value.
    push    { r0 - r4 }
    ldr     r4, =SamusUpgrades
    ldrb    r3, [r4, SamusUpgrades_CurrPowerBombs]
    add     r3, r0
    asr     r2, r3, #1Fh
    bic     r3, r2
    mov     r1, #0FFh
    sub     r1, r3
    asr     r1, #1Fh
    orr     r3, r1
    strb    r3, [r4, SamusUpgrades_CurrPowerBombs]
    ldrb    r3, [r4, SamusUpgrades_MaxPowerBombs]
    add     r3, r0
    asr     r2, r3, #1Fh
    bic     r3, r2
    mov     r1, #255
    sub     r1, r3
    asr     r1, #1Fh
    orr     r3, r1
    strb    r3, [r4, SamusUpgrades_MaxPowerBombs]
    pop     { r0 - r4 }
    bx      lr
    .pool
.endfunc

.func ObtainUpgrade
    push    { r4-r5, lr }
    mov     r5, r1
    cmp     r0, #Upgrade_None
    bne     @@checkIceTrap
    mov     r0, #Message_NothingUpgrade
    b       @@checkAutoMessage
@@checkIceTrap:
    cmp     r0, #Upgrade_IceTrap
    bne     @@checkMetroid
    ; Freeze Samus regardless of suit type
    mov     r0, #Sfx_SpriteFrozen >> 1
    lsl     r0, #1
    bl      Sfx_PlayIfNotPlaying
    ; Add ice missile effect
    ldr     r2, =SamusState
    mov     r0, SamusState_HitboxTop
    ldsh    r1, [r2, r0]
    asr     r1, r1, 1
    ldrh    r0, [r2, SamusState_PositionY]
    add     r0, r1
    ldrh    r1, [r2, SamusState_PositionX]
    mov     r2, #Particle_IceMissileExplosion
    bl      SpawnParticleEffect
    mov     r0, #SamusPose_FrozenRequest
    bl      Samus_SetPose
@@skipFreeze:
    mov     r0, #Message_IceTrapUpgrade
    b       @@checkAutoMessage
@@checkMetroid:
    cmp     r0, #Upgrade_InfantMetroid
    bne     @@checkMajor
    ldr     r1, =PermanentUpgrades
    ldrb    r0, [r1, PermanentUpgrades_InfantMetroids]
    add     r0, #1
    strb    r0, [r1, PermanentUpgrades_InfantMetroids]
    cmp     r5, #Message_AutoMetroidHandler
    beq     @@setMetroidMessage
    cmp     r5, #Message_Auto
    bne     @@defaultMessage
@@setMetroidMessage:
    ldr     r1, =TotalMetroidCount
    ldrb    r1, [r1]
    cmp     r0, r1
    bge     @@lastMetroid
    ldr     r2, =RequiredMetroidCount
    ldrb    r2, [r2]
    cmp     r0, r2
    bge     @@sufficientMetroids
    cmp     r1, r2
    bne     @@metroidsNeeded
    sub     r0, r2, r0
    cmp     r0, #1
    beq     @@secondLastMetroid
    mov     r0, #Message_InfantMetroidsRemain
    b       @@setMessage
@@metroidsNeeded:
    mov     r0, #Message_InfantMetroidsNeeded
    b       @@setMessage
@@secondLastMetroid:
    mov     r0, #Message_SecondLastInfantMetroid
    b       @@setMessage
@@sufficientMetroids:
    mov     r0, #Message_SufficientInfantMetroids
    b       @@setMessage
@@lastMetroid:
    ; the last metroid is in captivity. the galaxy is at peace.
    mov     r0, #Message_LastInfantMetroid
    b       @@setMessage
@@checkMajor:
    cmp     r0, #Upgrade_IceBeam
    bhi     @@checkMinors
    cmp     r0, #Upgrade_Missiles
    beq     @@incrementMissileCountFromData
    cmp     r0, #Upgrade_PowerBombs
    beq     @@incrementPowerBombCountFromData
    b       @@obtainMajor
@@incrementMissileCountFromData:
    ldr     r4, =TankIncrements
    mov     r0, #(Tank_MissileDataIncrement - 1) << 1
    ldrsh   r0, [r4, r0]
    bl      IncrementMissileCount
    mov     r0, #Upgrade_Missiles
    b       @@obtainMajor
@@incrementPowerBombCountFromData:
    ldr     r4, =TankIncrements
    mov     r0, #(Tank_PowerBombDataIncrement - 1) << 1
    ldrsh   r0, [r4, r0]
    bl      IncrementPBCount
    mov     r0, #Upgrade_PowerBombs
@@obtainMajor:
    ldr     r4, =ReloadWeaponGfxFlag
    mov     r3, #1
    strb    r3, [r4]
    ldr     r4, =MajorUpgradeInfo
    lsl     r0, #2
    add     r4, r0
    ldr     r3, =SamusUpgrades
    ldrb    r2, [r4, MajorUpgradeInfo_Offset]
    ldrb    r0, [r4, MajorUpgradeInfo_Bitmask]
    ldrb    r1, [r3, r2]
    orr     r0, r1
    strb    r0, [r3, r2]
@@checkSetUpgradeBackup:
    cmp     r2, #SamusUpgrades_SecurityLevel
    bne     @@setUpgradeBackup
    ldr     r1, =SecurityLevelFlash
    strb    r0, [r1]
    b       @@setMajorMessage
@@setUpgradeBackup:
    ldr     r3, =PermanentUpgrades
    sub     r2, #SamusUpgrades_BeamUpgrades - PermanentUpgrades_BeamUpgrades
    ldrb    r1, [r3, r2]
    orr     r0, r1
    strb    r0, [r3, r2]
@@setMajorMessage:
    ldrb    r0, [r4, MajorUpgradeInfo_Message]
    b       @@checkAutoMessage
@@checkMinors:
    ldr     r3, =TankIncrements
    cmp     r0, #Upgrade_PowerBombTank
    bhi     @@return
    ldr     r4, =SamusUpgrades
    cmp     r0, #Upgrade_MissileTank
    bne     @@checkETank
    mov     r0, #(Tank_Missiles - 1) << 1
    ldrsh   r0, [r3, r0]
    bl      IncrementMissileCount
    mov     r0, #Message_MissileTankUpgrade
    b       @@checkAutoMessage
@@checkETank:
    cmp     r0, #Upgrade_EnergyTank
    bne     @@checkPBTank
    mov     r0, #(Tank_Energy - 1) << 1
    ldrsh   r3, [r3, r0]
    ldrh    r0, [r4, SamusUpgrades_MaxEnergy]
    add     r0, r3
    sub     r0, #1
    asr     r2, r0, #1Fh
    bic     r0, r2
    add     r0, #1
    ldr     r1, =#0FFFFh
    sub     r1, r0
    asr     r1, #1Fh
    orr     r0, r1
    strh    r0, [r4, SamusUpgrades_MaxEnergy]
    strh    r0, [r4, SamusUpgrades_CurrEnergy]
    mov     r0, #Message_EnergyTankUpgrade
    b       @@checkAutoMessage
@@checkPBTank:
    cmp     r0, #Upgrade_PowerBombTank
    bne     @@return
    mov     r0, #(Tank_PowerBombs - 1) << 1
    ldrsh   r0, [r3, r0]
    bl      IncrementPBCount
    mov     r0, #Message_PowerBombTankUpgrade
@@checkAutoMessage:
    cmp     r5, #Message_Auto
    beq     @@setMessage
    cmp     r5, #Message_AutoMetroidHandler
    bne     @@defaultMessage
    ldr     r1, =PermanentUpgrades
    ldrb    r0, [r1, PermanentUpgrades_InfantMetroids]
    b       @@setMetroidMessage
@@defaultMessage:
    mov     r0, r5
@@setMessage:
    ldr     r1, =LastAbility
    strb    r0, [r1]
@@return:
    pop     { r4-r5, pc }
    .pool
.endfunc

.func CheckTrueGoMode
    push    { lr }
    mov     r0, #Event_GoMode
    bl      CheckEvent
    cmp     r0, #1
    bne     @@return_false
    mov     r0, #Event_EscapeSequence
    bl      CheckEvent
    cmp     r0, #01
    beq     @@return_false
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh
    lsr     r0, #1Fh
    cmp     r0, #1
    bne     @@return_false
    ldrb    r0, [r1, SamusUpgrades_ExplosiveUpgrades]
    lsl     r0, #1Fh
    lsr     r0, #1Fh
    cmp     r0, #1
    bne     @@return_false
@@return_true:
    mov     r0, #1
    pop     { pc }
@@return_false:
    mov     r0, #0
    pop     { pc }
    .pool
.endfunc

.func CheckCurrentAreaAndRoom
    ; r0 should contain area id
    ; r1 should contain room id
    ; returns r0 as false (0) or true (1)
    push    { r3, lr }
    ldr     r3, =CurrArea
    ldrb    r3, [r3]
    cmp     r3, r0
    bne     @@return_false
    ldr     r3, =CurrRoom
    ldrb    r3, [r3]
    cmp     r3, r1
    bne     @@return_false
@@return_true:
    mov     r0, #1
    pop     { r3, pc }
@@return_false:
    mov     r0, #0
    pop     { r3, pc }
    .pool
.endfunc

.func CheckReloadWeaponGfx
    push    { lr }
    ldr     r1, =ReloadWeaponGfxFlag
    ldrb    r0, [r1]
    cmp     r0, #0
    beq     @@return

    bl      LoadBeamGfx
    bl      LoadMissileGfx
    mov     r0, #0
    strb    r0, [r1]
@@return:
    pop     { pc }
    .pool
.endfunc
.endautoregion

.org 0800DF38h
.area 4
    bl  @InGameSubroutineHighjack
.endarea

.autoregion
.align 2
.func @InGameSubroutineHighjack
    push    { lr }
    bl      CheckReloadWeaponGfx
    bl      080819ECh
    pop     { r0 }
    bx      r0
.endfunc
.endautoregion

.org 080798F8h
.area 48h, 0
    ; get message index
    ldr     r7, =MessagesByLanguage
    ldr     r6, =Language
    ldr     r1, =LastAbility
    ldrb    r2, [r1]
    b       08079952h
    .pool
.endarea

.autoregion
TotalMetroidCount:
    .db     5
RequiredMetroidCount:
    .db     4
.endautoregion

; Points to two subsequent bytes, Total then Required
.org MetroidCountPointer
.area 04h
    .dw     TotalMetroidCount
.endarea

.org MajorLocationsPointer
.area 04h
    .dw     MajorLocationItems
.endarea

.autoregion
MajorLocationItems:
        .db     Upgrade_Missiles, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_MorphBall, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_ChargeBeam, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SecurityLevel1, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_Bombs, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_HiJump, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_Speedbooster, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SecurityLevel2, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SuperMissiles, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_VariaSuit, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SecurityLevel3, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_IceMissiles, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_WideBeam, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_PowerBombs, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SpaceJump, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_PlasmaBeam, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_GravitySuit, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_SecurityLevel4, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_DiffusionMissiles, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_WaveBeam, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_ScrewAttack, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_InfantMetroid, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_InfantMetroid, Message_Auto, MajorItemJingle, 0h
        .db     Upgrade_InfantMetroid, Message_Auto, MajorItemJingle, 0h
.endautoregion

.org TankIncrementsPointer
    .dw     TankIncrements

.autoregion
.align 4
TankIncrements:
    .dh     5   ; missile tank
    .dh     100 ; energy tank
    .dh     2   ; power bomb tank
    .dh     10  ; missile data
    .dh     10  ; power bomb data
.endautoregion

.org StartingItems
.area 0Fh
    ; same format as SamusUpgrades struct
    .dh     99       ; current energy
    .dh     99       ; max energy
    .dh     0       ; current missiles
    .dh     0       ; max missiles
    .db     0       ; current power bombs
    .db     0       ; max power bombs
    .db     0        ; beam upgrades
    .db     0        ; explosive upgrades
    .db     0        ; suit upgrades
    .db     00001b   ; security level
    .db     1111111b ; maps downloaded
.endarea

.org EventUpgradeInfo + 18 * EventUpgradeInfo_Size
.area EventUpgradeInfo_Size
    .db     0
    .db     0
    .db     1 << SuitUpgrade_OmegaSuit
    .skip 5
.endarea

.autoregion
MajorUpgradeInfo:
    .db     00h
    .db     00h
    .db     Message_NothingUpgrade
    .skip 1
    .db     SamusUpgrades_SecurityLevel
    .db     1 << SecurityLevel_Lv0
    .db     Message_SecurityLevel0
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_Missiles
    .db     Message_MissileUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_MorphBall
    .db     Message_MorphBallUpgrade
    .skip 1
    .db     SamusUpgrades_BeamUpgrades
    .db     1 << BeamUpgrade_ChargeBeam
    .db     Message_ChargeBeamUpgrade
    .skip 1
    .db     SamusUpgrades_SecurityLevel
    .db     1 << SecurityLevel_Lv1
    .db     Message_SecurityLevel1
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_Bombs
    .db     Message_BombUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_HiJump
    .db     Message_HiJumpUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_Speedbooster
    .db     Message_SpeedboosterUpgrade
    .skip 1
    .db     SamusUpgrades_SecurityLevel
    .db     1 << SecurityLevel_Lv2
    .db     Message_SecurityLevel2
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_SuperMissiles
    .db     Message_SuperMissileUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_VariaSuit
    .db     Message_VariaSuitUpgrade
    .skip 1
    .db     SamusUpgrades_SecurityLevel
    .db     1 << SecurityLevel_Lv3
    .db     Message_SecurityLevel3
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_IceMissiles
    .db     Message_IceMissileUpgrade
    .skip 1
    .db     SamusUpgrades_BeamUpgrades
    .db     1 << BeamUpgrade_WideBeam
    .db     Message_WideBeamUpgrade
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_PowerBombs
    .db     Message_PowerBombUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_SpaceJump
    .db     Message_SpaceJumpUpgrade
    .skip 1
    .db     SamusUpgrades_BeamUpgrades
    .db     1 << BeamUpgrade_PlasmaBeam
    .db     Message_PlasmaBeamUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_GravitySuit
    .db     Message_GravitySuitUpgrade
    .skip 1
    .db     SamusUpgrades_SecurityLevel
    .db     1 << SecurityLevel_Lv4
    .db     Message_SecurityLevel4
    .skip 1
    .db     SamusUpgrades_ExplosiveUpgrades
    .db     1 << ExplosiveUpgrade_DiffusionMissiles
    .db     Message_DiffusionMissileUpgrade
    .skip 1
    .db     SamusUpgrades_BeamUpgrades
    .db     1 << BeamUpgrade_WaveBeam
    .db     Message_WaveBeamUpgrade
    .skip 1
    .db     SamusUpgrades_SuitUpgrades
    .db     1 << SuitUpgrade_ScrewAttack
    .db     Message_ScrewAttackUpgrade
    .skip 1
    .db     SamusUpgrades_BeamUpgrades
    .db     1 << BeamUpgrade_IceBeam
    .db     Message_IceBeamUpgrade
    .skip 1
.endautoregion
