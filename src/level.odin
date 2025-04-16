package main

import rl "vendor:raylib"

// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 592
LEVEL_HEIGHT :: 400
LEVEL_TWO_WIDTH :: 352
LEVEL_TWO_HEIGHT :: 320
LEVEL_THREE_WIDTH :: 592
LEVEL_THREE_HEIGHT :: 992

LevelOne :: struct {
	levelBounds: rl.Rectangle,
}
lv_one: LevelOne

LevelTwo :: struct {
	levelBounds: rl.Rectangle,
}
lv_two: LevelTwo

LevelThree :: struct {
	levelBounds: rl.Rectangle,
}
lv_three: LevelThree

current_level: int
current_bounds: ^rl.Rectangle
init_levels :: proc() {
	current_level = 1
	current_bounds = &lv_one.levelBounds

	lv_one.levelBounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}

	lv_two.levelBounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_TWO_WIDTH,
		height = LEVEL_TWO_HEIGHT,
	}

	lv_three.levelBounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_THREE_WIDTH,
		height = LEVEL_THREE_HEIGHT,
	}
}

level_handler :: proc() {
	level_changed := false

	if rl.IsKeyPressed(.ONE) {
		current_level = 1
		p.bounds.x = 50
		p.bounds.y = 50
		level_changed = true
	}
	if rl.IsKeyPressed(.TWO) {
		current_level = 2
		p.bounds.x = 50
		p.bounds.y = 50
		level_changed = true
	}
	if rl.IsKeyPressed(.THREE) {
		current_level = 3
		p.bounds.x = 50
		p.bounds.y = 50
		level_changed = true
	}

	switch current_level {
	case 1:
		current_bounds = &lv_one.levelBounds
	case 2:
		current_bounds = &lv_two.levelBounds
	case 3:
		current_bounds = &lv_three.levelBounds
	}

	if level_changed == true {
		load_tiles("tiles.bin")
		level_changed = false
	}
}
