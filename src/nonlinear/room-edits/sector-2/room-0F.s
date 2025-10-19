; Cathedral Save access

; Turn door that goes to Cathedral from L-0 into an Open Hatch.

.org readptr(Sector2Levels + 0Fh * LevelMeta_Size + LevelMeta_Bg1)
.area 170h
.incbin "data/rooms/S2-0F-BG1.rlebg"
.endarea

.org readptr(Sector2Levels + 0Fh * LevelMeta_Size + LevelMeta_Clipdata)
.area 6Dh
.incbin "data/rooms/S2-0F-Clip.rlebg"
.endarea