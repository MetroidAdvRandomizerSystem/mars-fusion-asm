; Hatch fixes that are needed for door lock shuffle

; allow more than 2 lockable hatches that are open
.org 080654ACh
.area 2Ch
    ; check all hatch slots from 5 to 0
    ldr     r0, =HatchData
    mov     r6, #5
    mov     r2, #1
@@loop:
    lsl     r1, r6, #2
    ldrb    r1, [r0, r1]
    and     r1, r2
    cmp     r1, #0
    beq     080654D8h
    sub     r6, #1
    cmp     r6, #0
    blt     08065534h
    b       @@loop
    .pool
.endarea

; determine hatch facing direction from x exit distance
.org 08065500h
.area 0Ch
    ldrb    r0, [r7, DoorEntry_ExitDistanceX]
    cmp     r0, #80h
    bcs     08065524h
    b       0806550Ch
.endarea


; Modifying code in CheckUnlockHatches
.org 08063CA0h
    bl      @ResetEventHatches

; Modifying code in LoadDoors
.org 08065608h
    bl      @StoreHatchTypes


.autoregion
.align 4
.func @StoreHatchTypes
    push    { r1 - r3 }
    ; Check if code should run
    ldr     r0, =NonGameplayFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@return ; exit early if called from non-gameplay or cutscene
    ldr     r1, =OriginalHatchTypes
    ldr     r2, =HatchData
    mov     r3, #0 ; Loop counter
@@hatchLoop:
    ldrb    r0, [r2, HatchData_Status]
    ; Mask out everything but the type
    lsr     r0, #5
    lsl     r0, #5
    strb    r0, [r1, r3]
@@loopIncrement:
    add     r2, #4
    add     r3, #1
    cmp     r3, #6
    bne     @@hatchLoop ; Loop for all hatches
@@return:
    pop     { r1 - r3 }
    ; Hijacked code simply pops r0 and returns, same functionality must be maintained
    pop     r0
    bx      r0
    .pool
.endfunc
.endautoregion

.autoregion
.align 4
.func @ResetEventHatches
    push    { r0 - r3 }
    ; Some event rooms use #1 in the timer to set events. #2 will only be in the timer during an actual event unlock
    ; This will technically change the hatches one frame early
    cmp     r0, #2
    bne     @@return
    ldr     r2, =HatchData
    mov     r3, #0 ; Loop counter
@@hatchLoop:
    ; Ignore if not an event hatch
    ldrb    r0, [r2, HatchData_Status]
    mov     r1, r0
    lsr     r1, #5
    cmp     r1, #5 ; Event Door type ("can lock")
    bne     @@loopIncrement
    ; Mask out hatch type
    lsl     r0, r0, #27
    lsr     r0, r0, #27
    ; Load original hatch type
    ldr     r1, =OriginalHatchTypes
    ldrb    r1, [r1, r3]
    orr     r0, r1
    strb    r0, [r2, HatchData_Status]
    ; Determine hatch animation, everything closes except for open hatches
    lsr     r0, #5
    cmp     r0, #6
    beq     @@opening
    b       @@closing
@@opening:
    ; By setting the animation flag to 1, the opening animation triggers and the hatch works correct
    mov     r1, #1
    strb    r1, [r2, HatchData_Animation]
    b       @@loopIncrement
@@closing:
    ; By setting the animation flag to 3, and status to 9, the hatch closes immediately
    ; The hatch type needs to be preserved though
    ldrb    r0, [r2, HatchData_Status]
    ; Clear Animation Information
    lsr     r0, #4
    lsl     r0, #4
    mov     r1, #9h
    orr     r1, r0
    strb    r1, [r2, HatchData_Status]
    mov     r1, #3
    strb    r1, [r2, HatchData_Animation]
@@loopIncrement:
    add     r2, #4
    add     r3, #1
    cmp     r3, #6
    bne     @@hatchLoop ; Loop for all hatches
@@return:
    ; Code that we hijacked
    pop     { r0 - r3 }
    sub     r0, #1
    strb    r0, [r2]
    bl      08063CA4h ; Return to original code flow
    .pool
.endfunc
.endautoregion


; Remove Pink Event doors from Navigation rooms
; Since we don't have any story events anymore, and all our other places have
; gray locked doors, there is no need for nav rooms specifically to have pink ones.
; Overwrites the check in DetermineNavigationHatchesToLock on whether we're in a Navigation Room.
.org 0806323Eh
.area 2
    nop
.endarea


.org DetermineNavigationHatchesToLockForNavigationConversation
; Always show hatch bulkheads when talking to the computer in a Nav Room
.region 3Ch, 0
    push    { lr }
    mov     r0, #00 ; No Doors to lock
    ldr     r1, =CurrentNavRoom
    ldrb    r1, [r1]
    cmp     r1, #00 ; Check if Nav room is the Gunship Hangar
    beq     @@return
    mov     r0, #03 ; LeftDoor | RightDoor
@@return:
    pop     { r1 }
    bx      r1
    .pool
.endregion


; Change the Palette for the Event Door Graphic used in Nav Room conversations.
.org 08565BC8h
.area 32
    .incbin "data/nav-cutscene-gray-door.bin"
.endarea
