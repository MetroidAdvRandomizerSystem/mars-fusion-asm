; Optimizes the size of item collection info in memory.
; The arrays of room IDs and item positions are replaced with a bit array,
; with room IDs and item positions stored in ROM instead.
; This patch saves a significant amount of memory, freeing up large chunks in
; both external WRAM and SRAM.

; WIP: rewrite binary search tree for the following features:
; - configurable item collection messages
; - item locations shared between multiple rooms

.autoregion
; Gets the first item index found in the currently loaded room.
; The index will be a number from 0 to 99 if found, else it will be -1.
    .align 2
.func GetLoadedRoomItems
    ldr     r1, =CurrArea
    ldrb    r0, [r1]
    ldrb    r1, [r1, CurrRoom - CurrArea]
    b       GetRoomItems
    .pool
.endfunc

    .align 2
.func GetRoomItems
    ldr     r2, =MinorLocationTable
    lsl     r0, #2
    ldr     r2, [r2, r0]
    ; binary search for room id
    ; r1 = target, r2 = curr ptr
    ldrb    r0, [r2, #8]
    cmp     r0, r1
    bgt     @@bsearch_1
    add     r2, #8
@@bsearch_1:
    ldrb    r0, [r2, #4]
    cmp     r0, r1
    bgt     @@bsearch_2
    add     r2, #4
@@bsearch_2:
    ldrb    r0, [r2, #2]
    cmp     r0, r1
    bgt     @@bsearch_3
    add     r2, #2
@@bsearch_3:
    ldrb    r0, [r2, #1]
    cmp     r0, r1
    bgt     @@bsearch_4
    add     r2, #1
@@bsearch_4:
    ldrb    r0, [r2]
    cmp     r0, r1
    bne     @@fail
    add     r2, #16
    ldrb    r0, [r2]
    bx      lr
    .pool
@@fail:
    mov     r0, #0
    mvn     r0, r0
    bx      lr
.endfunc
.endautoregion

.autoregion
; Gets the index of the passed collectible item in the currently loaded room.
; The index will be a number from 0 to 99 if found, else it will be -1.
    .align 2
.func GetItemIndex
    ; r0 = x pos, r1 = y pos
    push    { r4-r5, lr }
    mov     r4, r0
    mov     r5, r1
    ldr     r1, =CurrArea
    ldrb    r0, [r1]
    ldrb    r1, [r1, CurrRoom - CurrArea]
    bl      GetRoomItems
    cmp     r0, #0
    blt     @@fail
    lsl     r1, r0, log2(MinorLocation_Size)
    ldr     r3, =MinorLocations
    add     r2, r3, r1
@@lsearch:
    ldrb    r0, [r2, MinorLocation_XPos]
    cmp     r0, r4
    bne     @@lsearch_inc
    ldrb    r0, [r2, MinorLocation_YPos]
    cmp     r0, r5
    beq     @@success
@@lsearch_inc:
    add     r1, #MinorLocation_Size
    add     r2, r3, r1
    ldrb    r0, [r2, MinorLocation_RoomIndex]
    cmp     r0, #0
    bne     @@lsearch
@@fail:
    mov     r0, #0
    mvn     r0, r0
    b       @@exit
@@success:
    lsr     r0, r1, log2(MinorLocation_Size)
@@exit:
    pop     { r4-r5, pc }
    .pool
.endfunc
.endautoregion

.autoregion
    .align 2
.func IsItemCollected
    ldr     r2, =TanksCollected
    lsr     r1, r0, #3
    ldrb    r2, [r2, r1]
    lsl     r0, #29
    lsr     r0, #29
    mov     r1, #1
    lsl     r1, r0
    and     r2, r1
    mov     r0, r2
    bx      lr
    .pool
.endfunc
.endautoregion

.org SetTankAsCollected
.area 84h
    push    { lr }
    bl      GetItemIndex
    cmp     r0, #0
    blt     @@exit
    ldr     r2, =TanksCollected
    lsr     r3, r0, #3
    lsl     r0, #29
    lsr     r0, #29
    mov     r1, #1
    lsl     r1, r0
    ldrb    r0, [r2, r3]
    orr     r0, r1
    strb    r0, [r2, r3]
@@exit:
    pop     { pc }
    .pool
.endarea

.org RemoveCollectedTanks
.area 0CCh
    push    { r4-r7, lr }
    ldr     r0, =NonGameplayFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@exit
.if RANDOMIZER
    ldr     r1, =RoomTanks
    mov     r0, #0
    mvn     r0, r0
    str     r0, [r1, #00h]
    str     r0, [r1, #04h]
    str     r0, [r1, #08h]
.endif
    bl      GetLoadedRoomItems
    mov     r5, r0
    cmp     r0, #0
    blt     @@exit
    ldr     r4, =MinorLocations
    lsl     r0, r5, log2(MinorLocation_Size)
    add     r4, r0
@@loop:
    ldrb    r0, [r4, MinorLocation_Upgrade]
    cmp     r0, #Upgrade_Invalid
    beq     @@loop_inc
    mov     r0, r5
    bl      IsItemCollected
    cmp     r0, #0
.if RANDOMIZER
    beq     @@load_tank_gfx
.else
    beq     @@loop_inc
.endif
    ; item collected, delete from the loaded map
    ldrb    r0, [r4, MinorLocation_YPos]
    ldr     r3, =LevelLayers
    ldrh    r1, [r3, LevelLayers_Clipdata + LevelLayer_Stride]
    mul     r0, r1
    ldrb    r1, [r4, MinorLocation_XPos]
    add     r0, r1
    lsl     r2, r0, #1
    ldr     r1, [r3, LevelLayers_Bg1 + LevelLayer_Data]
    mov     r0, #0
    strh    r0, [r1, r2]
    ldr     r3, [r3, LevelLayers_Clipdata + LevelLayer_Data]
    ldrh    r0, [r3, r2]
    ldr     r1, =SpecialTileset
    ldrh    r1, [r1, r0]
    sub     r1, #2Ah
    cmp     r1, #2
    bhi     @@set_bg1_zero
    ldr     r0, =#802Ch
    b       @@set_bg1
@@set_bg1_zero:
    mov     r0, #0
@@set_bg1:
    strh    r0, [r3, r2]
    b       @@loop_inc
.if RANDOMIZER
@@load_tank_gfx:
    mov     r0, r5
    bl      LoadTankGfx
.endif
@@loop_inc:
    add     r5, #1
    ldr     r4, =MinorLocations
    lsl     r0, r5, log2(MinorLocation_Size)
    add     r4, r0
    ldrb    r0, [r4, MinorLocation_RoomIndex]
    cmp     r0, #0
    bne     @@loop
@@exit:
    pop     { r4-r7, pc }
    .pool
.endarea

.org MinimapSetCollectedItems
; get all items in area and mark them as collected on the minimap
; takes area as an argument
.area 0A4h
    push    { r4-r6, lr }
    mov     r6, r0
    ldr     r1, =MinorLocationTable
    lsl     r0, #2
    ldr     r1, [r1, r0]
    add     r1, #10h
    ldrb    r5, [r1]
    ldr     r4, =MinorLocations
    lsl     r0, r5, log2(MinorLocation_Size)
    add     r4, r0
@@loop:
    lsr     r0, r5, #3
    ldr     r1, =TanksCollected
    ldrb    r0, [r1, r0]
    lsl     r1, r5, #20h - 3
    lsr     r1, #20h - 3
    add     r1, #1
    lsr     r0, r1
    bcc     @@loop_inc
    ldrb    r0, [r4, MinorLocation_Upgrade]
    cmp     r0, #Upgrade_Invalid
    beq     @@loop_inc
    ldrb    r0, [r4, MinorLocation_Room]
    mov     r1, #60
    mul     r0, r1
    ldr     r3, =AreaLevels
    mov     r1, r6
    lsl     r1, #2
    ldr     r1, [r3, r1]
    add     r3, r1, r0
    add     r3, #LevelMeta_MapX
    ldrb    r0, [r3, LevelMeta_MapY - LevelMeta_MapX]
    ldrb    r1, [r4, MinorLocation_YPos]
    sub     r1, #2
    mov     r2, #unsigned_reciprocal(10, 11)
    mul     r1, r2
    lsr     r1, #11
    add     r0, r1
    lsl     r0, #5
    ldrb    r1, [r4, MinorLocation_XPos]
    sub     r1, #2
    mov     r2, #unsigned_reciprocal(15, 11)
    mul     r1, r2
    lsr     r1, #11
    add     r0, r1
    ldrb    r1, [r3]
    add     r0, r1
    lsl     r0, #1
    ldr     r3, =MinimapData
    ldrh    r1, [r3, r0]
    add     r1, #1
    strh    r1, [r3, r0]
@@loop_inc:
    add     r5, #1
    ldr     r4, =MinorLocations
    lsl     r0, r5, log2(MinorLocation_Size)
    add     r4, r0
    ldrb    r0, [r4, MinorLocation_Area]
    cmp     r0, r6
    beq     @@loop
    pop     { r4-r6, pc }
    .pool
.endarea

.org MapScreenCountTanks
.area 13Ch
    ; TODO: stop using hardcoded numbers
    push    { r4-r5, lr }
    ldr     r5, =TankCounter
    mov     r0, #20
    strb    r0, [r5, TankCounter_MaxTotalEnergyTanks]
    mov     r0, #48
    strb    r0, [r5, TankCounter_MaxTotalMissileTanks]
    mov     r0, #32
    strb    r0, [r5, TankCounter_MaxTotalPowerBombTanks]
    ldr     r4, =SamusUpgrades
    ldrh    r0, [r4, SamusUpgrades_MaxEnergy]
    sub     r0, #99
    mov     r1, #100
    bl      Divide
    strb    r0, [r5, TankCounter_CurrTotalEnergyTanks]
    ldrh    r0, [r4, SamusUpgrades_MaxMissiles]
    sub     r0, #10
    mov     r1, #5
    bl      Divide
    strb    r0, [r5, TankCounter_CurrTotalMissileTanks]
    ldrb    r0, [r4, SamusUpgrades_MaxPowerBombs]
    sub     r0, #10
    lsr     r0, #1
    strb    r0, [r5, TankCounter_CurrTotalPowerBombTanks]
    ldr     r1, =MinorLocationTable
    ldr     r0, =CurrArea
    ldrb    r0, [r0]
    lsl     r0, #2
    ldr     r4, [r1, r0]
@@loop:
    ldrb    r2, [r4]
    cmp     r2, #0FFh
    beq     @@exit
    ldrb    r2, [r4, #16]
    lsr     r0, r2, #3
    ldr     r1, =TanksCollected
    ldrb    r0, [r1, r0]
    lsl     r1, r2, #29
    lsr     r1, #29
    lsr     r0, r1
    lsl     r0, #31
    lsr     r3, r0, #31
    ldr     r1, =MinorLocations
    lsl     r0, r2, log2(MinorLocation_Size)
    add     r1, r0
    ldrb    r0, [r1, MinorLocation_Upgrade]
    cmp     r0, #Upgrade_Invalid
    beq     @@loop_inc
    cmp     r0, #Upgrade_MissileTank
    bne     @@checkETank
    ldrb    r0, [r5, TankCounter_MaxAreaMissileTanks]
    add     r0, #1
    strb    r0, [r5, TankCounter_MaxAreaMissileTanks]
    ldrb    r0, [r5, TankCounter_CurrAreaMissileTanks]
    add     r0, r3
    strb    r0, [r5, TankCounter_CurrAreaMissileTanks]
@@checkETank:
    cmp     r0, Upgrade_EnergyTank
    bne     @@checkPBTank
    ldrb    r0, [r5, TankCounter_MaxAreaEnergyTanks]
    add     r0, #1
    strb    r0, [r5, TankCounter_MaxAreaEnergyTanks]
    ldrb    r0, [r5, TankCounter_CurrAreaEnergyTanks]
    add     r0, r3
    strb    r0, [r5, TankCounter_CurrAreaEnergyTanks]
@@checkPBTank:
    cmp     r0, Upgrade_PowerBombTank
    bne     @@loop_inc
    ldrb    r0, [r5, TankCounter_MaxAreaPowerBombTanks]
    add     r0, #1
    strb    r0, [r5, TankCounter_MaxAreaPowerBombTanks]
    ldrb    r0, [r5, TankCounter_CurrAreaPowerBombTanks]
    add     r0, r3
    strb    r0, [r5, TankCounter_CurrAreaPowerBombTanks]
@@loop_inc:
    add     r4, #1
    b       @@loop
    .pool
@@exit:
    pop     { r4-r5, pc }
    .pool
.endarea

; load entire table to SRAM instead of variable amount based on tanks collected
.org 0807FF1Ah
.area 34h
    mov     r0, r8
    add     r2, r0, r7
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    ldr     r1, =TanksCollected
    mov     r3, #(SaveData_Size - SaveData_TanksCollected) >> 4
    lsl     r3, #4
    bl      08002F1Ch
    b       0807FF4Eh
    .pool
.endarea

; load entire table from SRAM
.org 08080002h
.area 34h
    mov     r0, r8
    add     r1, r0, r7
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    ldr     r2, =TanksCollected
    mov     r3, #(SaveData_Size - SaveData_TanksCollected) >> 4
    lsl     r3, #4
    bl      08002F1Ch
    b       08080036h
    .pool
.endarea

; init item collection info with 0s instead of 1s
.org 08080416h
    mov     r1, #0

.org 08080576h
    mov     r1, #0

; reformat demo tank collection info
.org 083E40C8h
.area 14h, 0
    .db     1 << 3
.endarea

.autoregion
    .align 4
.func InitializeSavedata
    push    { r4, lr }
    sub     sp, #4
    ldr     r1, =SaveData
    ldr     r0, =SaveSlot
    ldrb    r0, [r0]
    lsl     r0, #2
    ldr     r4, [r1, r0]
    mov     r0, #10h
    str     r0, [sp]
    mov     r0, #3
    mov     r1, #0
    mov     r2, r4
    mov     r3, #300 >> 4
    lsl     r3, #4
    bl      08002FECh
    mov     r0, #3
    mov     r1, #0
    mov     r2, #SaveData_TanksCollected >> 4
    lsl     r2, #4
    add     r2, r4
    mov     r3, #(SaveData_Size - SaveData_TanksCollected) >> 4
    lsl     r3, #4
    bl      08002FECh
    add     sp, #4
    pop     { r4, pc }
    .pool
.endfunc
.endautoregion

.org 0807F1BAh
    bl  InitializeSavedata
    b   0807F222h

.org MinorLocationTablePointer
.area 04h
    .dw     MinorLocationTable
.endarea

.autoregion
    .align 4
MinorLocationTable:
    .dw     @@Items_MainDeck
    .dw     @@Items_Sector1
    .dw     @@Items_Sector2
    .dw     @@Items_Sector3
    .dw     @@Items_Sector4
    .dw     @@Items_Sector5
    .dw     @@Items_Sector6

; Sector items structure:
; - Sorted array of rooms containing items
; - Array of indices indicating the first item in each room, plus one extra
;   indicating the final item of the last room

@@Items_MainDeck:
    .db     07h, 11h, 23h, 26h, 2Dh, 2Eh, 2Fh, 32h
    .db     33h, 39h, 45h, 47h, 48h, 49h, 54h
    .fill   16 - (. - @@Items_MainDeck), 0FFh
    .db     (@Items_MainDeck_Room07 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room11 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room23 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room26 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room2D - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room2E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room2F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room32 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room33 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room39 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room45 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room47 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room48 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room49 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_MainDeck_Room54 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector1:
    .db     05h, 11h, 19h, 1Eh, 20h, 27h, 28h, 2Bh
    .db     2Ch, 2Fh, 32h, 34h
    .fill   16 - (. - @@Items_Sector1), 0FFh
    .db     (@Items_Sector1_Room05 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room11 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room19 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room1E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room20 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room27 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room28 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room2B - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room2C - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room2F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room32 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector1_Room34 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector2:
    .db     06h, 09h, 0Ah, 11h, 15h, 19h, 1Bh, 1Fh
    .db     21h, 2Ah, 2Fh, 32h, 36h, 37h
    .fill   16 - (. - @@Items_Sector2), 0FFh
    .db     (@Items_Sector2_Room06 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room09 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room0A - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room11 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room15 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room19 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room1B - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room1F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room21 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room2A - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room2F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room32 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room36 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector2_Room37 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector3:
    .db     03h, 06h, 08h, 09h, 0Ch, 13h, 1Ch, 1Eh
    .db     21h, 22h, 23h, 25h
    .fill   16 - (. - @@Items_Sector3), 0FFh
    .db     (@Items_Sector3_Room03 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room06 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room08 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room09 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room0C - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room13 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room1C - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room1E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room21 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room22 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room23 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector3_Room25 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector4:
    .db     06h, 0Ah, 0Dh, 0Fh, 11h, 17h, 18h, 1Ch
    .db     21h, 24h, 26h, 29h, 2Eh
    .fill   16 - (. - @@Items_Sector4), 0FFh
    .db     (@Items_Sector4_Room06 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room0A - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room0D - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room0F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room11 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room17 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room18 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room1C - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room21 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room24 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room26 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room29 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector4_Room2E - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector5:
    .db     04h, 0Ch, 0Eh, 12h, 16h, 17h, 1Ah, 1Eh
    .db     21h, 22h, 24h, 2Fh, 32h, 33h
    .fill   16 - (. - @@Items_Sector5), 0FFh
    .db     (@Items_Sector5_Room04 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room0C - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room0E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room12 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room16 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room17 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room1A - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room1E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room21 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room22 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room24 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room2F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room32 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector5_Room33 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
@@Items_Sector6:
    .db     00h, 0Fh, 12h, 18h, 1Ah, 1Eh, 22h, 26h
    .db     27h
    .fill   16 - (. - @@Items_Sector6), 0FFh
    .db     (@Items_Sector6_Room00 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room0F - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room12 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room18 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room1A - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room1E - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room22 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room26 - MinorLocations) >> log2(MinorLocation_Size)
    .db     (@Items_Sector6_Room27 - MinorLocations) >> log2(MinorLocation_Size)
.endautoregion

.autoregion
    .align 2
MinorLocations:
@Items_MainDeck_Room07:
    .db     Area_MainDeck, 07h, 0
    .db     0Dh, 0Eh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room11:
    .db     Area_MainDeck, 11h, 0
    .db     09h, 14h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room23:
    .db     Area_MainDeck, 23h, 0
    .db     0Eh, 41h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room26:
    .db     Area_MainDeck, 26h, 0
    .db     35h, 0Ah
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room2D:
    .db     Area_MainDeck, 2Dh, 0
    .db     04h, 06h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room2E:
    .db     Area_MainDeck, 2Eh, 0
    .db     09h, 08h
    .db     Upgrade_InfantMetroid
    .db     UpgradeSprite_InfantMetroid
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room2F:
    .db     Area_MainDeck, 2Fh, 0
    .db     04h, 03h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room32:
    .db     Area_MainDeck, 32h, 0
    .db     36h, 08h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room33:
    .db     Area_MainDeck, 33h, 0
    .db     05h, 1Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room39:
    .db     Area_MainDeck, 39h, 0
    .db     0Ch, 0Ah
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room45:
    .db     Area_MainDeck, 45h, 0
    .db     1Dh, 1Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room47:
    .db     Area_MainDeck, 47h, 0
    .db     06h, 09h
    .db     Upgrade_InfantMetroid
    .db     UpgradeSprite_InfantMetroid
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room48:
    .db     Area_MainDeck, 48h, 0
    .db     0Dh, 09h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room49:
    .db     Area_MainDeck, 49h, 0
    .db     06h, 0Ah
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_MainDeck_Room54:
    .db     Area_MainDeck, 54h, 0
    .db     0Eh, 0Ah
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room05:
    .db     Area_SRX, 05h, 0
    .db     1Bh, 0Ah
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room11:
    .db     Area_SRX, 11h, 0
    .db     08h, 06h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_SRX, 11h, 1
    .db     19h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_SRX, 11h, 2
    .db     2Ch, 13h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room19:
    .db     Area_SRX, 19h, 0
    .db     0Fh, 08h ; REPLACE WHEN IMPLEMENTED
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room1E:
    .db     Area_SRX, 1Eh, 0
    .db     0Fh, 08h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room20:
    .db     Area_SRX, 20h, 0
    .db     1Dh, 09h
    .db     Upgrade_InfantMetroid
    .db     UpgradeSprite_InfantMetroid
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room27:
    .db     Area_SRX, 27h, 0
    .db     04h, 06h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room28:
    .db     Area_SRX, 28h, 0
    .db     0Ch, 08h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room2B:
    .db     Area_SRX, 2Bh, 0
    .db     0Dh, 0Bh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room2C:
    .db     Area_SRX, 2Ch, 0
    .db     04h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room2F:
    .db     Area_SRX, 2Fh, 0
    .db     0Ah, 02h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room32:
    .db     Area_SRX, 32h, 0
    .db     06h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector1_Room34:
    .db     Area_SRX, 34h, 0
    .db     0Dh, 07h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room06:
    .db     Area_TRO, 06h, 0
    .db     1Dh, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room09:
    .db     Area_TRO, 09h, 0
    .db     0Dh, 04h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room0A:
    .db     Area_TRO, 0Ah, 0
    .db     13h, 23h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room11:
    .db     Area_TRO, 11h, 0
    .db     2Ch, 07h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room15:
    .db     Area_TRO, 15h, 0
    .db     1Dh, 04h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room19:
    .db     Area_TRO, 19h, 0
    .db     04h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room1B:
    .db     Area_TRO, 1Bh, 0
    .db     1Ch, 07h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room1F:
    .db     Area_TRO, 1Fh, 0
    .db     28h, 07h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room21:
    .db     Area_TRO, 21h, 0
    .db     15h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room2A:
    .db     Area_TRO, 2Ah, 0
    .db     05h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room2F:
    .db     Area_TRO, 2Fh, 0
    .db     1Dh, 10h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room32:
    .db     Area_TRO, 32h, 0
    .db     03h, 07h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_TRO, 32h, 1
    .db     03h, 18h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room36:
    .db     Area_TRO, 36h, 0
    .db     04h, 05h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_TRO, 36h, 1
    .db     09h, 0Eh
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector2_Room37:
    .db     Area_TRO, 37h, 0
    .db     07h, 04h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_TRO, 37h, 1
    .db     0Ah, 1Ah
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room03:
    .db     Area_PYR, 03h, 0
    .db     2Ch, 0Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room06:
    .db     Area_PYR, 06h, 0
    .db     05h, 11h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room08:
    .db     Area_PYR, 08h, 0
    .db     09h, 09h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_PYR, 08h, 1
    .db     16h, 0Dh
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room09:
    .db     Area_PYR, 09h, 0
    .db     2Ah, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room0C:
    .db     Area_PYR, 0Ch, 0
    .db     0Ch, 19h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room13:
    .db     Area_PYR, 13h, 0
    .db     13h, 0Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_PYR, 13h, 1
    .db     2Bh, 0Ah
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room1C:
    .db     Area_PYR, 1Ch, 0
    .db     0Ch, 07h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_PYR, 1Ch, 1
    .db     24h, 1Bh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room1E:
    .db     Area_PYR, 1Eh, 0
    .db     04h, 0Dh
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room21:
    .db     Area_PYR, 21h, 0
    .db     0Fh, 0Ah
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room22:
    .db     Area_PYR, 22h, 0
    .db     0Ah, 0Fh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room23:
    .db     Area_PYR, 23h, 0
    .db     04h, 1Bh
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_PYR, 23h, 1
    .db     0Fh, 56h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector3_Room25:
    .db     Area_PYR, 25h, 0
    .db     0Fh, 03h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room06:
    .db     Area_AQA, 06h, 0
    .db     16h, 1Dh
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room0A:
    .db     Area_AQA, 0Ah, 0
    .db     0Ch, 1Dh
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room0D:
    .db     Area_AQA, 0Dh, 0
    .db     18h, 09h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_AQA, 0Dh, 1
    .db     26h, 0Fh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room0F:
    .db     Area_AQA, 0Fh, 0
    .db     2Ch, 05h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room11:
    .db     Area_AQA, 11h, 0
    .db     17h, 14h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room17:
    .db     Area_AQA, 17h, 0
    .db     39h, 13h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room18:
    .db     Area_AQA, 18h, 0
    .db     28h, 07h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room1C:
    .db     Area_AQA, 1Ch, 0
    .db     09h, 06h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room21:
    .db     Area_AQA, 21h, 0
    .db     0Ah, 0Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room24:
    .db     Area_AQA, 24h, 0
    .db     03h, 07h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room26:
    .db     Area_AQA, 26h, 0
    .db     16h, 0Ah
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_AQA, 26h, 1
    .db     2Ah, 05h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room29:
    .db     Area_AQA, 29h, 0
    .db     0Fh, 04h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector4_Room2E:
    .db     Area_AQA, 2Eh, 0
    .db     04h, 0Ah
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room04:
    .db     Area_ARC, 04h, 0
    .db     05h, 05h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_ARC, 04h, 1
    .db     14h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room0C:
    .db     Area_ARC, 0Ch, 0
    .db     03h, 0Ah
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room0E:
    .db     Area_ARC, 0Eh, 0
    .db     0Dh, 03h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room12:
    .db     Area_ARC, 12h, 0
    .db     03h, 03h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room16:
    .db     Area_ARC, 16h, 0
    .db     03h, 30h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room17:
    .db     Area_ARC, 17h, 0
    .db     0Eh, 06h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room1A:
    .db     Area_ARC, 1Ah, 0
    .db     04h, 06h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room1E:
    .db     Area_ARC, 1Eh, 0
    .db     17h, 07h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room21:
    .db     Area_ARC, 21h, 0
    .db     0Eh, 03h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room22:
    .db     Area_ARC, 22h, 0
    .db     0Eh, 08h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room24:
    .db     Area_ARC, 24h, 0
    .db     08h, 08h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room2F:
    .db     Area_ARC, 2Fh, 0
    .db     04h, 0Ah
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room32:
    .db     Area_ARC, 32h, 0
    .db     0Dh, 08h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector5_Room33:
    .db     Area_ARC, 33h, 0
    .db     0Bh, 03h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room00:
    .db     Area_NOC, 00h, 0
    .db     29h, 12h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room0F:
    .db     Area_NOC, 0Fh, 0
    .db     03h, 03h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room12:
    .db     Area_NOC, 12h, 0
    .db     0Fh, 03h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_NOC, 12h, 1
    .db     1Dh, 14h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room18:
    .db     Area_NOC, 18h, 0
    .db     1Dh, 09h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room1A:
    .db     Area_NOC, 1Ah, 0
    .db     05h, 06h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room1E:
    .db     Area_NOC, 1Eh, 0
    .db     09h, 0Dh
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_NOC, 1Eh, 1
    .db     13h, 08h
    .db     Upgrade_MissileTank
    .db     UpgradeSprite_MissileTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room22:
    .db     Area_NOC, 22h, 0
    .db     0Eh, 08h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room26:
    .db     Area_NOC, 26h, 0
    .db     2Dh, 06h
    .db     Upgrade_EnergyTank
    .db     UpgradeSprite_EnergyTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
@Items_Sector6_Room27:
    .db     Area_NOC, 27h, 0
    .db     0Ah, 18h
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
    .db     Area_NOC, 27h, 1
    .db     21h, 0Ah
    .db     Upgrade_PowerBombTank
    .db     UpgradeSprite_PowerBombTank
    .db     Message_Auto, MinorItemJingle
    .fill   07h, 0
.endautoregion

.org MinorLocationsPointer
.area 04h
    .dw     MinorLocations
.endarea
