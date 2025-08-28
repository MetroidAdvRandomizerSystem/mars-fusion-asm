; Sector 1 - Charge Core Upper Access
; fix screen scroll when entering room from Charge Core Arena
.defineregion readptr(Sector1Scrolls + 01h * 4), ScrollList_HeaderSize + Scroll_Size * 1

; Move Doors back by one tile to prevent weird behaviour in Entrance Rando.
.org readptr(Sector1Levels + 0Ah * LevelMeta_Size + LevelMeta_Clipdata)
.area 06Ch
.incbin "data/rooms/S1-0A-Clip.rlebg"
.endarea

.org Sector1Doors + 05Ch * DoorEntry_Size + DoorEntry_XStart
.area 2
    .db     01h
    .db     01h
.endarea