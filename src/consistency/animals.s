; Allows Samus to be controlled during the animals event

; In MiscPadAfterInteraction, this section removes a conditional branch
; which prevents movement during the animals exiting the enclosure sequence and
; directly sets the pad to the inactive pose
.org 0803964Eh
.area 08039656h - 0803964Eh, 00
    b   08039656h ; skip to end of area
.endarea

; In DachoraWaitingForBaby, this section removes setting Samus' pose to "Unlocking the habitations Deck"
; (0x3Bh) which prevents movement during the animals run-away sequence.
.org 0804D6B0h
.area 0804D6C2h - 0804D6B0h, 00
    b   0804D6C2h ; skip to end of area
.endarea

; In BabyDachoraRunning, this section removes incrementing Samus' current animation frame while the
; Baby Dachora is running to the right.
.org 0804D9C2h
.area 0804D9CCh - 0804D9C2h, 00
    b   0804D9CCh ; skip to end of area
.endarea
