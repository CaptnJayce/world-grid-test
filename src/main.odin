package main

import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "World Grid Test")
	defer rl.CloseWindow()
	rl.SetTargetFPS(120)

	init_all()

	for !rl.WindowShouldClose() {
		player_prev_pos = {p.bounds.x, p.bounds.y}
		player_handler()
		mouse_handler()
		player_collision()

		if rl.IsKeyPressed(.O) {
			save_tiles()
		}

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)
		rl.BeginMode2D(camera)

		draw_all()

		rl.EndMode2D()
	}
}
