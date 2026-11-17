; Sector 4 - Pump Control Save Room

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.dataautoregion
@S4_16_Clipdata:
.incbin "data/rooms/S4-16-Clip.rlebg"
.endautoregion

.org Sector4Levels + 16h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S4_16_Clipdata
.endarea

.org Sector4Doors + 45h * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     11h
    .db     11h
.endarea