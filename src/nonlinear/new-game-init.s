; Rewrite new game init to account for starting items and location.

.org NewGameInit
.area 14Ch
    push    { lr }
    sub     sp, #4
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    mov     r1, #0
    ldr     r2, =02037C00h
    mov     r3, #380h >> 2
    lsl     r3, #2
    bl      BitFill
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    ldr     r1, =#0FFFFh
    ldr     r2, =02036000h
    mov     r3, #1200h >> 5
    lsl     r3, #5
    bl      BitFill
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    mov     r1, #0
    ldr     r2, =TanksCollected
    mov     r3, #900h >> 4
    lsl     r3, #4
    bl      BitFill
    mov     r0, #0
    mov     r1, #7
    ldr     r2, =03000033h
@@bitfill_loop:
    strb    r0, [r2, r1]
    sub     r1, #1
    bpl     @@bitfill_loop
    ldr     r1, =GameTimer
    strb    r0, [r1, GameTimer_Hours]
    strb    r0, [r1, GameTimer_Minutes]
    strb    r0, [r1, GameTimer_Seconds]
    strb    r0, [r1, GameTimer_Frames]
    strb    r0, [r1, GameTimer_Maxed]
    mov     r0, #1
    ldr     r1, =0300134Ah
    strb    r0, [r1]
    ldr     r1, =StartingItems
    ldr     r2, =PermanentUpgrades
    ldrb    r0, [r1, SamusUpgrades_BeamUpgrades]
    strb    r0, [r2, PermanentUpgrades_BeamUpgrades]
    ldrb    r0, [r1, SamusUpgrades_ExplosiveUpgrades]
    strb    r0, [r2, PermanentUpgrades_ExplosiveUpgrades]
    ldrb    r0, [r1, SamusUpgrades_SuitUpgrades]
    strb    r0, [r2, PermanentUpgrades_SuitUpgrades]
    mov     r0, #0
    strb    r0, [r2, PermanentUpgrades_InfantMetroids]
    ldr     r2, =SamusUpgrades
    ldrb    r0, [r1, SamusUpgrades_SecurityLevel]
    strb    r0, [r2, SamusUpgrades_SecurityLevel]
    ldr     r3, =SecurityLevelFlash
    strb    r0, [r3]
    strb    r0, [r3, PowerOutageSecurityBackup - SecurityLevelFlash]
    mov     r0, #0
    strb    r0, [r2, SamusUpgrades_MapDownloads]
    ldr     r1, =03000B86h
    strb    r0, [r1]
    mov     r0, #0FFh
    ldr     r1, =PrevSubEvent
    strb    r0, [r1]
    strb    r0, [r1, PrevNavConversation - 03000B86h]
    mov     r0, #0
    ldr     r1, =0300004Ch
    strb    r0, [r1]
    strb    r0, [r1, #1]
    ldr     r1, =StartingLocation
    ldr     r2, =CurrArea
    ldrb    r0, [r1, StartingLocation_Area]
    strb    r0, [r2]
    ldrb    r0, [r1, StartingLocation_Room]
    strb    r0, [r2, CurrRoom - CurrArea]
    ldrb    r0, [r1, StartingLocation_Door]
    strb    r0, [r2, PrevDoor - CurrArea]
    ldr     r2, =SamusState
    mov     r3, r2
    add     r3, #03001342h - SamusState
    ldrh    r0, [r1, StartingLocation_XPos]
    strh    r0, [r2, SamusState_PositionX]
    strh    r0, [r3]
    ldrh    r0, [r1, StartingLocation_YPos]
    strh    r0, [r2, SamusState_PositionY]
    strh    r0, [r3, #2]
    ldrb    r0, [r1, StartingLocation_Area]
    ldrb    r1, [r1, StartingLocation_Room]
    orr     r0, r1
    beq     @@init_map
    mov     r0, #0
    ldr     r1, =0300134Ah
    strb    r0, [r1]
@@init_map:
    bl      InitStartingMap
    mov     r0, #0
    ldr     r1, =03000B8Bh
    strb    r0, [r1]
    add     sp, #4
    pop     { pc }
    .pool
.endarea

.autoregion
    .align 2
.func @InitSaveMeta
    ldr     r1, =StartingItems
    ldrh    r0, [r1, SamusUpgrades_CurrEnergy]
    strh    r0, [r2, SaveMeta_CurrEnergy]
    ldrh    r0, [r1, SamusUpgrades_MaxEnergy]
    strh    r0, [r2, SaveMeta_MaxEnergy]
    ; Set both current and max missiles to what's in CurrMissiles in the Starting Items Struct
    ; This value has been repurposed to be "Starting Ammo", with MaxMissiles repurposed as
    ; the increment when Missile Data is obtained.
    ldrh    r0, [r1, SamusUpgrades_CurrMissiles]
    strh    r0, [r2, SaveMeta_CurrMissiles]
    ldrh    r0, [r1, SamusUpgrades_CurrMissiles]
    strh    r0, [r2, SaveMeta_MaxMissiles]
    ldrb    r0, [r1, SamusUpgrades_SuitUpgrades]
    strb    r0, [r2, SaveMeta_SuitUpgrades]
    ldr     r1, =StartingLocation
    ldrb    r0, [r1, StartingLocation_Area]
    strb    r0, [r2, SaveMeta_Area]
    strb    r3, [r2, SaveMeta_Exists]
    strb    r3, [r2, SaveMeta_Event]
    strb    r3, [r2, SaveMeta_IgtHours]
    strb    r3, [r2, SaveMeta_IgtMinutes]
    bx      lr
    .pool
.endfunc
.endautoregion

.org 08080926h
.area 14h
    bl      @InitSaveMeta
    b       0808093Ah
.endarea

.org 080A059Ah
.area 4
    bl      @FileSelectDrawInfoHighjack
.endarea

.autoregion
.align 2
; loads StartingItems to set default energy value on new file
.func @FileSelectDrawInfoHighjack
    push    { r4, lr }
    ldr     r4, =StartingItems
    ldrh    r0, [r4, SamusUpgrades_CurrEnergy]
    ; r1 contains Currentenergy offset for fileselect non-gameplay ram
    strh    r0, [r1]
    ldrh    r0, [r4, SamusUpgrades_MaxEnergy]
    strh    r0, [r1, SamusUpgrades_MaxEnergy - SamusUpgrades_CurrEnergy]
    pop     { r4, pc }
    .pool
.endfunc

.align 2
.func SetNewFileHealthInfo
/* Register contents during highjack
    r4 = MostRecentSaveFile 03000BD8
*/
    push    { lr }
    ldr     r6, =SaveData
    ldrb    r1, [r4]
    mov     r0, #SaveMeta_Size
    mul     r0, r1
    add     r0, r0, r6
    ldr     r0, [r0]
    mov     r1, #0C4h       ; SamusUpgrades offset in SramWram
    add     r0, r0, r1
    ldr     r1, =StartingItems
    ldrh    r1, [r1, SamusUpgrades_MaxEnergy]
    strh    r1, [r0, SamusUpgrades_CurrEnergy]
    strh    r1, [r0, SamusUpgrades_MaxEnergy]
@@return:
    pop     { r0 }
    bx      r0
    .pool
.endfunc
.endautoregion
