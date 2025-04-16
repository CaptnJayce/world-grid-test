package main

import rl "vendor:raylib"

draw_all :: proc() {
	rl.DrawRectangleLinesEx(current_bounds^, 2, rl.WHITE) // bounds
	draw_tilemap() // tilemap
	rl.DrawRectangleRec(p.bounds, p.texture) // player
	rl.DrawRectangleRec(mouse_rect, rl.WHITE) // mouse
}
