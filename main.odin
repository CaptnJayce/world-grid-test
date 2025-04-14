package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800

// level bounds
LEVEL_WIDTH :: 600
LEVEL_HEIGHT :: 600
LEVEL_TWO_WIDTH :: 800
LEVEL_TWO_HEIGHT :: 1000
LEVEL_THREE_WIDTH :: 1800
LEVEL_THREE_HEIGHT :: 2000

Player :: struct {
	bounds:  rl.Rectangle,
	texture: rl.Color,
	speed:   f32,
}
p: Player

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
		x      = (SCREEN_HEIGHT - LEVEL_WIDTH) / 2,
		y      = (SCREEN_HEIGHT - LEVEL_HEIGHT) / 2,
		width  = LEVEL_WIDTH,
		height = LEVEL_HEIGHT,
	}

	lv_two.levelBounds = {
		x      = (SCREEN_HEIGHT - LEVEL_TWO_WIDTH) / 2,
		y      = (SCREEN_HEIGHT - LEVEL_TWO_HEIGHT) / 2,
		width  = LEVEL_TWO_WIDTH,
		height = LEVEL_TWO_HEIGHT,
	}

	lv_three.levelBounds = {
		x      = (SCREEN_HEIGHT - LEVEL_TWO_WIDTH) / 2,
		y      = (SCREEN_HEIGHT - LEVEL_TWO_HEIGHT) / 2,
		width  = LEVEL_THREE_WIDTH,
		height = LEVEL_THREE_HEIGHT,
	}
}

init_player :: proc() {
	p.bounds = {300, 300, 60, 100}
	p.texture = {160, 100, 100, 255}
	p.speed = 500.0
}

camera: rl.Camera2D
init_camera :: proc() {
	camera = {
		target   = {p.bounds.x + p.bounds.width / 2, p.bounds.y + p.bounds.height / 2}, // Center on player
		offset   = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}, // Camera's center on screen
		rotation = 0,
		zoom     = 1.0,
	}
}

level_handler :: proc() {
	if rl.IsKeyPressed(.ONE) {
		current_level = 1
		p.bounds.x = 200
		p.bounds.y = 200
	}
	if rl.IsKeyPressed(.TWO) {
		current_level = 2
		p.bounds.x = 200
		p.bounds.y = 200
	}
	if rl.IsKeyPressed(.THREE) {
		current_level = 3
		p.bounds.x = 200
		p.bounds.y = 200
	}

	switch current_level {
	case 1:
		current_bounds = &lv_one.levelBounds
	case 2:
		current_bounds = &lv_two.levelBounds
	case 3:
		current_bounds = &lv_three.levelBounds
	}
}

player_handler :: proc() {
	deltaTime := rl.GetFrameTime()
	moveDir := rl.Vector2{}

	if rl.IsKeyDown(.LEFT) || rl.IsKeyDown(.A) do moveDir.x -= 1
	if rl.IsKeyDown(.RIGHT) || rl.IsKeyDown(.D) do moveDir.x += 1
	if rl.IsKeyDown(.UP) || rl.IsKeyDown(.W) do moveDir.y -= 1
	if rl.IsKeyDown(.DOWN) || rl.IsKeyDown(.S) do moveDir.y += 1

	if moveDir.x != 0 && moveDir.y != 0 {
		moveDir = rl.Vector2Normalize(moveDir)
	}

	newX := p.bounds.x + moveDir.x * p.speed * deltaTime
	newY := p.bounds.y + moveDir.y * p.speed * deltaTime

	if newX >= current_bounds.x &&
	   newX <= current_bounds.x + current_bounds.width - p.bounds.width {
		p.bounds.x = newX
	}
	if newY >= current_bounds.y &&
	   newY <= current_bounds.y + current_bounds.height - p.bounds.height {
		p.bounds.y = newY
	}

	if (p.bounds.x >= current_bounds.x &&
		   p.bounds.x <= current_bounds.x + current_bounds.width - p.bounds.width &&
		   p.bounds.y >= current_bounds.y &&
		   p.bounds.y <= current_bounds.y + current_bounds.height - p.bounds.height) {
		camera.target = {p.bounds.x + p.bounds.width / 2, p.bounds.y + p.bounds.height / 2}
	}
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "World Grid Test")
	defer rl.CloseWindow()

	rl.SetTargetFPS(120)

	init_player()
	init_levels()
	init_camera()

	for !rl.WindowShouldClose() {
		level_handler()
		player_handler()

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode2D(camera)
		rl.DrawRectangleLinesEx(current_bounds^, 2, rl.WHITE)
		rl.DrawRectangleRec(p.bounds, p.texture)
		rl.EndMode2D()
	}
}
