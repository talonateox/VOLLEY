package engine

WHITE :: Color{255, 255, 255, 255} // #FFFFFF
BLACK :: Color{0, 0, 0, 255} // #000000

VOID :: Color{46, 46, 67, 255} // #2E2E43
ASH :: Color{74, 75, 91, 255} // #4A4B5B
STONE :: Color{112, 123, 137, 255} // #707B89
MIST :: Color{169, 188, 191, 255} // #A9BCBF
FROST :: Color{230, 238, 237, 255} // #E6EEED
BONE :: Color{252, 251, 243, 255} // #FCFBF3

CANDLELIGHT :: Color{252, 235, 168, 255} // #FCEBA8
AMBER :: Color{245, 196, 124, 255} // #F5C47C
EMBER :: Color{227, 151, 100, 255} // #E39764
RUST :: Color{192, 104, 82, 255} // #C06852
BLOOD :: Color{157, 67, 67, 255} // #9D4343
MAROON :: Color{129, 54, 69, 255} // #813645
WINE :: Color{84, 34, 64, 255} // #542240
PITCH :: Color{42, 21, 45, 255} // #2A152D

DUSK :: Color{79, 45, 77, 255} // #4F2D4D
SHADOW :: Color{91, 58, 86, 255} // #5B3A56
PLUM :: Color{121, 78, 109, 255} // #794E6D

ABYSS :: Color{62, 76, 126, 255} // #3E4C7E
DEEP :: Color{73, 95, 148, 255} // #495F94
COBALT :: Color{90, 120, 178, 255} // #5A78B2
CORNFLOWER :: Color{115, 150, 213, 255} // #7396D5
SKY :: Color{127, 187, 220, 255} // #7FBBDC
SEAFOAM :: Color{170, 238, 234, 255} // #AAEEEA

CHARTREUSE :: Color{213, 248, 147, 255} // #D5F893
SAGE :: Color{150, 220, 127, 255} // #96DC7F
FERN :: Color{110, 192, 119, 255} // #6EC077
MOSS :: Color{78, 147, 99, 255} // #4E9363
PINE :: Color{60, 108, 84, 255} // #3C6C54
SWAMP :: Color{44, 80, 73, 255} // #2C5049

SLATE :: Color{52, 64, 79, 255} // #34404F
GUNMETAL :: Color{64, 89, 103, 255} // #405967
STEEL :: Color{92, 137, 149, 255} // #5C8995

Color :: struct #packed {
	r, g, b, a: u8,
}

color :: proc {
	color_from_rgb,
	color_from_rgba,
	color_from_hex,
}

color_from_rgb :: proc(r, g, b: u8) -> Color {
	return {r, g, b, 255}
}

color_from_rgba :: proc(r, g, b, a: u8) -> Color {
	return {r, g, b, a}
}

color_from_hex :: proc(hex: u32) -> Color {
	r := cast(u8)((hex & 0xff000000) >> 24)
	g := cast(u8)((hex & 0x00ff0000) >> 16)
	b := cast(u8)((hex & 0x0000ff00) >> 8)
	a := cast(u8)((hex & 0x000000ff))

	return {r, g, b, a}
}
