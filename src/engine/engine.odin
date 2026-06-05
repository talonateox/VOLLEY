package engine

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"

Engine :: struct {
	window:   ^sdl.Window,
	renderer: ^sdl.Renderer,
	running:  bool,
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
		}
	}
}

ticks_sec :: proc() -> f32 {
	return f32(sdl.GetTicks()) / 1000.0
}
