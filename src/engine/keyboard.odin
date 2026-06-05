package engine

import sdl "vendor:sdl3"

KEY_COUNT :: 512


Keyboard :: struct {
	curr: [KEY_COUNT]bool,
	prev: [KEY_COUNT]bool,
}

_keyboard_event :: proc(k: ^Keyboard, ev: sdl.Event) {
	sc := int(ev.key.scancode)
	if ev.type == .KEY_DOWN do k.curr[sc] = true
	if ev.type == .KEY_UP do k.curr[sc] = false
}

key_held :: proc(e: ^Engine, sc: sdl.Scancode) -> bool {
	return e.keyboard.curr[int(sc)]
}

key_pressed :: proc(e: ^Engine, sc: sdl.Scancode) -> bool {
	return e.keyboard.curr[int(sc)] && !e.keyboard.prev[int(sc)]
}

key_released :: proc(e: ^Engine, sc: sdl.Scancode) -> bool {
	return !e.keyboard.curr[int(sc)] && e.keyboard.prev[int(sc)]
}
