extends Node2D

@export var wall_node:Node
@export var turret_node:Node
@export var circle_display:Node
@export var circles = 0
@onready var info_label = $Label2

var filled_circle_coords = []
var filled_circle_hex = []

func _ready() -> void:
	GameManager.world = self
	GameManager.players_swapped.connect(swap_players)
	circle_display.connect("pulse_reached", turret_node._on_pulse_reached)
	
	create_grid(circles)
	create_collision_polygon()
	set_player_colors()

func create_circle(radius:float, res:int, sign:int = 0, offset:Vector2 = Vector2(0,0)):
	# make a circle
	var points = []
	var angle = 2*PI
	for i in range(res):
		points.append(Vector2(1,0).rotated(sign * angle / float(res) * i) * radius + offset)
	return points

func create_grid(radius:int):
	var hex_coords = []
	#var anchor = HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.LEFT, radius)
	
	for y in range(1, radius + 1):
		#print(y)
		#print(2*radius + 1 - abs(y))
		for x in range(0, 2*radius + 1 - abs(y)):
			var hex = HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.UP_RIGHT, y)
			hex = HexGrid.get_neighbor(hex, HexGrid.Dir.RIGHT, x - radius)
			hex_coords.append(hex)
	for y in range(0, radius + 1):
		for x in range(0, 2*radius + 1 - abs(y)):
			var hex = HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.DOWN_RIGHT, y)
			hex = HexGrid.get_neighbor(hex, HexGrid.Dir.RIGHT, x - radius)
			hex_coords.append(hex)
	
	#for i in range(5):
		#hex_coords.append(HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.UP_RIGHT, i))
		#hex_coords.append(HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.UP_LEFT, i))
		#hex_coords.append(HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.DOWN_RIGHT, i))
		#hex_coords.append(HexGrid.get_neighbor(Vector2i(0,0), HexGrid.Dir.DOWN_LEFT, i))
	
	var coords = []
	for hex in hex_coords:
		coords.append(HexGrid.hex_to_cartesian(hex, wall_node.inner_radius * 2 + 2))
	
	circle_display.filled_circle_coords = coords
	filled_circle_coords = coords
	
	#print(hex_coords)
	#print(coords)

func create_collision_polygon():
	var resolution = 40
	var shape:PackedVector2Array = PackedVector2Array(create_circle(3000, resolution, 1))
	var shapes = [[]]
	#for coords in [Vector2(100,100),Vector2(-100,-100)]:
	for coords in filled_circle_coords:
		var circle_shape = PackedVector2Array(create_circle(wall_node.inner_radius + 10, resolution, 1, coords))
		#shapes = Geometry2D.clip_polygons(shape, circle_shape)
		shapes = Geometry2D.merge_polygons(shapes[0], circle_shape)
		
		#if shapes.size() >= 2:
		for i in range(1, shapes.size()):
			if false:
				var poly = Polygon2D.new()
				poly.polygon = shapes[i]
				$StaticBody2D.add_child(poly)
			var collision_poly = CollisionPolygon2D.new()
			collision_poly.polygon = shapes[i]
			$StaticBody2D.add_child(collision_poly)
		
	print(shapes)
	#for s in shapes:
		#var poly = Polygon2D.new()
		#poly.polygon = s
		#poly.color = Color.from_hsv(randf(), 0.5, 0.8, 0.5)
		#$StaticBody2D.add_child(poly)
	

func set_player_colors():
	if GameManager.swap_state:
		turret_node.get_node("Polygon2D").modulate = GameManager.player2_color
		wall_node.get_node("Polygon2D").modulate = GameManager.player1_color
	else:
		turret_node.get_node("Polygon2D").modulate = GameManager.player1_color
		wall_node.get_node("Polygon2D").modulate = GameManager.player2_color
		

func swap_players(state:bool):
	print("swapping players")
	#GameManager.swap_state = !GameManager.swap_state
	
	set_player_colors()
	
	var actions_to_swap = [
		["turret_cw", "wall_cw"],
		["turret_ccw", "wall_ccw"],
		["turret_attack", "wall_attack"]
	]
	
	for i in actions_to_swap.size():
		var events0 = InputMap.action_get_events(actions_to_swap[i][0])
		var events1 = InputMap.action_get_events(actions_to_swap[i][1])
		
		InputMap.action_erase_events(actions_to_swap[i][0])
		InputMap.action_erase_events(actions_to_swap[i][1])
		
		for event in events0:
			InputMap.action_add_event(actions_to_swap[i][1], event)
		
		for event in events1:
			InputMap.action_add_event(actions_to_swap[i][0], event)
		

func _on_player_death():
	GameManager.turret.die()
	GameManager.swap_players(!GameManager.swap_state)

func _on_turret_alive_state_changed(state: bool) -> void:
	pass # Replace with function body.

func _on_wall_alive_state_changed(state: bool) -> void:
	if state == false:
		_on_player_death()
