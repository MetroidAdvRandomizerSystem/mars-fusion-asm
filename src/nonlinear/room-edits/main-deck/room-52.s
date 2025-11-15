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

.org MainDeckDoors + 0C2h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea
