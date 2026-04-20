extends Node2D

@export var width = 2
@export var radius = 280



func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	
	draw_circle(Vector2(0,0), radius, Color(1,1,1,0.5), false, width)
	
