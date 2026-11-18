; Main Deck - Operations Deck
; change operations room lv4 security door to lv0 security
; allow missile hatch to be destroyed from both sides
; adds stop-enemy clipdata to the tunnel to prevent the SA-X Monster form from jumping out-of-bound

.org readptr(MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Bg1)
.area 2DBh
.incbin "data/rooms/S0-0D-BG1.rlebg"
.endarea

.org MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata
.area 04h
    .dw     @S0_OperationsDeck_Clipdata
.endarea

.dataautoregion
    .align 4
@S0_OperationsDeck_Clipdata:
    .incbin "data/rooms/S0-0D-Clip.rlebg"
.endautoregion

.defineregion readptr(MainDeckLevels + 0Dh * LevelMeta_Size + LevelMeta_Clipdata), 0C3h

; Extends the hitbox of the shootable missile hatch to be able to be hit from both sides.
.org 0804193Eh ; Editing code in MissileHatchInit
.area 02h
    mov     r0, #60h
.endarea
