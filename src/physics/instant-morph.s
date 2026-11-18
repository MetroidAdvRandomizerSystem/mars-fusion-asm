; Add Instant (Un)Morph via SELECT button
.org InstantMorphFlagPointer
    .dw     InstantMorphFlag

.dataautoregion
InstantMorphFlag:
    .db     00
.endautoregion    

.codeautoregion
.align 2
; r0 has boolean return value on whether we should instant morph
.func @CheckInstantMorph
    push    { lr }
    ldr     r1, =InstantMorphFlag
    ldrb    r0, [r1]
    cmp     r0, #01
    bne     @@if_false

    ; If SELECT got pressed
    ldr     r0, =ToggleInput
    ldrh    r0, [r0]
    mov     r1, #(1 << Button_Select)
    and     r0, r1
    cmp     r0, #0
    beq     @@if_false
    ; ...and we have Morph
    ldr     r0, =SamusUpgrades
    ldrb    r0, [r0, #SamusUpgrades_SuitUpgrades]
    mov     r1, #(1 << SuitUpgrade_MorphBall)
    and     r0, r1
    cmp     r0, #0
    beq     @@if_false
    ; ...then set to Morphing pose
@@if_true:
    mov     r0, #01
    b       @@return
@@if_false:
    mov     r0, #00
@@return:
    pop     { pc }
    .pool
.endfunc
.endautoregion



; Poses that should transition into Morph Ball
; In all of these hijacks, we're free to use r0 and r1 in our code.

; Standing Pose
.org 080065E4h
.area 4
    bl      @SamusStandingHijack
.endarea

.codeautoregion
.align 2
; r0 is used as the return value in the outer function, as SamusPose
; When returning back to the original call, r0 and r4 have to be restored
.func @SamusStandingHijack
.definelabel @@ReturnInOuterFunction, 080066EAh

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    mov     r0, SoundEffect_Morph
    bl      Sfx_Play
    mov     r0, #SamusPose_Morphing
    pop     { r1 }
    ldr     r1, =@@ReturnInOuterFunction
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =HeldInput
    ldr     r4, =SamusState
    pop     { pc }
    .pool
.endfunc
.endautoregion


; Running Pose
.org 08006882h
.area 4
    bl      @SamusRunningHijack
.endarea

.codeautoregion
.align 2
; r0 is used as the return value in the outer function, as SamusPose
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusRunningHijack
.definelabel @@ReturnInOuterFunction, 08006982h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    mov     r0, SoundEffect_Morph
    bl      Sfx_Play
    mov     r0, #SamusPose_Morphing
    pop     { r1 }
    ldr     r1, =@@ReturnInOuterFunction
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion



; Crouching Pose
.org 08006E84h
.area 4
    bl      @SamusCrouchingHijack
.endarea

.codeautoregion
.align 2
; r0 is used as the return value in the outer function, as SamusPose
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusCrouchingHijack
.definelabel @@ReturnInOuterFunction, 08006F64h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    mov     r0, SoundEffect_Morph
    bl      Sfx_Play
    mov     r0, #SamusPose_Morphing
    pop     { r1 }
    ldr     r1, =@@ReturnInOuterFunction
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion


; Mid-Air Pose
.org 08006A52h
.area 4
    bl      @SamusMidAirHijack
.endarea

.codeautoregion
.align 2
; r0 is used as the return value in the outer function, as SamusPose
; When returning back to the original call, r1 and r2 have to be restored
.func @SamusMidAirHijack
.definelabel @@ReturnInOuterFunction, 08006B64h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    ; Additionally, also only proceed if neither left nor right is pressed
    ldr     r0, =HeldInput
    ldrh    r0, [r0]
    mov     r1, #((1 << Button_Left) + (1 << Button_Right))
    and     r0, r1
    cmp     r0, #0
    bne     @@OriginalCode
    mov     r0, SoundEffect_Morph
    bl      Sfx_Play
    mov     r0, #SamusPose_MorphBallMidAir
    pop     { r1 }
    ldr     r1, =@@ReturnInOuterFunction
    mov     pc, r1

@@OriginalCode:
    ldr     r2, =ToggleInput
    ldrh    r1, [r2]
    pop     { pc }
    .pool
.endfunc
.endautoregion


; Intentionally not hijack Spinjumping and Walljumping in order to prevent abuse


; Unmorphing Pose
.org 0800765Ah
.area 4
    bl      @SamusUnmorphingHijack
.endarea

.codeautoregion
.align 2
; r0 is used as the return value in the outer function, as SamusPose
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusUnmorphingHijack
.definelabel @@ReturnInOuterFunction, 08007688h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    ; We do NOT want to play the morphing sound effect here.
    mov     r0, #SamusPose_Morphing
    pop     { r1 }
    ldr     r1, =@@ReturnInOuterFunction
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion



; Poses that should transition out of Morph Ball
; In all of these hijacks, we're free to use r0 and r1 in our code.

; Morph Ball Pose
.org 080074C4h
.area 4
    bl      @SamusMorphBallHijack
.endarea

.codeautoregion
.align 2
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusMorphBallHijack
.definelabel @@CheckForMoreUnmorphingConditions, 080074D0h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    pop     { r1 }
    ldr     r1, =@@CheckForMoreUnmorphingConditions
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion

; Rolling Pose
.org 080075E0h
.area 4
    bl      @SamusRollingHijack
.endarea

.codeautoregion
.align 2
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusRollingHijack
.definelabel @@CheckForMoreUnmorphingConditions, 080075ECh

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    pop     { r1 }
    ldr     r1, =@@CheckForMoreUnmorphingConditions
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion


; Morph Ball Mid-Air Pose
.org 080076DAh
.area 4
    bl      @SamusMorphBallMidAirHijack
.endarea

.codeautoregion
.align 2
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusMorphBallMidAirHijack
.definelabel @@CheckForMoreUnmorphingConditions, 080076E6h

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    pop     { r1 }
    ldr     r1, =@@CheckForMoreUnmorphingConditions
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion


; Morphing Pose
.org 080073FEh
.area 4
    bl      @SamusMorphingHijack
.endarea

.codeautoregion
.align 2
; When returning back to the original call, r0 and r1 have to be restored
.func @SamusMorphingHijack
.definelabel @@CheckForMoreUnmorphingConditions, 0800740Ah

    push    { lr }
    bl      @CheckInstantMorph
    cmp     r0, #0
    beq     @@OriginalCode
    pop     { r1 }
    ldr     r1, =@@CheckForMoreUnmorphingConditions
    mov     pc, r1

@@OriginalCode:
    ldr     r0, =ToggleInput
    ldrh    r1, [r0]
    pop     { pc }
    .pool
.endfunc
.endautoregion
