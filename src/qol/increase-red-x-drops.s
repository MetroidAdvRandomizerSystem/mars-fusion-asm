; This file contains has two sets of changes. The first increases the normal probability of a Red-X spawning
; The second is a function that augments the default X Spawn functionality. A Red-X is now guaranteed if
; Energy and Missiles are maxed out, Power Bombs have been acquired, and Current Power Bombs = 0

; Increases the probability of Red X drops to a minimum of 3/256. Any enemy that is already more likely to drop a Red X will not be affected.
; The probability calculations are out of 1024 (0x0400). For X Drops this must add up precisely - so take from Yellow X chance
; In the ROM Data, the Weights/Probabilities are laid out as YellowXWeight/GreenXWeight/RedXWeight
; In the following comments, "originally 337/C8/1" would mean that the sprites original drop rates were:
; Yellow X: 337h (823/1024)
; Green  X:  C8h (200/1024)
; Red    X:   1h (  1/1024)
; When replacing the Weights, it needs to be set in that same order.

.org SpriteStats + Hornoad_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Halzyn_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2D3/12C/1
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + ZebesianWall_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2CA/12C/A
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + Moto_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2D3/12C/1
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + Yameba_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Zeela_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Zombie_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 20B/1F4/1
    .dh 0200h
    .dh 01F4h
    .dh 000Ch

.org SpriteStats + Geemer_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 3F4/A/2
    .dh 03EAh
    .dh 000Ah
    .dh 000Ch

.org SpriteStats + Waver_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 305/FA/1
    .dh 02FAh;
    .dh 00FAh;
    .dh 000Ch;

.org SpriteStats + Sciser_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Sidehopper_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 20B/1F4/1
    .dh 0200h
    .dh 01F4h
    .dh 000Ch

.org SpriteStats + Dessgeega_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 322/DC/2
    .dh 0318h
    .dh 00DCh
    .dh 000Ch

.org SpriteStats + Zoro_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 305/FA/1
    .dh 02FAh;
    .dh 00FAh;
    .dh 000Ch;


.org SpriteStats + KihunterFlying_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + KihunterGround_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Reo_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 369/96/1
    .dh 035Eh
    .dh 0096h
    .dh 000Ch

.org SpriteStats + Namihe_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2D1/12C/3
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + Fune_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2D1/12C/3
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch


.org SpriteStats + Geruda_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + SkulteraSmallNotLarge_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Sova_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 39B/64/1
    .dh 0390h
    .dh 0064h
    .dh 000Ch

.org SpriteStats + Yard_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 26E/190/2
    .dh 0264h
    .dh 0190h
    .dh 000Ch

.org SpriteStats + Evir_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 209/1F4/3
    .dh 0200h
    .dh 01F4h
    .dh 000Ch;

.org SpriteStats + Bull_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Memu_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 39B/64/1
    .dh 0390h
    .dh 0064h
    .dh 000Ch

.org SpriteStats + Choot_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + ZebesianGround_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2CA/12C/A
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + GoldSciser_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 175/28A/1
    .dh 016Ah
    .dh 028Ah
    .dh 000Ch

.org SpriteStats + Owtch_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 369/96/1
    .dh 035Eh
    .dh 0096h
    .dh 000Ch

.org SpriteStats + Genesis_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2CA/12C/A
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + Puyo_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 39B/64/1
    .dh 0390h
    .dh 0064h
    .dh 000Ch

.org SpriteStats + ZebesianAqua_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2CA/12C/A
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + ZebesianPreAqua_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2CA/12C/A
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

.org SpriteStats + SkulteraSmall_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 337/C8/1
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Powamp_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 32E/C8/A
    .dh 032Ch
    .dh 00C8h
    .dh 000Ch

.org SpriteStats + Zozoro_Id * SpriteStats_Size + SpriteStats_YellowXWeight
    ; originally 2D3/12C/1
    .dh 02C8h
    .dh 012Ch
    .dh 000Ch

; This function augments the existing DetermineXParasiteType function.
; Before starting to check the probability tables, but after determining if this is a special spawn (I.E. Room Yellow X)
; this function is called. If Current Energy = Max Energy, Current Missiles = Max Missiles, and Current Power Bombs = 0 (while having PB Upgrade),
; force the spawn of a Red-X. Otherwise use the current logic.

.codeautoregion
    .align 2
.func @CheckGuaranteedRedX
    ; Preserve original functionality - if r3 (Sprite Property) is not equal to 20h, fall back to the Error Handling Block. Otherwise execute the new code
    cmp     r3, #20h
    bne     @@default_error_handler
    push    { r0-r3 }
    ldr     r3, =SamusUpgrades
    ;Energy
    ldrh    r0, [r3, SamusUpgrades_CurrEnergy]
    ldrh    r1, [r3, SamusUpgrades_MaxEnergy]
    cmp     r0, r1
    bne     @@return_to_default_logic
    ; Missiles
    ldrh    r0, [r3, SamusUpgrades_CurrMissiles]
    ldrh    r1, [r3, SamusUpgrades_MaxMissiles]
    cmp     r0, r1
    bne     @@return_to_default_logic
    ; Power Bombs
    ; Ensure PB Upgrade has been acquired
    ldrb   r0, [r3, SamusUpgrades_ExplosiveUpgrades]
    mov    r1, #20h ; 5th bit is if PB Upgrade acquired
    and    r0, r1
    cmp    r0, #20h
    bne     @@return_to_default_logic
    ; Check if Max PB != 0
    ldrb   r0, [r3, SamusUpgrades_MaxPowerBombs]
    cmp    r0, #0h
    beq    @@return_to_default_logic
    ; Check if Current PB = 0
    ldrb   r0, [r3, SamusUpgrades_CurrPowerBombs]
    mov    r1, #0h
    cmp    r0, r1
    bne    @@return_to_default_logic
    ldr    r0, =RedX_OAMData
    ldr    r1, =CurrentSprite
    str    r0, [r1, Sprite_OamPointer]
    add    r1, Sprite_SamusCollision
    mov    r0, #11h ;11h spawns Red-X from enemy when put in SamusCollision
    strb   r0, [r1]
    pop    { r0-r3 }
    bl     08061930h ; Return to the original function end
@@return_to_default_logic:
    pop    { r0-r3 }
    bl     080617F8h ; Return to where the original function would have gone
@@default_error_handler:
    bl     0806192Ch ; Jump to the Error Handler secion of code in the original function
    .pool
.endfunc
.endautoregion

; Hijack the original code location
.org 080617E6h
.area 06h, 0
    bl     @CheckGuaranteedRedX
.endarea
