; Sector 6 - Warehouse

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector6Levels + 0Ah * LevelMeta_Size + LevelMeta_Clipdata)
.area 0C5h
.incbin "data/rooms/S6-0A-Clip.rlebg"
.endarea

.org Sector6Doors + 1Bh * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea