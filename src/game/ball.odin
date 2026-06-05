package game

import "../engine"
import "../shared"
import "core:math"

BALL_RADIUS :: 8.0
BALL_SPEED :: 300.0
MAX_BALL_SPEED :: 800.0

Ball :: struct {
	pos:   [2]f32,
	vel:   [2]f32,
	alive: bool,
}

create_ball :: proc(x, y: f32, angle_rad: f32) -> Ball {
	return {
		pos = {x, y},
		vel = {math.cos(angle_rad) * BALL_SPEED, math.sin(angle_rad) * BALL_SPEED},
		alive = true,
	}
}

update_ball :: proc(e: ^engine.Engine, b: ^Ball, m: ^shared.Map) {
	resolve_ball_map_collision(b, m, e)
}

draw_ball :: proc(e: ^engine.Engine, b: ^Ball) {
	engine.draw_rect(
		e,
		b.pos.x - BALL_RADIUS,
		b.pos.y - BALL_RADIUS,
		BALL_RADIUS * 2,
		BALL_RADIUS * 2,
		engine.CANDLELIGHT,
	)
}

ball_hits_player :: proc(b: ^Ball, p: ^Player) -> bool {
	return(
		b.pos.x + BALL_RADIUS > p.pos.x &&
		b.pos.x - BALL_RADIUS < p.pos.x + PLAYER_W &&
		b.pos.y + BALL_RADIUS > p.pos.y &&
		b.pos.y - BALL_RADIUS < p.pos.y + PLAYER_H \
	)
}

deflect :: proc(b: ^Ball, p: ^Player) {
	overlap_x := (BALL_RADIUS + PLAYER_W / 2) - abs(b.pos.x - (p.pos.x + PLAYER_W / 2))
	overlap_y := (BALL_RADIUS + PLAYER_H / 2) - abs(b.pos.y - (p.pos.y + PLAYER_H / 2))

	if overlap_x < overlap_y {
		b.vel.x = -b.vel.x
	} else {
		b.vel.y = -b.vel.y
	}

	b.vel.x += p.vel.x * 0.5
	b.vel.y += p.vel.y * 0.5

	speed := math.sqrt(b.vel.x * b.vel.x + b.vel.y * b.vel.y)
	if speed > MAX_BALL_SPEED {
		b.vel.x = b.vel.x / speed * MAX_BALL_SPEED
		b.vel.y = b.vel.y / speed * MAX_BALL_SPEED
	}
}

EPSILON :: 0.01

resolve_ball_map_collision :: proc(b: ^Ball, m: ^shared.Map, e: ^engine.Engine) {
	tile_size := get_map_tile_size(m, e)

	dx := b.vel.x * e.dt
	dy := b.vel.y * e.dt

	min_tx := int((b.pos.x - BALL_RADIUS) / tile_size)
	max_tx := int((b.pos.x + BALL_RADIUS) / tile_size)
	min_ty := int((b.pos.y - BALL_RADIUS) / tile_size)
	max_ty := int((b.pos.y + BALL_RADIUS) / tile_size)

	if dx > 0 do max_tx = int((b.pos.x + BALL_RADIUS + dx) / tile_size)
	if dx < 0 do min_tx = int((b.pos.x - BALL_RADIUS + dx) / tile_size)

	for ty in min_ty ..= max_ty {
		for tx in min_tx ..= max_tx {
			if !shared.is_solid(shared.get_tile(m, tx, ty)) do continue
			tile_left := f32(tx) * tile_size
			tile_right := tile_left + tile_size

			t: f32
			if dx > 0 do t = (tile_left - (b.pos.x + BALL_RADIUS)) / dx
			if dx < 0 do t = (tile_right - (b.pos.x - BALL_RADIUS)) / dx

			if t >= 0 && t <= 1 {
				b.pos.x += dx * t
				b.vel.x = -b.vel.x
				dx = dx * (1 - t) * -1
			}
			break
		}
	}

	b.pos.x += dx

	min_tx = int((b.pos.x - BALL_RADIUS) / tile_size)
	max_tx = int((b.pos.x + BALL_RADIUS) / tile_size)
	min_ty = int((b.pos.y - BALL_RADIUS) / tile_size)
	max_ty = int((b.pos.y + BALL_RADIUS) / tile_size)

	if dy > 0 do max_ty = int((b.pos.y + BALL_RADIUS + dy) / tile_size)
	if dy < 0 do min_ty = int((b.pos.y - BALL_RADIUS + dy) / tile_size)

	for ty in min_ty ..= max_ty {
		for tx in min_tx ..= max_tx {
			if !shared.is_solid(shared.get_tile(m, tx, ty)) do continue
			tile_top := f32(ty) * tile_size
			tile_bottom := tile_top + tile_size

			t: f32
			if dy > 0 do t = (tile_top - (b.pos.y + BALL_RADIUS)) / dy
			if dy < 0 do t = (tile_bottom - (b.pos.y - BALL_RADIUS)) / dy

			if t >= 0 && t <= 1 {
				b.pos.y += dy * t
				b.vel.y = -b.vel.y
				dy = dy * (1 - t) * -1
			}
			break
		}
	}

	b.pos.y += dy
}
