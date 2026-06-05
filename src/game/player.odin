package game

import "../engine"
import "../shared"

PLAYER_W :: 24
PLAYER_H :: 36

PLAYER_SPEED :: 0.06
ACCELERATION :: 0.2
FRICTION :: 0.5
GRAVITY :: 0.2
JUMP_FORCE :: -0.07
MAX_FALL_SPEED :: 0.9

Player :: struct {
	pos:       [2]f32,
	vel:       [2]f32,
	on_ground: bool,
}

create_player :: proc(x, y: f32) -> Player {
	return {pos = {x, y}}
}

update_player :: proc(e: ^engine.Engine, p: ^Player, m: ^shared.Map) {
	// horizontal
	if engine.key_held(e, .A) {
		p.vel.x -= ACCELERATION * e.dt
	} else if engine.key_held(e, .D) {
		p.vel.x += ACCELERATION * e.dt
	} else {
		// friction — decelerate toward zero
		if p.vel.x > 0 {
			p.vel.x = max(0, p.vel.x - FRICTION * e.dt)
		} else if p.vel.x < 0 {
			p.vel.x = min(0, p.vel.x + FRICTION * e.dt)
		}
	}

	// clamp horizontal speed
	p.vel.x = clamp(p.vel.x, -PLAYER_SPEED, PLAYER_SPEED)

	// jump
	if engine.key_pressed(e, .SPACE) && p.on_ground {
		p.vel.y = JUMP_FORCE
		p.on_ground = false
	}

	// gravity
	if !p.on_ground {
		p.vel.y = min(p.vel.y + GRAVITY * e.dt, MAX_FALL_SPEED)
	}

	p.on_ground = false
	resolve_map_collision(m, e, p)
}


draw_player :: proc(e: ^engine.Engine, p: ^Player) {
	engine.draw_rect(e, p.pos.x, p.pos.y, PLAYER_W, PLAYER_H, engine.EMBER)
}

resolve_map_collision :: proc(m: ^shared.Map, e: ^engine.Engine, player: ^Player) {
	tile_size := get_map_tile_size(m, e)

	player.pos.x += player.vel.x

	min_tx := int(player.pos.x / tile_size)
	max_tx := int((player.pos.x + PLAYER_W - 1) / tile_size)
	min_ty := int(player.pos.y / tile_size)
	max_ty := int((player.pos.y + PLAYER_H - 1) / tile_size)

	for ty in min_ty ..= max_ty {
		for tx in min_tx ..= max_tx {
			if !shared.is_solid(shared.get_tile(m, tx, ty)) do continue
			tile_left := f32(tx) * tile_size
			tile_right := tile_left + tile_size
			if player.vel.x > 0 do player.pos.x = tile_left - PLAYER_W
			if player.vel.x < 0 do player.pos.x = tile_right
			player.vel.x = 0
			break
		}
	}

	player.pos.y += player.vel.y

	min_tx = int(player.pos.x / tile_size)
	max_tx = int((player.pos.x + PLAYER_W - 1) / tile_size)
	min_ty = int(player.pos.y / tile_size)
	max_ty = int((player.pos.y + PLAYER_H - 1) / tile_size)

	for ty in min_ty ..= max_ty {
		for tx in min_tx ..= max_tx {
			if !shared.is_solid(shared.get_tile(m, tx, ty)) do continue
			tile_top := f32(ty) * tile_size
			tile_bottom := tile_top + tile_size
			if player.vel.y > 0 {
				player.pos.y = tile_top - PLAYER_H
				player.on_ground = true
			}
			if player.vel.y < 0 do player.pos.y = tile_bottom
			player.vel.y = 0
			break
		}
	}
}
