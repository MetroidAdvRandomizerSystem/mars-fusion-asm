; Changes all combinations of missile upgrades to function in an intuitive way.
; Like beams, vanilla behavior expects all upgrades to be collected in a
; fixed order.

; Type      Damage  Cooldown
; Normal     10      9
; Super     +20     +4
; Ice       +10     +2
; Diffusion  +5     +1

; Speed
; 1: 04 06 08 12 14 16 18
; 2: 04 06 08 12 16 20 24
; 3: 04 08 12 16 20 24 28
; 4: 08 12 16 20 24 28 32

; Graphics
; Super > Ice = Diffusion > Normal

; Hitbox size
; Normal    16 x 16
; Super     32 x 24
; Ice       32 x 24
; Diffusion 32 x 24

; Trail graphics
; Ice > Super = Diffusion > Normal

; Fire sound
; Charged > Ice > Super = Diffusion > Normal

; Hit effect
; Charged > Ice > Super > Diffusion = Normal


; modified portion of UpdateArmCannonAndWeapons
; where a new missile is initialized
.org 080815B8h
.area 128h
    ldr     r0, =SamusUpgrades
    ldrb    r1, [r0, SamusUpgrades_ExplosiveUpgrades]
    mov     r4, Projectile_NormalMissile
    mov     r5, MissileCooldown
    ; check super
    mov     r0, 1 << ExplosiveUpgrade_SuperMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkHasIce
    mov     r4, Projectile_SuperMissile
    add     r5, r5, SuperMissileCooldown
@@checkHasIce:
    mov     r0, 1 << ExplosiveUpgrade_IceMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkHasDiffusion
    mov     r4, Projectile_IceMissile
    add     r5, r5, IceMissileCooldown
@@checkHasDiffusion:
    mov     r0, 1 << ExplosiveUpgrade_DiffusionMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkNumber
    mov     r4, Projectile_DiffusionMissile
    add     r5, r5, DiffusionMissileCooldown
@@checkNumber:
    mov     r0, r4  ; r0 = type
    ldr     r1, =MissileLimit
    ldrb    r1, [r1]
    bl      CheckProjectiles
    cmp     r0, #0
    bne     @@underLimit
    b       080818E4h   ; return
@@underLimit:
    cmp     r4, Projectile_DiffusionMissile
    bne     @@notCharged
    ldr     r1, =SamusTimers
    ldrb    r0, [r1, SamusTimers_DiffusionMissileCharge]
    cmp     r0, #80h
    bcc     @@resetCounter
    mov     r4, Projectile_ChargedDiffusionMissile
@@resetCounter:
    mov     r0, #0
    strb    r0, [r1, SamusTimers_DiffusionMissileCharge]
@@notCharged:
    ldr     r1, =SamusState
    strb    r5, [r1, SamusState_ProjectileCooldown]
    mov     r0, r4  ; r0 = type
    ldr     r2, =ArmCannonPos
    ldrh    r1, [r2, #ArmCannonPos_Y]
    ldrh    r2, [r2, #ArmCannonPos_X]
    mov     r3, #0
    bl      SpawnProjectile
    b       080818E4h   ; return
    .pool
.endarea

.autoregion DataFreeSpace
MissileLimit:
    .db     3
.endautoregion

.org MissileLimitPointer
.area 04h
    .dw     MissileLimit
.endarea

; modified LoadMissileGfx function
.org LoadMissileGfx
.area 0DCh
    push    { lr }
    ldr     r0, =SamusUpgrades
    ldrb    r1, [r0, SamusUpgrades_ExplosiveUpgrades]
    mov     r2, r1
    ; check super
    mov     r0, 1 << ExplosiveUpgrade_SuperMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkIceOrDiffusion
    ldr     r0, =DMA3
    ldr     r1, =SuperMissileGfx0
    str     r1, [r0, DMA_SAD]
    ldr     r1, =06011380h
    str     r1, [r0, DMA_DAD]
    ldr     r2, =80000040h
    str     r2, [r0, DMA_CNT]
    ldr     r1, [r0, DMA_CNT]
    ldr     r1, =SuperMissileGfx1
    b       @@secondDMA
@@checkIceOrDiffusion:
    mov     r0, (1 << ExplosiveUpgrade_IceMissiles) \
        | (1 << ExplosiveUpgrade_DiffusionMissiles)
    and     r0, r1
    cmp     r0, #0
    beq     @@checkNormal
    ldr     r0, =DMA3
    ldr     r1, =IceMissileGfx0
    str     r1, [r0, DMA_SAD]
    ldr     r1, =06011380h
    str     r1, [r0, DMA_DAD]
    ldr     r2, =80000040h
    str     r2, [r0, DMA_CNT]
    ldr     r1, [r0, DMA_CNT]
    ldr     r1, =IceMissileGfx1
    b       @@secondDMA
@@checkNormal:
    mov     r0, 1 << ExplosiveUpgrade_Missiles
    and     r2, r0
    cmp     r2, #0
    beq     @@return
    ldr     r0, =DMA3
    ldr     r1, =NormalMissileGfx0
    str     r1, [r0, DMA_SAD]
    ldr     r1, =06011380h
    str     r1, [r0, DMA_DAD]
    ldr     r2, =80000040h
    str     r2, [r0, DMA_CNT]
    ldr     r1, [r0, DMA_CNT]
    ldr     r1, =NormalMissileGfx1
@@secondDMA:
    str     r1, [r0, DMA_SAD]
    ldr     r1, =06011780h
    str     r1, [r0, DMA_DAD]
    str     r2, [r0, DMA_CNT]
    ldr     r0, [r0, DMA_CNT]
@@return:
    pop     { r0 }
    bx      r0
    .pool
.endarea

; make all missile types branch to same code within CheckWeaponHitSprite
.org 08082CA4h
    .dw 08082EA8h   ; normal
    .dw 08082EA8h   ; super
    .dw 08082EA8h   ; ice
    .dw 08082EA8h   ; diffusion
    .dw 08082EA8h   ; charged


; overwrite missile hit sprite functions
.org 080846C4h
.area 49Ch

    ; combined missile hit sprite function
    ; r0 = SpriteSlotNum
    ; r1 = ProjectileSlotNum
    ; r2 = ProjectilePosY
    ; r3 = ProjectilePosX
    push    { r4-r7, lr }
    mov     r6, r9
    mov     r5, r8
    push    { r5, r6 }
    add     sp, #-0Ch
    ; initialize registers
    mov     r4, r0
    mov     r5, r1
    mov     r6, r2
    mov     r7, r3
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_ExplosiveUpgrades]
    mov     r8, r0
    ; check if sprite is solid
    ldr     r1, =SpriteList
    lsl     r0, r4, #3
    sub     r0, r0, r4
    lsl     r0, r0, #3
    add     r0, r1, r0
    add     r0, Sprite_Properties
    ldrb    r1, [r0]
    mov     r0, 1 << SpriteProps_SolidForProjectiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkSpriteImmune
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Sprite_StartOnHitTimer
    ; check for ice missiles
    mov     r0, r8  ; r0 = ExplosiveUpgrades
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@successfulHit
    ; check if sprite isn't frozen
    ldr     r1, =SpriteList
    lsl     r0, r4, #3
    sub     r0, r0, r4
    lsl     r0, r0, #3
    add     r0, r1, r0
    mov     r9, r0
    add     r0, Sprite_FreezeTimer
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@successfulHit
    ; check if sprite can be frozen
    mov     r0, r4
    bl      Sprite_GetWeakness
    mov     r1, 1 << SpriteWeakness_Freezable
    and     r0, r1
    cmp     r0, #0
    beq     @@successfulHit
    mov     r0, r9  ; sprite data address
    add     r0, Sprite_StandingOnFlag
    mov     r1, #0
    strb    r1, [r0]
    mov     r1, #240
    sub     r0, #1
    strb    r1, [r0]    ; FreezeTimer = 240
    add     r0, #3
    ldrb    r1, [r0]    ; r1 = FrozenPaletteRow
    sub     r0, #16h
    ldrb    r2, [r0]    ; r2 = SpritesetGfxSlot
    add     r1, r1, r2
    mov     r2, #15
    sub     r1, r2, r1
    strb    r1, [r0, #1]    ; Palette = 15 - (FrozenPaletteRow + SpritesetGfxSlot)
    b       @@successfulHit
@@checkSpriteImmune:
    mov     r0, 1 << SpriteProps_ImmuneToProjectiles
    and     r0, r1
    cmp     r0, #0
    bne     @@missileTinked
@@checkLowerHealthIce:
    ; check for ice missiles
    mov     r0, r8  ; r0 = ExplosiveUpgrades
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r0, r1
    cmp     r0, #0
    beq     @@checkLowerHealth
    ; check if sprite weak to missiles
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Sprite_GetWeakness
    mov     r1, 1 << SpriteWeakness_Missiles
    and     r1, r0
    cmp     r1, #0
    bne     @@lowerHealthIce
    ; check if sprite weak to super
    mov     r1, 1 << SpriteWeakness_SuperMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@checkCanFreeze
    ; check for super missiles
    mov     r1, r8  ; r1 = ExplosiveUpgrades
    mov     r2, 1 << ExplosiveUpgrade_SuperMissiles
    and     r1, r2
    cmp     r1, #0
    bne     @@lowerHealthIce
@@checkCanFreeze:
    ; check if sprite can be frozen
    mov     r1, 1 << SpriteWeakness_Freezable
    and     r0, r1
    cmp     r0, #0
    beq     @@checkLowerHealth
@@lowerHealthIce:
    mov     r0, r8  ; r0 = ExplosiveUpgrades
    bl      GetMissileDamage
    mov     r2, r0
    mov     r0, r4  ; r0 = SpriteSlotNum
    mov     r1, r5  ; r1 = ProjectileSlotNum
    bl      IceMissile_DamageSprite
    b       @@checkDamageReduction
@@checkLowerHealth:
    ; check if sprite weak to missiles
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Sprite_GetWeakness
    mov     r1, 1 << SpriteWeakness_Missiles
    and     r1, r0
    cmp     r1, #0
    bne     @@lowerHealth
    ; check if sprite weak to super
    mov     r1, 1 << SpriteWeakness_SuperMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@else
    ; check for super missiles
    mov     r1, r8  ; r1 = ExplosiveUpgrades
    mov     r2, 1 << ExplosiveUpgrade_SuperMissiles
    and     r1, r2
    cmp     r1, #0
    beq     @@else
@@lowerHealth:
    mov     r0, r8  ; r0 = ExplosiveUpgrades
    bl      GetMissileDamage
    mov     r1, r0
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Projectile_DamageSprite
    b       @@checkDamageReduction
@@else:
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Sprite_StartOnHitTimer
@@missileTinked:
    ; tink effect
    mov     r0, r6  ; ProjectilePosY
    mov     r1, r7  ; ProjectilePosX
    mov     r2, Particle_Tink
    bl      SpawnParticleEffect
    ; call tink function
    mov     r0, r4  ; r0 = SpriteSlotNum
    mov     r1, r5  ; r1 = ProjectileSlotNum
    bl      Missile_StartTumble
    b       @@return
@@checkDamageReduction:
    ; check damage reduction
    mov     r9, r0
    mov     r0, r4  ; r0 = SpriteSlotNum
    bl      Sprite_MakesDebrisWhenHit
    cmp     r0, #0
    beq     @@successfulHit
    ; check ice
    mov     r0, r8  ; r0 = ExplosiveUpgrades
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r0, r1
    lsr     r0, r0, #2
    add     r0, #1  ; r0 = 2 for ice, 1 otherwise
    mov     r1, r9  ; r1 = FlashTimer
    mov     r2, r6  ; r2 = ProjectilePosY
    mov     r3, r7  ; r3 = ProjectilePosX
    bl      Sprite_CreateDebris
@@successfulHit:
    ldr     r0, =ProjectileList
    lsl     r1, r5, #5
    add     r0, r0, r1
    mov     r9, r0
    ldrb    r0, [r0, Projectile_Type]
    cmp     r0, Projectile_ChargedDiffusionMissile
    bne     @@uncharged
    ; set graphics effect
    mov     r0, r6
    mov     r1, r7
    mov     r2, Particle_ChargedDiffusionMissileExplosion
    bl      SpawnParticleEffect
    ; set projectile RAM values
    mov     r2, r9  ; r2 = projectile data address
    mov     r0, #3
    strb    r0, [r2, Projectile_Stage]
    mov     r3, #0
    strb    r3, [r2, Projectile_Timer]
    ldrb    r0, [r2, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_AffectsClipdata
    bic     r0, r1
    mov     r1, 1 << ProjectileStatus_Exploding
    orr     r0, r1
    strb    r0, [r2]
    str     r3, [sp]
    str     r3, [sp, #4]
    ldrb    r0, [r2, Projectile_ParentSlot]
    str     r0, [sp, #8]
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r6  ; r1 = ProjPosY
    mov     r2, r7  ; r2 = ProjPosX
    mov     r3, #0
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r6
    mov     r2, r7
    mov     r3, #40h
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r6
    mov     r2, r7
    mov     r3, #80h
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r6
    mov     r2, r7
    mov     r3, #0C0h
    bl      SpawnSecondaryProjectile
    b       @@return
@@uncharged:
    ; set graphics effect
    mov     r0, r8
    bl      GetMissileHitEffect
    mov     r2, r0
    mov     r0, r6
    mov     r1, r7
    bl      SpawnParticleEffect
    ; set status to 0
    mov     r1, r9
    mov     r0, #0
    strb    r0, [r1, Projectile_Status]
@@return:
    add     sp, #0Ch
    pop     { r3, r4 }
    mov     r8, r3
    mov     r9, r4
    pop     { r4-r7 }
    pop     { r0 }
    bx      r0
    .pool

GetMissileDamage:
    ; r0 = ExplosiveUpgrades
    push    { lr }
    mov     r2, MissileDamage
@@checkSuper:
    mov     r1, 1 << ExplosiveUpgrade_SuperMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@checkIce
    add     r2, SuperMissileDamage
@@checkIce:
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@checkDiffusion
    add     r2, IceMissileDamage
@@checkDiffusion:
    mov     r1, 1 << ExplosiveUpgrade_DiffusionMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@return
    add     r2, DiffusionMissileDamage
@@return:
    mov     r0, r2
    pop     { r1 }
    bx      r1

GetMissileHitEffect:
    ; r0 = MissileStatus
    push    { lr }
@@checkIce:
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@checkSuper
    mov     r0, Particle_IceMissileExplosion
    b       @@return
@@checkSuper:
    mov     r1, 1 << ExplosiveUpgrade_SuperMissiles
    and     r1, r0
    cmp     r1, #0
    beq     @@normal
    mov     r0, Particle_SuperMissileExplosion
    b       @@return
@@normal:
    mov     r0, Particle_MissileExplosion
@@return:
    pop     { r1 }
    bx      r1
.endarea

; make all missile types branch to same process function
.org 0879C2A4h
    .dw CombinedProcessMissile + 1  ; normal
    .dw CombinedProcessMissile + 1  ; super
    .dw CombinedProcessMissile + 1  ; ice
    .dw CombinedProcessMissile + 1  ; diffusion
    .dw CombinedProcessMissile + 1  ; charged

.org 08085104h
.area 3ACh
CombinedProcessMissile:
    push    { r4-r6, lr }
    add     sp, -0Ch
    ; check if missile hit something
    ldr     r4, =CurrentProjectile
    ldr     r0, =CurrentClipdataAction
    mov     r1, ClipdataAction_Missile
    strb    r1, [r0]
    bl      Projectile_UpdateClipdata
    cmp     r0, #0
    beq     @@checkMovementStage
    ldrb    r0, [r4, Projectile_Type]
    cmp     r0, Projectile_ChargedDiffusionMissile
    beq     @@chargedHit
    ; uncharged hit
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_ExplosiveUpgrades]
    bl      GetMissileHitEffect
    mov     r2, r0
    mov     r0, #0
    strb    r0, [r4, Projectile_Status]
    ldrh    r0, [r4, Projectile_PosY]
    ldrh    r1, [r4, Projectile_PosX]
    bl      SpawnParticleEffect
    b       @@return
@@chargedHit:
    ldrh    r0, [r4, Projectile_PosY]
    ldrh    r1, [r4, Projectile_PosX]
    mov     r5, r0
    mov     r6, r1
    mov     r2, Particle_ChargedDiffusionMissileExplosion
    bl      SpawnParticleEffect
    ; set projectile RAM values
    mov     r0, #3
    strb    r0, [r4, Projectile_Stage]
    mov     r3, #0
    strb    r3, [r4, Projectile_Timer]
    ldrb    r0, [r4, Projectile_Status]
    mov     r1, 1 << ProjectileStatus_AffectsClipdata
    bic     r0, r1
    mov     r1, 1 << ProjectileStatus_Exploding
    orr     r0, r1
    strb    r0, [r4, Projectile_Status]
    str     r3, [sp]
    str     r3, [sp, #4]
    ldrb    r0, [r4, Projectile_ParentSlot]
    str     r0, [sp, #8]
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r5
    mov     r2, r6
    mov     r3, #0
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r5
    mov     r2, r6
    mov     r3, #40h
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r5
    mov     r2, r6
    mov     r3, #80h
    bl      SpawnSecondaryProjectile
    mov     r0, Projectile_DiffusionFlake
    mov     r1, r5
    mov     r2, r6
    mov     r3, #0C0h
    bl      SpawnSecondaryProjectile
@@checkMovementStage:
    ldrb    r0, [r4, Projectile_Stage]
    cmp     r0, #0
    beq     @@movementStage0
    cmp     r0, #1
    beq     @@movementStage1
    cmp     r0, #3
    beq     @@movementStage3
    cmp     r0, #7
    beq     @@movementStage7
    b       @@movementStage2
@@movementStage0:
    ldr     r0, =SamusUpgrades
    ldrb    r2, [r0, SamusUpgrades_ExplosiveUpgrades]
    ; set boundaries
    ; check super/ice/diffusion
    mov     r1, (1 << ExplosiveUpgrade_SuperMissiles) \
        | (1 << ExplosiveUpgrade_IceMissiles) \
        | (1 << ExplosiveUpgrade_DiffusionMissiles)
    and     r1, r2
    cmp     r1, #0
    beq     @@normalBound
    ldr     r0, =0FFF4h
    strh    r0, [r4, Projectile_BboxTop]
    mov     r0, #0Ch
    strh    r0, [r4, Projectile_BboxBottom]
    ldr     r0, =0FFF0h
    strh    r0, [r4, Projectile_BboxLeft]
    mov     r0, #10h
    strh    r0, [r4, Projectile_BboxRight]
    b       @@initialize
@@normalBound:
    ldr     r0, =0FFF8h
    strh    r0, [r4, Projectile_BboxTop]
    strh    r0, [r4, Projectile_BboxLeft]
    mov     r0, #8
    strh    r0, [r4, Projectile_BboxBottom]
    strh    r0, [r4, Projectile_BboxRight]
@@initialize:
    ; check ice
    mov     r1, 1 << ExplosiveUpgrade_IceMissiles
    and     r1, r2
    cmp     r1, #0
    beq     @@checkSuperOrDiffusionInit
    mov     r0, #1
    mov     r5, Sfx_IceMissile_Fired
    b       @@finishInit
@@checkSuperOrDiffusionInit:
    mov     r1, (1 << ExplosiveUpgrade_SuperMissiles) \
        | (1 << ExplosiveUpgrade_DiffusionMissiles)
    and     r1, r2
    cmp     r1, #0
    beq     @@normalInit
    mov     r0, #0
    mov     r5, Sfx_SuperMissile_Fired
    b       @@finishInit
@@normalInit:
    mov     r0, #0
    mov     r5, Sfx_Missile_Fired
@@finishInit:
    ldrb    r1, [r4, Projectile_Type]
    cmp     r1, Projectile_ChargedDiffusionMissile
    bne     @@noSoundChange
    mov     r5, Sfx_ChargedDiffusionMissile_Fired
@@noSoundChange:
    bl      InitMissile
    mov     r0, r5
    bl      Sfx_Play
    add     r0, r5, #1
    bl      Sfx_Play
    b       @@return
@@movementStage1:
    mov     r0, #2
    strb    r0, [r4, Projectile_Stage]
    mov     r0, #48
    bl      Projectile_Move
    b       @@return
@@movementStage3:
    ldrb    r0, [r4, Projectile_Timer]
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
    cmp     r0, #120
    bls     @@return
    mov     r0, #0
    strb    r0, [r4, Projectile_Status]
    b       @@return
@@movementStage7:
    bl      Missile_MoveTumbling
    b       @@return
@@movementStage2:
    ; count missiles equipped
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_ExplosiveUpgrades]
    mov     r5, r0
    lsr     r0, r0, #1
    mov     r2, #1
    and     r2, r0  ; +1 if super
    lsr     r0, r0, #1
    mov     r1, #1
    and     r1, r0
    add     r2, r2, r1  ; +1 if ice
    lsr     r0, r0, #1
    mov     r1, #1
    and     r1, r0
    add     r2, r2, r1  ; +1 if diffusion
    ; get missile speed
    ldr     r0, =MissileSpeeds
    lsl     r1, r2, #3
    sub     r1, r1, r2
    lsl     r1, r1, #1
    add     r0, r0, r1
    ldrb    r1, [r4, Projectile_Timer]
    lsr     r1, r1, #2
    lsl     r1, r1, #1
    add     r1, r1, r0  ; r1 = SpeedTable + (ProjTimer / 4) * 2
    ldrb    r0, [r1]
    bl      Projectile_Move
    ldrb    r0, [r4, Projectile_Timer]
    cmp     r0, #26
    bhi     @@checkIceTrail ; if ProjTimer <= 26
    add     r0, #1
    strb    r0, [r4, Projectile_Timer]
@@checkIceTrail:
    mov     r0, 1 << ExplosiveUpgrade_IceMissiles
    and     r0, r5
    cmp     r0, #0
    beq     @@checkSuperOrDiffusionTrail
    mov     r0, Particle_IceMissileTrail
    mov     r1, #3
    b       @@finishTrail
@@checkSuperOrDiffusionTrail:
    mov     r0, (1 << ExplosiveUpgrade_SuperMissiles) \
        | (1 << ExplosiveUpgrade_DiffusionMissiles)
    and     r0, r5
    cmp     r0, #0
    beq     @@normalTrail
    mov     r0, Particle_SuperMissileTrail
    mov     r1, #7
    b       @@finishTrail
@@normalTrail:
    mov     r0, Particle_MissileTrail
    mov     r1, #7
@@finishTrail:
    bl      Missile_SetTrail
@@return:
    add     sp, #0Ch
    pop     { r4-r6 }
    pop     { r0 }
    bx      r0
    .pool
.endarea

; missile graphics
.org 0858D324h
    .incbin "data/normal-missile.gfx"
.org 0858D424h
    .incbin "data/super-missile.gfx"
