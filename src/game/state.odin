package game

import "../engine"
import "../shared"
import "vendor:sdl3"

Game_State :: struct {}

init :: proc(e: ^engine.Engine) -> Game_State {
	return {}
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
}

destroy :: proc(state: ^Game_State, e: ^engine.Engine) {
}
