; Patches miscellaneous story flags to be tracked separately from events.

; TODO: set water lowered flag when exiting room with lowering event active

.org 08041984h
.area 38h, 0
    ; missile hatch idle
    push    { lr }
    ldr     r2, =CurrentSprite
    mov     r3, r2
    add     r3, #20h
    mov     r0, #1
    strb    r0, [r3, Sprite_IgnoreSamusCollisionTimer - 20h]
    ldrb    r0, [r2, Sprite_Health]
    cmp     r0, #0
    bne     @@return
    mov     r0, #18h
    strb    r0, [r3, Sprite_Pose - 20h]
    mov     r0, #0
    strb    r0, [r3, Sprite_Work1 - 20h]
    ldr     r2, =MiscProgress
    ldrh    r1, [r2, MiscProgress_StoryFlags]
    mov     r0, 1 << StoryFlag_MissileHatch
    orr     r0, r1
    strh    r0, [r2, MiscProgress_StoryFlags]
    mov     r0, #1
    bl      08041898h
@@return:
    pop     { pc }
    .pool
.endarea

.org 080418EAh
.area 1Ah, 0
    ; missile hatch initialize
    mov     r4, #0
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_MissileHatch + 1
    bcc     08041904h
    ldr     r1, =CurrentSprite
    strb    r4, [r1, Sprite_Status]
    b       0804196Ah
    .pool
.endarea

.org 08064FFCh
    ; water height check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_WaterLowered + 1
    bcc     08065020h
.org 08065018h
    .pool

.org 08060D98h
.area 18h, 0
    ; water lowered event check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsl     r0, 1Fh - StoryFlag_WaterLowered
    lsr     r0, 1Fh
    bx      lr
    .pool
.endarea

.org 08060E3Ch
.area 18h, 0
    ; pump room active event check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_WaterLowered + 1
    sbc     r0, r0
    neg     r0, r0
    bx      lr
    .pool
.endarea

.org 08060E74h
.area 18h
    ; habitation deck misc pad event check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    mvn     r0, r0
    lsl     r0, #1Fh - StoryFlag_AnimalsFreed
    lsr     r0, #1Fh
    bx      lr
    .pool
.endarea

.org 08060E8Ch
.area 18h
    ; animals saved event check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsl     r0, #1Fh - StoryFlag_AnimalsFreed
    lsr     r0, #1Fh
    bx      lr
    .pool
.endarea

.org 080651BEh
.area 16h, 0
    ; auxiliary power room event effect init
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, #StoryFlag_AuxiliaryPower + 1
    bcs     080652B8h
    ldr     r0, =03004FC8h
    strb    r2, [r0]
    mov     r0, #EventEffect_AuxiliaryPower
    b       080652B6h
.endarea
    .skip 4
    .pool

.org 08063774h
.area 10h
    ; auxiliary power room event effect check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, #StoryFlag_AuxiliaryPower + 1
    bcs     08063802h
    pop     { pc }
    .pool
.endarea


.org 08060EA4h
.area 18h
    ; auxiliary power console event check
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    mvn     r0, r0
    lsl     r0, #1Fh - StoryFlag_AuxiliaryPower
    lsr     r0, #1Fh
    bx      lr
    .pool
.endarea

.org 08060D20h
.area 18h
    ; zoro cocoon event check
    ldr     r0, =MiscProgress
    ldr     r0, [r0, MiscProgress_MajorLocations]
    lsl     r0, #1Fh - MajorLocation_Zazabi
    lsr     r0, #1Fh
    bx      lr
    .pool
.endarea

.org 08030ECCh
.area 34h, 0
    ; electric wire idle
    push    { lr }
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_WaterLowered + 1
    bcc     @@return
    ldr     r1, =CurrentSprite
    ldrh    r0, [r1, Sprite_AnimationFrame]
    cmp     r0, #0
    bne     @@return
    add     r1, Sprite_Pose
    mov     r0, #18h
    strb    r0, [r1]
    lsl     r0, #3
    add     r0, 117h - 0C0h
    ;bl     Sfx_Play
@@return:
    pop     { pc }
    .pool
.endarea

.org 08030FCCh
.area 1Ch, 0
    ; electric water damage update
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_WaterLowered + 1
    bcc     @@return
    ldr     r1, =CurrentSprite
    mov     r0, #0
    strh    r0, [r1, Sprite_Status]
@@return:
    pop     { pc }
    .pool
.endarea

.org 08031038h
.area 1Ch, 0
    ; electric water update
    ldr     r0, =MiscProgress
    ldrh    r0, [r0, MiscProgress_StoryFlags]
    lsr     r0, StoryFlag_WaterLowered + 1
    bcc     @@return
    ldr     r1, =CurrentSprite
    mov     r0, #0
    strh    r0, [r1, Sprite_Status]
@@return:
    pop     { pc }
    .pool
.endarea

; Override event based water lowering. Vanilla code, presumably in some failsafe
; or development function checks if the Event is > 1Fh in any room.
; If so it will trigger lowering the water, even if the Pump Station hasn't been triggered.
; The escape sequence sets Event to 67h. Change the code to always branch to the 
; code location used when Event <= 1Fh
.org 08063754h
.area 0Ah, 0
    b       80637FEh  
.endarea

.org 08063956h
.area 52h, 0
    ; update water lowered flag
    ldr     r5, =03004E4Ch
    ldr     r1, =MiscProgress
    ldrh    r0, [r1, MiscProgress_StoryFlags]
    mov     r1, 1 << StoryFlag_WaterLowered
    orr     r0, r1
    ldr     r1, =MiscProgress
    strh    r0, [r1, MiscProgress_StoryFlags]
    ldrh    r0, [r5, #8]
    add     r0, #1
    strh    r0, [r5, #8]
    mov     r1, #28h
    lsl     r1, #4
    cmp     r0, r1
    blt     @@checkScreenShake
    strh    r1, [r5, #8]
    mov     r0, #8Fh
    lsl     r0, #1
    bl      08002738h
    mov     r0, r5
    sub     r0, 03004E4Ch - 03004E3Ah
    strb    r4, [r0]
    mov     r6, #2
@@checkScreenShake:
    ldr     r0, =030000F0h
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@skipScreenShake
    mov     r0, #14h
    mov     r1, #81h
    bl      0806258Ch
@@skipScreenShake:
    b       08063C2Ah
    .pool
.endarea

.org 080395A4h
.area 0A0h
    ; miscellaneous console event handler
    push    { lr }
    sub     sp, #0Ch
    ldr     r2, =MiscProgress
    ldr     r3, =CurrentSprite + Sprite_Id
    ldrb    r0, [r3, Sprite_Work1 - Sprite_Id]
    sub     r0, #1
    strb    r0, [r3, Sprite_Work1 - Sprite_Id]
    bne     @@return
    mov     r0, #1Eh
    strb    r0, [r3, Sprite_Pose - Sprite_Id]
    ldrb    r0, [r3]
    cmp     r0, #SpriteId_PumpControlPad
    beq     @@lower_water_level
    cmp     r0, #SpriteId_BoilerControlPad
    beq     @@boiler_cooling
    cmp     r0, #SpriteId_AuxiliaryPowerPad
    beq     @@auxiliary_power
    cmp     r0, #SpriteId_HabitationControlPad
    beq     @@animals_freed
    b       @@return
@@lower_water_level:
    mov     r0, #EventEffect_WaterLowering
    bl      0806368Ch
    mov     r0, #Message_WaterLowered
    b       @@spawn_message_box
@@boiler_cooling:
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    mov     r1, #1 << StoryFlag_BoilerCooling
    orr     r0, r1
    strh    r0, [r2, MiscProgress_StoryFlags]
    ldr     r1, =DoorUnlockTimer
    mov     r0, #60
    strb    r0, [r1]
    ; Load proper location into r0
    mov     r0, #MajorLocation_BoilerCooling
    bl      ObtainMajorLocation
    ; Message ID returned in r0
@@auxiliary_power:
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    mov     r1, #1 << StoryFlag_AuxiliaryPower
    orr     r0, r1
    strh    r0, [r2, MiscProgress_StoryFlags]
    ; Load proper location into r0
    mov     r0, #MajorLocation_AuxiliaryPower
    bl      ObtainMajorLocation
    ; Message ID returned in r0
@@animals_freed:
    ldrh    r0, [r2, MiscProgress_StoryFlags]
    mov     r1, #1 << StoryFlag_AnimalsFreed
    orr     r0, r1
    strh    r0, [r2, MiscProgress_StoryFlags]
    ; Load proper location into r0
    mov     r0, #MajorLocation_AnimalsFreed
    bl      ObtainMajorLocation
    ; Message ID returned in r0
@@spawn_message_box:
    bl      ConsoleMessageBoxIdAdjustment
    ldr     r2, =TimeStopTimer
    mov     r0, #1000 >> 2
    lsl     r0, #2
    strh    r0, [r2]
    ldr     r2, =030006A0h
    ldrh    r0, [r2]
    str     r0, [sp]
    ldrh    r0, [r2, #2]
    str     r0, [sp, #4]
    mov     r0, #0
    str     r0, [sp, #8]
    mov     r0, #SpriteId_MessageBox
    mov     r2, #2
    mov     r3, #10h
    bl      SpawnPrimarySprite
@@return:
    add     sp, #0Ch
    pop     { pc }
    .pool
.endarea

.autoregion
.align 2
.func ConsoleMessageBoxIdAdjustment
    mov     r1, r0
    cmp     r1, #Message_LastInfantMetroid
    bgt     @@adjust_offset
    ; when r1 is 0, Message box will use the Major messages
    mov     r1, #0
    b       @@return
@@adjust_offset:
    sub     r1, #Message_AtmosphericStabilizer1 - 1
@@return:
    bx      lr
.endfunc
.endautoregion


.org 08060BFCh
.area 18h
    ; blue x flee after varia suit is acquired
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, SamusUpgrades_SuitUpgrades]
    lsl     r0, #1Fh - SuitUpgrade_VariaSuit
    lsr     r0, #1Fh
    bx      lr
    .pool
.endarea
