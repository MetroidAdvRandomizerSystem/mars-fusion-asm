; Sector 4 - Security Bypass
; Prevent several softlocks without bombs:
; Change level geometry on first two dead ends so that you can screw back out if you
; went in with screw+morph
; And change bomb block of last dead end to never respawn

.org readptr(Sector4Levels + 22h * LevelMeta_Size + LevelMeta_Bg1)
.area 57Ah
.incbin "data/rooms/S4-22-BG1.rlebg"
.endarea

.org readptr(Sector4Levels + 22h * LevelMeta_Size + LevelMeta_Clipdata)
.area 1B1h
.incbin "data/rooms/S4-22-Clip.rlebg"
.endarea
