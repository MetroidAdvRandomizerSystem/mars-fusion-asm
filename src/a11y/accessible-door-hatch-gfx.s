; Changes the graphics of the door hatches in order to
; make it possible to differentiate them without color.
; Also adds the new door symbols to the text graphics

.org 083F28C8h  ; Address of common background graphics
.area 1000h
    .incbin "data/accessible-doors.gfx"
.endarea

.org 08684FACh  ; Base address of text starts at 0x80682FAC, this here is an empty unused row
.area 800h
    .incbin "data/door-symbols-font.gfx"
.endarea
