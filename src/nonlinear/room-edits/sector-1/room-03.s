; Sector 1 - Yameba Corridor

; Move Geron a bit further to the left to not bump into it when coming from the right
.org readptr(Sector1Levels + 03h * LevelMeta_Size + LevelMeta_Spriteset0) + (4 * Spriteset_SpriteSize)
.area 3
    .db 06h, 25h, 27h
.endarea


