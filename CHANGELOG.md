# Changelog

## Unreleased - 2025-??-??

## 0.9.1 - 2025-09-23

- Changed: Hopefully made the instant unmorph patch not crash the game when they're being applied.

## 0.9.0 - 2025-09-19

- Added: An optional compile that repurposes the SELECT button to an instant (un)morph button.
- Changed: B.O.X has been moved slightly to the left to avoid bumping immediately into him in Entrance Rando.
- Removed: The PHYSICS compile variable/option was removed.
- Changed: The stereo-default patch has been moved from an IPS patch in the patcher to an ASM change togglable via a flag in ROM.

### Room Adjustments

#### Main Deck
- Changed: Central Reacto Core: Moved the Door leading to Silo Tunnel back by a tile to prevent getting stuck in Entrance Randomizer.

#### Sector 1
- Changed: Charge Core Upper Access: Moved the Door leading to Crab Rave back by a tile to prevent getting stuck in Entrance Randomizer.
- Changed: Tourian Eastern Hub: Removed the shot blocks and remodelled the space leading to Animorphs to prevent getting stuck in Entrance Randomizer.
- Changed: Twin Junctions Save Room: Moved the Door leading to Walljump Tutorial back by a tile to prevent getting stuck in Entrance Randomizer.

#### Sector 3
- Changed: Security Access: Moved the Door leading to the Security Room back by a tile to prevent getting stuck in Entrance Randomizer.

#### Sector 4
- Changed: Pump Control Save Room: Moved the Door leading to Breeding Tank Acecss back by a tile to prevent getting stuck in Entrance Randomizer.

#### Sector 5
- Changed: Flooded Tower: Moved the Door leading to Mini-Fridge back by a tile to prevent getting stuck in Entrance Randomizer.

#### Sector 6
- Changed: Geron's Crossing: Moved the Doors leading to the bottom side of Entrance Lobby and Vault back by a tile to prevent getting stuck in Entrance Randomizer.
- Changed: Warehouse: Moved the Door leading to Zozoro's Wine Cellar back by a tile to prevent getting stuck in Entrance Randomizer.


## 0.8.2 - 2025-08-29
- Fixed: Game crash caused by alignment of Minor item data within the ROM.
- Fixed: Ensure that the flag for reloading weapon gfx is cleared after reloading graphics.

## 0.8.1 - 2025-08-26
- Fixed: Custom Title Screen text could be dismissed accidentally when pressing `A` or `START` during the fade-in of "Press Start" and Copyright info.

## 0.8.0 - 2025-08-25
- Fixed: Weapon graphics sometimes did not reload after upgrades were collected/given.
- Fixed: Custom starting health displays incorrectly on a new file when you have not saved.
- Changed: Doors with Gadora on them have had their exit distance tweaked to prevent damage when traversing from the opposite side.

### Room Adjustments
- Removed: Removed the ANTI-SOFTLOCK conditional and instead made the changes always mandatory. This affects:
  - Sector 2 Cultivation Station: Bomb Block on the way to the Zoro area is now always a shot block.
  - Sector 2 Ripper Tower: Crumble Block on the bottom has been moved one tile up.
  - Sector 2 Crumble City: Furthest shot block on the left is now always a crumble block.
  - Sector 4 Reservoir East: All destructable blocks on the way to the bottom Power Bomb Tank never respawn.
  - Sector 4 Security Bypass: Make the dead-ends not softlock you if you went in there without Bombs or Power Bombs.
  - Sector 6 Zozoro Wine Cellar: Make the Bomb Block guarding the item always respawn.


## 0.7.2 - 2025-07-15
- Fixed: Major item jingle can no longer be canceled.

## 0.7.1 - 2025-07-15
- Fixed: Major item jingle no longer plays for message banners unrelated to item acquisition.
- Fixed: When Revealed Hidden Tiles is enabled, the item in Zazabi speedway no longer appears as a completely blank tile.

## 0.7.0 - 2025-07-11
- Fixed: Horizontal Extendable pillars in Pillar Highway will no longer have glitchy graphics after extending and overlapping with certain arrows when revealed tiles are enabled.
- Changed: Reveal Hidden Tiles: Revealed pickups with generic weak blocks have been replaced with a unique graphic indicating that the location contains an item.
- Fixed: Fixed an issue where laying normal bombs in electrified water may not propel samus upwards when taking damage.

### Room Adjustments
#### Sector 2
- Fixed: The Kihunters in Dessgeega Dorm now trigger when either Yakuza or Nettori is defeated, as opposed to only after Nettori is defeated.

### Randomizer
- Added: Provided a message ID (0x38h) which will display the Infant Metroid message.
- Added: Provide the ability to specify what jingle an item location plays.
- Added: Navigation rooms display the security level needed to view the hint.

### Accessibility
- Changed: Stronger/Blue Zoros, Stronger/Red Zeelas, Super Missile Gerons, Stronger/Golden Scizer and Stronger/Golden Pirates all have slight visual adjustments made for accessibility reasons.
- Changed: The flashing on the map and minimap has been reduced to 3Hz.

## 0.6.0 - 2025-06-20

### Randomizer
- Fixed: Room-based sound effects no longer continue playing after warping to start.
- Changed: Minimaps will now show connecting sectors via patcher changes.
- Changed: Extendable pillars will now show location and extension direction when revealed tiles are enabled. (Credit for Graphics to Raddley Vance)
- Fixed: Missile and Power Bomb Data will now increment with each obtained major upgrade.

### Visual
- Changed: The item select screen will show obtained missile upgrades before main missile data is obtained. Ammo counts for Missiles and PBs will always show.

## 0.5.1 - 2025-05-22

### Room Adjustments
- Changed: Sector 2 Eastern Shaft now has reforming speed booster blocks on the newly added ledge. The room also has had minor tiling tweaks.
- Changed: Sector 6 Big Shell 1 is now in the "Post-SAX" destroyed state, allowing traversal of the room without power bombs. It is now always included regardless of Anti-softlock settings.

### Visual
- Added: Minimap tiles have been added to allow for new events and fixes to vanilla map. Map will be updated in the patcher. (Credit to Raddley Vance)
- Changed: Minor tweaks to the data room and recharge room tile maps for visual inconsistencies. (Credit to Raddley Vance)

## 0.5.0 - 2025-05-15

### Gameplay Modifications
- Added: The events for cooling the Boiler, freeing the Animals, and turning on Auxiliary Power now give items.

### Room modifications
#### Main Deck
- Changed: Subzero Containment has been changed. The wall is removed between the right entrance and Ridley. Ridley will crumble when Samus approaches from the right. Exit to Genesis Speedway will not appear. Environmental damage has been changed to Cold with Knockback. Door to Subzero Containment now is Level 3.

### Randomizer
- Fixed: Go-mode music no longer triggers from save/recharge station in operations deck. Main Deck Data room will play SA-X Ambience instead of Go-Mode music if go-mode conditions are satisifed. Main Deck Data room will not change the music if the SA-X has been defeated.

## 0.4.2 - 2025-04-25

### Randomizer
- Added: Credits can now be paused by pressing and holding the A button.
- Fixed: Reverted Major Jingle audio change in an attempt to improve stability.

### Visual
- Fixed: BOX Debris Spawns Properly

## 0.4.1 - 2025-04-22

### Randomizer
- Fixed: Go-Mode Music should no longer start when closing miscellaneous banners, such as save or recharge banners, in sectors other than Main Deck.

## 0.4.0 - 2025-04-21
- Changed: Hidden Tanks are now revealed when "Reveal Hidden Tiles" is enabled. They will show as a beam-weak block.
- Changed: Message box duration for major items is back to its vanilla value (the previous music track will resume faster).
- Fixed: Removed an exploit that allowed toggling Screw Attack to give Single Walljump functionality.
- Fixed: Powamp Shaft Powamps no longer require X to spawn

### Randomizer
- Fixed: Rooms with Event doors no longer occasionally display the incorrect lock.
- Fixed: Warp to Start correctly plays background music on fresh file.
- Fixed: Tables for room names now allocate sufficient space to store name pointers.
- Fixed: Event Hatches can no longer be skipped by timing movement.
- Changed: Credits music loops until the Samus Screen. Additional contributers added to credits.
- Changed: Go-Mode music now starts immediately after closing the message box if your last required pickup is on Main Deck.

## 0.3.0 - 2025-03-15

### Randomizer
- Added: Snowflake gfx added to Ice Traps.
- Added: Option to reveal doors on map once visited.
- Changed: Ice traps now always freeze you regardless of Varia.
- Fixed: Escape music now triggers properly.
- Fixed: Respawning after warping to start now loads your most recent save location if you Game Over.
- Fixed: Removed bug when Samus would land on a frozen enemy while taking lethal damage.

### Quality of Life
- Changed: Ice Beam volume lowered for uncharged shots.

### Room modifications
#### Main Deck
- Fixed: Arachnus Arena: Arachnus no longer despawns before being defeated after triggering the escape sequence.
- Fixed: Reactor Silo: Removed event based door transition.
#### Sector 2
- Changed: Data Courtyard: the top Reo is now always in it's first pass location.
- Changed: Cathedral: the Zoro near the door to Ripper Tower is now moved away.
- Changed: Overgrown Checkpoint: moved the scroll so the missile block is visible from below.
- Fixed: Cathedral: fixed being able to clip through some of the Zoro cocoons.
- Fixed: Cultivation Station: fixed a block being always revealed.
#### Sector 4
- Fixed: Reservoir East: the Scizer on the wall is now always present.

## 0.2.0 - 2025-03-01

### Randomizer
- Fixed: Custom messages not working with more than 1 message.
- Fixed: Beams showing wrong graphics if they were collected from an item with a custom message.
- Changed: The door in Operations Deck to Operations Room has been changed to always be a Level-0 door.
- Changed: Halved Wave Beam's damage.

### Gameplay modifications
- Changed: When a door locks itself to become an event hatch, when it gets unlocked it will go back to the previous type rather than being fully open.

### Quality of Life
- Added: Optional setting to allow revealing destructible blocks by default.

## 0.1.0 - 2025-02-22

### Randomizer
- Changed: Allow all item locations (collectible tanks, security levels, data rooms, bosses) to be configured to contain any item.
- Changed: Data rooms and security rooms can be used at any point in time.
- Changed: Bosses can now be fought at any point in time, provided the player has access to the arena.
- Added: Unique collectible tank sprites for every item, including shiny variants of the missile tank and power bomb tank.
- Added: Collectible tank sprites can differ from the item they actually provide.
- Changed: Collectible tanks can display a configurable pickup fanfare message when collected.
- Changed: Anonymize all collectible tanks in demos.
- Added: Infant metroid item, a configurable number of which are required to spawn SA-X on Operations Deck and complete the game.
- Added: Nothing item, which has no effect upon collection.
- Added: Ice trap item, which freezes the player upon collection if varia suit is not active.
- Changed: On the Map screen, pressing A now shows you the name of your current room.
- Changed: Room states, background music, and other story flags are now dependent on combinations of progression flags (bosses defeated, terminals accessed, etc.) instead of a linear event counter.
- Changed: The first Adam dialogue is now configurable for the purpose of introducing the player to the randomizer and telling them other useful information.
- Changed: Navigation room terminals can be locked behind security levels.
- Changed: Navigation room terminals now provide configurable dialogue for the purpose of providing item location hints to the player.
- Changed: Credits roll is now configurable, intended for adding text after the vanilla credits, ex. randomizer credits, major item locations, etc.
- Changed: Initial energy, missile, and power bomb amounts and upgrade increments are now configurable.
- Changed: Escape sequence countdown only starts on entering Docking Bay Hangar.
- Changed: Having Screw Attack without Space Jump wil not let you Wall-Jump on a single wall anymore and instead behave the same as without Screw Attack.
- Added: The Map screen will now display on whether you have Lv-0 keycards collected.
- Added: Pressing select on the map menu rotates through the maps of each sector in numerical order.
- Added: Configurable start location and starting items.
- Added: Ability to warp to the starting location at any time, replacing the sleep mode menu. All progress since the last save is lost when warping.
- Removed: SA-X no longer patrols and chases the player through certain rooms.
- Removed: Boiler meltdown and reactor shutdown events no longer occur.
- Removed: Escape sequence no longer railroads the player towards the ship by locking doors.

### Gameplay modifications
- Changed: Reimplemented beam upgrades to stack on top of each other instead of only considering the highest obtained beam upgrade. Beam graphics are modified such that each beam combination can be easily differentiated at a glance.
  - Charge Beam: Allows the player to charge the beam, and buffs beam damage if only shooting one projectile.
  - Wide Beam: Shoots three beam projectiles, and adds a minor amount of damage.
  - Plasma Beam: Allows the beam to pierce enemies, reducing initial damage in favor of damage per tick.
  - Wave Beam: Allows the beam to pass through walls, and adds a significant amount of damage. Shots without wide beam also fire two projectiles instead of one.
  - Ice Beam: Freezes most enemies on contact, and adds a minor amount of damage.
- Changed: Reimplemented missile upgrades to stack on top of each other instead of only considering the highest obtained missile upgrade. Missile graphics are modified such that basic missiles have a purple tip, super missiles have a green tip, and super missiles take priority over the ice and diffusion missile graphics.
  - Main Missile Data: Allows the player to shoot missiles.
  - Super Missiles: Allows missiles to damage super missile gerons, and adds a major amount of damage and attack cooldown.
  - Ice Missiles: Freezes most enemies on contact, and adds a significant amount of damage and attack cooldown.
  - Diffusion Missiles: Allows the player to charge a radial area of effect freeze, but does not allow missiles to freeze enemies on contact. Adds a minor amount of damage and attack cooldown.
- Changed: Split the properties of varia suit and gravity suit. Damage reduction from enemies is incremental based on the number of suits obtained.
  - Varia Suit: Negates heat and cold damage, and reduces lava and acid damage by 40%. If gravity suit is also active, lava damage is negated.
  - Gravity Suit: Allows free movement in water and lava. Does not reduce environmental damage.
- Added: Configurable environmental damage per second.
- Added: Optional setting to allow use of power bombs without normal bombs.
- Added: Optional setting to allow use of missiles without main missile data.
- Added: Equipment enable/disable functionality to the Samus status menu.
- Added: Infant metroid counter to the Samus status menu.
- Changed: Reduced the amount of jump startup frames to allow Samus to destroy blocks directly above her head with screw attack.
- Changed: Sped up door transitions and elevators.
- Fixed: Vanilla aim lock bug where Samus's aim would get locked into a diagonal direction without holding the diagonal aim button.
- Fixed: Vanilla SA-X invulnerability softlocks in both Samus form and monster form.
- Changed: Slightly rework how Red-X drops work. Their chances for enemies have been bumped to 1.117%, and there is now a guaranteed drop when you ran out of PBs but have max health/missiles.

### Room modifications
#### Main Deck
- Added: Quarantine Bay: There is now a special Hornoad having a guaranteed Red-X drop.
- Removed: Restricted sector is always detached.
- Changed: Crew Quarters West: Remove power bomb geron to Elevator to Operations Deck.
- Changed: Operations Deck: Replace lv4 security door to Operations Room with a lv0 security door.
- Changed: Operations Deck: Allow missile hatch to be destroyed from both sides.
- Changed: Central Hub: Add power bomb geron to all room states.
- Changed: Eastern Hub: Remove missile geron in front of recharge station.
- Changed: Sector Hub: Keep main elevator active in all room states.
- Changed: Maintenance Shaft: Modify background tiles and add a missile geron to match the changes to Maintenance Crossing.
- Changed: Maintenance Crossing: Is now repaired and traversible, blocked by a missile geron.
- Changed: Silo Access: Move zoro cocoon out of the way of the path to reactor.
- Changed: Central Reactor Core: Add a platform between the doors to Silo Access and Silo Scaffolding A.
- Changed: Operations Room: Lv4 security door replaced with a Lv0 security door.
- Changed: Yakuza Arena: The Exit is now visible even if you haven't defeated Yakuza yet.
#### Sector 1
- Changed: Reactivating all atmospheric stabilizers changes the arrangements of some enemies.
- Changed: Metroid husks appear after collecting the required number of infant metroids.
- Changed: Hornoad Housing: The Hornoads aren't spawned in initially and instead have X flying in to form them.
#### Sector 2
- Changed: Defeating Zazabi turns all zoros into cocoons, and defeating Yakuza or Nettori turns all zoros and cocoons into kihunters.
- Changed: Data Hub Access: Add kihunters and zoro cocoons to intact room state.
- Changed: Zoro Zig-Zag: Zoro cocoons no longer block morph ball tunnels.
- Changed: Central Shaft:
  - Make door to Reo Room functional in intact room state.
  - Remove lv0 door to Ripper Roost with an open hatch.
  - Move zoro and zoro cocoon out of the way of Ripper Roost.
  - Add kihunters and zoro cocoons to intact room state.
  - Limit zoro pathing to prevent climbing the room early with ice beam.
- Changed: Dessgeega Dormitory: Add kihunters and zoro cocoons to intact room state.
- Changed: Dessgeega Dormitory: Add a connection guarded by bomb blocks that leads into Shadow Moses Island.
- Changed: Zazabi Access: Add kihunters and zoro cocoons to intact room state.
- Changed: Nettori Access: Change winged kihunter below eyedoor to a grounded kihunter to allow climbing up frozen enemies to Nettori Arena.
- Changed: Nettori Access: Change the vines in the top part slightly to prevent kihunters from jumping through solid walls.
- Added: Entrance Hub Underside: Add pre-Zazabi room state with zoros.
- Changed: Data Hub: Bomb block paths can be accessed freely without destroying the entrance hatch.
- Changed: Eastern Shaft: Add a ledge to allow climbing frozen enemies from middle doors to top doors.
- Changed: Eastern Shaft: In the middle part, remove the bottom 2 vine blocks to make climbing up the room consistent with the Post-Nettori state.
- Changed: Ripper Roost: (Optional) Move the bottom crumble block up one tile to pr softlocks without bombs.
- Changed: Crumble City: (Optional) Replace one of the shot blocks in the morph tunnel below the top item with a crumble block to pr softlocks without bombs.
- Changed: Cultivation Station: (Optional) Change the single bomb block next to the Zoros to a shot block to pr a softlock without morph bombs.
#### Sector 3
- Changed: Enemies which normally only spawn after unlocking lv2 security now always spawn.
- Changed: Security Access: Sidehoppers do not spawn on the speedbooster runway.
- Changed: BOX Access: Repair the door to Bob's Room in the destroyed room state.
- Changed: BOX Arena: Repair the door to the Data Room in the destroyed room state.
- Changed: BOX Arena: Jumping up on the pillar after the fight now has slightly better visibility on the exit without Hi-Jump.
#### Sector 4
- Changed: Security Bypass: (Optional) Prevent several softlocks without morph bombs.
- Changed: Drain Pipe: Spawn puffer in all room states.
- Changed: Reservoir East: (Optional) Prevent several softlocks without morph bombs.
#### Sector 5
- Removed: Sector 5 is no longer wrecked by Nightmare; several specific rooms are changed to compromise the intact and wrecked states.
- Changed: Nightmare Training Grounds: Added speedbooster runway at the top of the room in the intact room state.
- Changed: Arctic Containment: Replace lv4 security door to Crow's Nest with a lv3 security door.
- Changed: Data Room: Upper half of the room is inaccessible from the bottom half and vice versa.
- Changed: Security Shaft East: Repair the door to Kago Blockade.
- Changed: Ripper Road: Replace lv0 door to Arctic Containment with an open hatch.
- Changed: Crow's Nest: Repair the door to Arctic Containment into a lv3 security door.
- Changed: Geron Checkpoint: (Randomizer only) Remove Geron, even when Power Bomb Data has been acquired.
#### Sector 6
- Changed: Zozoro Wine Cellar: (Optional) Change reforming bomb block in front of expansion tank to a never reforming bomb block to prevent being trapped by running out of power bombs.
- Changed: Big Shell 1: (Optional) Remove the crumble block into the long morph tunnel to prevent softlocks without power bombs.
- Changed: X-BOX Arena: Leave the top left door unlocked even if X-BOX has not been defeated.
- Changed: X-BOX Arena: Add a shot block above the crumble blocks to prevent accidentally being trapped in the arena.

### Miscellaneous modifications
- Changed: Rewrite demo functionality for more equipment customizability.
- Changed: Always show in-game time on the map menu.
- Added: Optional setting to reveal full map information after downloading the sector's map, including hidden tiles, collectibles, and security doors. It will also center the map when paused.
- Changed: Credits roll now has full ASCII support.
- Removed: Item collection counters no longer appear on pause menu.
- Added: Game completion time in credits now displays seconds.
- Changed: Completion percentage in credits is now calculated by counting obtained item locations.
- Changed: Optimized item collection info to be faster and more memory efficient.
- Changed: Optimized wave beam movement and power bomb explosion code by not using floating point arithmetic in software.
