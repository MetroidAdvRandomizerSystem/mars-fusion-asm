.autoregion
    .align 4
KanjiMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B2FACh   ; security level 1
    .dw     086B2FF4h   ; security level 2
    .dw     086B303Eh   ; security level 3
    .dw     086B3088h   ; security level 4
    .dw     086B30D0h   ; main missiles
    .dw     086B3110h   ; super missiles
    .dw     086B3158h   ; bombs
    .dw     086B319Ch   ; main power bombs
    .dw     086B31F0h   ; ice missiles
    .dw     086B3232h   ; diffusion missiles
    .dw     086B3290h   ; morph ball
    .dw     086B32CEh   ; hi-jump
    .dw     086B331Eh   ; screw attack
    .dw     086B336Ch   ; space jump
    .dw     086B33BCh   ; speed booster
    .dw     086B340Ah   ; varia suit
    .dw     086B345Eh   ; gravity suit
    .dw     086B34A4h   ; charge beam
    .dw     086B34FEh   ; wide beam
    .dw     086B353Ah   ; wave beam
    .dw     086B357Ch   ; plasma beam
    .dw     086B35BAh   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B3962h   ; is your objective clear?
    .dw     086B3988h   ; confirm mission objective?
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
    .dw     086B3A2Ch   ; sleep mode line 3
    .dw     086B3602h   ; atmospheric stabilizer 1
    .dw     086B3630h   ; atmospheric stabilizer 2
    .dw     086B365Eh   ; atmospheric stabilizer 3
    .dw     086B368Ch   ; atmospheric stabilizer 4
    .dw     086B36BAh   ; atmospheric stabilizer 5
    .dw     086B36E0h   ; water level lowered
    .dw     086B36FAh   ; boiler cooling
    .dw     086B370Eh   ; animals freed
    .dw     086B372Eh   ; auxiliary power
    .dw     086B374Ah   ; restricted sector detaching
    .dw     @Message_EscapeSequenceStart
    .dw     086B37B4h   ; save prompt
    .dw     086B37DAh   ; save complete
    .dw     086B37ECh   ; adam uplink prompt
    .dw     086B3818h   ; ammunition resupply
    .dw     086B3830h   ; energy recharge
    .dw     086B3848h   ; ammo and energy recharge
    .dw     086B386Ch   ; energy tank
    .dw     086B389Eh   ; missile tank
    .dw     086B38DCh   ; power bomb tank
    .dw     086B391Eh   ; sprite location abnormal
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
