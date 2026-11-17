; Sector 5 - Data Room
; TODO: Mark room 05 as free space since it is unused in RDV

; merge the intact and destroyed data rooms into a single room
; seal off the destroyed upper half of the data room from the intact lower half
.defineregion readptr(Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Clipdata), 84h

.org readptr(Sector5Levels + 10h * LevelMeta_Size + LevelMeta_Bg1)
.area 19Fh
.incbin "data/rooms/S5-10-BG1.rlebg"
.endarea

.dataautoregion
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
