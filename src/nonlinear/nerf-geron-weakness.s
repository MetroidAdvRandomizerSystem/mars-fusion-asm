; Enforces intended Geron weaknesses (missiles, super missiles, power bombs)

; Atmospheric Geron weaknesses
.org SpriteStats + AtmosphericStabilizerParasite_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_Missiles)

; Missile Geron weaknesses
.org SpriteStats + XBarrierCoreNormal1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_Missiles)

.org SpriteStats + XBarrierCoreNormal2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_Missiles)

.org SpriteStats + XBarrierCoreNormal3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_Missiles)

; Super Missile Geron weaknesses
.org SpriteStats + XBarrierCoreSuper1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper4_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper5_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper6_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper7_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

.org SpriteStats + XBarrierCoreSuper8_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_SuperMissiles)

; Power Bomb Geron weaknesses
.org SpriteStats + XBarrierCorePower1_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower2_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower3_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower4_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower5_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower6_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower7_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

.org SpriteStats + XBarrierCorePower8_Id * SpriteStats_Size + SpriteStats_Weaknesses
    .db     (1 << SpriteWeakness_PowerBombs)

; Changes the clipdata passed into function XBarrierCoreSetCollision (08029cf0h)
; to not allow the player to pass through using Screw Attack or Speed Booster

; Missile Geron
.org 08029E68h
    mov r0, ClipdataAction_MakeSolid

; Super Missile Geron
.org 08041FA0h
    mov r0, ClipdataAction_MakeSolid

; Power Bomb Geron
.org 08042310h
    mov r0, ClipdataAction_MakeSolid

