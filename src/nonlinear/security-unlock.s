; Allows security rooms to unlock security level regardless of the event.
; Additionally splits security levels such that unlocking a higher security
; level will not also unlock lower security levels. This behavior can be
; reverted by including the bitmasks of lower security levels in the
; SecurityUnlockEvent structs.

; TODO: debug menu security set via event

.org 08074F70h
.region 8Ch, 0
.func UpdateSecurityLevel
    push    { lr }
    mov     r2, r0
    ldr     r0, =CurrArea
    ldrb    r0, [r0]
    sub     r0, Area_TRO
    cmp     r0, Area_ARC - Area_TRO
    bhi     @@retZero
    add     r1, =@@SecurityRoomLocations
    ldrb    r0, [r1, r0]
    ldr     r1, =MiscProgress
    ldr     r1, [r1, MiscProgress_MajorLocations]
    lsr     r1, r0
    lsr     r1, #1
    bcs     @@retZero
    cmp     r2, #0
    beq     @@retOne
    bl      ObtainMajorLocation
    mov     r0, #2
    bl      SetEventEffect
@@retOne:
    mov     r0, #1
    b       @@ret
@@retZero:
    mov     r0, #0
@@ret:
    pop     { pc }
    .pool
    .align 4
@@SecurityRoomLocations:
    .db     MajorLocation_TROSecurity
    .db     MajorLocation_PYRSecurity
    .db     MajorLocation_AQASecurity
    .db     MajorLocation_ARCSecurity
.endfunc
.endarea

; SetEvent fixes
.org 08074A72h
    mov     r0, 00000b
.org 08074A82h
    mov     r1, 00001b
.org 08074A90h
    mov     r0, 00011b
.org 08074AA4h
    mov     r0, 00111b
.org 08074AB8h
    mov     r0, 01111b
.org 08074ACCh
    mov     r0, 11111b
.org 08074AF8h
    mov     r0, 00000b

.org 08065B74h
    ; Security hatch flashing
    cmp     r0, #0
    beq     08065BBEh
.org 08065B9Ch
.area 22h, 0
    ldrb    r0, [r1, #1]
    ldr     r1, =08408264h
    lsl     r0, #5
    add     r1, r0
    ldr     r2, =05000028h
    ldrb    r3, [r3]
    cmp     r3, #0
@@loop:
    beq     08065BBEh
    add     r1, #4
    add     r2, #4
    lsr     r3, #1
    bcc     @@loop
    ldr     r0, [r1]
    str     r0, [r2]
    b       @@loop
@@end:
.endarea
.org 08065C28h
    .pool

.org 0806CB5Eh
    ; Check if door can open
    cmp     r1, 0b11111
.org 0806CBACh
.area 1Ch, 0
    tst     r1, r5
    beq     0806CBDCh
    bic     r1, r5
    lsl     r0, r1, #2
    add     r2, r0, r6
    ldrb    r0, [r2]
    lsr     r0, #5
    mov     r1, r10
    ldrb    r1, [r1, SamusUpgrades_SecurityLevel]
    lsr     r1, r0
    lsr     r1, #1
    bcc     0806CBE2h
.endarea

.org 08077E96h
.area 0Eh, 0
    mov     r3, #0
@MapScreenLockLoop0:
; The vanilla function works for setup of data, except it iterates at the beginning
; of the loop. We offset the function 2 bytes and move the iterator to the end of
; the loop instead.
.incbin "metroid4.gba", 077E96h, 4
    lsr     r0, r3
    mov     r6, #1
    and     r6, r0
.endarea
.else
.org 08077F04h
.area 0Ah, 0
    ; Check locks on map menu
    lsr     r0, r3
    mov     r6, #1
    and     r6, r0
.endarea

.org 08077EA4h
; The vanilla function works for setup of data, except it iterates at the beginning
; of the loop. We offset the function 2 bytes and move the iterator to the end of
; the loop instead.
.incbin "metroid4.gba", 077EA6h, 032h
.area 8h
.org 08077ED6h
    add     r3, r4, #1
    mov     r4, r3
    cmp     r3, #4
    bls     @MapScreenLockLoop0
.endarea

.org 08077F02h
.area 0Ch, 0
    mov     r3, #0
    ; Check locks on map menu
@MapScreenLockLoop1:
    lsr     r0, r3
    mov     r6, #1
    and     r6, r0
.endarea
.org 08077F0Ch
.incbin "metroid4.gba", 077F0Eh, 18h
.area 8h
    add     r3, r4, #1
    mov     r4, r3
    cmp     r3, #4
    bls     @MapScreenLockLoop1
.endarea

; this func loops through the lock OAM slots and sets clears the OAM Graphic
; this ensures all lock graphics are cleared
.org 08077F56h
.area 2
    cmp     r4, #4
.endarea
.else
.org 08077E9Ch
.area 0Ah, 0
    lsr     r0, r3
    mov     r6, #1
    and     r6, r0
.endarea

.org 0807D66Ah
.area 12h, 0
    ; Update debug menu
    ldr     r5, =SamusUpgrades
    ldrb    r3, [r5, SamusUpgrades_SecurityLevel]
    mov     r2, #4
    sub     r2, r4
    mov     r1, #1
    lsl     r1, r2
    eor     r1, r3
    b       @@contDebugUpdate
.endarea
    .skip 4
    .pool
.area 14h, 0
@@contDebugUpdate:
    strb    r1, [r5, SamusUpgrades_SecurityLevel]
    ldr     r2, =SecurityLevelFlash
    strb    r1, [r2]
    ldr     r2, =03000BD0h
    strb    r1, [r2, #9]
    b       #0807DADAh
    .pool
.endarea

.org 0807DDECh
.area 08h
    ; Draw debug menu
    lsr     r0, r2
    lsr     r0, #1
    bcs     @@securityPass
    b       @@securityFail
.endarea
    .skip 24h
.area 0Ah, 0
@@securityFail:
    mov     r4, #3
    b       @@cont
@@securityPass:
    mov     r4, #9
.endarea
@@cont:

.autoregion
    .aligna 2
@MapScreenLockLevels:
; Lock levels indicated by:
;   .db OamSlot, OamId
    .db 01Ah, MenuSpriteGfx_Lv0Locked
    .db 01Bh, MenuSpriteGfx_Lv1Locked
    .db 01Ch, MenuSpriteGfx_Lv2Locked
    .db 01Dh, MenuSpriteGfx_Lv3Locked
    .db 01Eh, MenuSpriteGfx_Lv4Locked
.endautoregion

.org 08077EE8h
    .dw @MapScreenLockLevels
    .dw @MapScreenLockLevels + 1

.org 08077F38h
    .dw @MapScreenLockLevels
