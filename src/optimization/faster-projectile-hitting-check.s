
@PROJECTILE_COUNT equ 16
@TotalSizeOfStack equ (48h + @PROJECTILE_COUNT*4 + 1*4) ; 0x48 is vanilla, we extend AMOUNT_OF_PROJECTILES (16) and 1 for a counter

@StartOfProjCount equ 48h
@StartOfProjArray equ 4Ch

.org 08082892h
.area 2
    sub    sp, #@TotalSizeOfStack
.endarea


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
.org 08082FBAh
.area 6
    bl      @ProjectileCheckHitSpriteHijack_EndOfLoop
.endarea

; hijack assigning proj
.org 08082C00h
.area   4
    bl      @ProjectileCheckHitSpriteHijack_AssignProj
.endarea

.autoregion
.align 2
.func @ProjectileCheckHitSpriteHijack1
    ; r4, r3, r2. r1, r0 are free to use

    ; initialize activeProjCounter
    mov     r0, #0
    str     r0, [sp, #@StartOfProjCount]
    
    ; TODO
    ldr     r0, =ProjectileList
    mov     r1, #0
@@start_of_loop:
    lsl     r2, r1, #5  ; multiplies by 32, each entry in the list is 32 bytes big
    add     r2, r0
    ldrb    r2, [r2, Projectile_Status]
    mov     r3, #11h    ; CanAffectEnvironment | Exists
    and     r2, r3
    cmp     r2, r3
    bne     @@end_of_loop

    mov     r3, sp
    add     r3, @StartOfProjArray
    lsl     r2, r1, #2
    str     r1, [r3, r2]

    ldr     r2, [sp, @StartOfProjCount]
    add     r2, #1
    str     r2, [sp, @StartOfProjCount]
    

@@end_of_loop:
    add     r1, 1
    cmp     r1, @PROJECTILE_COUNT
    blt     @@start_of_loop
    
    ; TODO
    ldr     r0, [sp, @StartOfProjCount]
    cmp     r0, #0
    beq     @@projectile_zero

    ; Restore vanilla code
    mov     r1, #1
    str     r1, [sp, #14h]
    bl      08082B96h   ; jump to TODO

@@projectile_zero:
    bl      08082FDCh
.pool
.endfunc

.align 2
.func @ProjectileCheckHitSpriteHijack_EndOfLoop
    ldr     r1, [sp, @StartOfProjCount]
    cmp     r0, r1
    bhi     @@case_higher
    bl      08082BFCh

@@case_higher:
    bl      08082FC0h
.endfunc

.align 2
.func @ProjectileCheckHitSpriteHijack_AssignProj
    ; r2 has projectile slot / "j" variable
    mov     r0, sp
    add     r0, @StartOfProjArray
    lsl     r3, r2, #2
    add     r0, r3
    ldr     r0, [r0, #0]

    lsl     r0, #5
    add     r4, r0, r1
    bl      08082C04h
.pool
.endfunc
.endautoregion