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
	tiles:         [][]Tile,
	texture:       rl.Texture2D,
}

tm: TileMap

tile_grid_columns: f32
tile_grid_rows: f32
total_tiles: f32
total_length: f32
total_height: f32
init_tilemap :: proc() {
	tm.width = int(current_bounds.width / TILE_SIZE)
	tm.height = int(current_bounds.height / TILE_SIZE)

	tm.tiles = make([][]Tile, tm.height)

	for row in 0 ..< tm.height {
		tm.tiles[row] = make([]Tile, tm.width)
		for col in 0 ..< tm.width {
			tm.tiles[row][col] = Tile {
				id      = 1,
				variant = 0,
				flags   = {.Stone, .Collidable},
			}
		}
	}
}

current_x: i32
current_y: i32
draw_tilemap :: proc() {
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			x := i32(col * TILE_SIZE)
			y := i32(row * TILE_SIZE)

			tile := tm.tiles[row][col]

			if .Stone in tile.flags {
				rl.DrawRectangle(x, y, TILE_SIZE, TILE_SIZE, rl.GRAY)
				fmt.println(x, y)
			} else if .Dirt in tile.flags {
				rl.DrawRectangle(x, y, TILE_SIZE, TILE_SIZE, rl.BROWN)
			}

			rl.DrawRectangleLines(x, y, TILE_SIZE, TILE_SIZE, rl.WHITE)
		}
	}
}
