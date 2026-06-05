package main

import "engine"
import "game"
import "loading"
import "shared"

State :: union {
	loading.Loading_State,
	game.Game_State,
}

State_Manager :: struct {
	current_state: State,
	_engine:       ^engine.Engine,
}

create_state_manager :: proc(engine: ^engine.Engine) -> State_Manager {
	return {_engine = engine, current_state = loading.init(engine)}
}

destroy_state_manager :: proc(sm: ^State_Manager) {
	switch &v in sm.current_state {
	case loading.Loading_State:
		loading.destroy(&v, sm._engine)
	case game.Game_State:
		game.destroy(&v, sm._engine)
	}
}

update_state_manager :: proc(sm: ^State_Manager) {
	free_all(context.temp_allocator)

	next_state: Maybe(shared.State_Kind)

	switch &v in sm.current_state {
	case loading.Loading_State:
		next_state = loading.update(&v, sm._engine)
	case game.Game_State:
		next_state = game.update(&v, sm._engine)
	}

	if state, ok := next_state.?; ok {
		state_manager_swap(sm, state)
	}
}

draw_state_manager :: proc(sm: ^State_Manager) {
	engine.clear(sm._engine)

	switch &v in sm.current_state {
	case loading.Loading_State:
		loading.draw(&v, sm._engine)
	case game.Game_State:
		game.draw(&v, sm._engine)
	}

	engine.present(sm._engine)
}

state_manager_swap :: proc(sm: ^State_Manager, next_state: shared.State_Kind) {
	destroy_state_manager(sm)

	switch next_state {
	case .Loading:
		state := loading.init(sm._engine)
		sm.current_state = state
	case .Game:
		state := game.init(sm._engine)
		sm.current_state = state
	}
}
