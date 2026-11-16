; Sector 3 - BOX Arena Access
; repair door to bob's room
.defineregion readptr(Sector3Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata), 0A5h

.org readptr(Sector3Levels + 16h * LevelMeta_Size + LevelMeta_Bg1)
.area 300h
.incbin "data/rooms/S3-16-BG1.rlebg"
.endarea

.autoregion DataFreeSpace
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
