; Prevents Samus from bonking her head against breakable blocks by
; spin jumping into them from directly below.

; SamusOAM Data for sSamusAnim_StartingSpinJump_Right
.org 082C4934h
    ; Reduce spinjump startup by 1 frame
    .db     1
