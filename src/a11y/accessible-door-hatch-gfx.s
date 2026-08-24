; Changes the graphics of the door hatches in order to
; make it possible to differentiate them without color.
; Also adds the new door symbols to the text graphics

.org 083F28C8h  ; Address of common background graphics
.area 1000h
    .incbin "data/accessible-doors.gfx"
.endarea

.org TEXT_CHARACTER_GFX + GFX_ROW * 8
.area GFX_ROW*2
    .incbin "data/door-symbols-font.gfx"
.endarea
