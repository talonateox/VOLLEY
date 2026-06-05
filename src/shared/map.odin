package shared

import "core:os"
import "core:strconv"
import "core:strings"

Map_Error :: enum u32 {
	Failed_To_Open_File,
	Map_Too_Big,
	Malformed_Map_Meta,
	Malformed_Map_Data,
}

Tile_Type :: enum u8 {
	AIR   = 0,
	WALL  = 1,
	FLOOR = 2,
}

Map :: struct {
	w, h:  int,
	name:  string,
	tiles: []Tile_Type,
}

get_tile :: proc(tiles: []Tile_Type, x, y: u32) {

}

load_map :: proc(path: string) -> (Map, Map_Error) {
	src_raw, ferr := os.read_entire_file_from_path(path, context.allocator)
	if ferr != nil {
		return {}, .Failed_To_Open_File
	}

	src := strings.clone_from_bytes(src_raw, context.temp_allocator)
	data_lines := strings.split_lines(src, context.temp_allocator)

	meta := strings.split(data_lines[0], " ", context.temp_allocator)
	if len(meta) != 3 {
		return {}, .Malformed_Map_Meta
	}

	w, wok, h, hok := strconv.parse_int(meta[0]), strconv.parse_int(meta[1])
	if !wok || !hok {
		return {}, .Malformed_Map_Meta
	}

	name := meta[2]

	if len(data_lines) - 1 != h {
		return {}, .Malformed_Map_Data
	}

	tiles := make([]Tile_Type, w * h)

	y := 0
	for row in data_lines[1:] {
		x := 0
		col, _ := strings.split(row, " ", context.temp_allocator)
		if len(col) != w {
			delete(tiles)
			return {}, .Malformed_Map_Data
		}

		for tile in col {
			tile_type_val, ok := strconv.parse_u64(tile)
			if !ok {
				delete(tiles)
				return {}, .Malformed_Map_Data
			}

			tile_type := cast(Tile_Type)tile_type_val
			tiles[y * w + x] = tile_type

			x += 1
		}

		y += 1
	}

	return {w = w, h = h, name = name, tiles = tiles}, nil
}
