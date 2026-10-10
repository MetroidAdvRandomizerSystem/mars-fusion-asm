; Sector 5 - Security Shaft West
; Make the Spriteset layer with the strong Zeela the default.
.org Sector5Levels + 09h * LevelMeta_Size + LevelMeta_Spriteset0
.area 13
    .dw     readptr(Sector5Levels + 09h * LevelMeta_Size + LevelMeta_Spriteset1)
    .skip   1
    .db     0
    .skip   2
    .dw     NullSpriteset
    .db     0
.endarea

