; Main Deck - Operations Ventilation
; repair maintenance crossing and add a geron
.org readptr(MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Bg1)
.area 492h
.incbin "data/rooms/S0-23-BG1.rlebg"
.endarea

.org readptr(MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Bg2)
.area 4F0h
.incbin "data/rooms/S0-23-BG2.rlebg"
.endarea

; Add doors so that it can have them synced with Operations Crossing (room 0x24)
; Reuse Doors 0x92 and 0xCC for this. Those are from the SA-X version of Operations Deck, which we dont use (room 0x55)
.dataautoregion
@S0_OperationsVentilation_Clipdata:
.incbin "data/rooms/S0-23-Clip.rlebg"
.endautoregion

.org MainDeckLevels + 23h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S0_OperationsVentilation_Clipdata
.endarea

.org MainDeckDoors + 92h * DoorEntry_Size + DoorEntry_Type
.area 7
    .db     DoorType_LockableHatch
    .db     23h
    .db     02h, 02h
    .db     38h, 3Bh
    .db     50h
.endarea

.org MainDeckDoors + 0CCh * DoorEntry_Size + DoorEntry_Type
.area 7
    .db     DoorType_LockableHatch
    .db     23h
    .db     10h, 10h
    .db     38h, 3Bh
    .db     53h
.endarea

.defineregion readptr(MainDeckLevels + 52h * LevelMeta_Size + LevelMeta_Spriteset0), 12h

.dataautoregion
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


; ---


; Main Deck - Operations Crossing
; This room is bundled with the above as one room in RDV's database
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

.dataautoregion
@MaintenanceCrossing_Spriteset0:
    .db     07h, 0Ch, 24h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org MainDeckLevels + 24h * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset1Event - LevelMeta_Spriteset0
    .dw     @MaintenanceCrossing_Spriteset0
    .db     19h
.endarea
