extends Node2D

@export var width = 4
@export var radius = 280
var filled_circle_coords = [Vector2(0,0)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	# draw static circle for path of the wall
	for coords in filled_circle_coords:
		draw_circle(coords, radius, Color("806fb078"), true, -1, true)
		#draw_circle(coords, radius, Color(1.0, 1.0, 1.0, 1.0), false, width, true)
		
