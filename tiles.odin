package main

import "core:fmt"
import rl "vendor:raylib"

TileFlags :: enum {
	Collidable = 0,
	Stone      = 1,
	Dirt       = 2,
}

Tile :: struct {
	id:      u16,
	variant: u8,
	flags:   bit_set[TileFlags;u8],
}

TileMap :: struct {
	width, height: int,
	tiles:         [][]TileFlags,
	texture:       rl.Texture2D,
}

init_tilemap :: proc() {
	// calculate tiles based on the current_levels bounds
	tile_grid_columns := current_bounds.width / TILE_SIZE
	tile_grid_rows := current_bounds.height / TILE_SIZE
	total_tiles := tile_grid_columns * tile_grid_rows
}

draw_tilemap :: proc() {
}

tiles :: proc() {
}
