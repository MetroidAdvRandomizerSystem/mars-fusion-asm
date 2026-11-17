; Sector 4 - Waterway
; add flooded room state
.dataautoregion
@S4_Waterway_Spriteset0:
    .db     03h, 09h, 17h
    .db     03h, 0Bh, 17h
    .db     03h, 10h, 17h
    .db     03h, 13h, 17h
    .db     03h, 17h, 17h
    .db     04h, 08h, 12h
    .db     04h, 18h, 12h
    .db     07h, 10h, 11h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector4Levels + 1Ch * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_Spriteset2Event - LevelMeta_Spriteset0
    .dw     @S4_Waterway_Spriteset0
    .db     0Eh
    .db     Event_WaterLevelLowered
    .skip 2
    .dw     readptr(Sector4Levels + 1Ch * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     1Dh
.endarea
