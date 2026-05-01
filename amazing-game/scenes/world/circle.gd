extends Node2D

@export var width = 4
# the end of the circle
@export var radius = 280
# start of the circle
@export var start_radius = 800

@export var pulse_duration:float = 2.0
@export var timing_range:float = 1.0

# [timing, damage scale]
@export var timing_ranges:Array[Array] = [
	[0.5, 0.5],
	[0.2, 1.0],
	[0.05, 2.0]
]

@export var colors:Array[Color] = [
	Color(0.375, 0.236, 0.58, 1.0),
	Color(0.224, 0.81, 0.822, 1.0),
	Color(0.545, 0.98, 0.274, 1.0)
]

var filled_circle_coords = [Vector2(0,0)]
var current_radius = 0
var radius_tween:Tween
var draw_pulsing_circle = true
var center_time = 0

signal pulse_reached(state:String)

func _ready() -> void:
	modulate = Color(1,1,1,0.5)
	circle_pulse(pulse_duration)

func _process(delta: float) -> void:
	queue_redraw()

func circle_pulse(duration:float):
	if radius_tween:
		radius_tween.kill()
	radius_tween = create_tween()
	current_radius = start_radius
	var offset = (start_radius - radius)/duration * timing_range
	#radius_tween.tween_property(self, "current_radius", radius, duration)
	radius_tween.tween_property(self, "current_radius", radius - offset, duration + timing_range)
	#radius_tween.tween_property(self, "modulate", Color(1,1,1,0), 0)
	radius_tween.tween_callback(_on_tween_finished)
	
	# [index, time after now when it happens, damage scale, start or end bool]
	var states:Array = []
	for i in timing_ranges.size():
		states.append([i, pulse_duration - timing_ranges[i][0], timing_ranges[i][1], true])
		states.append([i, pulse_duration + timing_ranges[i][0], timing_ranges[i][1], false])
	
	center_time = Time.get_ticks_msec() + pulse_duration * 1000.0
	
	for i in states.size():
		#var a = get_tree().create_timer(states[i][1], false, true).timeout.connect(_on_pulse_section_reached.bind(states[i][0]))
		#print(states[i][1])
		var a = get_tree().create_timer(states[i][1], false, true).timeout.connect(_on_pulse_section_reached.bind(states[i][0], states[i][2], states[i][3]))
	
	draw_pulsing_circle = true

func _on_pulse_section_reached(state_i:int, damage_scale:float, start_or_end_state:bool):
	pulse_reached.emit(state_i, damage_scale, start_or_end_state)
	
	print("state: " + str(state_i) + " " + str(start_or_end_state))
	

func _on_tween_finished():
	#pulse_reached.emit("end")
	draw_pulsing_circle = false
	var time = randf_range(3,7)
	await get_tree().create_timer(time).timeout
	circle_pulse(pulse_duration)

func _draw() -> void:
	
	if draw_pulsing_circle:
		var speed = (start_radius - radius)/pulse_duration
		var offset = speed * timing_range
		
		# total range
		#draw_circle(Vector2(0,0), current_radius, Color(0.835, 0.672, 0.96, 1.0), false, offset, true)
		
		for i in timing_ranges.size():
			#area
			draw_circle(Vector2(0,0), current_radius, colors[i], false, timing_ranges[i][0]*speed * 2.0, true)
	
