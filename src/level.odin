package main

import rl "vendor:raylib"

current_level: int
current_bounds: rl.Rectangle
init_levels :: proc() {
	current_level = 1

	current_bounds = {
		x      = 0,
		y      = 0,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}
}
