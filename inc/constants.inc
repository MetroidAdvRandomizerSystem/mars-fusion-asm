; GBA hardware constants
OBJ0_YCoordinate equ 0b11111111 ; Bits 0-7 (0-255)
OBJ0_Transform equ 1 << 8   ; For rotation or scaling
OBJ0_DoubleSize equ 1 << 9  ; 0 = Normal, 1 = Double        ; When Transform bit set
OBJ0_Disable equ 1 << 9     ; 0 = Normal, 1 = Not Diplayed  ; When Transform bit clear
OBJ0_Mode equ 10
OBJ0_Mode_Normal equ 0b00 << OBJ0_Mode
OBJ0_Mode_SemiTransparent equ 0b01 << OBJ0_Mode
OBJ0_Mode_OBJWindow equ 0b10 << OBJ0_Mode
; OBJ0 Mode 0b11 is prohibited
OBJ0_Mosaic equ 1 << 12
OBJ0_16Colors equ 0 << 13
OBJ0_256Colors equ 1 << 13
OBJ0_Shape_Square equ 0b00 << 14
OBJ0_Shape_Horizontal equ 0b01 << 14
OBJ0_Shape_Vertical equ 0b10 << 14
; OBJ0 Shape 0b11 is prohibited

OBJ1_XCoordinate equ 0b111111111 ; Bits 0-8 (0-511)
OBJ1_XFlip equ 1 << 12
OBJ1_YFlip equ 1 << 13
OBJ1_Size_8x8   equ 0 << 14
OBJ1_Size_16x16 equ 1 << 14
OBJ1_Size_32x32 equ 2 << 14
OBJ1_Size_64x64 equ 3 << 14
OBJ1_Size_16x8  equ 0 << 14
OBJ1_Size_32x8  equ 1 << 14
OBJ1_Size_32x16 equ 2 << 14
OBJ1_Size_64x32 equ 3 << 14
OBJ1_Size_8x16  equ 0 << 14
OBJ1_Size_8x32  equ 1 << 14
OBJ1_Size_16x32 equ 2 << 14
OBJ1_Size_32x64 equ 3 << 14

OBJ2_Character equ 0b1111111111
; Priority is relative to BG
OBJ2_Priority_Highest equ 0 << 10
OBJ2_Priority_High equ 1 << 10
OBJ2_Priority_Low equ 2 << 10
OBJ2_Priority_Lowest equ 3 << 10
OBJ2_Palette equ 12
OBJ2_PaletteMask equ 0b1111

; DMA_CNT
DMA_CNT_H equ 16
;  5-6   Dest Addr Control  (0=Increment,1=Decrement,2=Fixed,3=Increment/Reload)
;  7-8   Source Adr Control (0=Increment,1=Decrement,2=Fixed,3=Prohibited)
;  9     DMA Repeat                   (0=Off, 1=On) (Must be zero if Bit 11 set)
;  10    DMA Transfer Type            (0=16bit, 1=32bit)
;  11    Game Pak DRQ  - DMA3 only -  (0=Normal, 1=DRQ <from> Game Pak, DMA3)
;  12-13 DMA Start Timing  (0=Immediately, 1=VBlank, 2=HBlank, 3=Special)
;          The 'Special' setting (Start Timing=3) depends on the DMA channel:
;          DMA0=Prohibited, DMA1/DMA2=Sound FIFO, DMA3=Video Capture
;  14    IRQ upon end of Word Count   (0=Disable, 1=Enable)
;  15    DMA Enable                   (0=Off, 1=On)
DMA_DST_INCREMENT       equ 0 << 5 + DMA_CNT_H
DMA_DST_DECREMENT       equ 1 << 5 + DMA_CNT_H
DMA_DST_FIXED           equ 2 << 5 + DMA_CNT_H
DMA_DST_INCREMENTRELOAD equ 3 << 5 + DMA_CNT_H
DMA_SRC_INCREMENT       equ 0 << 7 + DMA_CNT_H
DMA_SRC_DECREMENT       equ 1 << 7 + DMA_CNT_H
DMA_SRC_FIXED           equ 2 << 7 + DMA_CNT_H
DMA_REPEAT              equ 1 << 9 + DMA_CNT_H
DMA_TYPE_16BIT          equ 0 << 10 + DMA_CNT_H
DMA_TYPE_32BIT          equ 1 << 10 + DMA_CNT_H
DMA_GAMEPAK             equ 1 << 11 + DMA_CNT_H
DMA_TIMING_IMM          equ 0 << 12 + DMA_CNT_H
DMA_TIMING_VBLANK       equ 1 << 12 + DMA_CNT_H
DMA_TIMING_HBLANK       equ 2 << 12 + DMA_CNT_H
DMA_TIMING_SPECIAL      equ 3 << 12 + DMA_CNT_H
DMA_IRQ_ENABLE          equ 1 << 14 + DMA_CNT_H
DMA_ENABLE              equ 1 << 15 + DMA_CNT_H

VRAM equ 06000000h
GFX_ROW equ 400h
GFX_TILE equ 20h


; non-vanilla constants

MissileCooldown equ 9
SuperMissileCooldown equ 4
IceMissileCooldown equ 2
DiffusionMissileCooldown equ 1

MissileDamage equ 10
SuperMissileDamage equ 20
IceMissileDamage equ 10
DiffusionMissileDamage equ 5

IceVolumeFactor equ 0.6

CustomMessages_Maximum equ 198 ; 58 Messages are reserved by existing behavior, leaving 198 ids left

NavLockGfxRow equ 4
NavLockGfxRowCount equ 2
