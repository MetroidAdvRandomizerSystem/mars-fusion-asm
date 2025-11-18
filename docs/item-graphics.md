# Item Graphics

The randomizer base makes it as a goal, to have every collectible item for the own game distinctly visible. The new graphics can be found in [`data/major-tanks.gfx`](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/main/data/major-tanks.gfx) which are uncompressed and raw.
Each item graphic consists of 4 frames per animation, which are played in order and looping (1, 2, 3, 4, 1, 2, 3, 4...).
In addition, each frame has its tiles laid out in this order: top left, top right, bottom left, bottom right.

Each item graphic can only use one of two possible palettes!
Palette 0: The first palette of the [Common BG Palette](https://labk.org/maps/app/?game=mf&region=u&map=data&filter=common+BG).
Palette 1: A custom palette that's written into each tileset's last available palette slot as well as the tile table of said tileset. You can find all the the tilesets that are changed for this [here](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/main/src/randomizer/tank-majors.s#L321) and the palette definition itself [there](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/main/inc/enums.inc#L671)

For convenience sake, the two palettes are shown below:
- ![palette0](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/doc/docs/item-graphics-palette-0.png?raw=true)
- ![palette1](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/doc/docs/item-graphics-palette-1.png?raw=true)

To add a new item graphic:
- modify the above mentioned gfx
- add a new entry to the [TankPalettes](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/main/src/randomizer/tank-majors.s#L287), writing the byte of the graphics' palette as well as a comment indicating what it is
- add an entry to the [UpgradeSprite](https://github.com/MetroidAdvRandomizerSystem/mars-fusion-asm/blob/a55335b11fd4ca78f6229f053ce5d707b2d1f1d9/inc/enums.inc#L591) enum.
Note that the latter two have to be synced.


