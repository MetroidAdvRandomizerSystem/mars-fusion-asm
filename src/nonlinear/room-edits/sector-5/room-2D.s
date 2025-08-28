; Sector 5 - Flooded Tower

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector5Levels + 2Dh * LevelMeta_Size + LevelMeta_Clipdata)
.area 0CBh
.incbin "data/rooms/S5-2D-Clip.rlebg"
.endarea

.org Sector5Doors + 44h * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea