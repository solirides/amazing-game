class_name HexGrid
extends Node

enum Dir {
	LEFT,
	RIGHT,
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT
}

static func hex_to_cartesian(hex:Vector2i, scale:float) -> Vector2:
	var result = Vector2(hex.x * scale, hex.y * sqrt(3)/2.0 * scale)
	if abs(hex.y) % 2 == 1:
		result.x += scale / 2.0
	return result

static func get_neighbor(hex:Vector2i, direction:Dir, steps:int) -> Vector2i:
	var result = hex
	var parity = 0
	if hex.y % 2 == 1:
		parity = 1
	
	match direction:
		Dir.LEFT:
			result.x -= steps
		Dir.RIGHT:
			result.x += steps
		Dir.UP_LEFT:
			result.y -= steps
			result.x -= floor((steps + parity + 1)/2.0)
		Dir.UP_RIGHT:
			result.y -= steps
			result.x += floor((steps + parity)/2.0)
		Dir.DOWN_LEFT:
			result.y += steps
			result.x -= floor((steps + parity + 1)/2.0)
		Dir.DOWN_RIGHT:
			result.y += steps
			result.x += floor((steps + parity)/2.0)
	
	return result
	
