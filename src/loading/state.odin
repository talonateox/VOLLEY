package loading

import "../engine"
import "../shared"

import "core:fmt"

Loading_State :: struct {}

init :: proc(e: ^engine.Engine) -> Loading_State {
	return {}
}

update :: proc(state: ^Loading_State, e: ^engine.Engine) -> Maybe(shared.State_Kind) {
	if test_map, err := shared.load_map("assets/maps/test_map.vmp"); err == nil {
		append(&shared.GLOBAL.loaded_maps, test_map)
	} else {
		fmt.println("failed to load test_map due to: ", err)
	}

	fmt.println("loaded ", len(shared.GLOBAL.loaded_maps), " maps")

	return .Game
}

draw :: proc(state: ^Loading_State, e: ^engine.Engine) {

}

destroy :: proc(state: ^Loading_State, e: ^engine.Engine) {

}
