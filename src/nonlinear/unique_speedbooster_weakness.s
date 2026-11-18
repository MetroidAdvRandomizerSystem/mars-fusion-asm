
; Hijack ProjectileContactDamageHitSprite to properly handle speedbooster vs screw attack weakness

.codeautoregion
.align 2
.func @ScrewSpeedWeaknessHijack
    ; r0 contains the sprite weaknesses of the sprite
    ; r0 also contains the return value on whether the condition succeeded or failed
    ; r1 contains SpriteWeakness_ScrewAttack as a return value

    ; The condition is true if:
    ; (r0 & weakness_screw != 0) and (samus.pose == screw)
    ; or (r0 & weakness_speed != 0) and (samus.pose == speed or samus.speedcounter != 0)

    ; Check speed.
    push    { lr }
    mov     r1, (1 << SpriteWeakness_Speedbooster)
    and     r1, r0
    cmp     r1, #0
    beq     @@check_screw       ; Check that sprite is weak to speed...
    ldr     r1, =SamusState
    ldrb    r2, [r1, SamusState_Pose]
    cmp     r2, #SamusPose_Shinesparking
    beq     @@condition_true    ; ...and that we're either in shinesparking...
    ldrb    r2, [r1, SamusState_SpeedboostingCounter]
    cmp     r2, #0              ; ...or that we're currently speedboosting.
    bne     @@condition_true

    ; Check Screw
@@check_screw:
    mov     r1, (1 << SpriteWeakness_ScrewAttack)
    and     r1, r0
    cmp     r1, #0
    beq     @@condition_fail    ; If the speed check failed, check that the sprite is weak to Screw...
    ldr     r1, =SamusState
    ldrb    r2, [r1, SamusState_Pose]
    cmp     r2, #SamusPose_ScrewAttacking
    bne     @@condition_fail    ; ...and that we're currently screw attacking.

@@condition_true:
    mov     r0, #1
    b       @@return

@@condition_fail:
    mov     r0, #0

@@return:
    mov     r1, (1 << SpriteWeakness_ScrewAttack)
    pop     { pc }
.endfunc
.pool
.endautoregion

.org 080834c0h   ; In ProjectileContactDamageHitSprite
.area 8
    bl      @ScrewSpeedWeaknessHijack
    mov     r9, r1
    cmp     r0, #0
.endarea


; Change all the enemy data to properly differentiate between screw and speed weakness
; Primaries
adjust_speed_weakness_of_sprites 0, 127, SpriteStats
adjust_speed_weakness_of_sprites 128, 256, SpriteStats
; Secondaries
adjust_speed_weakness_of_sprites 0, 127, SecondarySpriteStats
adjust_speed_weakness_of_sprites 128, 256, SecondarySpriteStats
