; Always show extra info (sector completion, in-game time) on map screen.
; Normally requires a save file which has previously completed the game.

; In MapScreenDrawSpecialOAM, replace the loading of the
; completedGame flag with it being true.
.org 08077F60h
    mov     r0, #1
