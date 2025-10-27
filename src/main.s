.gba
.open "metroid4.gba", "obj/m4rs.gba", 08000000h

.table "data/text.tbl"

; Assembly-time flags
.sym off
.ifndef DEBUG
.definelabel DEBUG, 1
.endif
.ifndef OPTIMIZE
.definelabel OPTIMIZE, 1
.endif
.ifndef QOL
.definelabel QOL, 1
.endif
.ifndef ACCESSIBILITY
.definelabel ACCESSIBILITY, 0
.endif
.ifndef NONLINEAR
.definelabel NONLINEAR, 1
.endif
.ifndef RANDOMIZER
.definelabel RANDOMIZER, 1
.endif

.ifndef BOMBLESS_PBS
.definelabel BOMBLESS_PBS, 0
.endif
.ifndef MISSILES_WITHOUT_MAINS
.definelabel MISSILES_WITHOUT_MAINS, 0
.endif
.ifndef UNHIDDEN_MAP
.definelabel UNHIDDEN_MAP, 0
.endif
.ifndef UNHIDDEN_MAP_DOORS
.definelabel UNHIDDEN_MAP_DOORS, 0
.endif
.ifndef NERF_GERON_WEAKNESS
.definelabel NERF_GERON_WEAKNESS, 0
.endif
.sym on

FreeIWRam equ 03005630h
FreeIWRamLen equ 23D0h
FreeIWRamEnd equ FreeIWRam + FreeIWRamLen ; ends 030079FFh

.include "inc/constants.inc"
.include "inc/enums.inc"
.include "inc/functions.inc"
.include "inc/macros.inc"
.include "inc/sprite-ids.inc"
.include "inc/structs.inc"

StartingItems equ 0828D2ACh
HintTargets equ 085766ECh
Credits equ 0874B0B0h
MessageTableLookupAddr equ 0879CDF4h ; This is not the location of the table itself. The pointers, offset by language, at this location will be the table location

; Reserved space addresses/pointers. Used by the patcher to know where it should write
; data to. The first address here should be used below when defining the free
; space region for the asm to use
PatcherFreeSpace equ 087D0000h
CreditsMusicSpace equ 087F0000h ; takes up 0x14E0h
FutureReservedSpace equ 087F14E0h
FutureReservedSpace_Len equ 0DB20h

; Reserved Pointers
ReservedPatcherAddrs equ 087FF000h
.org ReservedPatcherAddrs
reserve_pointer MinorLocationTablePointer
reserve_pointer MinorLocationsPointer
reserve_pointer MajorLocationsPointer
reserve_pointer TankIncrementsPointer
reserve_pointer MetroidCountPointer
reserve_pointer StartingLocationPointer
reserve_pointer CreditsParametersPointer
reserve_pointer HintSecurityLevelsPointer
reserve_pointer EnvironmentalHazardDpsPointer
reserve_pointer MissileLimitPointer
reserve_pointer RoomNamesPointer
reserve_pointer RevealHiddenTilesFlagPointer
reserve_pointer TitleScreenTextPointersPointer
reserve_pointer DefaultStereoFlagPointer
reserve_pointer InstantMorphFlagPointer
reserve_pointer ForceExcessHealthDisplayPointer


; Mark end-of-file padding as free space
EOF equ 0879ECC8h
.defineregion EOF, PatcherFreeSpace - EOF, 0FFh
; Free up large unused audio sample
DataFreeSpace equ 080F9A28h
DataFreeSpaceLen equ 20318h
DataFreeSpaceEnd equ DataFreeSpace + DataFreeSpaceLen
.defineregion DataFreeSpace, DataFreeSpaceLen, 0FFh

; Debug mode patch
.if DEBUG
.notice "Applying debug patches..."
.include "src/debug.s"
.endif

; Optimization patches
; Patches intended to produce identical behavior to vanilla, but optimized
.if OPTIMIZE
.notice "Applying optimization patches..."
.include "src/optimization/item-check.s"
.include "src/optimization/power-bomb-explosion.s"
.elseif RANDOMIZER
.include "src/optimization/item-check.s"
.endif

; Quality of life patches
; Patches providing non-essential but convenient features
.if QOL
.notice "Applying quality of life patches..."
.include "src/physics/instant-morph.s"
.include "src/qol/aim-lock.s"
.include "src/qol/completion-seconds.s"
.include "src/qol/cross-sector-maps.s"
.include "src/qol/fast-doors.s"
.include "src/qol/fast-elevators.s"
.include "src/qol/ice-beam-volume.s"
.include "src/qol/increase-red-x-drops.s"
.include "src/qol/map-info.s"
.include "src/qol/sax-softlock.s"
.include "src/qol/screw-unbonk.s"
.include "src/qol/skip-ending.s"
.include "src/qol/skip-intro.s"
.include "src/qol/stereo-default.s"
.include "src/qol/unhidden-breakable-tiles.s"
.if UNHIDDEN_MAP
.include "src/qol/unhidden-map.s"
.endif
.if UNHIDDEN_MAP_DOORS
.include "src/qol/unhidden-map-doors.s"
.endif
.include "src/qol/unhidden-pillars.s"

.endif

; Accessibility patches
; Patches which make the game more acccessible to people.
.if ACCESSIBILITY
.include "src/a11y/accessible-enemy-gfx.s"
.include "src/a11y/accessible-flashing.s"
.endif

; Non-linearity patches
; Patches which mitigate or remove linear story restrictions
; Forced if randomizer flag is on
.if NONLINEAR || RANDOMIZER
.notice "Applying non-linearity patches..."
.include "src/nonlinear/common.s"
.include "src/nonlinear/hud-edits.s"
.include "src/nonlinear/beam-stacking.s"
.include "src/nonlinear/bosses.s"
.include "src/nonlinear/data-rooms.s"
.include "src/nonlinear/demos.s"
.include "src/nonlinear/room-edits.s"
.include "src/nonlinear/room-states.s"
.include "src/nonlinear/main-missiles.s"
.include "src/nonlinear/major-completion.s"
.include "src/nonlinear/minimap-edits.s"
.include "src/nonlinear/messages.s"
.include "src/nonlinear/misc-progress.s"
.include "src/nonlinear/missile-stacking.s"
.include "src/nonlinear/music.s"
.include "src/nonlinear/new-game-init.s"
.include "src/nonlinear/null-event.s"
.include "src/nonlinear/operations-room.s"
.include "src/nonlinear/security-unlock.s"
.include "src/physics/bomb-jump.s"
.include "src/physics/single-walljump.s"
.include "src/nonlinear/split-suits.s"
.include "src/nonlinear/story-flags.s"

.if NERF_GERON_WEAKNESS
.include "src/nonlinear/nerf-geron-weakness.s"
.endif

.if !DEBUG
.include "src/nonlinear/item-select.s"
.endif
.if BOMBLESS_PBS
.include "src/nonlinear/bombless-pbs.s"
.endif
.endif

; Randomizer patches
; Patches making randomization of the game possible
.if RANDOMIZER
.notice "Applying randomizer patches..."
.include "src/randomizer/credits.s"
.include "src/randomizer/hatch-fixes.s"
.include "src/randomizer/hints.s"
.include "src/randomizer/less-map-info.s"
.include "src/randomizer/menu-edits.s"
.include "src/randomizer/open-escape.s"
.include "src/randomizer/start-warp.s"
.include "src/randomizer/start-location.s"
.include "src/randomizer/tank-majors.s"
.include "src/nonlinear/tileset-edits.s"
.include "src/randomizer/title-screen.s"
.include "src/randomizer/room-name-display.s"
.endif

.close
