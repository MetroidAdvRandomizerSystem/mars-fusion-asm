; Edits to tilesets for corrections to room tiles

/* Notes:
* Tileset data is LZ compressed. You can export as RAW from MAGE, and then use
    MAGE's tools -> Compression -> LZ77 Compress File to compress it. If you do
    not care to save the original data, you may save over the orignal file.
    A user macro has been provided for ease of importing. See `inc/macros.inc`
    for more information.
```example
.org TilesetEntry + (TilesetEntry_Size * XXh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx @LabelName, "path/to/data.gfx", YYYYh
```

* Tilemaps follow the following format, however it has been provided as a
    user macro as well.

; importing same size or smaller data
.org @TilemapXX ; readptr(TilesetEntry + (TilesetEntry_Size * XXh) + TilesetEntry_TilemapPointer)
.area YYYY      ; Size of original data
    ;header
    .db     02h             ;fixed value
    .db     tilemap_height  ; calculated as: (total number of 8x8 tiles) / 128
.incbin "path/to/data.bin"
    .dw     00              ; end of data marker
.endarea

    OR

    tilemap @LabelName, "path/to/data.bin", YYYYh ; importing and marking old data as free space. Add 4 bytes to tilemap data to include header/footer.
*/


; Tileset 08 - Main Deck Hallways
.org TilesetEntry + (TilesetEntry_Size * 08h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset08RlebgGfx, "data/tilesets/tileset-08.gfx", 113Eh

.org TilesetEntry + (TilesetEntry_Size * 08h) + TilesetEntry_TilemapPointer
    tilemap @Tileset08Tilemap, "data/tilemaps/08-maindeck-hallways.bin", 900h


; Tileset 0B-1E - BSL Grated Hallways
.org TilesetEntry + (TilesetEntry_Size * 0Bh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset0B1ERlebgGfx, "data/tilesets/tileset-0B-1E.gfx", 1BE9h

.org TilesetEntry + (TilesetEntry_Size * 0Bh) + TilesetEntry_TilemapPointer
    tilemap @Tileset0B1ETilemap, "data/tilemaps/0B-1E-bsl-grated-hallways.bin", 0E04h

.org TilesetEntry + (TilesetEntry_Size * 1Eh) + TilesetEntry_RlebgGfxPointer
.area 4
    .dw     @Tileset0B1ERlebgGfx
.endarea
.org TilesetEntry + (TilesetEntry_Size * 1Eh) + TilesetEntry_TilemapPointer
.area 4
    .dw     @Tileset0B1ETilemap
.endarea


; Tileset 0D - Recharge Rooms
.org readptr(TilesetEntry + (TilesetEntry_Size * 0Dh) + TilesetEntry_TilemapPointer)
.area 3588
    .skip 2
.incbin "data/tilemaps/0D-recharge-room.bin"
    .skip 2
.endarea


; Tileset 0F - Data Rooms
.org readptr(TilesetEntry + (TilesetEntry_Size * 0Fh) + TilesetEntry_TilemapPointer)
.area 4228
    .skip 2
.incbin "data/tilemaps/0F-data-room.bin"
    .skip 2
.endarea


; Tileset 1B - Main Deck Dark Tunnels
.org TilesetEntry + (TilesetEntry_Size * 1Bh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset1BRlebgGfx, "data/tilesets/tileset-1B.gfx", 1BB5h

.org TilesetEntry + (TilesetEntry_Size * 1Bh) + TilesetEntry_TilemapPointer
    tilemap @Tileset1BTilemap, "data/tilemaps/1B-maindeck-maintenance-tunnels.bin", 0D84h


; Tileset 20 - Sector 2 Lush Greenery
.org TilesetEntry + (TilesetEntry_Size * 20h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset20RlebgGfx, "data/tilesets/tileset-20.gfx", 47DFh

.org TilesetEntry + (TilesetEntry_Size * 20h) + TilesetEntry_TilemapPointer
    tilemap @Tileset20Tilemap, "data/tilemaps/20-tro-lush-greenery.bin", 0C04h


; Tileset 21 - Sector 3 Yellow Rooms
.org TilesetEntry + (TilesetEntry_Size * 21h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset21RlebgGfx, "data/tilesets/tileset-21.gfx", 15DCh

.org TilesetEntry + (TilesetEntry_Size * 21h) + TilesetEntry_TilemapPointer
    tilemap @Tileset21Tilemap, "data/tilemaps/21-pyr-yellow-rooms.bin", 1004h


; Tileset 28 - Sector 3 Orange Rooms
.org TilesetEntry + (TilesetEntry_Size * 28h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset28RlebgGfx, "data/tilesets/tileset-28.gfx", 17A9h

.org TilesetEntry + (TilesetEntry_Size * 28h) + TilesetEntry_TilemapPointer
    tilemap @Tileset28Tilemap, "data/tilemaps/28-pyr-orange-rooms.bin", 1004h


; Tileset 29 - Main Deck Dark Tunnels
.org TilesetEntry + (TilesetEntry_Size * 29h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset29RlebgGfx, "data/tilesets/tileset-29.gfx", 3112h

.org TilesetEntry + (TilesetEntry_Size * 29h) + TilesetEntry_TilemapPointer
    tilemap @Tileset29Tilemap, "data/tilemaps/29-srx-terrain.bin", 1084h


; Tileset 2B & 2F - Sector 4 Upper
.org TilesetEntry + (TilesetEntry_Size * 2Bh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset2B2FRlebgGfx, "data/tilesets/tileset-2B-2F.gfx", 2656h

.org TilesetEntry + (TilesetEntry_Size * 2Bh) + TilesetEntry_TilemapPointer
    tilemap @Tileset2B2FTilemap, "data/tilemaps/2B-2F-aqa-upper.bin", 1684h

.org TilesetEntry + (TilesetEntry_Size * 2Fh) + TilesetEntry_RlebgGfxPointer
.area 4
    .dw     @Tileset2B2FRlebgGfx
.endarea
.org TilesetEntry + (TilesetEntry_Size * 2Fh) + TilesetEntry_TilemapPointer
.area 4
    .dw     @Tileset2B2FTilemap
.endarea


; Tileset 30 - Sector 5 Non-frozen rooms
.org TilesetEntry + (TilesetEntry_Size * 30h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset30RlebgGfx, "data/tilesets/tileset-30.gfx", 34FFh

.org TilesetEntry + (TilesetEntry_Size * 30h) + TilesetEntry_TilemapPointer
    tilemap @Tileset30Tilemap, "data/tilemaps/30-arc-normal.bin", 1484h


; Tileset 31 - Sector 5 Frozen rooms
.org TilesetEntry + (TilesetEntry_Size * 31h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset31RlebgGfx, "data/tilesets/tileset-31.gfx", 2523h

.org TilesetEntry + (TilesetEntry_Size * 31h) + TilesetEntry_TilemapPointer
    tilemap @Tileset31Tilemap, "data/tilemaps/31-arc-frozen.bin", 1004h


; Tileset 34 - Sector 4 Lower
.org TilesetEntry + (TilesetEntry_Size * 34h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset34RlebgGfx, "data/tilesets/tileset-34.gfx", 2FF9h

.org TilesetEntry + (TilesetEntry_Size * 34h) + TilesetEntry_TilemapPointer
    tilemap @Tileset34Tilemap, "data/tilemaps/34-aqa-lower.bin", 1304h


; Tileset 3E - Sector 6 Rocky Areas
.org TilesetEntry + (TilesetEntry_Size * 3Eh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset3ERlebgGfx, "data/tilesets/tileset-3E.gfx", 218Bh

.org TilesetEntry + (TilesetEntry_Size * 3Eh) + TilesetEntry_TilemapPointer
    tilemap @Tileset3ETilemap, "data/tilemaps/3E-noc-rocky.bin", 1004h


; Tileset 43 & 44 - Generic Blue Rooms
.org TilesetEntry + (TilesetEntry_Size * 43h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx  @Tileset4344RlebgGfx, "data/tilesets/tileset-43-44.gfx", 0DF2h

.org TilesetEntry + (TilesetEntry_Size * 43h) + TilesetEntry_TilemapPointer
    tilemap @Tileset4344Tilemap, "data/tilemaps/43-44-blue-rooms.bin", 0E04h

.org TilesetEntry + (TilesetEntry_Size * 44h) + TilesetEntry_RlebgGfxPointer
.area 4
    .dw     @Tileset4344RlebgGfx
.endarea
.org TilesetEntry + (TilesetEntry_Size * 44h) + TilesetEntry_TilemapPointer
.area 4
    .dw     @Tileset4344Tilemap
.endarea


; Tileset 54 - Main Deck Restricted Lab Glass Tubes
.org TilesetEntry + (TilesetEntry_Size * 54h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx @Tileset54RlebgGfx, "data/tilesets/tileset-54.gfx", 0A5Bh

.org TilesetEntry + (TilesetEntry_Size * 54h) + TilesetEntry_TilemapPointer
    tilemap @Tileset54Tilemap, "data/tilemaps/54-restricted-lab-glass-tubes.bin", 0904h


; Tileset 58 - Sector 1 Tourian Area
.org TilesetEntry + (TilesetEntry_Size * 58h) + TilesetEntry_RlebgGfxPointer
    tilesetgfx @Tileset58RlebgGfx, "data/tilesets/tileset-58.gfx", 109Fh

.org TilesetEntry + (TilesetEntry_Size * 58h) + TilesetEntry_TilemapPointer
    tilemap @Tileset58Tilemap, "data/tilemaps/58-tourian.bin", 0E00h


; Tileset 5E - Sector Connector Glass Tubes
.org TilesetEntry + (TilesetEntry_Size * 5Eh) + TilesetEntry_RlebgGfxPointer
    tilesetgfx @Tileset5ERlebgGfx, "data/tilesets/tileset-5E.gfx", 0E2Dh

.org TilesetEntry + (TilesetEntry_Size * 5Eh) + TilesetEntry_TilemapPointer
    tilemap @Tileset5ETilemap, "data/tilemaps/5E-glass-tubes.bin", 0904h
