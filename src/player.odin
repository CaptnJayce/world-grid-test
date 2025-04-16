package main

import "core:fmt"
import rl "vendor:raylib"

Player :: struct {
	bounds:  rl.Rectangle,
	texture: rl.Color,
	speed:   f32,
}
p: Player
camera: rl.Camera2D
mouse_rect: rl.Rectangle = {}
player_prev_pos: rl.Vector2 = {}

init_player :: proc() {
	p.bounds = {0, 0, 25, 40}
	p.texture = {160, 100, 100, 255}
	p.speed = 300.0
}

init_camera :: proc() {
	camera = {
		target   = {p.bounds.x + p.bounds.width / 2, p.bounds.y + p.bounds.height / 2},
		offset   = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2},
		rotation = 0,
		zoom     = 2.0,
	}
}

mouse_handler :: proc() {
	mp := rl.GetScreenToWorld2D(rl.GetMousePosition(), camera)

	mouse_rect = {
		x      = mp.x - 2,
		y      = mp.y,
		width  = 4,
		height = 4,
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

player_collision :: proc() {
	for row in 0 ..< tm.height {
		for col in 0 ..< tm.width {
			tile := tm.tiles[row][col]

			if .Collidable in tile.flags && rl.CheckCollisionRecs(p.bounds, tile.rect) {
				p.bounds.x = player_prev_pos.x
				p.bounds.y = player_prev_pos.y
			}
		}
	}
}
