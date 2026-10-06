; Splits gravity suit functionality such that only varia protects from
; environmental damage, and damage reduction is incremental.
; Currently varia negates heat and cold damage, reduces lava and acid damage
; to 40%, and negates lava damage when gravity suit is also acquired.
; Gravity by itself does not negate damage.
; Also splits up sprite damage so that the reductions are based off of how many suits you 
; have instead of prioritizing gravity over varia.

; NOTE: Damage tick sfx can occur extremely often at higher values of heat,
; subzero, or cold hazard damage. Worth looking into if problems with the
; sound engine start occurring.

@VariaReduction equ 0.4
@VfxInitialCountdownValue equ 10 ; in frames
@ColdKnockbackFrameTreshold equ (FramesPerSecond * 1.45)
@SamusHurtGruntThreshold equ ((FramesPerSecond / 2) + (FramesPerSecond * 0.8))
@LidquidHazardHurtSfxThreshold1 equ ((@SamusHurtGruntThreshold - @SamusHurtGruntThreshold) + 1)
@LidquidHazardHurtSfxThreshold2 equ ((@SamusHurtGruntThreshold / 2) + 1)

; Rewrite the entire SamusHazardDamage Function
; Function returns a bool in r0, indicating whether Samus should transition into a hurt pose.
.org 08006290h
.area 168h
    push    { r4-r5, lr }
    ldr     r5, =SamusTimers
    ldr     r1, =SamusState
    ; Same check as in vanilla: if we're dying, return false.
    ldrb    r0, [r1, SamusState_Pose]
    cmp     r0, #SamusPose_Dying
    beq     @@return_false

    ; Get Clipdata at Samus position 
    ldrh    r0, [r1, SamusState_PositionY]
    ldrh    r1, [r1, SamusState_PositionX]
    bl      ClipdataCheckCurrentAffectingAtPosition
    ; r0 contains movement clipdata and hazard clipdata in upper/lower bytes.
    mov     r2, #0FFh
    and     r0, r2
    mov     r4, r0
    ; Checks whether hazard is in between lava and subzero
    sub     r0, #EnvironmentalHazard_Lava
    cmp     r0, #EnvironmentalHazard_Subzero - EnvironmentalHazard_Lava
    bhi     @@clear_timers

    ; It is, so continue and increase the environmental damage timer
    ldr     r1, =EnvironmentalHazardDps
    ldrb    r2, [r1, r0]
    ; TODO: maybe special cases for when r2 is 0?
    ldrb    r3, [r5, SamusTimers_EnvironmentalDamage]
    add     r3, r2
    ; Check if we have Varia equipped
    ldr     r1, =SamusUpgrades
    ldrb    r1, [r1, SamusUpgrades_SuitUpgrades]
    lsr     r0, r1, #SuitUpgrade_VariaSuit + 1
    bcc     @@full_damage
    ; We do, so now check if the hazard clipdata is between heat and subzero
    ; These are all hazards that get nullified by varia, so if it is we exit
    sub     r0, r4, #EnvironmentalHazard_Heat
    cmp     r0, #EnvironmentalHazard_Subzero - EnvironmentalHazard_Heat
    bls     @@clear_timers

    ; Check if we have Gravity equipped. If we don't then apply the varia-damage-reduction.
    lsr     r1, #SuitUpgrade_GravitySuit + 1
    bcc     @@reduced_damage
    ; We do, so now check if the hazard is lava. If it is, then we exit.
    ; If it's not, then it has to be acid at this point, where we then apply the varia-damage-reduction
    cmp     r4, #EnvironmentalHazard_Lava
    beq     @@clear_timers

@@reduced_damage:
    mov     r1, (#FramesPerSecond / @VariaReduction)
    b       @@divrem_damage
@@full_damage:
    mov     r1, #FramesPerSecond
@@divrem_damage:
    ; Do a division remainder with r3 // r1. Afterwards r3 contains remainder, r0 contains quotient
    ; We do this to figure out how much damage to apply per frame
    mov     r0, #0
    cmp     r3, r1
    blt     @@decrement_energy
@@divrem_damage_loop:
    add     r0, #1
    sub     r3, r1
    cmp     r3, r1
    bge     @@divrem_damage_loop
@@decrement_energy:
    ; If applied damge (quotient) is 0, skip decrementing health
    strb    r3, [r5, SamusTimers_EnvironmentalDamage]
    cmp     r0, #0
    beq     @@check_infrequent_damage_sfx

    ; Decrement health and write it back
    ldr     r2, =SamusUpgrades
    ldrh    r1, [r2, SamusUpgrades_CurrEnergy]
    sub     r1, r0
    ; Clamp health (r1) to not underflow
    asr     r0, r1, #31
    bic     r1, r0
    strh    r1, [r2, SamusUpgrades_CurrEnergy]

    ; Reset the Vfx countdown if it reached 0.
    ldrb    r0, [r5, SamusTimers_EnvironmentalDamageVfx]
    cmp     r0, #0
    bhi     @@check_damage_tick_sfx
    mov     r0, #@VfxInitialCountdownValue
    strb    r0, [r5, SamusTimers_EnvironmentalDamageVfx]

@@check_damage_tick_sfx:
    ; If in Heat to Subzero, play a damage tick sound
    sub     r0, r4, #EnvironmentalHazard_Heat
    cmp     r0, #EnvironmentalHazard_Subzero - EnvironmentalHazard_Heat
    bhi     @@check_infrequent_damage_sfx
    mov     r0, #SoundEffect_AirEnvironmentDamageTick
    bl      Sfx_Play

@@check_infrequent_damage_sfx:
    ; Increase Sfx timer.
    ldrb    r1, [r5, SamusTimers_EnvironmentalDamageSfx]
    add     r1, #1
    strb    r1, [r5, SamusTimers_EnvironmentalDamageSfx]
    ; If we're not in a liquid hazard, jump to checking grunt sfx
    sub     r0, r4, #EnvironmentalHazard_Lava
    cmp     r0, #EnvironmentalHazard_Acid - EnvironmentalHazard_Lava
    bhi     @@check_damage_grunt_sfx
    ; If we are in liquid, play liquid damage sfx if met the two thresholds
    cmp     r1, #@LidquidHazardHurtSfxThreshold1
    beq     @@play_rapid_damage_sfx
    cmp     r1, #LidquidHazardHurtSfxThreshold2
    bne     @@check_damage_grunt_sfx

@@play_rapid_damage_sfx:
    mov     r0, #SoundEffect_LiquidEnvironmentDamageTick
    bl      Sfx_Play
    b       @@check_knockback

@@check_damage_grunt_sfx:
    cmp     r1, #SamusHurtGruntThreshold
    beq     @@play_damage_grunt_sfx
    b       @@check_knockback

@@play_damage_grunt_sfx:
    ; Play hurt grunt sfx and reset sfx timer.
    mov     r0, #SoundEffect_SamusHurtGrunt
    bl      MusicWrapper_unk3B78
    mov     r0, #0
    strb    r0, [r5, SamusTimers_EnvironmentalDamageSfx]

@@check_knockback:
    ; If the hazard is cold, and the cold threshold is reached, reset knockback timer and request hurt pose
    cmp     r4, #EnvironmentalHazard_Cold
    bne     @@check_hp
    ldrb    r0, [r5, SamusTimers_ColdKnockback]
    add     r0, #1
    strb    r0, [r5, SamusTimers_ColdKnockback]
    cmp     r0, #ColdKnockbackFrameTreshold
    blt     @@check_hp
    mov     r0, #0
    strb    r0, [r5, SamusTimers_ColdKnockback]
    b       @@return_true

@@clear_timers:
    ; No environmental damages affect samus, so clear all timers.
    mov     r0, #0
    strb    r0, [r5, SamusTimers_ColdKnockback]
    strb    r0, [r5, SamusTimers_EnvironmentalDamage]
    strb    r0, [r5, SamusTimers_EnvironmentalDamageSfx]
    strb    r0, [r5, SamusTimers_EnvironmentalDamageVfx]

@@check_hp:
    ; If dead, signal a hurt pose
    ldr     r1, =SamusUpgrades
    ldrh    r0, [r1, SamusUpgrades_CurrEnergy]
    cmp     r0, #0
    bne     @@return_false

@@return_true:
    mov     r0, #1
    b       @@return
@@return_false:
    mov     r0, #0
@@return:
    ; Decrease Vfx timer by 1, clamp it so it doesn't underflow, and write it back
    ldrb    r1, [r5, SamusTimers_EnvironmentalDamageVfx]
    sub     r1, #1
    asr     r2, r1, #31
    bic     r1, r2
    strb    r1, [r5, SamusTimers_EnvironmentalDamageVfx]
    pop     { r4-r5, lr }
    .pool
.endarea

.org EnvironmentalHazardDpsPointer
.area 04h
    .dw     EnvironmentalHazardDps
.endarea

.autoregion
EnvironmentalHazardDps:
; These units are all damage per second
    .db     20  ; lava
    .db     60  ; acid
    .db     6   ; heat
    .db     15  ; cold
    .db     6   ; subzero
.endautoregion

; Repoint VFX check to actually look at the VFX RAM value
; Hijacks in SamusUpdateGraphics
; This line https://github.com/metroidret/mf/blob/025c335836d81af71258a2c928c764c865374bf5/src/samus.c#L7158 
; to check for Environmental Damage Vfx instead of SamusTimers_EnvironmentalDamage
.org 0800BDB6h
.area 2
    ldrb    r0, [r3, SamusTimers_EnvironmentalDamageVfx]
.endarea

; Hijacks in TakeDamageFromSprite
; Original code reduces damage based on whether you had gravity or varia, with gravity taking priority
; This code changes it so damage reduction is based off of how many suits you have instead.
; Hijack should end maximum at 0800FEB8h as that's where the rest of vanilla code continues
.org 0800FE72h
.area 1Ah
    ; Contact damage reduction
    ldr     r5, =SamusUpgrades
    ldrb    r0, [r5, SamusUpgrades_SuitUpgrades]
    ; This effectively puts into r0 whether we have 0, 1 or 2 suit upgrades
    lsl     r1, r0, #31 - SuitUpgrade_VariaSuit
    lsr     r1, #31
    lsl     r0, #31 - SuitUpgrade_GravitySuit
    lsr     r0, #31
    add     r0, r1
    ; Don't quite understand it this tbh, but vanilla code does it too.
    lsl     r0, #1
    lsl     r1, r4, #1
    add     r1, r4
    lsl     r1, #1
    add     r0, r1
    b       @@cont
.endarea
.area 0Ch
    .skip 4
    .pool
.endarea
.area 28h
@@cont:
    ldr     r1, =082E493Ch ; SuitDamageReductionPercent
    b       0800FEB8h ; back to vanilla code.
    .pool
.endarea
