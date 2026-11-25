; Permanently hides sector completion info from the map screen to prevent any
; spoilers/wrong info from counting tanks.

; In PauseScreenDrawIGTAndTanks, after setting up registers, jump
; to after the if/else block
.org 08075E70h
.region 44h
    b       08075EB4h
.endregion

; In PauseScreenDrawIGTAndTanks, before the if/else block for current etanks, jump
; to the end of the function
.org 08075F40h
.area 10h, 0
    b       080761B4h
.endarea
    ; Preserve existing pool
    .skip 18h
; Mark the rest of code as freespace
.region 24Ch, 0
.endregion


; In MapScreenDrawSpecialOAM, nop out the MapScreenCountTanks function call.
.org 08077FA0h
    nop :: nop

; In MapScreenDrawSpecialOAM, where its going through the loop of
; sPauseScreenIgtAndTanksOamInfo, make it stop after going through
; IGT, and jump backwards to the case where it sets PAUSE_SCREEN_DATA.unk_274 and returns
.org 0807801Ah
.region 0C4h
    b       08077F76h
.endregion
