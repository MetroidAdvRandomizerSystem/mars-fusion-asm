; Sector 6 - Geron's Crossing


; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector6Levels + 03h * LevelMeta_Size + LevelMeta_Clipdata)
.area 0A6h
.incbin "data/rooms/S6-03-Clip.rlebg"
.endarea

.org Sector6Doors + 32h * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea

.org Sector6Doors + 4Bh * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     20h
    .db     20h
.endarea