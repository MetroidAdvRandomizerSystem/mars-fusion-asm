; Data Courtyard

; Repair door to Courtyard access
.defineregion readptr(Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Clipdata), 0CEh

.org readptr(Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Bg1)
.area 40Bh
.incbin "data/rooms/S2-1F-BG1.rlebg"
.endarea

.dataautoregion
@S2_DataHub_Clipdata:
.incbin "data/rooms/S2-1F-Clip.rlebg"
.endautoregion

.org Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S2_DataHub_Clipdata
.endarea

.org Sector2Doors + 10h * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     1Fh
.endarea

.org Sector2Doors + 11h * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     1Fh
.endarea

.org Sector2Doors + 13h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 45h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

; Move Reo in the post-destruction room to be in the same position as pre-destruction
.org readptr(Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Spriteset0) + (1 * Spriteset_SpriteSize)
.area 3
    .db 08h, 1Bh, 22h
.endarea

.org readptr(Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Spriteset1) + (0 * Spriteset_SpriteSize)
.area 3
    .db 08h, 1Bh, 22h
.endarea

.org readptr(Sector2Levels + 1Fh * LevelMeta_Size + LevelMeta_Spriteset2) + (0 * Spriteset_SpriteSize)
.area 3
    .db 08h, 1Bh, 22h
.endarea
