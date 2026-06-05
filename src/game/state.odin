package game

import "../engine"
import "../shared"

Game_State :: struct {
	current_map: ^shared.Map,
}

init :: proc(e: ^engine.Engine) -> Game_State {
	return {current_map = &shared.GLOBAL.loaded_maps[0]}
}

update :: proc(state: ^Game_State, e: ^engine.Engine) -> Maybe(shared.State_Kind) {
	return nil
}

draw :: proc(state: ^Game_State, e: ^engine.Engine) {
	engine.draw_debug_text(
		e,
		engine.EMBER,
		cast(f32)e.width / 2.0 - 8 * 27 / 2,
		cast(f32)e.height / 2.0,
		"this is looking good so far",
	)

	draw_map(state.current_map, e)
}

destroy :: proc(state: ^Game_State, e: ^engine.Engine) {
}
