.autoregion
    .align 4
ItalianMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B8C5Eh   ; security level 1
    .dw     086B8CCEh   ; security level 2
    .dw     086B8D42h   ; security level 3
    .dw     086B8DB8h   ; security level 4
    .dw     086B8E2Ch   ; main missiles
    .dw     086B8E9Ah   ; super missiles
    .dw     086B8F14h   ; bombs
    .dw     086B8F78h   ; main power bombs
    .dw     086B8FEEh   ; ice missiles
    .dw     086B905Ah   ; diffusion missiles
    .dw     086B90D8h   ; morph ball
    .dw     086B9140h   ; hi-jump
    .dw     086B919Ah   ; screw attack
    .dw     086B920Ch   ; space jump
    .dw     086B9274h   ; speed booster
    .dw     086B92E0h   ; varia suit
    .dw     086B9342h   ; gravity suit
    .dw     086B93B0h   ; charge beam
    .dw     086B9428h   ; wide beam
    .dw     086B949Ah   ; wave beam
    .dw     086B9508h   ; plasma beam
    .dw     086B9578h   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B9D5Eh   ; is your objective clear?
    .dw     086B9DA6h   ; confirm mission objective?
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
    .dw     086B9EDAh   ; sleep mode line 3
    .dw     086B95E0h   ; atmospheric stabilizer 1
    .dw     086B964Ch   ; atmospheric stabilizer 2
    .dw     086B96B0h   ; atmospheric stabilizer 3
    .dw     086B9714h   ; atmospheric stabilizer 4
    .dw     086B9784h   ; atmospheric stabilizer 5
    .dw     086B980Ah   ; water level lowered
    .dw     086B9842h   ; boiler cooling
    .dw     086B9882h   ; animals freed
    .dw     086B98D2h   ; auxiliary power
    .dw     086B9918h   ; restricted sector detaching
    .dw     @Message_EscapeSequenceStart
    .dw     086B99DEh   ; save prompt
    .dw     086B9A1Ch   ; save complete
    .dw     086B9A52h   ; adam uplink prompt
    .dw     086B9A90h   ; ammunition resupply
    .dw     086B9AD8h   ; energy recharge
    .dw     086B9B2Ah   ; ammo and energy recharge
    .dw     086B9B82h   ; energy tank
    .dw     086B9BFCh   ; missile tank
    .dw     086B9C72h   ; power bomb tank
    .dw     086B9CECh   ; sprite location abnormal
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
