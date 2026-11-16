; Sector 2 - Cathedral Cooridor
; add connection to Shadow Moses Island under hidden bomb blocks
; add cocoon and kihunter spritesets to intact room state
.autoregion DataFreeSpace
@S2_Dessgeega_Dormitory_Bg1:
.incbin "data/rooms/S2-0E-BG1.rlebg"
.endautoregion

.autoregion DataFreeSpace
@S2_Dessgeega_Dormitory_Clipdata:
.incbin "data/rooms/S2-0E-Clip.rlebg"
.endautoregion

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Bg1
.area 04h
    .dw     @S2_Dessgeega_Dormitory_Bg1
.endarea

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S2_Dessgeega_Dormitory_Clipdata
.endarea

.org Sector2Levels + 0Eh * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     readptr(Sector2Levels + 2Ch * LevelMeta_Size + LevelMeta_Spriteset0)
    .db     13h
    .db     Event_ReactorOutage
    .skip 2
    .dw     readptr(Sector2Levels + 2Ch * LevelMeta_Size + LevelMeta_Spriteset1)
    .db     1Eh
.endarea

.org Sector2Doors + 2Ah * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector2Doors + 60h * DoorEntry_Size + DoorEntry_Destination
.area 1
    .db     67h
.endarea

.org Sector2Doors + 65h * DoorEntry_Size + DoorEntry_Type
.area 6
    .db     DoorType_NoHatch
    .db     0Eh
    .db     5, 6
    .db     0Ch, 0Dh
.endarea

.org Sector2Doors + 67h * DoorEntry_Size + DoorEntry_Destination
.area 1
    .db     60h
.endarea
