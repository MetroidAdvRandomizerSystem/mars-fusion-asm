; Sector 5 - Security Shaft East
; TODO: Mark room 15 as free space since it is unused in RDV

; repair the door to kago blockade
.defineregion readptr(Sector5Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata), 110h

.org readptr(Sector5Levels + 16h * LevelMeta_Size + LevelMeta_Bg1)
.area 2EBh
.incbin "data/rooms/S5-16-BG1.rlebg"
.endarea

.autoregion DataFreeSpace
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
