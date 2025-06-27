.autoregion
    .align 4
FrenchMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B7516h   ; security level 1
    .dw     086B7592h   ; security level 2
    .dw     086B760Eh   ; security level 3
    .dw     086B768Ah   ; security level 4
    .dw     086B7706h   ; main missiles
    .dw     086B775Ch   ; super missiles
    .dw     086B77BEh   ; bombs
    .dw     086B782Ch   ; main power bombs
    .dw     086B78A6h   ; ice missiles
    .dw     086B790Eh   ; diffusion missiles
    .dw     086B797Eh   ; morph ball
    .dw     086B79FEh   ; hi-jump
    .dw     086B7A4Eh   ; screw attack
    .dw     086B7AC0h   ; space jump
    .dw     086B7B2Eh   ; speed booster
    .dw     086B7B9Eh   ; varia suit
    .dw     086B7C0Eh   ; gravity suit
    .dw     086B7C8Ch   ; charge beam
    .dw     086B76FEh   ; wide beam
    .dw     086B7D68h   ; wave beam
    .dw     086B7DD4h   ; plasma beam
    .dw     086B7E48h   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B86BAh   ; is your objective clear?
    .dw     086B8706h   ; confirm mission objective?
.if RANDOMIZER
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
.else
    .dw     086B8752h   ; sleep mode line 1
    .dw     086B87C0h   ; sleep mode line 2
.endif
    .dw     086B882Eh   ; sleep mode line 3
    .dw     086B7EC2h   ; atmospheric stabilizer 1
    .dw     086B7F32h   ; atmospheric stabilizer 2
    .dw     086B7FA0h   ; atmospheric stabilizer 3
    .dw     086B800Ch   ; atmospheric stabilizer 4
    .dw     086B8078h   ; atmospheric stabilizer 5
    .dw     086B80F2h   ; water level lowered
    .dw     086B8128h   ; boiler cooling
    .dw     086B816Ch   ; animals freed
    .dw     086B81C0h   ; auxiliary power
    .dw     086B8200h   ; restricted sector detaching
.if RANDOMIZER
    .dw     @Message_EscapeSequenceStart
.else
    .dw     086B826Ch   ; escape sequence starting
.endif
    .dw     086B82E8h   ; save prompt
    .dw     086B8332h   ; save complete
    .dw     086B8362h   ; adam uplink prompt
    .dw     086B839Ah   ; ammunition resupply
    .dw     086B8402h   ; energy recharge
    .dw     086B846Eh   ; ammo and energy recharge
    .dw     086B84E0h   ; energy tank
    .dw     086B8552h   ; missile tank
    .dw     086B85C8h   ; power bomb tank
    .dw     086B863Ch   ; sprite location abnormal
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