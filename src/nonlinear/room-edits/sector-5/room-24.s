; Sector 5 - Crow's Nest
; repair the door to arctic containment into a lv3 security door
.defineregion readptr(Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Clipdata), 0F0h

.org readptr(Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Bg1)
.area 263h
.incbin "data/rooms/S5-24-BG1.rlebg"
.endarea

.dataautoregion
@S5_CrowsNest_Clipdata:
.incbin "data/rooms/S5-24-Clip.rlebg"
.endautoregion

.org Sector5Levels + 24h * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S5_CrowsNest_Clipdata
.endarea

.org Sector5Doors + 57h * DoorEntry_Size + DoorEntry_Type
.area DoorEntry_ExitDistanceX - DoorEntry_Type + 1
    .db     DoorType_LockableHatch
    .skip DoorEntry_ExitDistanceX - DoorEntry_Type - 1
    .db     20h
.endarea
