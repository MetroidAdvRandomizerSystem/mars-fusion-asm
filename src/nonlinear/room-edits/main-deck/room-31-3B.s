; Main Deck - Central Reactor Core
; Add platform between door to Silo Access and door to Silo Scaffolding A
; Also move the Silo Tunnel back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(MainDeckLevels + 31h * LevelMeta_Size + LevelMeta_Bg1)
.area 4C3h
.incbin "data/rooms/S0-31-BG1.rlebg"
.endarea

.autoregion DataFreeSpace, DataFreeSpaceEnd
@S0_WreckedCentralReactorCore_Clipdata:
.incbin "data/rooms/S0-31-Clip.rlebg"
.endautoregion

.autoregion DataFreeSpace, DataFreeSpaceEnd
@S0_CentralReactorCore_BG1:
.incbin "data/rooms/S0-3B-BG1.rlebg"
.endautoregion

.autoregion DataFreeSpace, DataFreeSpaceEnd
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

; Move Silo Tunnel door back by a tile
.org MainDeckDoors + 7Dh * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea


; Remove event-based transitions to wrecked Silo Access
.if RANDOMIZER
.org MainDeckDoors + 86h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch | DoorType_ShowsLocationName
.endarea
.endif
