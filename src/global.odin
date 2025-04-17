package main

// CONSTANTS
SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800

TILE_SIZE :: 16

// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 592
LEVEL_HEIGHT :: 400
LEVEL_TWO_WIDTH :: 352
LEVEL_TWO_HEIGHT :: 320
LEVEL_THREE_WIDTH :: 592
LEVEL_THREE_HEIGHT :: 992

init_all :: proc() {
	init_player()
	init_levels()
	init_camera()
	init_tilemap(current_level)
	load_tiles(fp, current_level)
}
