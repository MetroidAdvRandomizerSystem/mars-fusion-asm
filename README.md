## Metroid Advance Randomizer System
This repository contains the ASM changes needed in order to build a new Metroid Fusion ROM that allows, among other things, randomization.  
To actually randomize things, you will need to use the [Python patcher](https://github.com/MetroidAdvRandomizerSystem/mars-patcher) instead.

### Running from Source

#### Prerequisites

##### Unix
- Build [armips](https://github.com/Kingcom/armips) from source, and put the resulting binary into your PATH
- Put [FLIPS](https://github.com/Alcaro/Flips/releases) into your PATH

##### Windows
- Build [armips](https://github.com/Kingcom/armips) from source, and put the resulting binary into the `tools` folder as `armips-a8d71f0.exe`
- Put [FLIPS](https://github.com/Alcaro/Flips/releases) into the `tools` folder as `flips.exe`

#### Compiling
To compile, place your US copy of Metroid Fusion into the root of the repo as `metroid4.gba` and then run `make`. This will spit out a new ROM into `bin/m4rs.gba`.  
By running `make dist` you will additionally get an IPS patch of the base patch, as well as for some optional changes.

To get a list of all assembly flags, you can check out [this file](https://github.com/MetroidAdvRandomizerSystem/MARS-Fusion/blob/main/src/main.s).
