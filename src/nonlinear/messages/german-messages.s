.autoregion
    .align 4
GermanMessages:
    .dw     @Message_SecurityLevel0
    .dw     086B5E68h   ; security level 1
    .dw     086B5EDAh   ; security level 2
    .dw     086B5F4Ch   ; security level 3
    .dw     086B5FBEh   ; security level 4
    .dw     086B602Eh   ; main missiles
    .dw     086B6092h   ; super missiles
    .dw     086B6102h   ; bombs
    .dw     086B6170h   ; main power bombs
    .dw     086B61EEh   ; ice missiles
    .dw     086B626Ch   ; diffusion missiles
    .dw     086B62E8h   ; morph ball
    .dw     086B635Ah   ; hi-jump
    .dw     086B63ACh   ; screw attack
    .dw     086B641Eh   ; space jump
    .dw     086B6490h   ; speed booster
    .dw     086B64F8h   ; varia suit
    .dw     086B6574h   ; gravity suit
    .dw     086B65ECh   ; charge beam
    .dw     086B6664h   ; wide beam
    .dw     086B66CCh   ; wave beam
    .dw     086B673Ah   ; plasma beam
    .dw     086B67AEh   ; ice beam
    .dw     @Message_InfantMetroidsRemain
    .dw     @Message_InfantMetroidsNeeded
    .dw     @Message_SecondLastInfantMetroid
    .dw     @Message_SufficientInfantMetroids
    .dw     @Message_LastInfantMetroid
    .dw     086B701Ch   ; is your objective clear?
    .dw     086B706Ah   ; confirm mission objective?
    .dw     @Message_WarpToStartLine1
    .dw     @Message_WarpToStartLine2
    .dw     086B719Ah   ; sleep mode line 3
    .dw     086B681Ah   ; atmospheric stabilizer 1
    .dw     086B6896h   ; atmospheric stabilizer 2
    .dw     086B6912h   ; atmospheric stabilizer 3
    .dw     086B698Eh   ; atmospheric stabilizer 4
    .dw     086B6A06h   ; atmospheric stabilizer 5
    .dw     086B6A82h   ; water level lowered
    .dw     086B6AD2h   ; boiler cooling
    .dw     086B6B06h   ; animals freed
    .dw     086B6B58h   ; auxiliary power
    .dw     086B6B98h   ; restricted sector detaching
    .dw     @Message_EscapeSequenceStart
    .dw     086B6C66h   ; save prompt
    .dw     086B6C94h   ; save complete
    .dw     086B6CCCh   ; adam uplink prompt
    .dw     086B6D20h   ; ammunition resupply
    .dw     086B6D7Ch   ; energy recharge
    .dw     086B6DDAh   ; ammo and energy recharge
    .dw     086B6E50h   ; energy tank
    .dw     086B6EBAh   ; missile tank
    .dw     086B6F30h   ; power bomb tank
    .dw     086B6FACh   ; sprite location abnormal
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