package game

import "../engine"
import "../shared"

get_map_tile_size :: proc(m: ^shared.Map, e: ^engine.Engine) -> f32 {
	return min(f32(e.width) / f32(m.w), f32(e.height) / f32(m.h))
}

draw_map :: proc(m: ^shared.Map, e: ^engine.Engine) {
	tile_size := get_map_tile_size(m, e)

	for tile, i in m.tiles {
		x := f32(i % m.w) * tile_size
		y := f32(i / m.w) * tile_size

		color: engine.Color
		switch tile {
		case .AIR:
			continue
		case .WALL:
			color = engine.STONE
		case .FLOOR:
			color = engine.ASH
		}

		engine.draw_rect(e, x, y, tile_size, tile_size, color)
	}
}
