; Room edits for open exploration, enemies, softlock prevention, etc.

; TODO: patch scroll behavior such that if no scroll zones are found,
; extended scrolls with unbroken tiles will be treated as fallbacks.

; Debug room data
.defineregion 083C2A48h, 3 * 90h
.defineregion 083C2C10h, 3Ch
.defineregion 083F1548h, 0C56h

; Main Deck - Docking Bay Shaft
; remove event-based transitions to wrecked Silo Access
.if RANDOMIZER
.org MainDeckDoors + 0Dh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_NoHatch
.endarea

.org MainDeckDoors + 0Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea
.endif

; Main Deck - Crew Quarters West
; remove power bomb geron
.defineregion readptr(MainDeckLevels + 0Ch * LevelMeta_Size + LevelMeta_Spriteset1), 0Fh

.org MainDeckLevels + 0Ch * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_GoMode
    .skip 2
    .dw     readptr(MainDeckLevels + 0Ch * LevelMeta_Size + LevelMeta_Spriteset2)
    .db     33h
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Main Deck - Operations Deck
; change operations room lv4 security door to lv0 security
; allow missile hatch to be destroyed from both sides
.org readptr(MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Bg1)
.area 2DBh
.incbin "data/rooms/S0-0D-BG1.rlebg"
.endarea

.org readptr(MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata)
.area 0C3h
.incbin "data/rooms/S0-0D-Clip.rlebg"
.endarea

.org 0804193Eh
.area 02h
    mov     r0, #60h
.endarea

; Main Deck - Central Hub
; keep power bomb geron always loaded
.defineregion readptr(MainDeckLevels + 12h * LevelMeta_Size + LevelMeta_Spriteset0), 03h

.org MainDeckLevels + 12h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset0
    .dw     readptr(MainDeckLevels + 12h * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     33h
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Main Deck - Eastern Hub
; remove geron in front of recharge station
.defineregion readptr(MainDeckLevels + 15h * LevelMeta_Size + LevelMeta_Spriteset0), 12h

.org MainDeckLevels + 15h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_MapX - LevelMeta_Spriteset0
    .dw     readptr(MainDeckLevels + 15h * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     19h
    .db     63h
    .skip 2
    .dw     readptr(MainDeckLevels + 15h * LevelMeta_Size + LevelMeta_Spriteset2)
    .db     19h
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Main Deck - Sector Hub
; keep main elevator always active
.defineregion readptr(MainDeckLevels + 18h * LevelMeta_Size + LevelMeta_Spriteset0), 27h

.org MainDeckLevels + 18h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset0
    .dw     readptr(MainDeckLevels + 18h * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     02h
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Main Deck - Main Elevator Shaft
; remove event-based transition
.org MainDeckDoors + 32h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_NoHatch
.endarea

; Main Deck - Maintenance Shaft
; repair maintenance crossing and add a geron
.org readptr(MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Bg1)
.area 492h
.incbin "data/rooms/S0-23-BG1.rlebg"
.endarea

.org readptr(MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Bg2)
.area 4F0h
.incbin "data/rooms/S0-23-BG2.rlebg"
.endarea

.defineregion readptr(MainDeckLevels + 52h * LevelMeta_Size + LevelMeta_Spriteset0), 12h

.autoregion
@MaintenanceShaft_Spriteset0:
    .db     05h, 0Eh, 25h
    .db     15h, 0Bh, 03h
    .db     19h, 0Ch, 12h
    .db     20h, 07h, 38h
    .db     46h, 0Bh, 22h
    .db     39h, 0Ch, 24h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset1Event - LevelMeta_Spriteset0
    .dw     @MaintenanceShaft_Spriteset0
    .db     19h
.endarea

; Main Deck - Maintenance Crossing
; repair so the crossing is traversable and add a geron
.org readptr(MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Bg1)
.area 100h
.incbin "data/rooms/S0-24-BG1.rlebg"
.endarea

.org readptr(MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Bg2)
.area 0D2h
.incbin "data/rooms/S0-24-BG2.rlebg"
.endarea

.org readptr(MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Clipdata)
.area 61h
.incbin "data/rooms/S0-24-Clip.rlebg"
.endarea

.defineregion readptr(MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Spriteset0), 03h

.autoregion
@MaintenanceCrossing_Spriteset0:
    .db     07h, 0Ch, 24h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset1Event - LevelMeta_Spriteset0
    .dw     @MaintenanceCrossing_Spriteset0
    .db     19h
.endarea

; Main Deck - Arachnus Arena
; remove sprite layer that removes Arachnus during the escape
.org MainDeckLevels + 26h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset1Event
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Main Deck - Main Elevator Access
; remove event-based transition
.org MainDeckDoors + 4Ah * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_Destination - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_Destination - DoorEntry_Type - 1
    .db     61h
.endarea

.org MainDeckDoors + 5Ch * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org MainDeckDoors + 5Dh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Main Deck - Silo Access
; move zoro cocoon
.org readptr(MainDeckLevels + 30h * LevelMeta_Size + LevelMeta_Spriteset0)
.area 03h
    .db     15h, 05h, 14h
.endarea

.org readptr(MainDeckLevels + 30h * LevelMeta_Size + LevelMeta_Spriteset1)
.area 03h
    .db     15h, 05h, 14h
.endarea

; Main Deck - Central Reactor Core
; add platform between door to Silo Access and door to Silo Scaffolding A
.org readptr(MainDeckLevels + 31h * LevelMeta_Size + LevelMeta_Bg1)
.area 4C3h
.incbin "data/rooms/S0-31-BG1.rlebg"
.endarea

.autoregion
@S0_WreckedCentralReactorCore_Clipdata:
.incbin "data/rooms/S0-31-Clip.rlebg"
.endautoregion

.autoregion
@S0_CentralReactorCore_BG1:
.incbin "data/rooms/S0-3B-BG1.rlebg"
.endautoregion

.autoregion
@S0_CentralReactorCore_Clipdata:
.incbin "data/rooms/S0-3B-Clip.rlebg"
.endautoregion

.org MainDeckLevels + 31h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S0_WreckedCentralReactorCore_Clipdata
.endarea

.org MainDeckLevels + 3Bh * LevelMeta_Size + LevelMeta_Bg1
.area 0Ch
    .dw     @S0_CentralReactorCore_BG1
    .skip 4
    .dw     @S0_CentralReactorCore_Clipdata
.endarea

.defineregion readptr(MainDeckLevels + 31h * LevelMeta_Size + LevelMeta_Clipdata), 1E2h
.defineregion readptr(MainDeckLevels + 3Bh * LevelMeta_Size + LevelMeta_Bg1), 457h
.defineregion readptr(MainDeckLevels + 3Bh * LevelMeta_Size + LevelMeta_Clipdata), 16Ah

; remove event-based transitions to wrecked Silo Access
.if RANDOMIZER
.org MainDeckDoors + 86h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch | DoorType_ShowsLocationName
.endarea
.endif

; Main Deck - Operations Room
; change lv4 security door to lv0 security
; remove event-based transition leading to wrecked Operations Deck
.org readptr(MainDeckLevels + 52h * LevelMeta_Size + LevelMeta_Bg1)
.area 0F8h
.incbin "data/rooms/S0-52-BG1.rlebg"
.endarea

.org readptr(MainDeckLevels + 52h * LevelMeta_Size + LevelMeta_Clipdata)
.area 3Ch
.incbin "data/rooms/S0-52-Clip.rlebg"
.endarea

.if RANDOMIZER
.org MainDeckDoors + 0C2h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea
.endif

; Sector 1 - Atmospheric Stabilizer Northwest
; show metroid molt in go mode instead of after ridley
.org Sector1Levels + 04h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area 1
    .db     Event_GoMode
.endarea

; Sector 1 - Charge Core Exit
; fix screen scroll when entering room from Charge Core Arena
.defineregion readptr(Sector1Scrolls + 01h * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Sector 1 - Moto Manor
; show metroid molt in go mode instead of after ridley
.org Sector1Levels + 0Ch * LevelMeta_Size + LevelMeta_Spriteset1Event
.area 1
    .db     Event_GoMode
.endarea

; Sector 1 - Atmospheric Stabilizer Southeast
; show metroid molt in go mode instead of after ridley
.org Sector1Levels + 0Fh * LevelMeta_Size + LevelMeta_Spriteset1Event
.area 1
    .db     Event_GoMode
.endarea

; Sector 1 - Lava Lake Annex
; show metroid molt in go mode instead of after ridley
.org Sector1Levels + 14h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area 1
    .db     Event_GoMode
.endarea

; Sector 1 - Hornoad Housing
; have hornoads spawn by x forming them
.org readptr(Sector1Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset0)
.area 15
    .skip 6
    .db 07h, 08h, 16h
    .skip 3
    .db 07h, 0Ah, 16h
.endarea

; Sector 1 - Sciser Playground
; fix screen scroll when entering room from Charge Core Access
.defineregion readptr(Sector1Scrolls + 07h * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Sector 1 scroll table fixes
.org Sector1Scrolls
.area 30h
    .dw     readptr(Sector1Scrolls + 00h * 4)
    .dw     readptr(Sector1Scrolls + 02h * 4)
    .dw     readptr(Sector1Scrolls + 03h * 4)
    .dw     readptr(Sector1Scrolls + 04h * 4)
    .dw     readptr(Sector1Scrolls + 05h * 4)
    .dw     readptr(Sector1Scrolls + 06h * 4)
    .dw     readptr(Sector1Scrolls + 08h * 4)
    .dw     readptr(Sector1Scrolls + 09h * 4)
    .dw     readptr(Sector1Scrolls + 0Ah * 4)
    .dw     readptr(Sector1Scrolls + 0Bh * 4)
.endarea

; Sector 2 - Data Hub Access
; move cocoon and kihunter spritesets to intact room state
.org Sector2Levels + 03h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     readptr(Sector2Levels + 1Eh * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     Event_ReactorOutage
    .skip 2
    .dw     readptr(Sector2Levels + 1Eh * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

.org Sector2Doors + 02h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

; Sector 2 - Owtch Cache A
; TODO: fix screen scroll when custom start is behind bomb blocks

; Sector 2 - Zoro Zig-Zag
; moves zoro coocoons to prevent blocking morph ball tunnels
.org readptr(Sector2Levels + 09h * LevelMeta_Size + LevelMeta_Spriteset1) + (7 * Spriteset_SpriteSize)
.area 9
    .db 25h, 17h, 14h
    .db 2Ah, 1Bh, 14h
    .db 32h, 1Bh, 14h
.endarea

.org readptr(Sector2Levels + 09h * LevelMeta_Size + LevelMeta_Spriteset2) + (0Bh * Spriteset_SpriteSize)
.area 9
    .db 26h, 17h, 14h
    .db 2Ah, 1Bh, 14h
    .db 32h, 1Bh, 14h
.endarea

; Sector 2 - Cathedral
; make door to reo room functional
; remove hatch to ripper roost
; move zoro out of the way of ripper roost
; move cocoon and kihunter spritesets to intact room state
; limit zoro pathing to prevent climbing the room early with ice beam
; move a stop-enemy block one tile lower to avoid glitchy sprite behavior
.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Bg1)
.area 4E1h
.incbin "data/rooms/S2-0D-BG1.rlebg"
.endarea

.autoregion
@S2_CentralShaft_Clipdata:
.incbin "data/rooms/S2-0D-Clip.rlebg"
.endautoregion

.autoregion
@S2_CentralShaft_KihunterSpriteset:
    .db     3Eh, 00h
    .db     5Eh, 01h
    .db     36h, 08h
    .db     8Ah, 02h
    .db     5Bh, 03h
    .db     5Ch, 03h
    .db     89h, 06h
    .db     0, 0
.endautoregion

.org SpritesetList + 1Eh * 04h
.area 04h
    .dw     @S2_CentralShaft_KihunterSpriteset
.endarea

.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset0) + (1 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset0) + (3 * Spriteset_SpriteSize)
.area 03h
    .db     2Bh, 03h, 24h
.endarea


.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset0) + (1 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1) + (2 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1) + (6 * Spriteset_SpriteSize)
.area 03h
    .db     2Ch, 03h, 17h
.endarea

.org Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S2_CentralShaft_Clipdata
.endarea

.org Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     Event_ReactorOutage
    .skip 2
    .dw     readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

.org Sector2Doors + 1Bh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 1Fh * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     0Dh
.endarea

.org Sector2Doors + 23h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 2Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 5Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 6Eh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea

.org Sector2Doors + 71h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceY - DoorEntry_Type + 1
    .db     DoorType_OpenHatch
    .skip   DoorEntry_SourceRoom - DoorEntry_Type - 1
    .db     0Dh
    .skip   DoorEntry_ExitDistanceX - DoorEntry_SourceRoom - 1
    .db     18h
    .db     00h
.endarea

.defineregion readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata), 1F0h

; Sector 2 - Dessgeega Dormitory
; add connection to Shadow Moses Island under hidden bomb blocks
; add cocoon and kihunter spritesets to intact room state
.autoregion
@S2_Dessgeega_Dormitory_Bg1:
.incbin "data/rooms/S2-0E-BG1.rlebg"
.endautoregion

.autoregion
@S2_Dessgeega_Dormitory_Clipdata:
.incbin "data/rooms/S2-0E-Clip.rlebg"
.endautoregion

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Bg1
.area 04h
    .dw     @S2_Dessgeega_Dormitory_Bg1
.endarea

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S2_Dessgeega_Dormitory_Clipdata
.endarea

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     readptr(Sector2Levels + 2Ch * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     Event_ReactorOutage
    .skip 2
    .dw     readptr(Sector2Levels + 2Ch * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

.org Sector2Doors + 2Ah * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 60h * DoorEntry_Size + DoorEntry_Destination
.area 1
    .db     67h
.endarea

.org Sector2Doors + 65h * DoorEntry_Size + DoorEntry_Type
.area 6
    .db     DoorType_NoHatch
    .db     0Eh
    .db     5, 6
    .db     0Ch, 0Dh
.endarea

.org Sector2Doors + 67h * DoorEntry_Size + DoorEntry_Destination
.area 1
    .db     60h
.endarea

; Sector 2 - Zazabi Access
; add cocoon and kihunter spritesets to intact room state
.autoregion
@S2_ZazabiAccess_Spriteset1:
    .db     03h, 27h, 12h
    .db     05h, 2Dh, 12h
    .db     0Dh, 08h, 12h
    .db     0Dh, 0Ch, 12h
    .db     0Dh, 0Fh, 12h
    .db     0Eh, 15h, 12h
    .db     0Eh, 19h, 12h
    .db     11h, 14h, 02h
    .db     10h, 2Dh, 21h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.autoregion
@S2_ZazabiAccess_Spriteset2:
    .db     03h, 28h, 12h
    .db     04h, 2Ah, 23h
    .db     05h, 2Bh, 23h
    .db     05h, 2Dh, 12h
    .db     0Dh, 07h, 12h
    .db     0Dh, 0Bh, 12h
    .db     0Dh, 0Fh, 12h
    .db     0Eh, 15h, 12h
    .db     0Eh, 19h, 12h
    .db     0Fh, 0Fh, 23h
    .db     11h, 14h, 02h
    .db     11h, 19h, 23h
    .db     11h, 1Dh, 23h
    .db     14h, 15h, 24h
    .db     10h, 2Dh, 21h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector2Levels + 11h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     @S2_ZazabiAccess_Spriteset1
    .db     68h
    .db     Event_ReactorOutage
    .skip 2
    .dw     @S2_ZazabiAccess_Spriteset2
    .db     69h
.endarea

.autoregion
@S2_ZazabiAccess_CocoonSpriteset:
    .db     91h, 00h
    .db     89h, 02h
    .db     0, 0
.endautoregion

.autoregion
@S2_ZazabiAccess_KihunterSpriteset:
    .db     91h, 00h
    .db     8Ah, 02h
    .db     5Bh, 03h
    .db     5Ch, 03h
    .db     0, 0
.endautoregion

.org SpritesetList + 68h * 04h
.area 08h
    .dw     @S2_ZazabiAccess_CocoonSpriteset
    .dw     @S2_ZazabiAccess_KihunterSpriteset
.endarea

; Sector 2 - Zazabi Arena
; fix screen scroll when entering room from Zazabi Speedway
.org readptr(Sector2Scrolls + 05h * 4) + ScrollList_HeaderSize
.area Scroll_Size
    .db     02h, 2Eh
    .db     02h, 0Eh
    .db     0FFh, 0FFh
    .db     ScrollExtend_None
    .db     0FFh
.endarea

; Sector 2 - Nettori Access
; change winged kihunter below eyedoor into a grounded kihunter
; remove 4 tiles to prevent the above kihunter from jumping through solids
.org readptr(Sector2Levels + 14h * LevelMeta_Size + LevelMeta_Bg1)
.area 4F6h
.incbin "data/rooms/S2-14-BG1.rlebg"
.endarea

.org readptr(Sector2Levels + 14h * LevelMeta_Size + LevelMeta_Clipdata)
.area 1AEh
.incbin "data/rooms/S2-14-Clip.rlebg"
.endarea

.org readptr(Sector2Levels + 14h * LevelMeta_Size + LevelMeta_Spriteset0) + 3 * 3
.area 3
    .db     11h, 15h, 26h
.endarea

.org readptr(Sector2Levels + 22h * LevelMeta_Size + LevelMeta_Spriteset0) + 2 * 3
.area 3
    .db     11h, 15h, 26h
.endarea

; Sector 2 - Entrance Hub Underside
; add room state with zoros
.autoregion
@S2_EntranceHubUnderside_Spriteset0:
    .db     03h, 09h, 24h
    .db     0Fh, 0Fh, 24h
    .db     10h, 0Dh, 02h
    .db     12h, 0Eh, 26h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_MapX - LevelMeta_Spriteset0
    .dw     @S2_EntranceHubUnderside_Spriteset0
    .db     12h
    .db     19h
    .skip 2
    .dw     readptr(Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     4Eh
    .skip 2
    .dw     readptr(Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

; Sector 2 - Eastern Shaft
; add ledge to allow climbing frozen enemies from middle doors to top doors
; removed 2 vine tiles to prevent dangerous nettori
.defineregion readptr(Sector2Levels + 20h * LevelMeta_Size + LevelMeta_Clipdata), 21Fh
.defineregion readptr(Sector2Levels + 23h * LevelMeta_Size + LevelMeta_Bg1), 46Ah

.org readptr(Sector2Levels + 20h * LevelMeta_Size + LevelMeta_Bg1)
.area 46Ah
.incbin "data/rooms/S2-20-BG1.rlebg"
.endarea

.autoregion
@S2_EasternShaftVines_Clipdata:
.incbin "data/rooms/S2-20-Clip.rlebg"
.endautoregion

.org Sector2Levels + 20h * LevelMeta_Size + LevelMeta_Clipdata
.area 4
    .dw     @S2_EasternShaftVines_Clipdata
.endarea

.autoregion
@S2_EasternShaft_Bg1:
.incbin "data/rooms/S2-23-BG1.rlebg"
.endautoregion

.org readptr(Sector2Levels + 23h * LevelMeta_Size + LevelMeta_Clipdata)
.area 1C3h
.incbin "data/rooms/S2-23-Clip.rlebg"
.endarea

.org Sector2Levels + 23h * LevelMeta_Size + LevelMeta_Bg1
.area 4
    .dw     @S2_EasternShaft_Bg1
.endarea

; Sector 2 - Ripper Roost
; move bottom crumble block up one to prevent softlocks without bombs
.if ANTI_SOFTLOCK
.org readptr(Sector2Levels + 32h * LevelMeta_Size + LevelMeta_Clipdata)
.area 10Ah
.incbin "data/rooms/S2-32-Clip.rlebg"
.endarea
.endif

; Sector 2 - Crumble City
; replace one of the shot blocks in the morph tunnel below the top item
; with a crumble block to prevent softlocks without bombs
.if ANTI_SOFTLOCK
.org readptr(Sector2Levels + 36h * LevelMeta_Size + LevelMeta_Clipdata)
.area 121h
.incbin "data/rooms/S2-36-Clip.rlebg"
.endarea
.endif

; Sector 2 - Shooting Gallery
; change lower door connection to be event based
.org VariableConnections + (0Bh * VariableConnection_Size)
.area 4
    .db Area_TRO, 19h
    .db Event_NettoriAbsorbed, 4Bh
.endarea

.org Sector2Doors + 19h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db 24h
.endarea

.org Sector2Doors + 19h * DoorEntry_Size + DoorEntry_Destination
.area 1
    .db 2Fh
.endarea

; Sector 3 - Security Access
; remove sidehoppers on speedbooster runway to prevent near softlock with neither charge nor missiles
; move sidehoppers below runway to prevent them from clipping into the wall
.org readptr(Sector3Levels + 03h * LevelMeta_Size + LevelMeta_Spriteset1)
.area 27h
    .db     04h, 24h, 0A4h
    .db     05h, 1Fh, 0A4h
    .db     05h, 29h, 0A4h
    .db     06h, 1Dh, 02h
    .db     14h, 29h, 23h
    .db     14h, 2Ch, 23h
    .db     0FFh, 0FFh, 0FFh
.endarea

; Sector 3 - Bob's Room
; remove event-based transitions leading to wrecked room state
.org Sector3Doors + 0Ch * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector3Doors + 14h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector3Doors + 2Fh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector3Doors + 30h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector3Doors + 3Fh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 3 - BOX Access
; repair door to bob's room
.defineregion readptr(Sector3Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata), 0A5h

.org readptr(Sector3Levels + 16h * LevelMeta_Size + LevelMeta_Bg1)
.area 300h
.incbin "data/rooms/S3-16-BG1.rlebg"
.endarea

.autoregion
@S3_BoxAccess_Clipdata:
.incbin "data/rooms/S3-16-Clip.rlebg"
.endautoregion

.org Sector3Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S3_BoxAccess_Clipdata
.endarea

.org Sector3Doors + 10h * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     16h
.endarea

.org Sector3Doors + 23h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 3 - BOX Arena
; repair door to data room
.defineregion readptr(Sector3Levels + 17h * LevelMeta_Size + LevelMeta_Clipdata), 08Fh

.org readptr(Sector3Levels + 17h * LevelMeta_Size + LevelMeta_Bg1)
.area 256h
.incbin "data/rooms/S3-17-BG1.rlebg"
.endarea

.autoregion
@S3_BoxArena_Clipdata:
.incbin "data/rooms/S3-17-Clip.rlebg"
.endautoregion

.org Sector3Levels + 17h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S3_BoxArena_Clipdata
.endarea

.org Sector3Doors + 1Dh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector3Doors + 2Bh * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     17h
.endarea

.org Sector3Doors + 2Dh * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_Destination - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_Destination - DoorEntry_Type - 1
    .db     2Eh
.endarea

.org Sector3Doors + 24h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Extends upper scroll down by one tile for slightly better visibility after
; defeating BOX without showing the exit during the fight
.org readptr(Sector3Scrolls + 09h * 4) + ScrollList_HeaderSize
.area Scroll_Size
    .db     10h, 1Fh
    .db     02h, 0Dh
    .db     0FFh, 0FFh
    .db     ScrollExtend_None
    .db     0FFh
.endarea

; Sector 4 - Serris Escape
; TODO: fix screen scrolls when custom start is behind the bomb blocks
; scroll 0 (11, 02) -> (2E, 17), scroll 1 (02, 16) -> (2E, 1F)

; Sector 4 - Pump Control Access
; fix screen scrolls when entering from Pump Control Save Room
.org readptr(Sector4Scrolls + 03h * 4) + ScrollList_HeaderSize
.area Scroll_Size
    .db     02h, 10h
    .db     02h, 29h
    .db     0FFh, 0FFh
    .db     ScrollExtend_None
    .db     0FFh
.endarea

; Sector 4 - Pump Control Save Room
; fix entering the room for the first time from morph tunnel
; this should only be an issue for entrance rando
.org Sector4Doors + 045h * DoorEntry_Size + DoorEntry_ExitDistanceX
.area 1
    .db 0E0h
.endarea

; Sector 4 - Cheddar Bay
; fix screen scrolls when entering from Security Bypass
.org readptr(Sector4Scrolls + 05h * 4) + ScrollList_HeaderSize + Scroll_Size * 1
.area Scroll_Size
    .db     02h, 20h
    .db     02h, 0Ch
    .db     0FFh, 0FFh
    .db     ScrollExtend_None
    .db     0FFh
.endarea

; Sector 4 - Waterway
; add flooded room state
.autoregion
@S4_Waterway_Spriteset0:
    .db     03h, 09h, 17h
    .db     03h, 0Bh, 17h
    .db     03h, 10h, 17h
    .db     03h, 13h, 17h
    .db     03h, 17h, 17h
    .db     04h, 08h, 12h
    .db     04h, 18h, 12h
    .db     07h, 10h, 11h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector4Levels + 1Ch * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset0
    .dw     @S4_Waterway_Spriteset0
    .db     0Eh
    .db     Event_WaterLevelLowered
    .skip 2
    .dw     readptr(Sector4Levels + 1Ch * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     1Dh
.endarea

; Sector 4 - Security Bypass
; prevent several softlocks without bombs
.if ANTI_SOFTLOCK
.org readptr(Sector4Levels + 22h * LevelMeta_Size + LevelMeta_Bg1)
.area 57Ah
.incbin "data/rooms/S4-22-BG1.rlebg"
.endarea

.org readptr(Sector4Levels + 22h * LevelMeta_Size + LevelMeta_Clipdata)
.area 1B1h
.incbin "data/rooms/S4-22-Clip.rlebg"
.endarea
.endif

; Sector 4 - Drain Pipe
; keep puffer always active
.defineregion readptr(Sector4Levels + 24h * LevelMeta_Size + LevelMeta_Spriteset1), 2Ah

.org Sector4Levels + 24h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_WaterLevelLowered
    .skip 2
    .dw     readptr(Sector4Levels + 24h * LevelMeta_Size + LevelMeta_Spriteset2)
    .db     23h
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Sector 4 - Aquarium Storage
; make kago always block missile tank
.defineregion readptr(Sector4Levels + 26h * LevelMeta_Size + LevelMeta_Spriteset0), 24h

.org Sector4Levels + 26h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset0
    .dw     readptr(Sector4Levels + 26h * LevelMeta_Size + LevelMeta_Spriteset1)
    .skip 1
    .db     0
    .skip 2
    .dw     NullSpriteset
    .db     0
.endarea

; Sector 5 - Nightmare Training Grounds
; restructure the room to have a speedbooster runway across the top
; add speedbooster blocks above the power bomb blocks
.defineregion readptr(Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Bg1), 486h
.defineregion readptr(Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Clipdata), 212h

.autoregion
@S5_NightmareTrainingGrounds_Bg1:
.incbin "data/rooms/S5-03-BG1.rlebg"
.endautoregion

.autoregion
@S5_NightmareTrainingGrounds_Clipdata:
.incbin "data/rooms/S5-03-Clip.rlebg"
.endautoregion

; Remove Nightmare flying around by removing BG0
.org Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Bg0Properties
    .db     0
.org Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Bg0
    .dw     NullBg

.org Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Bg1
.area 0Ch
    .dw     @S5_NightmareTrainingGrounds_Bg1
    .skip 4
    .dw     @S5_NightmareTrainingGrounds_Clipdata
.endarea

.org readptr(Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Spriteset0)
.area 06h
    .db     10h, 1Ch, 25h
    .db     10h, 23h, 25h
.endarea

.org Sector5Doors + 03h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 0Ah * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 4Dh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 0Bh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 0Ch * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 0Dh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 50h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 5 - Arctic Containment
; change the lv4 security door to crow's nest to a functional lv3 security door
.defineregion readptr(Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Clipdata), 1AAh

.org readptr(Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Bg1)
.area 652h
.incbin "data/rooms/S5-07-BG1.rlebg"
.endarea

.autoregion
@S5_ArcticContainment_Clipdata:
.incbin "data/rooms/S5-07-Clip.rlebg"
.endautoregion

.org Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_ArcticContainment_Clipdata
.endarea

.org Sector5Doors + 15h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 24h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 35h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceX - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .db     07h
    .skip DoorEntry_ExitDistanceX - DoorEntry_SourceRoom - 1
    .db     -20h
.endarea

.org Sector5Doors + 38h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea

.org Sector5Doors + 55h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 64h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 1Bh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Ch * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Dh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Fh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 39h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 46h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.if RANDOMIZER
; Sector 5 - Geron Checkpoint
; Remove power bomb geron spriteset
.defineregion readptr(Sector5Levels + 08h * LevelMeta_Size + LevelMeta_Spriteset2), 15h
.org Sector5Levels + 08h * LevelMeta_Size + LevelMeta_Spriteset2Event
.area LevelMeta_Spriteset2Id - LevelMeta_Spriteset1Id
    .db     0
    .skip   2
    .dw     NullSpriteset
    .db     0
.endarea
.endif

; Sector 5 - Frozen Tower
; remove event-based transitions
.org Sector5Doors + 17h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 2Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_NoHatch
.endarea

.org Sector5Doors + 30h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 5Eh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 5Fh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 60h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 5 - Data Room
; merge the intact and destroyed data rooms into a single room
; seal off the destroyed upper half of the data room from the intact lower half
.defineregion readptr(Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Clipdata), 84h

.org readptr(Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Bg1)
.area 19Fh
.incbin "data/rooms/S5-10-BG1.rlebg"
.endarea

.autoregion
@S5_DataRoom_Clipdata:
.incbin "data/rooms/S5-10-Clip.rlebg"
.endautoregion

.org Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_DataRoom_Clipdata
.endarea

.org readptr(Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Spriteset0)
.area 03h
    .db     14h, 09h, 11h
.endarea

.org Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Spriteset0Id
.area 01h
    .db     0Ch
.endarea

.org Sector5Doors + 56h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_Destination - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_Destination - DoorEntry_Type - 1
    .db     5Ch
.endarea

.org Sector5Doors + 59h * DoorEntry_Size + DoorEntry_SourceRoom
.area DoorEntry_YEnd - DoorEntry_SourceRoom + 1
    .db     10h
    .db     10h, 10h
    .db     0Fh, 12h
.endarea

.org Sector5Doors + 34h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 5 - Security Shaft East
; repair the door to kago blockade
.defineregion readptr(Sector5Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata), 110h

.org readptr(Sector5Levels + 16h * LevelMeta_Size + LevelMeta_Bg1)
.area 2EBh
.incbin "data/rooms/S5-16-BG1.rlebg"
.endarea

.autoregion
@S5_SecurityShaftEast_Clipdata:
.incbin "data/rooms/S5-16-Clip.rlebg"
.endautoregion

.org Sector5Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_SecurityShaftEast_Clipdata
.endarea

.org Sector5Doors + 28h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_Destination - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_Destination - DoorEntry_Type - 1
    .db     6Ch
.endarea

.org Sector5Doors + 2Ah * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     16h
.endarea

.org Sector5Doors + 29h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Sector 5 - Ripper Road
; replace lv0 door to arctic containment with an open hatch
.org readptr(Sector5Levels + 1Ah * LevelMeta_Size + LevelMeta_Bg1)
.area 1B3h
.incbin "data/rooms/S5-1A-BG1.rlebg"
.endarea

.org readptr(Sector5Levels + 1Ah * LevelMeta_Size + LevelMeta_Clipdata)
.area 0A4h
.incbin "data/rooms/S5-1A-Clip.rlebg"
.endarea

.org Sector5Doors + 37h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea

; Sector 5 - Crow's Nest
; repair the door to arctic containment into a lv3 security door
.defineregion readptr(Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Clipdata), 0F0h

.org readptr(Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Bg1)
.area 263h
.incbin "data/rooms/S5-24-BG1.rlebg"
.endarea

.autoregion
@S5_CrowsNest_Clipdata:
.incbin "data/rooms/S5-24-Clip.rlebg"
.endautoregion

.org Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_CrowsNest_Clipdata
.endarea

.org Sector5Doors + 57h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceX - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_ExitDistanceX - DoorEntry_Type - 1
    .db     20h
.endarea

; Sector 5 - Kago Blockade
; remove event-based transition from Save Station South
.org Sector5Doors + 2Dh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

; Sector 5 - Groznyj Grad
; fix screen scrolls when entering from Security Shaft East
.defineregion readptr(Sector5Scrolls + 0Fh * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Sector 5 scroll table fixes
.org Sector5Scrolls
.area 4Ch
    .dw     readptr(Sector5Scrolls + 00h * 4)
    .dw     readptr(Sector5Scrolls + 01h * 4)
    .dw     readptr(Sector5Scrolls + 02h * 4)
    .dw     readptr(Sector5Scrolls + 03h * 4)
    .dw     readptr(Sector5Scrolls + 04h * 4)
    .dw     readptr(Sector5Scrolls + 05h * 4)
    .dw     readptr(Sector5Scrolls + 06h * 4)
    .dw     readptr(Sector5Scrolls + 07h * 4)
    .dw     readptr(Sector5Scrolls + 08h * 4)
    .dw     readptr(Sector5Scrolls + 09h * 4)
    .dw     readptr(Sector5Scrolls + 0Ah * 4)
    .dw     readptr(Sector5Scrolls + 0Bh * 4)
    .dw     readptr(Sector5Scrolls + 0Ch * 4)
    .dw     readptr(Sector5Scrolls + 0Dh * 4)
    .dw     readptr(Sector5Scrolls + 0Eh * 4)
    .dw     readptr(Sector5Scrolls + 10h * 4)
    .dw     readptr(Sector5Scrolls + 11h * 4)
    .dw     readptr(Sector5Scrolls + 12h * 4)
.endarea

; Sector 6 - Zozoro Wine Cellar
; change the reforming bomb block to a never reforming bomb block to prevent
; softlocking from running out of power bombs
.if ANTI_SOFTLOCK
.org readptr(Sector6Levels + 0Fh * LevelMeta_Size + LevelMeta_Clipdata)
.area 033h
.incbin "data/rooms/S6-0F-Clip.rlebg"
.endarea
.endif

; Sector 6 - X-BOX Arena
; change the top crumble block into a shot block to mitigate accidentally
; entering a point of no return
.org readptr(Sector6Levels + 10h * LevelMeta_Size + LevelMeta_Clipdata)
.area 0B3h
.incbin "data/rooms/S6-10-Clip.rlebg"
.endarea

; Sector 6 - Forbidden Entrance
; fix screen scrolls when entering room from XBOX Access
.defineregion readptr(Sector6Scrolls + 02h * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Sector 6 - Missile Storage
; TODO: fix screen scrolls when custom start is behind bomb blocks

; Sector 6 - Big Shell 1
; Remove the crumble block into the long morph tunnel to prevent softlocks
; without power bombs
.if ANTI_SOFTLOCK
.org readptr(Sector6Levels + 1Bh * LevelMeta_Size + LevelMeta_Bg1)
.area 1EFh
.incbin "data/rooms/S6-1B-BG1.rlebg"
.endarea

.org readptr(Sector6Levels + 1Bh * LevelMeta_Size + LevelMeta_Clipdata)
.area 0B5h
.incbin "data/rooms/S6-1B-Clip.rlebg"
.endarea
.endif

; Sector 6 - Big Shell 2
; fix screen scrolls when entering room from Blue X Blockade
.defineregion readptr(Sector6Scrolls + 0Fh * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Sector 6 scroll table fixes
.org Sector6Scrolls
.area 50h
    .dw     readptr(Sector6Scrolls + 00h * 4)
    .dw     readptr(Sector6Scrolls + 01h * 4)
    .dw     readptr(Sector6Scrolls + 03h * 4)
    .dw     readptr(Sector6Scrolls + 04h * 4)
    .dw     readptr(Sector6Scrolls + 05h * 4)
    .dw     readptr(Sector6Scrolls + 06h * 4)
    .dw     readptr(Sector6Scrolls + 07h * 4)
    .dw     readptr(Sector6Scrolls + 08h * 4)
    .dw     readptr(Sector6Scrolls + 09h * 4)
    .dw     readptr(Sector6Scrolls + 0Ah * 4)
    .dw     readptr(Sector6Scrolls + 0Bh * 4)
    .dw     readptr(Sector6Scrolls + 0Ch * 4)
    .dw     readptr(Sector6Scrolls + 0Dh * 4)
    .dw     readptr(Sector6Scrolls + 0Eh * 4)
    .dw     readptr(Sector6Scrolls + 10h * 4)
    .dw     readptr(Sector6Scrolls + 11h * 4)
    .dw     readptr(Sector6Scrolls + 12h * 4)
    .dw     readptr(Sector6Scrolls + 13h * 4)
.endarea

.include "src/nonlinear/room-edits/main-deck/room-47.s"
.include "src/nonlinear/room-edits/main-deck/room-56.s"
.include "src/nonlinear/room-edits/sector-2/room-07-and-1F.s"
.include "src/nonlinear/room-edits/sector-2/room-0A.s"
.include "src/nonlinear/room-edits/sector-2/room-39.s"
.include "src/nonlinear/room-edits/sector-4/room-06.s"
.include "src/nonlinear/room-edits/sector-4/room-23.s"
