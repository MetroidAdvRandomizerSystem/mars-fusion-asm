; Sector 2 - Cathedral
; make door to reo room functional
; remove hatch to ripper roost
; remove hatch to save station access
; move zoro out of the way of ripper roost
; move cocoon and kihunter spritesets to intact room state
; limit zoro pathing to prevent climbing the room early with ice beam
; move a stop-enemy block one tile lower to avoid glitchy sprite behavior
.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Bg1)
.area 4E1h
.incbin "data/rooms/S2-0D-BG1.rlebg"
.endarea

.autoregion DataFreeSpace, DataFreeSpaceEnd
@S2_CentralShaft_Clipdata:
.incbin "data/rooms/S2-0D-Clip.rlebg"
.endautoregion

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Bg1)
.area 4F4h
.incbin "data/rooms/S2-2E-BG1.rlebg"
.endarea

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Clipdata)
.area 1FDh
.incbin "data/rooms/S2-2E-Clip.rlebg"
.endarea

.autoregion
@S2_CentralShaft_KihunterSpriteset:
    .db     3Eh, 00h
    .db     5Eh, 01h
    .db     36h, 08h
    .db     8Ah, 02h
    .db     5Bh, 03h
    .db     5Ch, 03h
    .db     89h, 06h
    .db     0, 0
.endautoregion

.org SpritesetList + 1Eh * 04h
.area 04h
    .dw     @S2_CentralShaft_KihunterSpriteset
.endarea

.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset0) + (1 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset0) + (3 * Spriteset_SpriteSize)
.area 03h
    .db     2Bh, 03h, 24h
.endarea


.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset0) + (1 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1) + (2 * Spriteset_SpriteSize)
.area 03h
    .db     17h, 05h, 24h
.endarea

.org readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1) + (6 * Spriteset_SpriteSize)
.area 03h
    .db     2Ch, 03h, 17h
.endarea

.org Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S2_CentralShaft_Clipdata
.endarea

.org Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     Event_ReactorOutage
    .skip 2
    .dw     readptr(Sector2Levels + 2Eh * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

.org Sector2Doors + 1Bh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 1Fh * DoorEntry_Size + DoorEntry_SourceRoom
.area 1
    .db     0Dh
.endarea

.org Sector2Doors + 23h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 2Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 5Fh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 6Eh * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea

.org Sector2Doors + 71h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceY - DoorEntry_Type + 1
    .db     DoorType_OpenHatch
    .skip   DoorEntry_SourceRoom - DoorEntry_Type - 1
    .db     0Dh
    .skip   DoorEntry_ExitDistanceX - DoorEntry_SourceRoom - 1
    .db     18h
    .db     00h
.endarea

.defineregion readptr(Sector2Levels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata), 1F0h
