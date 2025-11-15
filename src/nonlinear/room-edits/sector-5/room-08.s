; Sector 5 - Zeela Checkpoint
; Remove power bomb geron spriteset
.defineregion readptr(Sector5Levels + 08h * LevelMeta_Size + LevelMeta_Spriteset2), 15h
.org Sector5Levels + 08h * LevelMeta_Size + LevelMeta_Spriteset2Event
.area LevelMeta_Spriteset2Id - LevelMeta_Spriteset1Id
    .db     0
    .skip   2
    .dw     NullSpriteset
    .db     0
.endarea
