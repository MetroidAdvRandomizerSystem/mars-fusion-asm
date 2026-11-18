; Changes all combinations of beam upgrades to function in an intuitive way.
; Vanilla behavior expects all previous beam upgrades to have been obtained,
; causing behavior such as Plasma, Wave, and Ice firing three projectiles even
; without Wide Beam obtained.

.defineregion 08085E44h, 280h, 0    ; wide beam update/init functions
.defineregion 08083BACh, 988h, 0    ; beam hit sprite functions

.org LoadBeamGfx
.region 1B4h, 0
    push    { r4 }
    ldr     r1, =SamusUpgrades
    ldrb    r1, [r1, SamusUpgrades_BeamUpgrades]
    lsr     r0, r1, BeamUpgrade_ChargeBeam + 1
    bne     @@gfxLookup
    mov     r0, r1
    b       @@dmaGfx
@@gfxLookup:
    add     r2, =@@BeamGfxLookup
    lsl     r0, r1, 1Fh - BeamUpgrade_IceBeam
    lsr     r0, 1Fh - BeamUpgrade_PlasmaBeam
    lsl     r0, #1
    add     r2, r0
    ldrb    r0, [r2]
    ldrb    r1, [r2, #1]
@@dmaGfx:
    mov     r2, r0
    mov     r3, r1
    ldr     r4, =DMA3
    lsl     r0, r2, #8
    lsl     r1, r0, #2
    add     r0, r1
    ldr     r1, =0858B524h
    add     r1, r0
    str     r1, [r4, DMA_SAD]
    ldr     r0, =06011000h
    str     r0, [r4, DMA_DAD]
    ldr     r0, =80000140h
    str     r0, [r4, DMA_CNT]
    ldr     r0, [r4, DMA_CNT]
    mov     r0, #28h
    lsl     r0, #4
    add     r0, r1
    str     r0, [r4, DMA_SAD]
    ldr     r0, =06011400h
    str     r0, [r4, DMA_DAD]
    ldr     r0, =80000140h
    str     r0, [r4, DMA_CNT]
    ldr     r0, [r4, DMA_CNT]
    lsl     r0, r3, #5
    ldr     r1, =0858B464h
    add     r0, r1
    str     r0, [r4, DMA_SAD]
    ldr     r0, =05000240h
    str     r0, [r4, DMA_DAD]
    ldr     r0, =80000005h
    str     r0, [r4, DMA_CNT]
    ldr     r0, [r4, DMA_CNT]
    pop     { r4 }
    bx      lr
    .align 4
@@BeamGfxLookup:
    ; sprite and palette indices for every non-basic beam combination
    .db     2, 2    ; pure wide
    .db     3, 3    ; pure plasma
    .db     2, 2    ; pure wave
    .db     4, 4    ; wave + plasma
    .db     5, 5    ; pure ice
    .db     3, 5    ; ice + plasma
    .db     5, 5    ; ice + wave
    .db     4, 5    ; ice + wave + plasma
    .pool
.endregion

.org 080860C4h
.region 14Ch, 0
.func ChargedPlasmaBeam_Initialize
    push    { lr }
    ldr     r3, =CurrentProjectile
    mov     r0, #0
    strh    r0, [r3, Projectile_AnimFrame]
    strb    r0, [r3, Projectile_AnimCounter]
    mov     r0, #10h
    strb    r0, [r3, Projectile_VertOffscreenRange]
    strb    r0, [r3, Projectile_HorizOffscreenRange]
    ldrb    r0, [r3, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_Exploding
    bic     r0, r1
    mov     r1, 1 << ProjectileStatus_AffectsClipdata
    orr     r0, r1
    ldrb    r1, [r3, Projectile_Direction]
    cmp     r1, #0
    beq     @@setStatus
    lsr     r1, #1
    bcc     @@setStatus
    mov     r1, 1 << ProjectileStatus_VerticalFlip
    orr     r0, r1
@@setStatus:
    strb    r0, [r3, Projectile_Status]
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r2, 1Fh - BeamUpgrade_IceBeam
    lsr     r2, 1Fh - BeamUpgrade_PlasmaBeam
    ldr     r0, =@BeamGfxIndex
    ldrb    r1, [r0, r2]
    ; override bbox size if omega metroid is being fought
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_OmegaFight
    blt     @@get_bbox_size
    mov     r0, #0Ch
    b       @@set_bbox_size
@@get_bbox_size:
    ldr     r0, =@ChargedBeamBboxOffsets
    ldrb    r0, [r0, r1]
@@set_bbox_size:
    strh    r0, [r3, Projectile_BboxBottom]
    strh    r0, [r3, Projectile_BboxRight]
    neg     r0, r0
    strh    r0, [r3, Projectile_BboxTop]
    strh    r0, [r3, Projectile_BboxLeft]
    lsl     r0, r1, #2
    lsl     r1, r0, #1
    add     r0, r1
    ldrb    r1, [r4, Projectile_Direction]
    cmp     r1, #5
    ble     @@lookupOamPtr
    mov     r1, #0
@@lookupOamPtr:
    lsr     r1, #1
    lsl     r1, #2
    add     r0, r1
    ldr     r1, =@ChargedBeamOamPointers
    ldr     r0, [r1, r0]
    str     r0, [r4, Projectile_OamPointer]
    ldr     r0, =@ChargedBeamSfx
    ldrb    r0, [r0, r2]
    bl      Sfx_Play
    pop     { pc }
    .pool
.endfunc
.func ChargedPlasmaBeam_Update
    push    { r4, lr }
    ldr     r4, =CurrentProjectile
    ldrb    r0, [r4, Projectile_Part]
    cmp     r0, #0
    beq     @@skipWideLogic
    ldrb    r0, [r4, Projectile_Stage]
    cmp     r0, #8
    bhi     @@skipWideLogic
    bl      Beam_MoveParts
@@skipWideLogic:
    ldr     r1, =CurrentClipdataAction
    mov     r0, ClipdataAction_Beam
    strb    r0, [r1]
    bl      Projectile_UpdateClipdata
    cmp     r0, #0
    beq     @@noCollision
    mov     r0, #0
    strb    r0, [r4, Projectile_Status]
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    add     r2, r0, #5
    ldrh    r0, [r4, Projectile_PosY]
    ldrh    r1, [r4, Projectile_PosX]
    bl      SpawnParticleEffect
    b       @@return
@@noCollision:
    ldrb    r0, [r4, Projectile_Stage]
    lsr     r1, r0, #1
    bne     @@stageOver1
    bcs     @@stageEquals1
    bl      ChargedPlasmaBeam_Initialize
    b       @@incrementStage
@@stageOver1:
    cmp     r0, #8
    bhi     @@maxedStage
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@maxedStage:
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    lsl     r0, #2
    add     r0, #18h
    bl      Projectile_Move
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, 1Fh - BeamUpgrade_IceBeam
    lsr     r0, 1Fh - BeamUpgrade_PlasmaBeam
    ldr     r1, =@BeamGfxIndex
    ldrb    r0, [r1, r0]
    add     r0, #11h
    mov     r1, #3
    bl      Beam_SetTrail
    b       @@incrementTimer
@@stageEquals1:
    mov     r0, #10h
    bl      Projectile_Move
@@incrementStage:
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@incrementTimer:
    ldrb    r0, [r4, Projectile_Timer]
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
@@return:
    pop     { r4, pc }
    .pool
.endfunc
.endregion

.org 08086210h
.region 140h, 0
.func PlasmaBeam_Initialize
    push    { lr }
    ldr     r3, =CurrentProjectile
    mov     r0, #0
    strh    r0, [r3, Projectile_AnimFrame]
    strb    r0, [r3, Projectile_AnimCounter]
    mov     r0, #10h
    strb    r0, [r3, Projectile_VertOffscreenRange]
    strb    r0, [r3, Projectile_HorizOffscreenRange]
    ldrb    r0, [r3, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_Exploding
    bic     r0, r1
    mov     r1, 1 << ProjectileStatus_AffectsClipdata
    orr     r0, r1
    ldrb    r1, [r3, Projectile_Direction]
    cmp     r1, #0
    beq     @@setStatus
    lsr     r1, #1
    bcc     @@setStatus
    mov     r1, 1 << ProjectileStatus_VerticalFlip
    orr     r0, r1
@@setStatus:
    strb    r0, [r3, Projectile_Status]
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r2, 1Fh - BeamUpgrade_IceBeam
    lsr     r2, 1Fh - BeamUpgrade_PlasmaBeam
    ldr     r0, =@BeamGfxIndex
    ldrb    r1, [r0, r2]
    ; override bbox size if omega metroid is being fought
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_OmegaFight
    blt     @@get_bbox_size
    mov     r0, #0Ch
    b       @@set_bbox_size
@@get_bbox_size:
    ldr     r0, =@BeamBboxOffsets
    ldrb    r0, [r0, r1]
@@set_bbox_size:
    strh    r0, [r3, Projectile_BboxBottom]
    strh    r0, [r3, Projectile_BboxRight]
    neg     r0, r0
    strh    r0, [r3, Projectile_BboxTop]
    strh    r0, [r3, Projectile_BboxLeft]
    lsl     r0, r1, #2
    lsl     r1, r0, #1
    add     r0, r1
    ldrb    r1, [r4, Projectile_Direction]
    cmp     r1, #5
    ble     @@lookupOamPtr
    mov     r1, #0
@@lookupOamPtr:
    lsr     r1, #1
    lsl     r1, #2
    add     r0, r1
    ldr     r1, =@BeamOamPointers
    ldr     r0, [r1, r0]
    str     r0, [r4, Projectile_OamPointer]
    ldr     r0, =@BeamSfx
    ldrb    r0, [r0, r2]
    bl      Sfx_Play
    pop     { pc }
    .pool
.endfunc
.func PlasmaBeam_Update
    push    { r4, lr }
    ldr     r4, =CurrentProjectile
    ldrb    r0, [r4, Projectile_Part]
    cmp     r0, #0
    beq     @@skipWideLogic
    ldrb    r0, [r4, Projectile_Stage]
    cmp     r0, #8
    bhi     @@skipWideLogic
    bl      Beam_MoveParts
@@skipWideLogic:
    ldr     r1, =CurrentClipdataAction
    mov     r0, ClipdataAction_Beam
    strb    r0, [r1]
    bl      Projectile_UpdateClipdata
    cmp     r0, #0
    beq     @@noCollision
    mov     r0, #0
    strb    r0, [r4, Projectile_Status]
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    add     r2, r0, #5
    ldrh    r0, [r4, Projectile_PosY]
    ldrh    r1, [r4, Projectile_PosX]
    bl      SpawnParticleEffect
    b       @@return
@@noCollision:
    ldrb    r0, [r4, Projectile_Stage]
    lsr     r1, r0, #1
    bne     @@stageOver1
    bcs     @@stageEquals1
    bl      PlasmaBeam_Initialize
    b       @@incrementStage
@@stageOver1:
    cmp     r0, #8
    bhi     @@maxedStage
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@maxedStage:
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    lsl     r0, #2
    add     r0, #18h
    bl      Projectile_Move
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsr     r1, r0, BeamUpgrade_PlasmaBeam + 1
    bcs     @@incrementTimer
    lsr     r1, r0, BeamUpgrade_IceBeam + 1
    bcc     @@incrementTimer
    mov     r0, #0Eh
    mov     r1, #3
    bl      Beam_SetTrail
    b       @@incrementTimer
@@stageEquals1:
    mov     r0, #10h
    bl      Projectile_Move
@@incrementStage:
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@incrementTimer:
    ldrb    r0, [r4, Projectile_Timer]
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
@@return:
    pop     { r4, pc }
    .pool
.endfunc
.endregion

.org 08086350h
.region 184h, 0
.func ChargedWaveBeam_Initialize
    push    { lr }
    ldr     r3, =CurrentProjectile
    mov     r0, #0
    strh    r0, [r3, Projectile_AnimFrame]
    strb    r0, [r3, Projectile_AnimCounter]
    mov     r0, #10h
    strb    r0, [r3, Projectile_VertOffscreenRange]
    strb    r0, [r3, Projectile_HorizOffscreenRange]
    ldrb    r0, [r3, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_Exploding
    bic     r0, r1
    mov     r1, (1 << ProjectileStatus_IgnoreCollision) \
        | (1 << ProjectileStatus_AffectsClipdata)
    orr     r0, r1
    ldrb    r1, [r3, Projectile_Direction]
    cmp     r1, #0
    beq     @@setStatus
    lsr     r1, #1
    bcc     @@setStatus
    mov     r1, 1 << ProjectileStatus_VerticalFlip
    orr     r0, r1
@@setStatus:
    strb    r0, [r3, Projectile_Status]
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r2, 1Fh - BeamUpgrade_IceBeam
    lsr     r2, 1Fh - BeamUpgrade_PlasmaBeam
    ldr     r0, =@BeamGfxIndex
    ldrb    r1, [r0, r2]
    ; override bbox size if omega metroid is being fought
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_OmegaFight
    blt     @@get_bbox_size
    mov     r0, #0Ch
    b       @@set_bbox_size
@@get_bbox_size:
    ldr     r0, =@ChargedBeamBboxOffsets
    ldrb    r0, [r0, r1]
@@set_bbox_size:
    strh    r0, [r3, Projectile_BboxBottom]
    strh    r0, [r3, Projectile_BboxRight]
    neg     r0, r0
    strh    r0, [r3, Projectile_BboxTop]
    strh    r0, [r3, Projectile_BboxLeft]
    lsl     r0, r1, #2
    lsl     r1, r0, #1
    add     r0, r1
    ldrb    r1, [r4, Projectile_Direction]
    cmp     r1, #5
    ble     @@lookupOamPtr
    mov     r1, #0
@@lookupOamPtr:
    lsr     r1, #1
    lsl     r1, #2
    add     r0, r1
    ldr     r1, =@ChargedBeamOamPointers
    ldr     r0, [r1, r0]
    str     r0, [r4, Projectile_OamPointer]
    ldr     r0, =@ChargedBeamSfx
    ldrb    r0, [r0, r2]
    bl      Sfx_Play
    pop     { pc }
    .pool
.endfunc
.func ChargedWaveBeam_Update
    push    { r4, lr }
    ldr     r4, =CurrentProjectile
    ldrb    r0, [r4, Projectile_Part]
    cmp     r0, #0
    beq     @@skipWideLogic
    ldrb    r0, [r4, Projectile_Stage]
    cmp     r0, #8
    bhi     @@skipWideLogic
    bl      WaveBeam_MoveParts
@@skipWideLogic:
    ldr     r1, =CurrentClipdataAction
    mov     r0, ClipdataAction_Beam
    strb    r0, [r1]
    bl      WaveBeam_UpdateClipdata
    ldrb    r0, [r4, Projectile_Stage]
    lsr     r1, r0, #1
    bne     @@stageOver1
    bcs     @@stageEquals1
    bl      ChargedWaveBeam_Initialize
    b       @@incrementStage
@@stageOver1:
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    lsl     r0, #2
    add     r0, #18h
    bl      Projectile_Move
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh - BeamUpgrade_IceBeam
    lsr     r0, #1Fh - BeamUpgrade_PlasmaBeam
    ldr     r1, =@BeamGfxIndex
    ldrb    r0, [r1, r0]
    add     r0, #11h
    mov     r1, #3
    bl      Beam_SetTrail
    b       @@incrementTimer
@@stageEquals1:
    mov     r0, #10h
    bl      Projectile_Move
@@incrementStage:
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@incrementTimer:
    ldrb    r0, [r4, Projectile_Timer]
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
@@return:
    pop     { r4, pc }
    .pool
.endfunc
.endregion

.org WaveBeam_MoveParts
.area 48h, 0
    push    { r4-r6, lr }
    ldr     r5, =CurrentProjectile
    ldrb    r0, [r5, Projectile_Timer]
    mov     r4, #07h
    and     r4, r0
    ldr     r1, =0858B3CCh
    lsl     r0, r4, #1
    ldrsh   r6, [r1, r0]
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_BeamUpgrades]
    lsr     r0, BeamUpgrade_WideBeam + 1
    bcs     @@wideWave
    lsr     r6, #1
@@wideWave:
    ldrb    r2, [r5, Projectile_Part]
    cmp     r2, #0
    beq     @@positive_offset
    neg     r6, r6
@@positive_offset:
    lsl     r0, r6, #3
    sub     r0, r6
    mov     r1, #signed_reciprocal(5, 10)
    mul     r0, r1
    asr     r0, #10
    lsr     r1, r0, #1Fh
    add     r3, r0, r1
    b       0808257Ah
    .pool
.endarea

.org 08012B54h
.area 4Ch
    ; wave beam core-x beam movement
    push    { r4-r6, lr }
    ldr     r5, =CurrentSprite
    mov     r0, #Sprite_Work1
    ldrb    r0, [r5, r0]
    mov     r4, #07h
    and     r4, r0
    ldr     r1, =0858B3CCh
    lsl     r0, r4, #1
    ldrsh   r6, [r1, r0]
    ldrb    r2, [r5, Sprite_RoomSlot]
    cmp     r2, #0
    beq     @@positive_offset
    neg     r6, r6
@@positive_offset:
    lsl     r0, r6, #3
    sub     r0, r6
    mov     r1, #5
    mov     r1, #signed_reciprocal(5, 10)
    mul     r0, r1
    asr     r0, #10
    lsr     r1, r0, #1Fh
    add     r3, r0, r1
    b       08012BA6h
    .pool
.endarea

.org 0858B3CCh
    .dh     24, 16, 8, 4, -4, -8, -16, -24

.org 080864D4h
.region 178h, 0
.func WaveBeam_Initialize
    push    { lr }
    ldr     r3, =CurrentProjectile
    mov     r0, #0
    strh    r0, [r3, Projectile_AnimFrame]
    strb    r0, [r3, Projectile_AnimCounter]
    mov     r0, #10h
    strb    r0, [r3, Projectile_VertOffscreenRange]
    strb    r0, [r3, Projectile_HorizOffscreenRange]
    ldrb    r0, [r3, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_Exploding
    bic     r0, r1
    mov     r1, (1 << ProjectileStatus_IgnoreCollision) \
        | (1 << ProjectileStatus_AffectsClipdata)
    orr     r0, r1
    ldrb    r1, [r3, Projectile_Direction]
    cmp     r1, #0
    beq     @@setStatus
    lsr     r1, #1
    bcc     @@setStatus
    mov     r1, 1 << ProjectileStatus_VerticalFlip
    orr     r0, r1
@@setStatus:
    strb    r0, [r3, Projectile_Status]
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r2, 1Fh - BeamUpgrade_IceBeam
    lsr     r2, 1Fh - BeamUpgrade_PlasmaBeam
    ldr     r0, =@BeamGfxIndex
    ldrb    r1, [r0, r2]
    ; override bbox size if omega metroid is being fought
    ldr     r0, =CurrEvent
    ldrb    r0, [r0]
    cmp     r0, #Event_OmegaFight
    blt     @@get_bbox_size
    mov     r0, #0Ch
    b       @@set_bbox_size
@@get_bbox_size:
    ldr     r0, =@BeamBboxOffsets
    ldrb    r0, [r0, r1]
@@set_bbox_size:
    strh    r0, [r3, Projectile_BboxBottom]
    strh    r0, [r3, Projectile_BboxRight]
    neg     r0, r0
    strh    r0, [r3, Projectile_BboxTop]
    strh    r0, [r3, Projectile_BboxLeft]
    lsl     r0, r1, #2
    lsl     r1, r0, #1
    add     r0, r1
    ldrb    r1, [r4, Projectile_Direction]
    cmp     r1, #5
    ble     @@lookupOamPtr
    mov     r1, #0
@@lookupOamPtr:
    lsr     r1, #1
    lsl     r1, #2
    add     r0, r1
    ldr     r1, =@BeamOamPointers
    ldr     r0, [r1, r0]
    str     r0, [r4, Projectile_OamPointer]
    ldr     r0, =@BeamSfx
    ldrb    r0, [r0, r2]
    bl      Sfx_Play
    pop     { pc }
    .pool
.endfunc
.func WaveBeam_Update
    push    { r4, lr }
    ldr     r4, =CurrentProjectile
    ldrb    r0, [r4, Projectile_Part]
    cmp     r0, #0
    beq     @@skipWideLogic
    ldrb    r0, [r4, Projectile_Stage]
    cmp     r0, #8
    bhi     @@skipWideLogic
    bl      WaveBeam_MoveParts
@@skipWideLogic:
    ldr     r1, =CurrentClipdataAction
    mov     r0, ClipdataAction_Beam
    strb    r0, [r1]
    bl      WaveBeam_UpdateClipdata
    ldrb    r0, [r4, Projectile_Stage]
    lsr     r1, r0, #1
    bne     @@stageOver1
    bcs     @@stageEquals1
    bl      WaveBeam_Initialize
    b       @@incrementStage
@@stageOver1:
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsl     r0, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, #1Fh
    lsl     r0, #2
    add     r0, #18h
    bl      Projectile_Move
    ldr     r1, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    lsr     r1, r0, BeamUpgrade_PlasmaBeam + 1
    bcs     @@incrementTimer
    lsr     r1, r0, BeamUpgrade_IceBeam + 1
    bcc     @@incrementTimer
    mov     r0, #0Eh
    mov     r1, #3
    bl      Beam_SetTrail
    b       @@incrementTimer
@@stageEquals1:
    mov     r0, #10h
    bl      Projectile_Move
@@incrementStage:
    ldrb    r0, [r4, Projectile_Stage]
    add     r0, #1
    strb    r0, [r4, Projectile_Stage]
@@incrementTimer:
    ldrb    r0, [r4, Projectile_Timer]
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
@@return:
    pop     { r4, pc }
    .pool
.endfunc
.endregion

.org 08006412h
.fill 0Ah, 0

.org 0807453Ch
.fill 0Ah, 0

.org 08081404h
.region 1B4h, 0
    ; Uncharged beam firing
    ldr     r4, =ArmCannonPos
    ldr     r1, =SamusUpgrades
    ldrb    r2, [r1, SamusUpgrades_BeamUpgrades]
    mov     r1, r2
    lsr     r0, r1, #1
    beq     @@basicBeam
    lsl     r1, 1Fh - BeamUpgrade_WaveBeam
    lsr     r1, 1Fh
    add     r1, #2
@@basicBeam:
    mov     r5, r1
    mov     r6, #1
    mov     r7, #0
    ; jump to special case for pure charge beam
    lsr     r0, r2, BeamUpgrade_ChargeBeam + 1
    bcc     @@wideCheck
    beq     @@spawnPureCharge
@@wideCheck:
    ; fire three projectiles with wide beam
    lsr     r0, r2, BeamUpgrade_WideBeam + 1
    bcc     @@waveCheck
    mov     r6, #3
    b       @@spawnProjectiles
@@waveCheck:
    ; fire two projectiles with wave beam
    lsr     r0, r2, BeamUpgrade_WaveBeam + 1
    bcc     @@spawnProjectiles
    mov     r6, #2
    mov     r7, #1
    b       @@spawnProjectiles
@@spawnPureCharge:
    ; spawn center charge projectile
    mov     r0, r5
    mov     r1, #7
    bl      CheckProjectiles
    cmp     r0, #0
    beq     @@end
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #0
    bl      SpawnProjectile
    ; spawn secondary charge projectiles
    str     r0, [sp, #8]
    ldr     r1, =ProjectileList
    lsl     r0, #5
    add     r1, r0
    ldrb    r0, [r1, Projectile_Direction]
    str     r0, [sp, #4]
    ldrb    r0, [r1, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_HorizontalFlip
    and     r0, r1
    str     r0, [sp, #0]
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #1
    bl      SpawnSecondaryProjectile
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #2
    bl      SpawnSecondaryProjectile
    b       @@cleanup
@@spawnProjectiles:
    mov     r0, r5
    lsl     r1, r6, #1
    add     r1, #1
    bl      CheckProjectiles
    cmp     r0, #0
    beq     @@end
    sub     r6, #1
@@spawnLoop:
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    add     r3, r6, r7
    bl      SpawnProjectile
    sub     r6, #1
    bpl     @@spawnLoop
@@cleanup:
    ldr     r1, =SamusState
    mov     r0, #7
    strb    r0, [r1, SamusState_ProjectileCooldown]
    ldrh    r0, [r4, ArmCannonPos_Y]
    ldrh    r1, [r4, ArmCannonPos_X]
    mov     r2, #2Bh
    bl      SpawnParticleEffect
@@end:
    b       080818E4h
    .pool
.endregion

.org 08081740h
.region 1A4h, 0
    ; Charged beam firing
    ldr     r4, =ArmCannonPos
    ldr     r1, =SamusUpgrades
    ldrb    r2, [r1, SamusUpgrades_BeamUpgrades]
    mov     r1, r2
    lsr     r0, r1, #1
    beq     @@basicBeam
    lsl     r1, 1Fh - BeamUpgrade_WaveBeam
    lsr     r1, 1Fh
    add     r1, #2
@@basicBeam:
    add     r5, r1, Projectile_ChargedNormalBeam
    mov     r6, #1
    mov     r7, #0
    ; jump to special case for pure charge beam
    lsr     r0, r2, BeamUpgrade_ChargeBeam + 1
    bcc     @@wideCheck
    beq     @@spawnPureCharge
@@wideCheck:
    ; fire three projectiles with wide beam
    lsr     r0, r2, BeamUpgrade_WideBeam + 1
    bcc     @@waveCheck
    mov     r6, #3
    b       @@spawnProjectiles
@@waveCheck:
    ; fire two projectiles with wave beam
    lsr     r0, r2, BeamUpgrade_WaveBeam + 1
    bcc     @@spawnProjectiles
    mov     r6, #2
    mov     r7, #1
    b       @@spawnProjectiles
@@spawnPureCharge:
    ; spawn center charge projectile
    mov     r0, r5
    mov     r1, #7
    bl      CheckProjectiles
    cmp     r0, #0
    beq     @@end
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #0
    bl      SpawnProjectile
    ; spawn secondary charge projectiles
    str     r0, [sp, #8]
    ldr     r1, =ProjectileList
    lsl     r0, #5
    add     r1, r0
    ldrb    r0, [r1, Projectile_Direction]
    str     r0, [sp, #4]
    ldrb    r0, [r1, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_HorizontalFlip
    and     r0, r1
    str     r0, [sp, #0]
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #1
    bl      SpawnSecondaryProjectile
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #2
    bl      SpawnSecondaryProjectile
    b       @@cleanup
@@spawnProjectiles:
    mov     r0, r5
    lsl     r1, r6, #1
    add     r1, #1
    bl      CheckProjectiles
    cmp     r0, #0
    beq     @@end
    sub     r6, #1
@@spawnLoop:
    mov     r0, r5
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    add     r3, r6, r7
    bl      SpawnProjectile
    sub     r6, #1
    bpl     @@spawnLoop
@@cleanup:
    ldr     r1, =SamusState
    mov     r0, #3
    strb    r0, [r1, SamusState_ProjectileCooldown]
    mov     r0, Projectile_BeamFlare
    ldrh    r1, [r4, ArmCannonPos_Y]
    ldrh    r2, [r4, ArmCannonPos_X]
    mov     r3, #0
    bl      SpawnProjectile
@@end:
    b       080818E4h
    .pool
.endregion

.codeautoregion
    .align 2
.func Beam_CalculateDamage
    ; 2 + wave + ice + wide
    ; multiplies damage by 1.5 if firing a single projectile with charge
    ; r2 used to store damage value
    mov     r2, #2
    ldr     r0, =SamusUpgrades
    ldrb    r3, [r0, SamusUpgrades_BeamUpgrades]
    ; check for wave and add 1 to beam damage
    lsl     r0, r3, #1Fh - BeamUpgrade_WaveBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; check for ice and add 1 to beam damage
    lsl     r0, r3, #1Fh - BeamUpgrade_IceBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; check for wide and add 1 to beam damage
    lsl     r0, r3, #1Fh - BeamUpgrade_WideBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; check if ONLY charge beam set, if yes skip
    cmp     r3, #1 << BeamUpgrade_ChargeBeam
    beq     @@return
    ; check if charge beam is set, if not skip
    lsr     r0, r3, #BeamUpgrade_ChargeBeam + 1
    bcc     @@return
    ; check if wide beam set or wave beam set, if yes skip
    mov     r0, (1 << BeamUpgrade_WideBeam) | (1 << BeamUpgrade_WaveBeam)
    and     r0, r3
    bne     @@return
    ; multiply damage by 1.5
    lsr     r0, r2, #1
    add     r2, r0
@@return:
    mov     r0, r2
    bx      lr
    .pool
.endfunc
.endautoregion

.codeautoregion
    .align 2
.func Beam_HitSprite
    push    { r4-r7, lr }
    mov     r5, r8
    mov     r6, r9
    mov     r7, r10
    push    { r5-r7 }
    mov     r7, r0
    mov     r8, r1
    mov     r9, r2
    mov     r10, r3
    ldr     r1, =SamusUpgrades
    ldrb    r6, [r1, SamusUpgrades_BeamUpgrades]
    ldr     r4, =SpriteList
    add     r4, #20h
    mov     r1, #38h
    mul     r1, r0
    add     r4, r1
    ldrb    r1, [r4, Sprite_Properties - 20h]
    lsr     r3, r1, SpriteProps_SolidForProjectiles + 1
    bcs     @@collideWithSolid
    lsr     r3, r1, SpriteProps_ImmuneToProjectiles + 1
    bcs     @@hitInvulnSprite
    bl      Sprite_GetWeakness
    lsr     r1, r0, SpriteWeakness_BeamOrBombs + 1
    bcs     @@hitSprite
    ldr     r2, =SpriteList
    mov     r1, #38h
    mul     r1, r7
    add     r2, r1
    ldrb    r1, [r2, Sprite_Id]
    cmp     r1, #SpriteId_SaxBoss_Samus
    beq     @@hitImmuneSprite
    lsr     r1, r0, SpriteWeakness_Freezable + 1
    bcc     @@hitImmuneSprite
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@hitImmuneSprite
@@hitSprite:
    bl      Beam_CalculateDamage
    mov     r1, r0
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@hitWithoutIce
    mov     r2, r1
    mov     r0, r7
    mov     r1, #0
    bl      IceBeam_DamageSprite
    mov     r1, #2
    mov     r4, r1
    mov     r5, r0
    b       @@checkDebris
@@hitWithoutIce:
    mov     r0, r7
    bl      Projectile_DamageSprite
    mov     r1, #1
    mov     r4, r1
    mov     r5, r0
@@checkDebris:
    lsr     r0, r6, BeamUpgrade_PlasmaBeam + 1
    bcs     @@plasmaDebris
    mov     r0, r7
    bl      Sprite_MakesDebrisWhenHit
    cmp     r0, #0
    beq     @@despawnWithHitParticle
    mov     r0, r4
    mov     r1, r5
    mov     r2, r9
    mov     r3, r10
    bl      Sprite_CreateDebris
    b       @@despawnWithHitParticle
@@plasmaDebris:
    mov     r0, r7
    bl      Sprite_MakesDebrisWhenHit
    cmp     r0, #0
    beq     @@return
    mov     r0, r4
    mov     r1, r5
    mov     r2, r9
    mov     r3, r10
    bl      Sprite_CreatePlasmaDebris
    b       @@return
@@hitImmuneSprite:
    mov     r0, r7
    bl      Sprite_StartOnHitTimer
    mov     r0, r9
    mov     r1, r10
    mov     r2, #7
    bl      SpawnParticleEffect
    b       @@despawnIfNoPlasma
@@hitInvulnSprite:
    mov     r0, r9
    mov     r1, r10
    mov     r2, #7
    bl      SpawnParticleEffect
    b       @@despawn
@@collideWithSolid:
    mov     r0, r7
    bl      Sprite_StartOnHitTimer
    mov     r0, r7
    bl      Sprite_GetWeakness
    lsr     r0, SpriteWeakness_Freezable + 1
    bcc     @@checkWave
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@checkWave
    ldr     r2, =SpriteList
    mov     r1, #38h
    mul     r1, r7
    add     r2, r1
    mov     r3, r2
    add     r3, #20h
    mov     r0, #240
    strb    r0, [r3, Sprite_FreezeTimer - 20h]
    mov     r0, #0
    strb    r0, [r3, Sprite_StandingOnFlag - 20h]
    mov     r0, #15
    ldrb    r1, [r3, Sprite_FreezePaletteOffset - 20h]
    sub     r0, r1
    ldrb    r1, [r2, Sprite_SpritesetGfxSlot]
    sub     r0, r1
    strb    r0, [r3, Sprite_PaletteRow - 20h]
@@checkWave:
    lsr     r0, r6, BeamUpgrade_WaveBeam + 1
    bcs     @@return
@@despawnWithHitParticle:
    lsl     r0, r6, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r1, r6, BeamUpgrade_IceBeam
    lsl     r1, BeamUpgrade_WideBeam
    orr     r0, r1
    ldr     r1, =@BeamImpactParticle
    ldrb    r2, [r1, r0]
    mov     r0, r9
    mov     r1, r10
    bl      SpawnParticleEffect
    b       @@despawn
@@despawnIfNoPlasma:
    lsr     r0, r6, BeamUpgrade_PlasmaBeam + 1
    bcs     @@return
@@despawn:
    ldr     r2, =ProjectileList
    mov     r0, r8
    lsl     r0, #5
    add     r1, r2, r0
    cmp     r6, 1 << BeamUpgrade_ChargeBeam
    bne     @@despawnNotCharge
    ldrb    r0, [r1, Projectile_Status]
    lsr     r0, ProjectileStatus_Exploding + 1
    bcc     @@despawnNotCharge
    ldrb    r0, [r1, Projectile_ParentSlot]
    lsl     r0, #5
    add     r2, r0
    ldrb    r0, [r2, Projectile_Stage]
    cmp     r0, #4
    bge     @@despawnNotCharge
    mov     r0, #4
    strb    r0, [r2, Projectile_Stage]
@@despawnNotCharge:
    mov     r0, #0
    strb    r0, [r1, Projectile_Status]
@@return:
    pop     { r5-r7 }
    mov     r8, r5
    mov     r9, r6
    mov     r10, r7
    pop     { r4-r7, pc }
    .pool
.endfunc
.endautoregion

.codeautoregion
    .align 2
.func ChargedBeam_CalculateDamage
    ; floor(5 * (2 + (wave + ice + wide) / 2) * (3 * plasma / 5))
    ; multiplies damage by 1.5 if firing a single projectile with charge
    mov     r2, #4
    ldr     r0, =SamusUpgrades
    ldrb    r3, [r0, SamusUpgrades_BeamUpgrades]
    ; check for wave and add 1 to term
    lsl     r0, r3, #1Fh - BeamUpgrade_WaveBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; check for ice and add 1 to term
    lsl     r0, r3, #1Fh - BeamUpgrade_IceBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; check for wide and add 1 to term
    lsl     r0, r3, #1Fh - BeamUpgrade_WideBeam
    lsr     r0, #1Fh
    add     r2, r0
    ; multiply term by 5
    lsl     r0, r2, #2
    add     r2, r0
    ; check if ONLY charge beam set, if yes skip
    cmp     r3, #1 << BeamUpgrade_ChargeBeam
    beq     @@return
    lsr     r0, r3, #BeamUpgrade_ChargeBeam + 1
    bcc     @@check_plasma
    ; check if wide beam set or wave beam set, if yes skip
    mov     r0, #(1 << BeamUpgrade_WideBeam) | (1 << BeamUpgrade_WaveBeam)
    and     r0, r3
    bne     @@check_plasma
    lsr     r0, r2, #1
    add     r2, r0
@@check_plasma:
    lsr     r0, r3, #BeamUpgrade_PlasmaBeam + 1
    bcc     @@return
    lsl     r0, r2, #1
    add     r2, r0
    mov     r0, #unsigned_reciprocal(5, 10)
    mul     r2, r0
    lsr     r2, #10
@@return:
    lsr     r0, r2, #1
    bx      lr
    .pool
.endfunc
.endautoregion

.codeautoregion
    .align 2
.func ChargedBeam_HitSprite
    push    { r4-r7, lr }
    mov     r5, r8
    mov     r6, r9
    mov     r7, r10
    push    { r5-r7 }
    mov     r7, r0
    mov     r8, r1
    mov     r9, r2
    mov     r10, r3
    ldr     r1, =SamusUpgrades
    ldrb    r6, [r1, SamusUpgrades_BeamUpgrades]
    ldr     r4, =SpriteList
    mov     r1, #38h
    mul     r1, r0
    add     r4, r1
    mov     r1, Sprite_Properties
    ldrb    r1, [r4, r1]
    lsr     r3, r1, SpriteProps_SolidForProjectiles + 1
    bcs     @@collideWithSolid
    lsr     r3, r1, SpriteProps_ImmuneToProjectiles + 1
    bcs     @@hitInvulnSprite
    bl      Sprite_GetWeakness
    lsr     r1, r0, SpriteWeakness_BeamOrBombs + 1
    bcs     @@hitSprite
    lsr     r1, r0, SpriteWeakness_ChargeBeam + 1
    bcs     @@hitSprite
    lsr     r1, r0, SpriteWeakness_Freezable + 1
    bcc     @@hitImmuneSprite
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@hitImmuneSprite
@@hitSprite:
    bl      ChargedBeam_CalculateDamage
    mov     r1, r0
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@hitWithoutIce
    ldr     r2, =SpriteList
    mov     r0, #38h
    mul     r0, r7
    add     r2, r0
    ldrb    r0, [r2, Sprite_Id]
    cmp     r0, #SpriteId_SaxBoss_Samus
    beq     @@hitWithoutIce
    mov     r2, r1
    mov     r0, r7
    mov     r1, #1
    bl      IceBeam_DamageSprite
    mov     r1, #2
    mov     r4, r1
    mov     r5, r0
    b       @@checkDebris
@@hitWithoutIce:
    mov     r0, r7
    bl      Projectile_DamageSprite
    mov     r1, #1
    mov     r4, r1
    mov     r5, r0
@@checkDebris:
    lsr     r0, r6, BeamUpgrade_PlasmaBeam + 1
    bcs     @@plasmaDebris
    mov     r0, r7
    bl      Sprite_MakesDebrisWhenHit
    cmp     r0, #0
    beq     @@despawnWithHitParticle
    mov     r0, r4
    mov     r1, r5
    mov     r2, r9
    mov     r3, r10
    bl      Sprite_CreateDebris
    b       @@despawnWithHitParticle
@@plasmaDebris:
    mov     r0, r7
    bl      Sprite_MakesDebrisWhenHit
    cmp     r0, #0
    beq     @@return
    mov     r0, r4
    mov     r1, r5
    mov     r2, r9
    mov     r3, r10
    bl      Sprite_CreatePlasmaDebris
    b       @@return
@@hitImmuneSprite:
    mov     r0, r7
    bl      Sprite_StartOnHitTimer
    mov     r0, r9
    mov     r1, r10
    mov     r2, #7
    bl      SpawnParticleEffect
    b       @@despawnIfNoPlasma
@@hitInvulnSprite:
    mov     r0, r9
    mov     r1, r10
    mov     r2, #7
    bl      SpawnParticleEffect
    b       @@despawn
@@collideWithSolid:
    mov     r0, r7
    bl      Sprite_StartOnHitTimer
    mov     r0, r7
    bl      Sprite_GetWeakness
    lsr     r0, SpriteWeakness_Freezable + 1
    bcc     @@checkWave
    lsr     r0, r6, BeamUpgrade_IceBeam + 1
    bcc     @@checkWave
    ldr     r2, =SpriteList
    mov     r1, #38h
    mul     r1, r7
    add     r2, r1
    mov     r3, r2
    add     r3, #20h
    mov     r0, #240
    strb    r0, [r3, Sprite_FreezeTimer - 20h]
    mov     r0, #0
    strb    r0, [r3, Sprite_StandingOnFlag - 20h]
    mov     r0, #15
    ldrb    r1, [r3, Sprite_FreezePaletteOffset - 20h]
    sub     r0, r1
    ldrb    r1, [r2, Sprite_SpritesetGfxSlot]
    sub     r0, r1
    strb    r0, [r3, Sprite_PaletteRow - 20h]
@@checkWave:
    lsr     r0, r6, BeamUpgrade_WaveBeam + 1
    bcs     @@return
@@despawnWithHitParticle:
    lsl     r0, r6, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r0, 1Fh - BeamUpgrade_PlasmaBeam
    lsr     r1, r6, BeamUpgrade_IceBeam
    lsl     r1, BeamUpgrade_WideBeam
    orr     r0, r1
    ldr     r1, =@BeamImpactParticle
    ldrb    r2, [r1, r0]
    mov     r0, r9
    mov     r1, r10
    bl      SpawnParticleEffect
    b       @@despawn
@@despawnIfNoPlasma:
    lsr     r0, r6, BeamUpgrade_PlasmaBeam + 1
    bcs     @@return
@@despawn:
    ldr     r2, =ProjectileList
    mov     r0, r8
    lsl     r0, #5
    add     r1, r2, r0
    cmp     r6, 1 << BeamUpgrade_ChargeBeam
    bne     @@despawnNoSoloCharge
    ldrb    r0, [r1, Projectile_Status]
    lsr     r0, ProjectileStatus_Exploding + 1
    bcc     @@despawnNoSoloCharge
    ldrb    r0, [r1, Projectile_ParentSlot]
    lsl     r0, #5
    add     r2, r0
    ldrb    r0, [r2, Projectile_Stage]
    cmp     r0, #4
    bge     @@despawnNoSoloCharge
    mov     r0, #4
    strb    r0, [r2, Projectile_Stage]
@@despawnNoSoloCharge:
    mov     r0, #0
    strb    r0, [r1, Projectile_Status]
@@return:
    pop     { r5-r7 }
    mov     r8, r5
    mov     r9, r6
    mov     r10, r7
    pop     { r4-r7, pc }
    .pool
.endfunc
.endautoregion

.codeautoregion
    .align 2
.func @BeamFlare_CalculateDamage
    ; set beam flare damage
    ; 6 + 3 * (2 * (plasma + wave) + ice + wide) / 2
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r1, r2, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r1, #1Fh
    lsl     r0, r2, #1Fh - BeamUpgrade_WaveBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r1, #1
    lsl     r0, r2, #1Fh - BeamUpgrade_IceBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r0, r2, #1Fh - BeamUpgrade_WideBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r0, r1, #1
    add     r1, r0
    lsr     r0, r1, #1
    add     r0, #6
    bx      lr
    .pool
.endfunc
.endautoregion

.org 08084596h
.area 2Eh
    bl      @BeamFlare_CalculateDamage
    mov     r1, r0
    b       080845C4h
.endarea

.codeautoregion
    .align 2
.func @PseudoScrew_CalculateDamage
    ; set pseudo-screw damage
    ; 15 + 11 * (2 * (plasma + wave) + ice + wide) / 2
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_BeamUpgrades]
    lsl     r1, r2, #1Fh - BeamUpgrade_PlasmaBeam
    lsr     r1, #1Fh
    lsl     r0, r2, #1Fh - BeamUpgrade_WaveBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r1, #1
    lsl     r0, r2, #1Fh - BeamUpgrade_IceBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r0, r2, #1Fh - BeamUpgrade_WideBeam
    lsr     r0, #1Fh
    add     r1, r0
    lsl     r0, r1, #1
    add     r0, r1
    lsl     r1, #3
    add     r1, r0
    lsr     r0, r1, #1
    add     r0, #15
    bx      lr
    .pool
.endfunc
.endautoregion

.org 080836FCh
.area 1Ch
    bl      @PseudoScrew_CalculateDamage
    mov     r1, r0
    b       08083746h
.endarea

.org 08083A54h
.area 1Eh, 0
    mov     r4, r0
    mov     r5, r2
    mov     r6, #0
    mov     r7, #0
    mov     r8, r1
    bl      Sprite_GetWeakness
    mov     r3, r0
    lsr     r0, r3, #SpriteWeakness_BeamOrBombs + 1
    bcs     08083A72h
    lsr     r0, r3, #SpriteWeakness_ChargeBeam + 1
    bcc     08083B2Ch
    mov     r0, r8
    cmp     r0, #0
    beq     08083B2Ch
.endarea

.org 08004F40h
.area 1Ah
    ; prevent ice from granting omega suit
    b       08004F5Ah
.endarea

.org 08059888h
.area 3Ch
    ; ridley uncharged wave beam interaction
    ldrb    r1, [r4, Projectile_Status]
    lsr     r0, r1, #ProjectileStatus_Exists + 1
    bcc     080598EEh
    lsr     r0, r1, #ProjectileStatus_AffectsClipdata + 1
    bcc     080598EEh
    ldrb    r0, [r4, Projectile_Type]
    sub     r0, #Projectile_WideBeam
    cmp     r0, #Projectile_WaveBeam - Projectile_WideBeam
    bhi     080598EEh
    ldr     r0, =SamusUpgrades
    ldrb    r1, [r0, SamusUpgrades_BeamUpgrades]
    lsr     r0, r1, #BeamUpgrade_PlasmaBeam + 1
    bcs     @@destroy_projectile
    lsr     r0, r1, #BeamUpgrade_WaveBeam + 1
    bcc     080598EEh
@@destroy_projectile:
    ldrh    r5, [r4, Projectile_PosY]
    ldrh    r6, [r4, Projectile_PosX]
    ldrh    r0, [r4, Projectile_BboxTop]
    add     r0, r5
    ldrh    r1, [r4, Projectile_BboxBottom]
    add     r1, r5
    ldrh    r2, [r4, Projectile_BboxLeft]
    add     r2, r6
    ldrh    r3, [r4, Projectile_BboxRight]
    add     r3, r6
    b       080598C4h
    .pool
.endarea

.org 080508B0h
.area 3Ch
    ; sa-x monster form uncharged wave beam interaction
    ldrb    r1, [r4, Projectile_Status]
    lsr     r0, r1, #ProjectileStatus_Exists + 1
    bcc     08050916h
    lsr     r0, r1, #ProjectileStatus_AffectsClipdata + 1
    bcc     08050916h
    ldrb    r0, [r4, Projectile_Type]
    sub     r0, #Projectile_WideBeam
    cmp     r0, #Projectile_WaveBeam - Projectile_WideBeam
    bhi     08050916h
    ldr     r0, =SamusUpgrades
    ldrb    r1, [r0, SamusUpgrades_BeamUpgrades]
    lsr     r0, r1, #BeamUpgrade_PlasmaBeam + 1
    bcs     @@destroy_projectile
    lsr     r0, r1, #BeamUpgrade_WaveBeam + 1
    bcc     08050916h
@@destroy_projectile:
    ldrh    r5, [r4, Projectile_PosY]
    ldrh    r6, [r4, Projectile_PosX]
    ldrh    r0, [r4, Projectile_BboxTop]
    add     r0, r5
    ldrh    r1, [r4, Projectile_BboxBottom]
    add     r1, r5
    ldrh    r2, [r4, Projectile_BboxLeft]
    add     r2, r6
    ldrh    r3, [r4, Projectile_BboxRight]
    add     r3, r6
    b       080508ECh
    .pool
.endarea

.org 0804A9BCh
.area 4Eh
    ; telescoping pillar wave beam interaction
    ldrb    r1, [r3, Projectile_Status]
    lsr     r0, r1, #ProjectileStatus_Exists + 1
    bcc     0804AA26h
    lsr     r0, r1, #ProjectileStatus_AffectsClipdata + 1
    bcc     0804AA26h
    ldrb    r1, [r3, Projectile_Type]
    cmp     r1, #Projectile_Bomb
    beq     0804A9E2h
    cmp     r1, #Projectile_DiffusionFlake
    beq     0804A9E2h
    sub     r0, r1, #Projectile_WideBeam
    cmp     r0, #Projectile_WaveBeam - Projectile_WideBeam
    bls     @@checkWaveUpgrade
    sub     r0, r1, #Projectile_ChargedWideBeam
    cmp     r0, #Projectile_ChargedWaveBeam - Projectile_ChargedWideBeam
    bhi     0804AA26h
@@checkWaveUpgrade:
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_BeamUpgrades]
    lsr     r0, #BeamUpgrade_WaveBeam + 1
    bcc     0804AA26h
    ldrh    r5, [r3, Projectile_PosY]
    ldrh    r6, [r3, Projectile_PosX]
    ldrh    r0, [r3, Projectile_BboxTop]
    add     r0, r5
    ldrh    r1, [r3, Projectile_BboxBottom]
    add     r1, r5
    ldrh    r2, [r3, Projectile_BboxLeft]
    add     r2, r6
    ldrh    r3, [r3, Projectile_BboxRight]
    add     r3, r6
    mov     r6, r0
    mov     r5, r1
    b       0804AA0Ah
    .pool
.endarea

.org 08082CE6h
    bl      Beam_HitSprite
.org 08082D0Ch
    bl      Beam_HitSprite
.org 08082D36h
    bl      Beam_HitSprite
.org 08082D5Eh
    bl      Beam_HitSprite

.org 08082DACh
    bl      ChargedBeam_HitSprite
.org 08082DD4h
    bl      ChargedBeam_HitSprite
.org 08082E0Ah
    bl      ChargedBeam_HitSprite
.org 08082E30h
    bl      ChargedBeam_HitSprite

.org 0879C284h
    ; projectile update functions
    .dw     PlasmaBeam_Update | 1
    .dw     WaveBeam_Update | 1
    .dw     WaveBeam_Update | 1
.org 0879C298h
    .dw     ChargedPlasmaBeam_Update | 1
    .dw     ChargedWaveBeam_Update | 1
    .dw     ChargedWaveBeam_Update | 1

.dataautoregion
@BeamImpactParticle:
    .db     3   ; normal
    .db     4   ; pure charge
    .db     5   ; pure wide
    .db     5   ; charge + wide
    .db     6   ; pure plasma
    .db     6   ; charge + plasma
    .db     6   ; wide + plasma
    .db     6   ; charge + wide + plasma
.endautoregion

.dataautoregion
@BeamSfx:
    .db     0C9h    ; pure wide
    .db     0CBh    ; pure plasma
    .db     0CCh    ; pure wave
    .db     0CCh    ; wave + plasma
    .db     0CDh    ; pure ice
    .db     0CDh    ; ice + plasma
    .db     0CDh    ; ice + wave
    .db     0CDh    ; ice + wave + plasma
.endautoregion

.dataautoregion
@ChargedBeamSfx:
    .db     0EEh    ; pure wide
    .db     0EFh    ; pure plasma
    .db     0F0h    ; pure wave
    .db     0F0h    ; wave + plasma
    .db     0F1h    ; pure ice
    .db     0F1h    ; ice + plasma
    .db     0F1h    ; ice + wave
    .db     0F1h    ; ice + wave + plasma
.endautoregion

.dataautoregion
@BeamGfxIndex:
    .db     0   ; pure wide
    .db     1   ; pure plasma
    .db     0   ; pure wave
    .db     2   ; wave + plasma
    .db     3   ; pure ice
    .db     1   ; ice + plasma
    .db     3   ; ice + wave
    .db     2   ; ice + wave + plasma
.endautoregion

.dataautoregion
    .align 4
@BeamOamPointers:
    .dw     0858DBDCh, 0858DBFCh, 0858DC1Ch
    .dw     0858DDF4h, 0858DE0Ch, 0858DE24h
    .dw     0858DF64h, 0858DF74h, 0858DF84h
    .dw     0858E1D8h, 0858E1E8h, 0858E1F8h
.endautoregion

.dataautoregion
    .align 4
@ChargedBeamOamPointers:
    .dw     0858DC3Ch, 0858DC54h, 0858DC6Ch
    .dw     0858DE3Ch, 0858DE54h, 0858DE6Ch
    .dw     0858DF94h, 0858DFACh, 0858DFC4h
    .dw     0858E208h, 0858E218h, 0858E228h
.endautoregion

.dataautoregion
@BeamBboxOffsets:
    .db     10h, 0Ch, 14h, 10h
.endautoregion

.dataautoregion
@ChargedBeamBboxOffsets:
    .db     14h, 14h, 14h, 14h
.endautoregion
