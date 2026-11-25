; Skips the intro cutscene, starting from the first Adam dialogue instead.

; In NewFileIntroSubroutine, if the intro hasn't played yet, change the
; gSubGameMode to the end (12) instead of 1.
.org 0808777Eh
    mov     r0, #12

; Unused functions after this patch:

; Intro state 2
.defineregion 0808A044h, 0ACh   ; NewFileIntroSr388Preview
.defineregion 08089AB4h, 248h   ; NewFileIntroSr388PreviewInit
.defineregion 08089CFCh, 348h   ; NewFileIntroSr388PreviewProcess

; Intro state 3
.defineregion 0808ABD0h, 98h    ; NewFileIntroInSr388
.defineregion 0808A638h, 254h   ; NewFileIntroInSr388Init
.defineregion 0808A88Ch, 344h   ; NewFileIntroInSr388Process

; Intro state 4
.defineregion 08087DF0h, 0A0h   ; NewFileIntroSamusShipFlying
.defineregion 08087A04h, 264h   ; NewFileIntroSamusShipFlyingInit
.defineregion 08087C68h, 188h   ; NewFileIntroSamusShipFlyingProcess

; Intro state 5
.defineregion 080881A4h, 9Ch    ; NewFileIntroSamusFainting
.defineregion 08087E90h, 1D8h   ; NewFileIntroSamusFaintingInit
.defineregion 08088068h, 13Ch   ; NewFileIntroSamusFaintingProcess

; Intro state 6
.defineregion 08088CC8h, 9Ch    ; NewFileIntroSamusDrifting
.defineregion 08088240h, 26Ch   ; NewFileIntroSamusDriftingInit
.defineregion 080889B0h, 318h   ; NewFileIntroSamusDriftingProcess

; Intro state 7
.defineregion 0808E6D4h, 0A8h   ; NewFileIntroSamusFound
.defineregion 0808DF30h, 210h   ; NewFileIntroSamusFoundInit
.defineregion 0808E140h, 594h   ; NewFileIntroSamusFoundProcess

; Intro state 8
.defineregion 0808CF80h, 0DCh   ; NewFileIntroSamusGettingCured
.defineregion 0808C670h, 204h   ; NewFileIntroSamusGettingCuredInit
.defineregion 0808C874h, 158h   ; NewFileIntroSamusGettingCuredOperationProcess
.defineregion 0808CD0Ch, 274h   ; NewFileIntroSamusGettingCuredNervousSystemProcess


; What about Intro State 9 to 11?


; Unused graphics after this patch:
.defineregion 085980B0h, 08598898h - 085980B0h  ; sIntroSamusShipPal to sIntroSamusShipFlyingTextTilemap (excluding)
.defineregion 08598AACh, 085FFF08h - 08598AACh  ; sIntroSamusCloseupGrayscalePal to sIntroLandingOnBslSpaceTilemap (excluding)
