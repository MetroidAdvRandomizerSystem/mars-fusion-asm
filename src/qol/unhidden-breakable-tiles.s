.org RemoveNeverReformBlocksAndCollectedTanks
.area 08064AEBh-08064ADCh, 0
    push    { lr }
    bl       @RemoveMiscTilesFromRoom
    pop     { r0 }
    bx      r0
.endarea

.org RevealHiddenTilesFlagPointer
.area 04h
    .dw     RevealHiddenTilesFlag
.endarea

.org 0806B962h ; Editing UpdateBlockAnimation, case 07h
.area 0806B968h-0806B962h, 0
    bl      @BreakStateIfRevealed
.endarea

.autoregion 08000000h, DataFreeSpace
RevealHiddenTilesFlag:
    .db     00h
    .align 2
.func @RemoveMiscTilesFromRoom
    push    { lr }
    bl      RemoveNeverReformBlocks
    bl      RemoveCollectedTanks
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #01
    bne     @@skip
    bl      SetupRevealedTileCode

; This will automatically use leftover NonGameplayRam for code, or if the code
; is too long, it will put it in FreeIWRam.
.if (RevealHiddenBreakableTilesEndAddr - RevealHiddenBreakableTiles) > (NonGameplayRam_Len - ConvertClipdataCodeLength)
    ldr     r0, =RevealedTilesCode+1
.else
    ldr     r0, =NonGameplayRam+ConvertClipdataCodeLength+1 ; space after Clipdata code in WRAM
.endif
    blx      r0

@@skip:
    pop     { r0 }
    bx      r0
    .pool
.definelabel RevealHiddenBreakableTilesWram, NonGameplayRam+ConvertClipdataCodeLength
.endfunc


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


.func RevealBombChainTile
; input
; r4 = stack pointer, should have indexed block being checked for updating animation
; output
; r4 = bool
;      true = block found and r0 updated
;      false = no block found
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


.func SetupRevealedTileCode
    push    { lr }
    ldr     r3, =DMA3
    ldr     r2, =RevealHiddenBreakableTiles+1
.if (RevealHiddenBreakableTilesEndAddr - RevealHiddenBreakableTiles) > (NonGameplayRam_Len - ConvertClipdataCodeLength)
    ldr     r1, =RevealedTilesCode
.else
    ldr     r1, =NonGameplayRam+ConvertClipdataCodeLength ; space after Clipdata code
.endif
    ldr     r0, =DMA_ENABLE | DMA_TYPE_32BIT | (RevealHiddenBreakableTilesEndAddr - RevealHiddenBreakableTiles) / 4
    str     r2, [r3, DMA_SAD]
    str     r1, [r3, DMA_DAD]
    str     r0, [r3, DMA_CNT]
    ldr     r0, [r3, DMA_CNT]
    pop     { r0 }
    bx      r0
    .pool
.endfunc

.func RevealHiddenBreakableTiles
    push    { r4-r7, lr }
    mov     r4, r8
    mov     r5, r9
    mov     r6, r10
    push    { r4-r6 }
    sub     sp, #04
    ldr     r0, =RevealHiddenTilesFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    beq     @return_from_revealhiddentiles
    ldr     r0, =NonGameplayFlag
    ldrb    r0, [r0]
    cmp     r0, #0
    bne     @return_from_revealhiddentiles ; exit early if called from non-gameplay or cutscene
@@clear_StoredRevealedTiles:
    mov     r0, #20h
    str     r0, [sp]
    mov     r0, #3
    mov     r1, #0
    ldr     r2, =StoredRevealedTiles
    ldr     r3, =StoredRevealedTiles_Len * StoredRevealedTiles_Size
    ldr     r4, =BitFill
    blx     r4
@@load_room_info:
    ldr     r7, =LevelLayers + LevelLayers_Clipdata
    ldrh    r6, [r7, LevelLayer_Rows]   ; height
    ldrh    r5, [r7, LevelLayer_Stride] ; width
    ldr     r7, [r7]
    mov     r2, r5
    mul     r2, r6
    add     r2, r2, r5
    lsl     r2, #01
    mov     r10, r2                     ; end of room
    mov     r8, r5                      ; width [sp]
    mov     r9, r6                      ; height [sp+4]
@loop_in_revealhiddentiles:
    mov     r1, r7
    mov     r3, r8
    mov     r2, r6
    mov     r2, r10                     ; start at end of room and walk backards
    add     r0, r1, r2
    cmp     r2, #0                      ; stop when we hit the last tile
    beq     @return_from_revealhiddentiles
    ldrh    r0, [r7, r2]
    cmp     r0, #ClipdataTile_2x2TopLeftNeverReform
    blt     @dec_width                 ; if tile is not breakable, skip
    mov     r1, r5
    mov     r2, r6

//u16 replacementTile LoadRevealedTile(u16 xPos, u16 yPos)
@LoadRevealedTile:
    push    { r4-r6 }
    ldr     r4, [@ClipDataReplacementsPointer] ; PC relative load instead of loading from a pool. Value is defined manually
    mov     r5, r1
    mov     r6, r2

    ;Make ClipdataTile_2x2TopLeftNeverReform the starting index at 0
    sub     r0, #ClipdataTile_2x2TopLeftNeverReform
    bmi     @return_replacement
    cmp     r0, #ClipdataTile_HorizontalBombChain4 - ClipdataTile_2x2TopLeftNeverReform
    bhi     @return_replacement
    lsl     r0, #02
    add     r4, r0
    ldrh    r2, [r4]        ; load tile into r2
    ldrh    r4, [r4, #02]   ; load replacement into r0
    ldr     r1, =ClipdataRevealed_Bomb
    cmp     r4, r1
    bne     @return_replacement

@@check_bomb_chain:
    mov     r1, #ClipdataTile_VerticalBombChain1
    lsl     r1, r1, 10h
    lsr     r1, r1, 10h
    cmp     r2, r1
    blt     @return_replacement ; else
    mov     r1, #ClipdataTile_HorizontalBombChain4
    lsl     r1, r1, 10h
    lsr     r1, r1, 10h
    cmp     r1, r2
    blt     @return_replacement ; else

    mov     r0, r5 ; X Pos
    mov     r1, r6 ; Y Pos
//end in-line func

//void StoreBombChainTile(u16 xPos, u16 yPos)
@StoreBombChainTile:
    push    { r3-r5 }
    mov     r5, #0

@@loop:
    ldr     r4, =StoredRevealedTiles
    mov     r3, r5
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
    add     r5, #1
    cmp     r5, #StoredRevealedTiles_Len    ; exit if end of table
    beq     @@return
    b       @@loop
@@return:
    pop     { r3-r5 }
    b       @return_replacement

@return_replacement:
    mov     r0, r4
    pop     { r4-r6 }
// end in-line func

    mov     r1, #0
    mvn     r1, r1
    lsl     r1, #10h
    lsr     r1, #10h
    cmp     r1, r0  ; if not FFFF
    bne     @reveal_hidden_block
    b       @dec_width
@reveal_hidden_block:
    ; r0 should contain value of new tile
    mov     r1, r6  ; Y Pos
    mov     r2, r5  ; X Pos
    push    { r3 }
    ldr     r3, =SetSpecialBg1Tile
    blx     r3
    pop     { r3 }
@dec_width:
    mov     r2, r10 ;\
    sub     r2, #02 ;} Decrement Room Tile Index
    mov     r10, r2 ;/
    sub     r5, #01
    cmp     r5, #00
    bgt     @loop_in_revealhiddentiles
@dec_height:
    sub     r6, #01
    cmp     r6, #00
    beq     @return_from_revealhiddentiles
    mov     r5, r8
    b       @loop_in_revealhiddentiles
@return_from_revealhiddentiles:
    add     sp, #4
    pop     { r4-r6 }
    mov     r8, r4
    mov     r9, r5
    mov     r10, r6
    pop     { r4-r7 }
    pop     { r0 }
    bx      r0
    .pool
@ClipDataReplacementsPointer:
.if (RevealHiddenBreakableTilesEndAddr - RevealHiddenBreakableTiles) > (NonGameplayRam_Len - ConvertClipdataCodeLength)
    .dw     RevealedTilesCode + (@ClipDataReplacements - RevealHiddenBreakableTiles) ;ClipDataReplacements in WRAM
.else
    .dw     NonGameplayRam+ConvertClipdataCodeLength + (@ClipDataReplacements - RevealHiddenBreakableTiles)
.endif
.endfunc

    .align 2
@ClipDataReplacements:
   ;.db Clip to check, replacement clip
    .dh ClipdataTile_2x2TopLeftNeverReform,     ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopRightNeverReform,    ClipdataRevealed_Weak
    .dh ClipdataTile_WeakNeverReform,           ClipdataRevealed_Weak
    .dh ClipdataTile_WeakReform,                ClipdataRevealed_Weak
    .dh ClipdataTile_MissileNeverReform,        ClipdataRevealed_Missile
    .dh ClipdataTile_BombNeverReform,           ClipdataRevealed_Bomb
    .dh ClipdataTile_BombReform,                ClipdataRevealed_Bomb
    .dh ClipdataTile_PBomb,                     ClipdataRevealed_PBomb
    .dh ClipdataTile_SpeedNoReform,             ClipdataRevealed_Speed
    .dh ClipdataTile_ScrewAttack,               ClipdataRevealed_ScrewAttack
    .dh ClipdataTile_Crumble,                   ClipdataRevealed_Crumble
    .dh ClipdataTile_WeakNoReform,              ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopLeftNoReform,        ClipdataRevealed_Weak
    .dh ClipdataTile_2x2TopRightNoReform,       ClipdataRevealed_Weak
    .dh ClipdataTile_MissileNoReform,           ClipdataRevealed_Missile
    .dh 005Fh,                                  ClipdataRevealed_None
    .dh ClipdataTile_2x2BottomLeftNeverReform,  ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomRightNeverReform, ClipdataRevealed_Weak
    .dh 0062h,                                  ClipdataRevealed_None
    .dh 0063h,                                  ClipdataRevealed_None
    .dh ClipdataTile_MissileTankHidden,         ClipdataRevealed_Pickup
    .dh ClipdataTile_EnergyTankHidden,          ClipdataRevealed_Pickup
    .dh 0066h,                                  ClipdataRevealed_None
    .dh 0067h,                                  ClipdataRevealed_None
    .dh 0068h,                                  ClipdataRevealed_None
    .dh ClipdataTile_PBombTankHidden,           ClipdataRevealed_Pickup
    .dh 006Ah,                                  ClipdataRevealed_None
    .dh ClipdataTile_SpeedReform,               ClipdataRevealed_Speed
    .dh ClipdataTile_2x2BottomLeftNoReform,     ClipdataRevealed_Weak
    .dh ClipdataTile_2x2BottomRightNoReform,    ClipdataRevealed_Weak
    .dh 006Eh,                                  ClipdataRevealed_None
    .dh 006Fh,                                  ClipdataRevealed_None
    .dh ClipdataTile_VerticalBombChain1,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain2,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain3,        ClipdataRevealed_Bomb
    .dh ClipdataTile_VerticalBombChain4,        ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain1,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain2,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain3,      ClipdataRevealed_Bomb
    .dh ClipdataTile_HorizontalBombChain4,      ClipdataRevealed_Bomb

    ; Fill remainder of table to prevent out-of-bounds reads
    .fill (0AFh - ClipdataTile_HorizontalBombChain4) * 4, 0FFh

RevealHiddenBreakableTilesEndAddr:
.endautoregion
