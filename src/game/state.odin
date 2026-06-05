package game

import "../engine"
import "../shared"

Game_State :: struct {
	current_map: ^shared.Map,
	player:      Player,
	ball:        Ball,
}

init :: proc(e: ^engine.Engine) -> Game_State {
	return {
		current_map = &shared.GLOBAL.loaded_maps[0],
		player = create_player(50, 50),
		ball = create_ball(100, 50, 10),
	}
}

update :: proc(state: ^Game_State, e: ^engine.Engine) -> Maybe(shared.State_Kind) {
	update_player(e, &state.player, state.current_map)
	update_ball(e, &state.ball, state.current_map)

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
	draw_player(e, &state.player)
	draw_ball(e, &state.ball)
}

destroy :: proc(state: ^Game_State, e: ^engine.Engine) {
}
