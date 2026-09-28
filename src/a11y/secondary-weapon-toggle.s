
; weaponhighlight, case for morph states
.org 080060A0h
.area 24h
    ldr     r4, =@PowerBombAddresses
    bl      @SamusUpdateHighlightHijack
.pool
.endarea

.org 080060E8h
.area 24h
    ldr     r4, =@MissileAddresses
    bl      @SamusUpdateHighlightHijack
.pool
.endarea

@WH_POWER_BOMB equ 10h
@WH_MISSILES equ 01h

; Weapon highlight check after switch case
@EXIT_ADDRESS equ 08006116h

.org SecondaryWeaponSelectModePointer
.area 04h 
    .dw     @SecondaryWeaponSelectMode
.endarea

.autoregion

.align 2
@SecondaryWeaponSelectMode:
    .db     0


@MissileAddresses:
.db     @WH_MISSILES
.db     @WH_POWER_BOMB
.db     (1 << ExplosiveUpgrade_Missiles)
.db     (SamusUpgrades_CurrMissiles)
@PowerBombAddresses:
.db     @WH_POWER_BOMB
.db     @WH_MISSILES 
.db     (1 << ExplosiveUpgrade_PowerBombs)
.db     (SamusUpgrades_CurrPowerBombs)

@ADDRESSES_CURRENT_WH equ 0
@ADDRESSES_ALTERNATIVE_WH equ 1
@ADDRESSES_EXPLOSIVE_UPGRADE equ 2
@ADDRESSES_SAMUSUPGRADES_CURR_AMMO equ 3

.align 2
.func @CheckSecondaryDataAndAmmo
    ; Overwrites r0-r2
    ; Relies on r4 pointing to either @MissileAddresses or @PowerBombAddresses
    ; r0 has boolean return value on whether we have usable PBs

    push    {lr}

    ; Check whether we have Data pickup
    ldr     r2, =SamusUpgrades
    ldrb    r1, [r2, #SamusUpgrades_ExplosiveUpgrades]
    ldrb    r0, [r4, @ADDRESSES_EXPLOSIVE_UPGRADE]
    and     r0, r1
    cmp     r0, #0
    beq     @@no_usable_secondary
    ; Check whether we have ammo
    ldrb    r0, [r4, @ADDRESSES_SAMUSUPGRADES_CURR_AMMO]
    ldrb    r0, [r2, r0]
    cmp     r0, #0
    beq     @@no_usable_secondary 

@@usable_secondary:
    mov     r0, #1
    b       @@return

@@no_usable_secondary:
    mov     r0, #0

@@return:
    pop     {pc}

.pool
.endfunc



.func @SamusUpdateHighlightHijack    
    ; r5 contains the temporary weaponhighlight. It starts with WH_NONE.
    ; r6 contains SamusState
    ; r3 needs to point to SamusTimers when jumping out
    ; Otherwise, r0-r4 are freely usable

    ; Check first whether to use HOLD (vanilla) or TOGGLE
    ldr     r0, =@SecondaryWeaponSelectMode
    ldrb    r0, [r0, #0]
    cmp     r0, 0
    beq     @VanillaSamusUpdateCode

    ; Was secondary weapon button pressed?
    ldr     r0, =ToggleInput
    ldr     r1, =ButtonAssignments
    ldrh    r2, [r0, #0]
    ldrh    r3, [r1, #ButtonAssignments_SecondaryWeaponSelect]
    and     r3, r2
    cmp     r3, #0
    beq     @@ButtonNotPressed
    ; Button was pressed
    ; Can we use that secondary weapon? If no, bail out
    bl      @CheckSecondaryDataAndAmmo
    cmp     r0, #0
    beq     @@return

    ; Button was pressed and we can use this weapon, so set r5 to the opposite of whatever is currently selected
    ldrb    r0, [r6, #SamusState_SecondaryWeaponSelect]
    ldrb    r1, [r4, @ADDRESSES_CURRENT_WH]
    cmp     r0, r1
    beq     @@return
    mov     r5, r1
    ; Special Case for Missiles: release charge beam shot if possible
    cmp     r1, @WH_MISSILES
    bne     @@return
    ldrb    r0, [r6, SamusState_ChargeCounter]
    cmp     r0, #03Fh
    bls     @@return
    ; Charge counter is high enough, so fire charge
    mov     r0, #5
    strb    r0, [r6, SamusState_ProjectileType]
    b       @@return


@@ButtonNotPressed:
    ; This branch assumes we can't loose the secondary weapon usability while not using them
    ; Check first what the last selected weapon was. 
    ; If it was the "alternative" one (e.g. WH_MISSILES when we're currently in a morph state), we should enable our current secondary 
    ldrb    r0, [r6, #SamusState_SecondaryWeaponSelect]
    ldrb    r1, [r4, @ADDRESSES_ALTERNATIVE_WH]
    cmp     r0, r1
    bne     @@ButtonNotPressed_CheckForCurrentSecondary
    ; In the previous frame we had the alternative secondary selected, so before switching to the current secondary, check if we can use them.
    bl      @CheckSecondaryDataAndAmmo
    cmp     r0, #0
    beq     @@return
    ; They're usable, so we can set them and exit
    ldrb    r1, [r4, @ADDRESSES_CURRENT_WH]
    mov     r5, r1
    b       @@return

@@ButtonNotPressed_CheckForCurrentSecondary:
    ; At this point it can either be WH_NONE or the WH for the current secondary, so set r5 to what is currently highlighted
    ldrb    r1, [r4, @ADDRESSES_CURRENT_WH]
    cmp     r0, r1
    bne     @@return
    mov     r5, r1

@@return:
    ldr     r3, =SamusTimers
    bl    @EXIT_ADDRESS     

.pool
.endfunc

.align 2
.func @VanillaSamusUpdateCode
    ; Seperated into another function to more clearly seperate behaviours
    ; Was the button pressed?
    ldr     r0, =HeldInput
    ldr     r1, =ButtonAssignments
    ldrh    r2, [r0, #0]
    ldrh    r3, [r1, #ButtonAssignments_SecondaryWeaponSelect]
    and     r3, r2
    cmp     r3, #0
    beq     @@return
    ; Can we use the weapon?
    bl      @CheckSecondaryDataAndAmmo
    cmp     r0, #0
    beq     @@return
    ; We can, so set value of r5
    ldrb    r1, [r4, @ADDRESSES_CURRENT_WH]
    mov     r5, r1
    ; Special Case for Missiles: release charge beam shot if possible
    cmp     r1, @WH_MISSILES
    bne     @@return
    ldrb    r0, [r6, SamusState_ChargeCounter]
    cmp     r0, #03Fh
    bls     @@return
    ; Charge counter is high enough, so fire charge
    mov     r0, #5
    strb    r0, [r6, SamusState_ProjectileType]

@@return:
    ldr     r3, =SamusTimers
    bl    @EXIT_ADDRESS  

.pool
.endfunc
.endautoregion