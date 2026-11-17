; Sector 5 - Arctic Containment
; change the lv4 security door to crow's nest to a functional lv3 security door
.defineregion readptr(Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Clipdata), 1AAh

.org readptr(Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Bg1)
.area 652h
.incbin "data/rooms/S5-07-BG1.rlebg"
.endarea

.dataautoregion
@S5_ArcticContainment_Clipdata:
.incbin "data/rooms/S5-07-Clip.rlebg"
.endautoregion

.org Sector5Levels + 07h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_ArcticContainment_Clipdata
.endarea

.org Sector5Doors + 15h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 24h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 35h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceX - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .db     07h
    .skip DoorEntry_ExitDistanceX - DoorEntry_SourceRoom - 1
    .db     -20h
.endarea

.org Sector5Doors + 38h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_OpenHatch
.endarea

.org Sector5Doors + 55h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 64h * DoorEntry_Size + DoorEntry_Type
.area 1
    .db     DoorType_LockableHatch
.endarea

.org Sector5Doors + 1Bh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Ch * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Dh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 1Fh * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 39h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh

.org Sector5Doors + 46h * DoorEntry_Size
.fill DoorEntry_Size, 0FFh
