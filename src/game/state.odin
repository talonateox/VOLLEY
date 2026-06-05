package game

import "../engine"
import "../shared"

Game_State :: struct {}

init :: proc(e: ^engine.Engine) -> Game_State {
	return {}
}

update :: proc(state: ^Game_State, e: ^engine.Engine) -> Maybe(shared.State_Kind) {
	return nil
}

draw :: proc(state: ^Game_State, e: ^engine.Engine) {
}

destroy :: proc(state: ^Game_State, e: ^engine.Engine) {
}
