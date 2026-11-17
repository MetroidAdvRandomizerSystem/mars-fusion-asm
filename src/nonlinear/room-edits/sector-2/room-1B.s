; Sector 2 - Dessgeega Dorm
; add room state with zoros
.dataautoregion
@S2_EntranceHubUnderside_Spriteset0:
    .db     03h, 09h, 24h
    .db     0Fh, 0Fh, 24h
    .db     10h, 0Dh, 02h
    .db     12h, 0Eh, 26h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset0
.area LevelMeta_MapX - LevelMeta_Spriteset0
    .dw     @S2_EntranceHubUnderside_Spriteset0
    .db     12h
    .db     19h
    .skip 2
    .dw     readptr(Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     47h
    .skip 2
    .dw     readptr(Sector2Levels + 1Bh * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea
