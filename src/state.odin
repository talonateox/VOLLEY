package main

import "engine"
import "game"
import "loading"
import "shared"

State_Manager :: struct {
	current_state: shared.State_Kind,
	_engine:       ^engine.Engine,
	loading_state: loading.Loading_State,
	game_state:    game.Game_State,
}

create_state_manager :: proc(engine: ^engine.Engine) -> State_Manager {
	return {_engine = engine, current_state = .Loading, loading_state = loading.init(engine)}
}

destroy_state_manager :: proc(sm: ^State_Manager) {
	switch sm.current_state {
	case .Loading:
		loading.destroy(&sm.loading_state, sm._engine)
	case .Game:
		game.destroy(&sm.game_state, sm._engine)
	}
}

update_state_manager :: proc(sm: ^State_Manager) {
	next_state: Maybe(shared.State_Kind)

	switch sm.current_state {
	case .Loading:
		next_state = loading.update(&sm.loading_state, sm._engine)
	case .Game:
		next_state = game.update(&sm.game_state, sm._engine)
	}

	if state, ok := next_state.?; ok {
		state_manager_swap(sm, state)
	}
}

draw_state_manager :: proc(sm: ^State_Manager) {
	switch sm.current_state {
	case .Loading:
		loading.draw(&sm.loading_state, sm._engine)
	case .Game:
		game.draw(&sm.game_state, sm._engine)
	}
}

state_manager_swap :: proc(sm: ^State_Manager, next_state: shared.State_Kind) {
	destroy_state_manager(sm)

	sm.current_state = next_state

	switch sm.current_state {
	case .Loading:
		sm.loading_state = loading.init(sm._engine)
	case .Game:
		sm.game_state = game.init(sm._engine)
	}
}
