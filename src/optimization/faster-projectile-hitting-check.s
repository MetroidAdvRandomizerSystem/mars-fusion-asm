
@PROJECTILE_COUNT equ 16
@TotalSizeOfStack equ (48h + @PROJECTILE_COUNT*4 + 1*4) ; 0x48 is vanilla, we extend by AMOUNT_OF_PROJECTILES and 1 for a counter

@ActiveProjCountStack equ 48h
@ActiveProjArrayStack equ 4Ch

; TODO
.org 08082892h
.area 2
    sub    sp, #@TotalSizeOfStack
.endarea

; TODO
.org 08082FDCh
.area 2
    add     sp, #@TotalSizeOfStack
.endarea


; Main hijack
.org 08082B92h 
.area 4
    bl      @ProjectileCheckHitSpriteHijack1
.endarea

; hijack end of proj loop
; There is an unnecessary `& 0xFF` that we can remove and hijack in place
.org 08082FB0h
.area 10h
    ; Modify loop variable condition to check our activeProjCount instead of PROJECTILE_COUNT
    ldr     r0, [sp, #10h]
    add     r0, #1
    str     r0, [sp, #10h]
    ldr     r1, [sp, @ActiveProjCountStack]
    cmp     r0, r1
    bhi     08082FC0h
    bl      08082BFCh
.endarea

; hijack assigning proj
.org 08082C00h
.area   4
    bl      @ProjectileCheckHitSpriteHijack_AssignProj
.endarea

.autoregion
.align 2
.func @ProjectileCheckHitSpriteHijack1
    ; r0-r4 are free to use

    ; Initialize activeProjCounter
    mov     r0, #0
    str     r0, [sp, #@ActiveProjCountStack]
    
    ; Using r1 for loop variable / projectileID
    ldr     r0, =ProjectileList
    mov     r1, #0
@@start_of_loop:
    ; Effectively do ProjectileList[i].Status
    lsl     r2, r1, #5  ; multiplies by 32, each entry in the list is 32 bytes big
    add     r2, r0
    ldrb    r2, [r2, Projectile_Status]
    ; Check if projectile is "active"
    mov     r3, #((1 << ProjectileStatus_AffectsClipdata) | (1 << ProjectileStatus_Exists))
    and     r2, r3
    cmp     r2, r3
    bne     @@loop_condition

    ; It does, so save projectileID in array and increase projCounter
    mov     r3, sp
    add     r3, @ActiveProjArrayStack
    lsl     r2, r1, #2
    str     r1, [r3, r2]
    ldr     r2, [sp, @ActiveProjCountStack]
    add     r2, #1
    str     r2, [sp, @ActiveProjCountStack]
    
@@loop_condition:
    ; Continue loop until we're out of projectile ids.
    add     r1, 1
    cmp     r1, @PROJECTILE_COUNT
    blt     @@start_of_loop
    
    ; If we had no active projectiles, quit out of the function.
    ldr     r0, [sp, @ActiveProjCountStack]
    cmp     r0, #0
    beq     @@projectile_zero

    ; Restore vanilla code
    mov     r1, #1
    str     r1, [sp, #14h]
    bl      08082B96h   ; jump to right the place right after we hijacked.

@@projectile_zero:
    bl      08082FDCh   ; Return part in ProjectileCheckHittingSprite
.pool
.endfunc

.align 2
.func @ProjectileCheckHitSpriteHijack_AssignProj
    ; r2 has projectile slot / "j" variable
    ; Instead of using j directly as an index for ProjectileList, we 
    ; modify it to ProjectileList[ActiveProjArray[j]]
    mov     r0, sp
    add     r0, @ActiveProjArrayStack
    lsl     r3, r2, #2
    add     r0, r3
    ldr     r0, [r0, #0]

    ; Restore vanilla functionality
    lsl     r0, #5
    add     r4, r0, r1
    bl      08082C04h   ; jump to right after hijack place
.pool
.endfunc
.endautoregion