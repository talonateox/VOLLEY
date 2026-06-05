package engine

import sdl "vendor:sdl3"

Rect :: struct {
	x, y, w, h: f32,
	color:      Color,
}

draw_rect :: proc(e: ^Engine, x, y, w, h: f32, color: Color) {
	sdl.SetRenderDrawColor(e.renderer, color.r, color.g, color.b, color.a)
	r := sdl.FRect{x, y, w, h}
	sdl.RenderFillRect(e.renderer, &r)
}
