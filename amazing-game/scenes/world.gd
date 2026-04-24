extends Node2D

@export var wall_node:Node
@export var player_node:Node
@export var circle_display:Node

func _ready() -> void:
	var resolution = 40
	var circle_shape = create_circle(wall_node.inner_radius, resolution)
	$StaticBody2D/CollisionPolygon2D.polygon = circle_shape
	
	circle_display.connect("pulse_reached", player_node._on_pulse_reached)


func create_circle(radius:float, res:int):
	# make a circle
	var points = []
	var angle = 2*PI
	for i in range(res):
		points.append(Vector2(1,0).rotated(angle / float(res) * i) * radius)
	return points
