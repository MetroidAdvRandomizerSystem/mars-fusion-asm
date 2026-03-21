; Enforces intended Geron weaknesses (charge, missiles, super missiles, power bombs, speed)
; NOTE: Relies on unique_speedbooster_weakness!

.definelabel @missile_and_speed_weakness, (1 << SpriteWeakness_Missiles) | (1 << SpriteWeakness_Speedbooster)
.definelabel @supers_and_speed_weakness, (1 << SpriteWeakness_SuperMissiles) | (1 << SpriteWeakness_Speedbooster)
.definelabel @pbs_and_speed_weakness, (1 << SpriteWeakness_PowerBombs) | (1 << SpriteWeakness_Speedbooster)

; Atmospheric Geron weaknesses
.org SpriteStats + AtmosphericStabilizerParasite_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_ChargeBeam) | @missile_and_speed_weakness

; Missile Geron weaknesses
.org SpriteStats + XBarrierCoreNormal1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @missile_and_speed_weakness

.org SpriteStats + XBarrierCoreNormal2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @missile_and_speed_weakness

.org SpriteStats + XBarrierCoreNormal3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @missile_and_speed_weakness

; Super Missile Geron weaknesses
.org SpriteStats + XBarrierCoreSuper1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper4_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper5_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper6_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper7_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

.org SpriteStats + XBarrierCoreSuper8_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @supers_and_speed_weakness

; Power Bomb Geron weaknesses
.org SpriteStats + XBarrierCorePower1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower4_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower5_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower6_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower7_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

.org SpriteStats + XBarrierCorePower8_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     @pbs_and_speed_weakness

; Changes the clipdata passed into function XBarrierCoreSetCollision (08029cf0h)
; to not allow the player to pass through using Screw Attack or Speed Booster

; Missile Geron
.org 08029E68h
    mov r0, ClipdataAction_MakeSolid

; Power Bomb Geron
.org 08042310h
    mov r0, ClipdataAction_MakeSolid


; Increases the sideways hitbox of each Geron, so that
; you can shinespark/speedboost through them without bonking against the solid collision
; These are all modified in their respective Init functions.
; FIXME: Instead of increasing hitboxes, create a new speedboostable clipdata type

.definelabel @missile_geron_hitbox, 4Ah
.definelabel @super_geron_hitbox, 4Ah
.definelabel @pb_geron_hitbox, 4Ah

; Missile Geron
.org 08029E64h
.area 1
    .db (100h - @missile_geron_hitbox)
.endarea

.org 08029E34h
.area 2
    mov     r0, @missile_geron_hitbox
.endarea

; Super Missile Geron
.org 08041F9Ch
.area 1
    .db (100h - @super_geron_hitbox)
.endarea

.org 08041F6Ch
.area 2
    mov     r0, @super_geron_hitbox
.endarea

; Power Bomb Geron
.org 0804230Ch
.area 1
    .db (100h - @pb_geron_hitbox)
.endarea

.org 080422DCh
.area 2
    mov     r0, @pb_geron_hitbox
.endarea


.org 08041FA0h      ; in SuperMissileGeronInit
.area 6, 0
    bl @SuperGeronInitHijack
.endarea

.autoregion
.align 2
.func @SuperGeronInitHijack
; Make Super Missile Geron passable if it hasn't formed yet, but impassable once it has formed.
; Changes the function in SuperMissileGeronInit, to only set collision if pose is not Spawning_From_X
    push    { lr }
    ldr     r1, =CurrentSprite
    add     r1, Sprite_Pose
    ldrb    r0, [r1, #0]
    cmp     r0, #5Ah        ; SPRITE_POSE_SPAWNING_FROM_X
    beq     @@return
    mov     r0, ClipdataAction_MakeSolid
    bl 	    GeronSetCollision
@@return:
    pop     { pc }
.endfunc
.pool

.func @SuperGeronIdleInitHijack
; Call GeronSetCollision at the end of SuperMissileGeronIdleInit
    push    { lr }
    mov     r0, ClipdataAction_MakeSolid
    bl      GeronSetCollision

    ; Restore original code
    add     r2, r1, #00
    add     r2, #24h
    mov     r3, #0
    mov     r0, #2
    strb    r0, [r2, #0]
    pop     { pc }
.endfunc
.endautoregion

.org 08041FB2h  ; end of SuperMissileGeronIdleInit
.area 10
    ; We need to manually save/restore lr here
    push    { lr }
    bl @SuperGeronIdleInitHijack
    pop     { pc }
.endarea
