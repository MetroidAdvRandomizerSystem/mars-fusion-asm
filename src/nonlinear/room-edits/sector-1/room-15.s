; Sector 1 - Tourian Eastern Hub
; Change space around Animorphs to prevent issues in Entrance Rando.
.org readptr(Sector1Levels + 15h * LevelMeta_Size + LevelMeta_Clipdata)
.area 121h
.incbin "data/rooms/S1-15-Clip.rlebg"
.endarea

.org readptr(Sector1Levels + 15h * LevelMeta_Size + LevelMeta_Bg1)
.area 2DEh
.incbin "data/rooms/S1-15-BG1.rlebg"
.endarea