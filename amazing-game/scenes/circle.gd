extends Node2D

@export var width = 4
@export var radius = 280

@export var start_radius = 800
@export var pulse_duration:float = 2.0

var current_radius = 0
var radius_tween:Tween

signal pulse_reached()

func _ready() -> void:
	circle_pulse(pulse_duration)

func _process(delta: float) -> void:
	queue_redraw()

func circle_pulse(duration:float):
	if radius_tween:
		radius_tween.kill()
	radius_tween = create_tween()
	current_radius = start_radius
	radius_tween.tween_property(self, "current_radius", radius, duration)
	radius_tween.tween_callback(_on_tween_finished)

func _on_tween_finished():
	pulse_reached.emit()
	circle_pulse(pulse_duration)

func _draw() -> void:
	draw_circle(Vector2(0,0), radius, Color(1,1,1,0.5), false, width)
	
	
	draw_circle(Vector2(0,0), current_radius, Color(0.95, 0.629, 0.875, 0.816), false, width)
	
	
