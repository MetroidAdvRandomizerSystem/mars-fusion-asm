; Sector 4 - Pump Control Save Room

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector4Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata)
.area 03Fh
.incbin "data/rooms/S4-16-Clip.rlebg"
.endarea

.org Sector4Doors + 45h * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     11h
    .db     11h
.endarea