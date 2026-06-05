package engine

import "core:fmt"
import "core:strings"
import sdl "vendor:sdl3"

draw_debug_text :: proc(e: ^Engine, color: Color, x: f32, y: f32, args: ..any) {
	r, g, b, a: u8 = 0, 0, 0, 0
	sdl.GetRenderDrawColor(e.renderer, &r, &g, &b, &a)

	sdl.SetRenderDrawColor(e.renderer, color.r, color.g, color.b, color.a)

	text := fmt.tprint(..args)
	lines := strings.split(text, "\n", context.temp_allocator)

	y_offset: f32 = 0.0
	for line in lines {
		sdl.RenderDebugText(
			e.renderer,
			x,
			y + y_offset,
			strings.clone_to_cstring(line, context.temp_allocator),
		)
		y_offset += 10.0
	}

	sdl.SetRenderDrawColor(e.renderer, r, g, b, a)
}
