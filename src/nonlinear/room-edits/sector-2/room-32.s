; Sector 2 - Ripper Tower
; move bottom crumble block up one to prevent softlocks without bombs

.org readptr(Sector2Levels + 32h * LevelMeta_Size + LevelMeta_Clipdata)
.area 10Ah
.incbin "data/rooms/S2-32-Clip.rlebg"
.endarea
