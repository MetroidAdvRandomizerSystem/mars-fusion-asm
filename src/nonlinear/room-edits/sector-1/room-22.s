; Sector 1 - Twin Junctions Save Room
; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector1Levels + 22h * LevelMeta_Size + LevelMeta_Clipdata)
.area 041h
.incbin "data/rooms/S1-22-Clip.rlebg"
.endarea

.org Sector1Doors + 6Ch * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     11h
    .db     11h
.endarea