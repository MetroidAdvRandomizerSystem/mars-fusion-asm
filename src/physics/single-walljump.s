; Hijack setting of Screw Attack Pose. If the pose was WallJumping (16h), set RAM flag
.org 080061D0h
    bl     @SetScrewWJFlag

.autoregion
.align 2
.func @SetScrewWJFlag
    push    { r0-r3 }
    ldr     r2, =SamusState
    ldrb    r0, [r2, SamusState_Pose]
    cmp     r0, #SamusPose_WallJumping
    bne     @@default
    ; Do not set if space jump is active
    ldr     r1, =SamusUpgrades
    ldrb    r1, [r1, SamusUpgrades_SuitUpgrades]
    mov     r0, 1 << SuitUpgrade_SpaceJump
    and     r0, r1
    cmp     r0, #0
    bne     @@default
    mov     r0, #1
    ldr     r2, =ScrewAttackWJFlag
    strb    r0, [r2]
@@default:
    ; Always set Pose to Screw
    ldr     r2, =SamusState
    mov     r0, #SamusPose_ScrewAttacking
    strb    r0, [r2, SamusState_Pose]
    pop     { r0-r3 }
    bl      0800623Ch ; Return to original code flow
    .pool
.endfunc
.endautoregion

; Hijack Spinning Pose Velocity Code. If the ScrewWJ flag is set, do not allow change of directions
; Until Vertical Velocity is <= 0
.org 080072D4h
    bl      @PreventDirectionChangeDuringScrewWJ

.org 0800733Ch
.area 06h, 0
    bl      @UseIncreasedVelocityDuringScrewWJ
.endarea

.autoregion
.align 2
.func @PreventDirectionChangeDuringScrewWJ
    push    { r2 }
    ; If pose isn't screw attack, allow, and turn flag off if it was on
    ldr     r2, =SamusState
    ldrb    r0, [r2, SamusState_Pose]
    cmp     r0, #SamusPose_ScrewAttacking
    bne     @@unsetScrewWJFlag
    ; Check Flag
    ldr     r2, =ScrewAttackWJFlag
    ldrb    r2, [r2]
    cmp     r2, #1
    bne     @@allow
    ldr     r2,=SamusState
    mov     r0, SamusState_VelocityY
    ldrsh   r0, [r2, r0]
    cmp     r0, #0h
    bgt     @@prevent
@@unsetScrewWJFlag:
    ; Turn ScrewWJ flag off
    mov     r0, #0
    ldr     r2, =ScrewAttackWJFlag
    strb    r0, [r2]
@@allow:
    mov     r0, #0
    strh    r3, [r6, SamusState_Direction]
    strh    r0, [r6, SamusState_VelocityX]
    b       @@return
@@prevent:
    ldrh    r3, [r6, SamusState_Direction]
@@return:
    ldrh    r1, [r6, SamusState_WallJumpDirection]
    pop     { r2 }
    bl      080072DCh ; Return to original code flow
    .pool
.endfunc

; Returns r1 = Acceleration
; r2 is cleared after this function, it is not necessary to push it
.func @UseIncreasedVelocityDuringScrewWJ
    push    { r0 }
    ; Turn ScrewWJ flag off if Y Velocity <= 0 and A button is not down
    ldr     r2,=SamusState
    mov     r0, SamusState_VelocityY
    ldrsh   r0, [r2, r0]
    cmp     r0, #0h
    bgt     @@checkIfScrewWJ
    ldr     r0, =HeldInput
    mov     r1, 1 << Button_A
    ldrh    r0, [r0]
    and     r0, r1
    bne     @@checkIfScrewWJ
    mov     r0, #0
    ldr     r2, =ScrewAttackWJFlag
    strb    r0, [r2]
@@checkIfScrewWJ:
    ldr     r0, =ScrewAttackWJFlag
    ldrb    r0, [r0]
    cmp     r0, #1
    bne     @@default
    mov     r1, #40h
    b       @@return
@@default:
    ldr     r1, =SamusPhysics
    mov     r2, SamusPhysics_MidairXVelocityCap
    ldrsh   r1, [r1, r2]
@@return:
    pop     { r0 }
    bl      08007342h ;Return to original code flow
    .pool
.endfunc
.endautoregion

; Hijack the end of the SamusUpdate function, if pose isn't Screw Attack, always clear the flag
.org 0800657Ch
    bl      @ClearScrewWJFlagIfNecessary

.autoregion
.func @ClearScrewWJFlagIfNecessary
    push    { r0, r2 }
    ; If pose isn't screw attack, turn flag off
    ldr     r2, =SamusState
    ldrb    r0, [r2, SamusState_Pose]
    cmp     r0, #SamusPose_ScrewAttacking
    bne     @@unsetScrewWJFlag
    b       @@return
@@unsetScrewWJFlag:
    ; Turn ScrewWJ flag off
    mov     r0, #0
    ldr     r2, =ScrewAttackWJFlag
    strb    r0, [r2]
@@return:
    ; default behavior
    pop     { r0, r2 }
    pop     { r4, r5 }
    pop     { r1 }
    bx      r1
    .pool
.endfunc
.endautoregion