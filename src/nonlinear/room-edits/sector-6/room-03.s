; Sector 6 - Geron's Crossing


; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.dataautoregion
@S6_03_Clipdata:
.incbin "data/rooms/S6-03-Clip.rlebg"
.endautoregion

.org Sector6Levels + 03h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S6_03_Clipdata
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