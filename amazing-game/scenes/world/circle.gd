extends Node2D

@export var width = 4
# the end of the circle
@export var radius = 280
# start of the circle
@export var start_radius = 800

@export var pulse_duration:float = 2.0
@export var timing_range:float = 1.0
#@export var perfect_timing_range:float = 0.03

#@export var timing_ranges:Array[Array] = [
	#[1.0, 0.5],
	#[0.05, 2.0]
#]

# [timing, damage scale]
@export var timing_ranges:Array[Array] = [
	[0.5, 0.1],
	[0.2, 2.0],
	[0.05, 20.0]
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
	
	#var states:Array = [
			#["initiated", 0],
			#["range_start", pulse_duration - timing_range],
			#["perfect_start", pulse_duration - perfect_timing_range],
			#["center", pulse_duration],
			#["perfect_end", pulse_duration + perfect_timing_range],
			#["range_end", pulse_duration + timing_range],
			#["ended", pulse_duration + timing_range]
		#]
	
	center_time = Time.get_ticks_msec() + pulse_duration * 1000.0
	
	for i in states.size():
		#var a = get_tree().create_timer(states[i][1], false, true).timeout.connect(_on_pulse_section_reached.bind(states[i][0]))
		#print(states[i][1])
		var a = get_tree().create_timer(states[i][1], false, true).timeout.connect(_on_pulse_section_reached.bind(states[i][0], states[i][2], states[i][3]))
	
	draw_pulsing_circle = true
	
	#_on_pulse_start_before_the_start()
	#var a = get_tree().create_timer(pulse_duration - timing_range, false, true).timeout.connect(_on_pulse_start)
	#var b = get_tree().create_timer(pulse_duration, false, true).timeout.connect(_on_pulse_perfect_start)
	#var b = get_tree().create_timer(pulse_duration, false, true).timeout.connect(_on_pulse_center)
	#var b = get_tree().create_timer(pulse_duration, false, true).timeout.connect(_on_pulse_center)
	#var c = get_tree().create_timer(pulse_duration + timing_range, false, true).timeout.connect(_on_pulse_end)
	
	#pulse_reached.emit("start")

func _on_pulse_section_reached(state_i:int, damage_scale:float, start_or_end_state:bool):
	pulse_reached.emit(state_i, damage_scale, start_or_end_state)
	
	print("state: " + str(state_i) + " " + str(start_or_end_state))
	

	# if this is one of the outer bounds
	#if state_i == 0:
		#if start_or_end_state:
			#draw_pulsing_circle = false
		#else:
			#draw_pulsing_circle = true
	
	#match [state_i, start_or_end_state]:
		#[0, true]:
			#draw_pulsing_circle = true
		#[0, false]:
			#draw_pulsing_circle = false
			#await get_tree().create_timer(1.0).timeout
			#circle_pulse(pulse_duration)

#func _on_pulse_start_before_the_start():
	#pulse_reached.emit("start_before_the_start")
	#draw_pulsing_circle = true
#
#func _on_pulse_start():
	#pulse_reached.emit("start")
#
#func _on_pulse_center():
	#pulse_reached.emit("center")
#
#func _on_pulse_end():
	#pulse_reached.emit("end")
	#draw_pulsing_circle = false

func _on_tween_finished():
	#pulse_reached.emit("end")
	draw_pulsing_circle = false
	var time = randf_range(3,7)
	await get_tree().create_timer(time).timeout
	circle_pulse(pulse_duration)

func _draw() -> void:
	# draw static circle for path of the wall
	for coords in filled_circle_coords:
		draw_circle(coords, radius, Color(1,1,1,0.5), false, width, true)
		draw_circle(coords, radius, Color("806fb078"), true, -1, true)
	
	if draw_pulsing_circle:
		var speed = (start_radius - radius)/pulse_duration
		var offset = speed * timing_range
		#var perfect_offset = (start_radius - radius)/pulse_duration * timing_ranges[1][0]
		
		# total range
		draw_circle(Vector2(0,0), current_radius, Color(0.835, 0.672, 0.96, 1.0), false, offset, true)
		
		for i in timing_ranges.size():
			#area
			draw_circle(Vector2(0,0), current_radius, Color.from_hsv(i*0.3,1,1,1) , false, timing_ranges[i][0]*speed * 2.0, true)
			# leading edge
			draw_circle(Vector2(0,0), current_radius - timing_ranges[i][0]*speed, Color.from_hsv(i*0.3,0.4,1,1) , false, 1, true)
			
		#states.append([i, pulse_duration + timing_ranges[i][0], timing_ranges[i][1], true])
		
		## perfect range
		#draw_circle(Vector2(0,0), current_radius, Color(0.973, 0.435, 0.635, 1.0), false, perfect_offset, true)
		
	
	
