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
	load_tiles("tiles.bin")

	for !rl.WindowShouldClose() {
		level_handler()

		player_prev_pos = {p.bounds.x, p.bounds.y}
		player_handler()
		mouse_handler()
		player_collision()

		if rl.IsKeyPressed(.O) {
			save_tiles("tiles.bin")
		}

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode2D(camera)

		draw_all()

		rl.EndMode2D()
	}
}
