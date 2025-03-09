; Map downloads reveal full minimap layout.

.org 08075804h
.area 08h
    tst     r0, r1
    beq     0807580Eh
    lsl     r0, r1, #20h - 0Ch
    lsr     r0, #20h - 0Ch
.endarea
