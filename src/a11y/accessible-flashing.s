; Reduces various flashing in the game to be 3Hz or lower.
; Value is recommmended by the Web Content Accessibility Guidelines to avoid seizures.


; Change (mini)map flashings
.definelabel MinimapIndicatorFlashingSpeed, 10h

.org 08071B94h ; In-Game Minimap Position Indicator, inside of DrawHudOAM
    mov     r0, #MinimapIndicatorFlashingSpeed

.org 08566848h ; Pause Screen OAM for Map Position Indicator/Debug Cursor
.area 16
    .skip   4
    .db     MinimapIndicatorFlashingSpeed
    .skip   3
    .skip   4
    .db     MinimapIndicatorFlashingSpeed
    .skip   3
.endarea
