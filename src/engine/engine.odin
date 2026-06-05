package engine

import "core:c"
import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"

Engine :: struct {
	window:        ^sdl.Window,
	renderer:      ^sdl.Renderer,
	running:       bool,
	width, height: int,
}

create :: proc(title: cstring, w, h: i32) -> (Engine, bool) {
	if !sdl.Init({.VIDEO, .AUDIO}) {
		fmt.eprintln("Failed to initialize SDL3, heres the reason: ", sdl.GetError())
		return {}, false
	}

	engine := Engine{}

	window_flags: sdl.WindowFlags = {}
	engine.window = sdl.CreateWindow(title, w, h, window_flags)
	if engine.window == nil {
		fmt.eprintln("Failed to create Window, heres the reason: ", sdl.GetError())
		return {}, false
	}

	engine.renderer = sdl.CreateRenderer(engine.window, nil)
	if engine.renderer == nil {
		fmt.eprintln("Failed to create Renderer, heres the reason: ", sdl.GetError())
		return {}, false
	}

	engine.running = true

	engine.width, engine.height = cast(int)w, cast(int)h

	return engine, true
}

destroy :: proc(e: ^Engine) {
	if e.renderer != nil do sdl.DestroyRenderer(e.renderer)
	if e.window != nil do sdl.DestroyWindow(e.window)

	sdl.Quit()
}

poll_events :: proc(e: ^Engine) {
	ev: sdl.Event

	for sdl.PollEvent(&ev) {
		#partial switch ev.type {
		case .QUIT:
			e.running = false
		case .WINDOW_RESIZED:
			_resized(e)
		}
	}
}

_resized :: proc(e: ^Engine) {
	w, h: c.int = 0, 0

	sdl.GetWindowSize(e.window, &w, &h)
	e.width, e.height = cast(int)w, cast(int)h
}

clear :: proc(e: ^Engine) {
	sdl.RenderClear(e.renderer)
}

present :: proc(e: ^Engine) {
	sdl.RenderPresent(e.renderer)
}

ticks_sec :: proc() -> f32 {
	return f32(sdl.GetTicks()) / 1000.0
}
