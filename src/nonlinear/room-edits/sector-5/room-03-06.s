; Sector 5 - Nightmare Training Grounds
; TODO: Remove room 06 as it is unused in RDV
; restructure the room to have a speedbooster runway across the top
; add speedbooster blocks above the power bomb blocks
.defineregion readptr(Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Bg1), 486h
.defineregion readptr(Sector5Levels + 03h * LevelMeta_Size + LevelMeta_Clipdata), 212h

.dataautoregion
@S5_NightmareTrainingGrounds_Bg1:
.incbin "data/rooms/S5-03-BG1.rlebg"
.endautoregion

.dataautoregion
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
