.autoregion
    .align 4
SpanishMessages:
    .dw     @Message_SecurityLevel0
    .dw     086BA2D4h   ; security level 1
    .dw     086BA33Ah   ; security level 2
    .dw     086BA3A0h   ; security level 3
    .dw     086BA40Ch   ; security level 4
    .dw     086BA470h   ; main missiles
    .dw     086BA4BCh   ; super missiles
    .dw     086BA512h   ; bombs
    .dw     086BA578h   ; main power bombs
    .dw     086BA5EEh   ; ice missiles
    .dw     086BA668h   ; diffusion missiles
    .dw     086BA6E6h   ; morph ball
    .dw     086BA750h   ; hi-jump
    .dw     086BA7BAh   ; screw attack
    .dw     086BA82Ah   ; space jump
    .dw     086BA8A2h   ; speed booster
    .dw     086BA90Ah   ; varia suit
    .dw     086BA982h   ; gravity suit
    .dw     086BAA00h   ; charge beam
    .dw     086BAA72h   ; wide beam
    .dw     086BAADCh   ; wave beam
    .dw     086BAB50h   ; plasma beam
    .dw     086BABCAh   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086BB3F4h   ; is your objective clear?
    .dw     086BB42Eh   ; confirm mission objective?
.if RANDOMIZER
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
.else
    .dw     086BB47Eh   ; sleep mode line 1
    .dw     086BB4ECh   ; sleep mode line 2
.endif
    .dw     086BB53Ah   ; sleep mode line 3
    .dw     086BAC3Eh   ; atmospheric stabilizer 1
    .dw     086BACA8h   ; atmospheric stabilizer 2
    .dw     086BAD0Eh   ; atmospheric stabilizer 3
    .dw     086BAD72h   ; atmospheric stabilizer 4
    .dw     086BADD4h   ; atmospheric stabilizer 5
    .dw     086BAE4Ah   ; water level lowered
    .dw     086BAE90h   ; boiler cooling
    .dw     086BAEDAh   ; animals freed
    .dw     086BAF34h   ; auxiliary power
    .dw     086BAF76h   ; restricted sector detaching
.if RANDOMIZER
    .dw     @Message_EscapeSequenceStart
.else
    .dw     086BAFEEh   ; escape sequence starting
.endif
    .dw     086BB04Eh   ; save prompt
    .dw     086BB086h   ; save complete
    .dw     086BB0B2h   ; adam uplink prompt
    .dw     086BB0EEh   ; ammunition resupply
    .dw     086BB148h   ; energy recharge
    .dw     086BB1A8h   ; ammo and energy recharge
    .dw     086BB206h   ; energy tank
    .dw     086BB282h   ; missile tank
    .dw     086BB300h   ; power bomb tank
    .dw     086BB378h   ; sprite location abnormal
    .dw     @Message_IceTrap
    .dw     @Message_Nothing
    .dw     @Message_InfantMetroidsPlaceholder ; This is the AutoMetroidHandler ID, does not have its own message text
    .fill   4 * CustomMessages_Maximum ; Reserve space for custom messages
.endautoregion

.autoregion
    .align 2
@Message_SecurityLevel0:
    .stringn 21, "[INDENT]Security level 0 unlocked.\n"
    .string  22, "[INDENT]Gray hatches now active."
.endautoregion

.autoregion
    .align 2
@Message_IceTrap:
    .string 56, "[INDENT]You are a FOOL!\n"
.endautoregion

.autoregion
    .align 2
@Message_Nothing:
    .string 50, "[INDENT]Nothing acquired.\n"
.endautoregion

.autoregion
    .align 2
@Message_InfantMetroidsPlaceholder:
    .string "Metroid Placeholder Message."
.endautoregion

.autoregion
    .align 2
@Message_InfantMetroidsRemain:
    .stringn 24, "[INDENT]Found an Infant Metroid.\n"
    .string  62, "[INDENT][METROIDS] more remain."
.endautoregion

.autoregion
    .align 2
@Message_InfantMetroidsNeeded:
    .stringn 24, "[INDENT]Found an Infant Metroid.\n"
    .string  61, "[INDENT][METROIDS] more needed."
.endautoregion

.autoregion
    .align 2
@Message_SecondLastInfantMetroid:
    .stringn 24, "[INDENT]Found an Infant Metroid.\n"
    .string  59, "[INDENT]1 more remains."
.endautoregion

.autoregion
    .align 2
@Message_SufficientInfantMetroids:
    .stringn 4,  "[INDENT]Enough Infant Metroids found.\n"
    .string  14, "[INDENT]Return to Operations Deck."
.endautoregion

.autoregion
    .align 2
@Message_LastInfantMetroid:
    .stringn 3,  "[INDENT]Found the last Infant Metroid.\n"
    .string  14, "[INDENT]Return to Operations Deck."
.endautoregion

.if RANDOMIZER
.defineregion 086B5A18h, 60h
.defineregion 086B5A78h, 72h

.autoregion
    .align 2
@Message_WarpToStartLine1:
    .stringn 58, "[INDENT]Warp to start?\n"
    .string  7, "[INDENT]You will return to your start"
.endautoregion

.autoregion
    .align 2
@Message_WarpToStartLine2:
    .stringn 20, "[INDENT]location, but your recent\n"
    .string  15, "[INDENT]progress will not be saved."
.endautoregion

.autoregion
    .align 2
@Message_EscapeSequenceStart:
    .stringn 19, "[INDENT]Orbit change implemented.\n"
    .string  41, "[INDENT]Escape the station."
.endautoregion
.endif
