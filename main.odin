package main

import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "World Grid Test")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)

	init_player()
	init_levels()
	init_camera()
	init_tilemap()

	for !rl.WindowShouldClose() {
		level_handler()

		player_prev_pos = {p.bounds.x, p.bounds.y}
		player_handler()
		mouse_handler()
		player_collision()
		edit_tilemap()

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode2D(camera)

		rl.DrawRectangleLinesEx(current_bounds^, 2, rl.WHITE) // bounds
		draw_tilemap() // tilemap
		rl.DrawRectangleRec(p.bounds, p.texture) // player
		rl.DrawRectangleRec(mouse_rect, rl.WHITE) // mouse
		rl.EndMode2D()
	}
}
