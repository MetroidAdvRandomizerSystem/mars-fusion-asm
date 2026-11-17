; Sector 2 - Zazabi Arena Access
; add cocoon and kihunter spritesets to intact room state
; Slightly adjust exit-distance from door with gadora to prevent instant damage if the gadora is not defeated.

.dataautoregion
@S2_ZazabiAccess_Spriteset1:
    .db     03h, 27h, 12h
    .db     05h, 2Dh, 12h
    .db     0Dh, 08h, 12h
    .db     0Dh, 0Ch, 12h
    .db     0Dh, 0Fh, 12h
    .db     0Eh, 15h, 12h
    .db     0Eh, 19h, 12h
    .db     11h, 14h, 02h
    .db     10h, 2Dh, 21h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.dataautoregion
@S2_ZazabiAccess_Spriteset2:
    .db     03h, 28h, 12h
    .db     04h, 2Ah, 23h
    .db     05h, 2Bh, 23h
    .db     05h, 2Dh, 12h
    .db     0Dh, 07h, 12h
    .db     0Dh, 0Bh, 12h
    .db     0Dh, 0Fh, 12h
    .db     0Eh, 15h, 12h
    .db     0Eh, 19h, 12h
    .db     0Fh, 0Fh, 23h
    .db     11h, 14h, 02h
    .db     11h, 19h, 23h
    .db     11h, 1Dh, 23h
    .db     14h, 15h, 24h
    .db     10h, 2Dh, 21h
    .db     0FFh, 0FFh, 0FFh
.endautoregion

.org Sector2Levels + 11h * LevelMeta_Size + LevelMeta_Spriteset1Event
.area LevelMeta_MapX - LevelMeta_Spriteset1Event
    .db     Event_ZazabiAbsorbed
    .skip 2
    .dw     @S2_ZazabiAccess_Spriteset1
    .db     68h
    .db     Event_ReactorOutage
    .skip 2
    .dw     @S2_ZazabiAccess_Spriteset2
    .db     69h
.endarea

.dataautoregion
@S2_ZazabiAccess_CocoonSpriteset:
    .db     91h, 00h
    .db     89h, 02h
    .db     0, 0
.endautoregion

.dataautoregion
@S2_ZazabiAccess_KihunterSpriteset:
    .db     91h, 00h
    .db     8Ah, 02h
    .db     5Bh, 03h
    .db     5Ch, 03h
    .db     0, 0
.endautoregion

.org SpritesetList + 68h * 04h
.area 08h
    .dw     @S2_ZazabiAccess_CocoonSpriteset
    .dw     @S2_ZazabiAccess_KihunterSpriteset
.endarea

.org Sector2Doors + 27h * DoorEntry_Size + DoorEntry_ExitDistanceX
.area 1
    .db     GadoraExitDistance_Left
.endarea
