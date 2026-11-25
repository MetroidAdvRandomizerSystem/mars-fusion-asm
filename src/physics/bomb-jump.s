; Removes the check for invincibility frames when bomb jumping.
; This fixes an inconsistent behavior when trying to bomb jump in electrified
; water where when samus takes damage, if the invincibility frames have not
; expired when this code is run then samus will not be propelled by the bomb.

; Modifying code at start of ProjectileCheckSamusBombBounce after setting up registers
.org 080856AAh
.area 080856B2h - 080856AAh, 0
    b       080856B2h   ; Jumps to the checkdamagepose part of the condition
.endarea
