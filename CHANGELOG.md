# Changelog

## Unreleased - 2025-XX-XX

### Randomizer
- Fixed: Removed event based door transition from Reactor Silo.
- Fixed: Escape music now triggers properly.
- Fixed: Respawning after warping to start now loads your most recent save location if you Game Over.

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
* Changed: Allow all item locations (collectible tanks, security levels, data rooms, bosses) to be configured to contain any item.
* Changed: Data rooms and security rooms can be used at any point in time.
* Changed: Bosses can now be fought at any point in time, provided the player has access to the arena.
* Added: Unique collectible tank sprites for every item, including shiny variants of the missile tank and power bomb tank.
* Added: Collectible tank sprites can differ from the item they actually provide.
* Changed: Collectible tanks can display a configurable pickup fanfare message when collected.
* Changed: Anonymize all collectible tanks in demos.
* Added: Infant metroid item, a configurable number of which are required to spawn SA-X on Operations Deck and complete the game.
* Added: Nothing item, which has no effect upon collection.
* Added: Ice trap item, which freezes the player upon collection if varia suit is not active.
* Changed: On the Map screen, pressing A now shows you the name of your current room.
* Changed: Room states, background music, and other story flags are now dependent on combinations of progression flags (bosses defeated, terminals accessed, etc.) instead of a linear event counter.
* Changed: The first Adam dialogue is now configurable for the purpose of introducing the player to the randomizer and telling them other useful information.
* Changed: Navigation room terminals can be locked behind security levels.
* Changed: Navigation room terminals now provide configurable dialogue for the purpose of providing item location hints to the player.
* Changed: Credits roll is now configurable, intended for adding text after the vanilla credits, ex. randomizer credits, major item locations, etc.
* Changed: Initial energy, missile, and power bomb amounts and upgrade increments are now configurable.
* Changed: Escape sequence countdown only starts on entering Docking Bay Hangar.
* Changed: Having Screw Attack without Space Jump wil not let you Wall-Jump on a single wall anymore and instead behave the same as without Screw Attack.
* Added: The Map screen will now display on whether you have Lv-0 keycards collected.
* Added: Pressing select on the map menu rotates through the maps of each sector in numerical order.
* Added: Configurable start location and starting items.
* Added: Ability to warp to the starting location at any time, replacing the sleep mode menu. All progress since the last save is lost when warping.
* Removed: SA-X no longer patrols and chases the player through certain rooms.
* Removed: Boiler meltdown and reactor shutdown events no longer occur.
* Removed: Escape sequence no longer railroads the player towards the ship by locking doors.

### Gameplay modifications
* Changed: Reimplemented beam upgrades to stack on top of each other instead of only considering the highest obtained beam upgrade. Beam graphics are modified such that each beam combination can be easily differentiated at a glance.
  * Charge Beam: Allows the player to charge the beam, and buffs beam damage if only shooting one projectile.
  * Wide Beam: Shoots three beam projectiles, and adds a minor amount of damage.
  * Plasma Beam: Allows the beam to pierce enemies, reducing initial damage in favor of damage per tick.
  * Wave Beam: Allows the beam to pass through walls, and adds a significant amount of damage. Shots without wide beam also fire two projectiles instead of one.
  * Ice Beam: Freezes most enemies on contact, and adds a minor amount of damage.
* Changed: Reimplemented missile upgrades to stack on top of each other instead of only considering the highest obtained missile upgrade. Missile graphics are modified such that basic missiles have a purple tip, super missiles have a green tip, and super missiles take priority over the ice and diffusion missile graphics.
  * Main Missile Data: Allows the player to shoot missiles.
  * Super Missiles: Allows missiles to damage super missile gerons, and adds a major amount of damage and attack cooldown.
  * Ice Missiles: Freezes most enemies on contact, and adds a significant amount of damage and attack cooldown.
  * Diffusion Missiles: Allows the player to charge a radial area of effect freeze, but does not allow missiles to freeze enemies on contact. Adds a minor amount of damage and attack cooldown.
* Changed: Split the properties of varia suit and gravity suit. Damage reduction from enemies is incremental based on the number of suits obtained.
  * Varia Suit: Negates heat and cold damage, and reduces lava and acid damage by 40%. If gravity suit is also active, lava damage is negated.
  * Gravity Suit: Allows free movement in water and lava. Does not reduce environmental damage.
* Added: Configurable environmental damage per second.
* Added: Optional setting to allow use of power bombs without normal bombs.
* Added: Optional setting to allow use of missiles without main missile data.
* Added: Equipment enable/disable functionality to the Samus status menu.
* Added: Infant metroid counter to the Samus status menu.
* Changed: Reduced the amount of jump startup frames to allow Samus to destroy blocks directly above her head with screw attack.
* Changed: Sped up door transitions and elevators.
* Fixed: Vanilla aim lock bug where Samus's aim would get locked into a diagonal direction without holding the diagonal aim button.
* Fixed: Vanilla SA-X invulnerability softlocks in both Samus form and monster form.
* Changed: Slightly rework how Red-X drops work. Their chances for enemies have been bumped to 1.117%, and there is now a guaranteed drop when you ran out of PBs but have max health/missiles.

### Room modifications
#### Main Deck
* Added: Quarantine Bay: There is now a special Hornoad having a guaranteed Red-X drop.
* Removed: Restricted sector is always detached.
* Changed: Crew Quarters West: Remove power bomb geron to Elevator to Operations Deck.
* Changed: Operations Deck: Replace lv4 security door to Operations Room with a lv0 security door.
* Changed: Operations Deck: Allow missile hatch to be destroyed from both sides.
* Changed: Central Hub: Add power bomb geron to all room states.
* Changed: Eastern Hub: Remove missile geron in front of recharge station.
* Changed: Sector Hub: Keep main elevator active in all room states.
* Changed: Maintenance Shaft: Modify background tiles and add a missile geron to match the changes to Maintenance Crossing.
* Changed: Maintenance Crossing: Is now repaired and traversible, blocked by a missile geron.
* Changed: Silo Access: Move zoro cocoon out of the way of the path to reactor.
* Changed: Central Reactor Core: Add a platform between the doors to Silo Access and Silo Scaffolding A.
* Changed: Operations Room: Lv4 security door replaced with a Lv0 security door.
* Changed: Yakuza Arena: The Exit is now visible even if you haven't defeated Yakuza yet.
#### Sector 1
* Changed: Reactivating all atmospheric stabilizers changes the arrangements of some enemies.
* Changed: Metroid husks appear after collecting the required number of infant metroids.
* Changed: Hornoad Housing: The Hornoads aren't spawned in initially and instead have X flying in to form them.
#### Sector 2
* Changed: Defeating Zazabi turns all zoros into cocoons, and defeating Yakuza or Nettori turns all zoros and cocoons into kihunters.
* Changed: Data Hub Access: Add kihunters and zoro cocoons to intact room state.
* Changed: Zoro Zig-Zag: Zoro cocoons no longer block morph ball tunnels.
* Changed: Central Shaft:
  * Make door to Reo Room functional in intact room state.
  * Remove lv0 door to Ripper Roost with an open hatch.
  * Move zoro and zoro cocoon out of the way of Ripper Roost.
  * Add kihunters and zoro cocoons to intact room state.
  * Limit zoro pathing to prevent climbing the room early with ice beam.
* Changed: Dessgeega Dormitory: Add kihunters and zoro cocoons to intact room state.
* Changed: Dessgeega Dormitory: Add a connection guarded by bomb blocks that leads into Shadow Moses Island.
* Changed: Zazabi Access: Add kihunters and zoro cocoons to intact room state.
* Changed: Nettori Access: Change winged kihunter below eyedoor to a grounded kihunter to allow climbing up frozen enemies to Nettori Arena.
* Changed: Nettori Access: Change the vines in the top part slightly to prevent kihunters from jumping through solid walls.
* Added: Entrance Hub Underside: Add pre-Zazabi room state with zoros.
* Changed: Data Hub: Bomb block paths can be accessed freely without destroying the entrance hatch.
* Changed: Eastern Shaft: Add a ledge to allow climbing frozen enemies from middle doors to top doors.
* Changed: Eastern Shaft: In the middle part, remove the bottom 2 vine blocks to make climbing up the room consistent with the Post-Nettori state.
* Changed: Ripper Roost: (Optional) Move the bottom crumble block up one tile to pr softlocks without bombs.
* Changed: Crumble City: (Optional) Replace one of the shot blocks in the morph tunnel below the top item with a crumble block to pr softlocks without bombs.
* Changed: Cultivation Station: (Optional) Change the single bomb block next to the Zoros to a shot block to pr a softlock without morph bombs.
#### Sector 3
* Changed: Enemies which normally only spawn after unlocking lv2 security now always spawn.
* Changed: Security Access: Sidehoppers do not spawn on the speedbooster runway.
* Changed: BOX Access: Repair the door to Bob's Room in the destroyed room state.
* Changed: BOX Arena: Repair the door to the Data Room in the destroyed room state.
* Changed: BOX Arena: Jumping up on the pillar after the fight now has slightly better visibility on the exit without Hi-Jump.
#### Sector 4
* Changed: Security Bypass: (Optional) Prevent several softlocks without morph bombs.
* Changed: Drain Pipe: Spawn puffer in all room states.
* Changed: Reservoir East: (Optional) Prevent several softlocks without morph bombs.
#### Sector 5
* Removed: Sector 5 is no longer wrecked by Nightmare; several specific rooms are changed to compromise the intact and wrecked states.
* Changed: Nightmare Training Grounds: Added speedbooster runway at the top of the room in the intact room state.
* Changed: Arctic Containment: Replace lv4 security door to Crow's Nest with a lv3 security door.
* Changed: Data Room: Upper half of the room is inaccessible from the bottom half and vice versa.
* Changed: Security Shaft East: Repair the door to Kago Blockade.
* Changed: Ripper Road: Replace lv0 door to Arctic Containment with an open hatch.
* Changed: Crow's Nest: Repair the door to Arctic Containment into a lv3 security door.
* Changed: Geron Checkpoint: (Randomizer only) Remove Geron, even when Power Bomb Data has been acquired.
#### Sector 6
* Changed: Zozoro Wine Cellar: (Optional) Change reforming bomb block in front of expansion tank to a never reforming bomb block to prevent being trapped by running out of power bombs.
* Changed: Big Shell 1: (Optional) Remove the crumble block into the long morph tunnel to prevent softlocks without power bombs.
* Changed: X-BOX Arena: Leave the top left door unlocked even if X-BOX has not been defeated.
* Changed: X-BOX Arena: Add a shot block above the crumble blocks to prevent accidentally being trapped in the arena.

### Miscellaneous modifications
* Changed: Rewrite demo functionality for more equipment customizability.
* Changed: Always show in-game time on the map menu.
* Added: Optional setting to reveal full map information after downloading the sector's map, including hidden tiles, collectibles, and security doors. It will also center the map when paused.
* Changed: Credits roll now has full ASCII support.
* Removed: Item collection counters no longer appear on pause menu.
* Added: Game completion time in credits now displays seconds.
* Changed: Completion percentage in credits is now calculated by counting obtained item locations.
* Changed: Optimized item collection info to be faster and more memory efficient.
* Changed: Optimized wave beam movement and power bomb explosion code by not using floating point arithmetic in software.
