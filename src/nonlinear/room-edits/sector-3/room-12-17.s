; Sector 3 - BOX Arena
; repair door to data room
.defineregion readptr(Sector3Levels + 17h * LevelMeta_Size + LevelMeta_Clipdata), 08Fh

.org readptr(Sector3Levels + 17h * LevelMeta_Size + LevelMeta_Bg1)
.area 256h
.incbin "data/rooms/S3-17-BG1.rlebg"
.endarea

.autoregion DataFreeSpace
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
