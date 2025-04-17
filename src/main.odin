package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "World Grid Test")
	defer rl.CloseWindow()
	rl.SetTargetFPS(120)

	init_all()

	for !rl.WindowShouldClose() {
		level_handler()

		player_prev_pos = {p.bounds.x, p.bounds.y}
		player_handler()
		mouse_handler()
		player_collision()

		if rl.IsKeyPressed(.O) {
			if current_level == 1 {
				save_tiles("level1_tiles.bin", current_level)
			}
			if current_level == 2 {
				save_tiles("level2_tiles.bin", current_level)
			}
			if current_level == 3 {
				save_tiles("level3_tiles.bin", current_level)
			}
		}

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		rl.BeginMode2D(camera)

		draw_all()

		rl.EndMode2D()
	}
}
