package main

import "core:fmt"
import rl "vendor:raylib"

// screen
SCREEN_WIDTH :: 1200
SCREEN_HEIGHT :: 800

// level bounds
// ensure always evenly divisble by TILE_SIZE
LEVEL_WIDTH :: 592
LEVEL_HEIGHT :: 400
LEVEL_TWO_WIDTH :: 352
LEVEL_TWO_HEIGHT :: 320
LEVEL_THREE_WIDTH :: 592
LEVEL_THREE_HEIGHT :: 992

// tiles
TILE_SIZE :: 16

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

init_player :: proc() {
	p.bounds = {0, 0, 30, 50}
	p.texture = {160, 100, 100, 255}
	p.speed = 300.0
}

camera: rl.Camera2D
init_camera :: proc() {
	camera = {
		target   = {p.bounds.x + p.bounds.width / 2, p.bounds.y + p.bounds.height / 2},
		offset   = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2},
		rotation = 0,
		zoom     = 2.0,
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
		init_tilemap()
		level_changed = false
	}
}

player_prev_pos := rl.Vector2{}
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

player_collision :: proc() {
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			tile := tm.tiles[row][col]

			if rl.CheckCollisionRecs(p.bounds, tile.rect) {
				p.bounds.x = player_prev_pos.x
				p.bounds.y = player_prev_pos.y
			}
		}
	}
}

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
		player_collision()

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode2D(camera)

		rl.DrawRectangleLinesEx(current_bounds^, 2, rl.WHITE)
		draw_tilemap()

		rl.DrawRectangleRec(p.bounds, p.texture)
		rl.EndMode2D()
	}
}
