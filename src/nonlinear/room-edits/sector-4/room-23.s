; Sector 4 - Powamp Shaft
; Remove the X that spawn the Powamps and make the Powamps start spawned.
.org readptr(Sector4Levels + 23h * LevelMeta_Size + LevelMeta_Spriteset0)
.area 15*3, 0 ; clear existing values.
    .db     11h, 0Ch, 27h
    .db     16h, 05h, 27h
    .db     17h, 08h, 27h
    .db     1Dh, 0Ch, 27h
    .db     1Fh, 08h, 27h
    .db     24h, 05h, 27h
    .db     26h, 09h, 27h
    .db     0FFh, 0FFh, 0FFh
.endarea