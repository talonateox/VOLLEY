package main

import "engine"

main :: proc() {
	e, ok := engine.create("VOLLEY", 1280, 720)
	defer engine.destroy(&e)

	if !ok {
		return
	}

	sm := create_state_manager(&e)
	defer destroy_state_manager(&sm)

	for e.running {
		engine.poll_events(&e)
		update_state_manager(&sm)
		draw_state_manager(&sm)
	}
}
