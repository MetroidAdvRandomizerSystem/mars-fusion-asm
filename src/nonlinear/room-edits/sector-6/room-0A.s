; Sector 6 - Warehouse

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.dataautoregion
@S6_0A_Clipdata:
.incbin "data/rooms/S6-0A-Clip.rlebg"
.endautoregion

.org Sector6Levels + 0Ah * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S6_0A_Clipdata
.endarea

.org Sector6Doors + 1Bh * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea