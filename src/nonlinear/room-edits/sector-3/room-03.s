; Sector 3 - Security Access
; remove sidehoppers on speedbooster runway to prevent near softlock with neither charge nor missiles
; move sidehoppers below runway to prevent them from clipping into the wall
.org readptr(Sector3Levels + 03h * LevelMeta_Size + LevelMeta_Spriteset1)
.area 27h
    .db     04h, 24h, 0A4h
    .db     05h, 1Fh, 0A4h
    .db     05h, 29h, 0A4h
    .db     06h, 1Dh, 02h
    .db     14h, 29h, 23h
    .db     14h, 2Ch, 23h
    .db     0FFh, 0FFh, 0FFh
.endarea
