.org RemoveNeverReformBlocksAndCollectedTanks
.area 08064AEBh-08064ADCh, 0
    push    { lr }
    bl       @RemoveMiscTilesFromRoom
    pop     { r0 }
    bx      r0
.endarea

.autoregion
    .align 2
.func @RemoveMiscTilesFromRoom
    push    { lr }
    bl      RemoveNeverReformBlocks
    bl      RemoveCollectedTanks
    bl      RevealHiddenBreakableTiles
    pop     { r0 }
    bx      r0
.endfunc
.endautoregion

.org RevealHiddenTilesFlag
.area 1
    .db     00h
.endarea

.org 0806B962h ; Editing UpdateBlockAnimation, case 07h
.area 0806B968h-0806B962h, 0
    bl      @BreakStateIfRevealed
.endarea

.autoregion
    .align 2
.func @BreakStateIfRevealed
    push    { r4, lr }
    ldr     r4, =RevealHiddenTilesFlag
    ldrb    r4, [r4]
    cmp     r4, 0
    bne     @@if_revealed
@@if_vanilla:
    add     r0, #01h
    b       @@return
@@if_revealed:
    ldr     r4, [sp]
    bl      RevealBombChainTile
    cmp     r4, #1
    beq     @@if_vanilla
    sub     r0, #05h
@@return:
    lsl     r0, r0, #10h
    lsr     r5, r0, #10h
    pop     { r4, lr }
    .pool
.endfunc
.endautoregion

.autoregion
; input
; r4 = stack pointer, should have indexed block being checked for updating animation
; output
; r4 = bool
;      true = block found and r0 updated
;      false = no block found
    .align 2
.func RevealBombChainTile
    push    { r5-r7, lr }
    mov     r6, r4
    mov     r5, #0
    ldrb    r3, [r6, BrokenBlock_YPos]
    ldrb    r2, [r6, BrokenBlock_XPos]
    ldr     r7, =StoredRevealedTiles
@@loop:
    lsl     r4, r5, #2      ; index = counter * 4
    add     r4, r4, r7      ; StoredRevealedTiles + index
    ldrb    r1, [r4, StoredRevealedTiles_XPos]
    cmp     r1, r2
    bne     @@inc_counter
    ldrb    r1, [r4, StoredRevealedTiles_YPos]
    cmp     r1, r3
    bne     @@inc_counter
    ldrh    r0, [r4, StoredRevealedTiles_Type]
    b       @@return_true
@@inc_counter:
    add     r5, #1
    cmp     r5, #StoredRevealedTiles_Len
    blt     @@loop
    b       @@return_false
@@return_true:
    mov     r4, 1
    pop     { r5-r7, pc }
@@return_false:
    mov     r4, 0
    pop     { r5-r7, pc }
    .pool
.endfunc
.endautoregion

.autoregion
    .align 2
.func RevealHiddenBreakableTiles
    push    { r4-r7, lr }
    sub     sp, #8
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    beq     @@return
    ldr     r0, =NonGameplayFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @@return ; exit early if called from non-gameplay or cutscene
@@clear_StoredRevealedTiles:
    mov     r0, #20h
    str     r0, [sp]
    mov     r0, #3
    mov     r1, #0
    ldr     r2, =StoredRevealedTiles
    ldr     r3, =StoredRevealedTiles_Len * StoredRevealedTiles_Size
    bl      BitFill
    b       @@load_room_info
    .pool
@@load_room_info:
    ldr     r7, =LevelLayers + LevelLayers_Clipdata
    ldrh    r6, [r7, LevelLayer_Rows]   ; height
    ldrh    r5, [r7, LevelLayer_Stride] ; width
    ldr     r7, [r7]
    str     r5, [sp]
    str     r6, [sp, #4]
    mov     r5, #0
    mov     r6, #0
@@loop:
    mov     r1, r7
    ldr     r3, [sp]
    mov     r2, r6
    mul     r2, r3      ; height * room width
    add     r2, r2, r5  ; + width
    lsl     r2, #1
    add     r0, r1, r2
    ldr     r1, =3001h
    cmp     r1, r2      ; don't read past Clipdata RAM
    beq     @@return
    ldrh    r0, [r7, r2]
    cmp     r0, #ClipdataTile_Air
    beq     @@inc_width
    cmp     r0, #ClipdataTile_Solid
    beq     @@inc_width
    cmp     r0, #ClipdataTile_DoorTransition
    beq     @@inc_width
    bl      @SearchForHiddenBlocks
    mov     r1, #0
    mvn     r1, r1
    lsl     r1, #10h
    lsr     r1, #10h
    cmp     r1, r0  ; if not FFFF
    bne     @@reveal_hidden_block
    b       @@inc_width
@@reveal_hidden_block:
    ; r0 should contain value of new tile
    mov     r1, r6  ; Y Pos
    mov     r2, r5  ; X Pos
    bl      SetSpecialBg1Tile
@@inc_width:
    add     r5, #1
    ldr     r0, [sp]
    cmp     r5, r0
    ble     @@loop
@@inc_height:
    add     r6, #1
    ldr     r0, [sp, #4]
    cmp     r6, r0
    beq     @@return
    mov     r5, #1
    b       @@loop
@@return:
    add     sp, #8
    pop     { r4-r7 }
    pop     { r0 }
    bx      r0
    .pool
.endfunc
.endautoregion

.autoregion
    .align 2
@ClipDataReplacements:
   ;.db Clip to check, replacement clip
    .dh ClipdataTile_Crumble,                   ClipdataRevealed_Crumble
    .dh ClipdataTile_WeakReform,                ClipdataRevealed_Weak
    .dh ClipdataTile_BombNeverReform,           ClipdataRevealed_Bomb
    .dh ClipdataTile_BombReform,                ClipdataRevealed_Bomb
    .dh ClipdataTile_SpeedNoReform,             ClipdataRevealed_Speed
    .dh ClipdataTile_SpeedReform,               ClipdataRevealed_Speed
    .dh ClipdataTile_MissileNeverReform,        ClipdataRevealed_Missile
    .dh ClipdataTile_MissileNoReform,           ClipdataRevealed_Missile
    .dh ClipdataTile_PBomb,                     ClipdataRevealed_PBomb
    .dh ClipdataTile_ScrewAttack,               ClipdataRevealed_ScrewAttack
    .dh ClipdataTile_MissileTankHidden,         ClipdataRevealed_Weak ; 801Ch ; Maybe we change these later if we find a better way to reveal
    .dh ClipdataTile_EnergyTankHidden,          ClipdataRevealed_Weak ; 801Dh ; tanks without needing to shoot them.
    .dh ClipdataTile_PBombTankHidden,           ClipdataRevealed_Weak ; 801Eh
    .dh ClipdataTile_2x2TopLeftNeverReform,     ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopRightNeverReform,    ClipdataRevealed_Weak
    .dh ClipdataTile_WeakNeverReform,           ClipdataRevealed_Weak
    .dh ClipdataTile_WeakNoReform,              ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopLeftNoReform,        ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopRightNoReform,       ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomLeftNeverReform,  ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomRightNeverReform, ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomLeftNoReform,     ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomRightNoReform,    ClipdataRevealed_Weak
    .dh ClipdataTile_VerticalBombChain1,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain2,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain3,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain4,        ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain1,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain2,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain3,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain4,      ClipdataRevealed_Bomb
    .dh 0FFFFh, 0FFFFh
.endautoregion


.autoregion
; input
; r0 = Block to Search For
; r5 = X Pos
; r6 = Y Pos
; output
; r0 = Replacement Tile, or None (0FFFFh)
    .align 2
.func @SearchForHiddenBlocks
    push    { r1-r4, lr }
    sub     sp, #4
    mov     r3, #0
    str     r3, [sp]
@@search:
    ldr     r3, [sp]
    lsl     r3, #2
    ldr     r4, =@ClipDataReplacements
    add     r4, r4, r3
    ldrh    r2, [r4]
    mov     r1, #0
    mvn     r1, r1
    lsl     r1, r1, 10h
    lsr     r1, r1, 10h
    cmp     r2, r1
    beq     @@return_none
    cmp     r0, r2
    beq     @@check_bomb_chain
    ; increment counter
    lsr     r3, #2
    add     r3, #1
    str     r3, [sp]
    b       @@search
@@check_bomb_chain:
/*
if (r0 >= ClipdataTile_VerticalBombChain1 and
    r0 <= ClipdataTile_HorizontalBombChain4
   ) then
*/
    ldr     r1, =ClipdataTile_VerticalBombChain1
    lsl     r1, r1, 10h
    lsr     r1, r1, 10h
    cmp     r0, r1
    blt     @@return_replacement ; else
    ldr     r1, =ClipdataTile_HorizontalBombChain4
    lsl     r1, r1, 10h
    lsr     r1, r1, 10h
    cmp     r1, r0
    blt     @@return_replacement ; else

    mov     r0, r5 ; X Pos
    mov     r1, r6 ; Y Pos
    bl StoreBombChainTile
@@return_replacement:
    ldr     r2, =@ClipDataReplacements+2
    add     r2, r2, r3
    ldrh    r0, [r2, #0]
    add     sp, #4
    pop     { r1-r4, pc }
@@return_none:
    ldr     r0, =0FFFFh
    add     sp, #4
    pop     { r1-r4, pc }
    .pool
.endfunc
.endautoregion


.autoregion
; input
; r0 = X Pos
; r1 = Y Pos
    .align 2
.func StoreBombChainTile
    push    { r3, lr }
    sub     sp, #4
    mov     r3, #0
    str     r3, [sp] ; counter @ SP

@@loop:
    ldr     r4, =StoredRevealedTiles
    mov     r3, sp
    ldr     r3, [r3]
    lsl     r3, #2
    add     r4, r4, r3
    ldrh    r3, [r4, StoredRevealedTiles_Type]
    cmp     r3, #0
    bne     @@inc_counter
@@store:
    strb    r0, [r4, StoredRevealedTiles_XPos]
    strb    r1, [r4, StoredRevealedTiles_YPos]
    ldr     r3, =LevelLayers + LevelLayers_Bg1
    ldrh    r2, [r3, LevelLayer_Stride]
    mul     r2, r1      ; height * room width
    add     r2, r2, r0  ; + width
    lsl     r0, r2, #1h
    ldr     r1, [r3]
    ldrh    r1, [r1, r0]
    strh    r1, [r4, StoredRevealedTiles_Type]
    b       @@return
@@inc_counter:
    ldr     r3, [sp]
    add     r3, r3, #1
    str     r3, [sp]
    cmp     r3, #StoredRevealedTiles_Len    ; exit early if end of table
    beq     @@return
    b       @@loop
@@return:
    add     sp, #4
    pop     { r3, pc }
    .pool
.endfunc
.endautoregion
