.autoregion
    .align 4
EnglishMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B489Ah   ; security level 1
    .dw     086B4906h   ; security level 2
    .dw     086B4974h   ; security level 3
    .dw     086B49E4h   ; security level 4
    .dw     086B4A4Eh   ; main missiles
    .dw     086B4AB0h   ; super missiles
    .dw     086B4B1Eh   ; bombs
    .dw     086B4B8Ch   ; main power bombs
    .dw     086B4C08h   ; ice missiles
    .dw     086B4C7Ch   ; diffusion missiles
    .dw     086B4Cf6h   ; morph ball
    .dw     086B4D68h   ; hi-jump
    .dw     086B4DC0h   ; screw attack
    .dw     086B4E34h   ; space jump
    .dw     086B4EB2h   ; speed booster
    .dw     086B4F2Ch   ; varia suit
    .dw     086B4FA4h   ; gravity suit
    .dw     086B5010h   ; charge beam
    .dw     086B508Ah   ; wide beam
    .dw     086B50FCh   ; wave beam
    .dw     086B5170h   ; plasma beam
    .dw     086B51E6h   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B5984h   ; is your objective clear?
    .dw     086B59CCh   ; confirm mission objective?
.if RANDOMIZER
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
.else
    .dw     086B5A18h   ; sleep mode line 1
    .dw     086B5A78h   ; sleep mode line 2
.endif
    .dw     086B5AEAh   ; sleep mode line 3
    .dw     086B5256h   ; atmospheric stabilizer 1
    .dw     086B52D8h   ; atmospheric stabilizer 2
    .dw     086B5352h   ; atmospheric stabilizer 3
    .dw     086B53D4h   ; atmospheric stabilizer 4
    .dw     086B5454h   ; atmospheric stabilizer 5
    .dw     086B54C4h   ; water level lowered
    .dw     086B54F4h   ; boiler cooling
    .dw     086B552Eh   ; animals freed
    .dw     086B5570h   ; auxiliary power
    .dw     086B55A8h   ; restricted sector detaching
.if RANDOMIZER
    .dw     @Message_EscapeSequenceStart
.else
    .dw     086B5612h   ; escape sequence starting
.endif
    .dw     086B5674h   ; save prompt
    .dw     086B56A0h   ; save complete
    .dw     086B56C4h   ; adam uplink prompt
    .dw     086B56FAh   ; ammunition resupply
    .dw     086B5742h   ; energy recharge
    .dw     086B5784h   ; ammo and energy recharge
    .dw     086B57CEh   ; energy tank
    .dw     086B5834h   ; missile tank
    .dw     086B589Eh   ; power bomb tank
    .dw     086B5912h   ; sprite location abnormal
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