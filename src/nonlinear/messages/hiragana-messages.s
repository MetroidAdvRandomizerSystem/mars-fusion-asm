.autoregion
    .align 4
HiraganaMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B3C48h   ; security level 1
    .dw     086B3C90h   ; security level 2
    .dw     086B3CDAh   ; security level 3
    .dw     086B3D24h   ; security level 4
    .dw     086B3D6Ch   ; main missiles
    .dw     086B3DACh   ; super missiles
    .dw     086B3DF4h   ; bombs
    .dw     086B3E38h   ; main power bombs
    .dw     086B3E8Eh   ; ice missiles
    .dw     086B3ED0h   ; diffusion missiles
    .dw     086B3F2Eh   ; morph ball
    .dw     086B3F6Ch   ; hi-jump
    .dw     086B3FBCh   ; screw attack
    .dw     086B400Ah   ; space jump
    .dw     086B405Ah   ; speed booster
    .dw     086B40A8h   ; varia suit
    .dw     086B40FCh   ; gravity suit
    .dw     086B4142h   ; charge beam
    .dw     086B419Ch   ; wide beam
    .dw     086B41D8h   ; wave beam
    .dw     086B421Ah   ; plasma beam
    .dw     086B4258h   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B45FCh   ; is your objective clear?
    .dw     086B4622h   ; confirm mission objective?
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
    .dw     086B46C6h   ; sleep mode line 3
    .dw     086B42A0h   ; atmospheric stabilizer 1
    .dw     086B42CEh   ; atmospheric stabilizer 2
    .dw     086B42FCh   ; atmospheric stabilizer 3
    .dw     086B432Ah   ; atmospheric stabilizer 4
    .dw     086B4358h   ; atmospheric stabilizer 5
    .dw     086B437Eh   ; water level lowered
    .dw     086B4398h   ; boiler cooling
    .dw     086B43ACh   ; animals freed
    .dw     086B43CCh   ; auxiliary power
    .dw     086B43E8h   ; restricted sector detaching
    .dw     @Message_EscapeSequenceStart
    .dw     086B4454h   ; save prompt
    .dw     086B447Ah   ; save complete
    .dw     086B448Ch   ; adam uplink prompt
    .dw     086B44B8h   ; ammunition resupply
    .dw     086B44D0h   ; energy recharge
    .dw     086B44E8h   ; ammo and energy recharge
    .dw     086B450Ch   ; energy tank
    .dw     086B453Eh   ; missile tank
    .dw     086B457Ch   ; power bomb tank
    .dw     086B45B8h   ; sprite location abnormal
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
