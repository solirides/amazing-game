extends Player

#@export var rotation_speed = 0.1
@export var infinite_shooting = false

@export var circle_node:Node

# ligma ligma on the wall
# whos is the skibibidiest onf them all


var last_pulse_state_time = 0
var pulse_state = [0, false]
var highest_active_pulse_state = -1
var pulse_states = []
var shot_bullet = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.turret = self
	GameManager.player1 = self
	GameManager.players_swapped.connect(swap_player)
	is_hacking = GameManager.hacks
	
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	#await get_tree().process_frame
	for i in circle_node.timing_ranges:
		pulse_states.append(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Pointer.global_rotation = (get_global_mouse_position() - self.global_position).angle()
	pass
	

func _physics_process(delta: float) -> void:
	if false:
		var vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		vector.normalized()
		linear_velocity = vector * speed
	
	#print(shot_bullet)
	
	# note: "left_mouse" is an input set in Project>Project settings>Input ma[
	# Input.is_action_just_pressed("left_mouse")
	if Input.is_action_just_pressed("turret_attack"):
		if pulse_states[0] == true and (shot_bullet == false or infinite_shooting) and ammo > 0:
			shot_bullet = true
			var damage = bullet_damage
			damage *= circle_node.timing_ranges[highest_active_pulse_state][1]
			
			#if circle_node:
				#var time = Time.get_ticks_msec()
				#var time_diff = abs(time - circle_node.center_time)/1000.0
				#if time_diff <= circle_node.timing_range:
					#damage = 1
				##damage =  max(0, 1 - (time_diff / circle_node.timing_range))
				##print("current time: " + str(time))
				##print("prediced time: " + str(circle_node.center_time))
				#print("time difference: " + str(time_diff))
				#print("this is the damage: " + str(damage))
				#damage *= bullet_damage
				#
			
			shoot(damage)
	if can_move:
		if Input.is_action_pressed("turret_ccw"):
			theta -= speed * delta
		if Input.is_action_pressed("turret_cw"):
			theta += speed * delta
	$Sprite2D.global_rotation = theta + PI*0.5

func _input(event: InputEvent) -> void:
	pass
	

func shoot(damage:float):
	#print("shoot")
	var bullet_scene = preload("res://modules/bullet/bullet.tscn")
	var instance = bullet_scene.instantiate()
	
	#var direction = (get_global_mouse_position() - global_position).normalized()
	var direction = theta
	
	instance.global_position = self.global_position
	instance.linear_velocity = bullet_speed * Vector2(1,0).rotated(theta)
	#instance.rotate(direction.angle())
	instance.rotate(theta)
	instance.damage = damage
	
	if is_hacking:
		instance.target = GameManager.wall.critical_target_spot
		instance.homing = true
	#instance.scale = Vector2(damage, damage)
	
	instance.get_node("Polygon2D").color = $Polygon2D.modulate
	instance.get_node("Label").text = str(int(damage))
	GameManager.world.info_label.text = "bullet damage: " + str(damage)
	print("spawned bullet with damage: " + str(damage))
	
	get_tree().current_scene.add_child(instance)
	
	ammo -= 1
	ammo_changed.emit(ammo)
	
#
#func damage(amount:int):
	#health -= amount
	#if health <= 0:
		#print("player dead")
		#queue_free()

func _on_pulse_reached(state_i:int, damage_scale:float, start_or_end_state:bool):
	pulse_state = [state_i, start_or_end_state]
	pulse_states[state_i] = start_or_end_state
	if start_or_end_state:
		highest_active_pulse_state = state_i
	else:
		highest_active_pulse_state = state_i - 1
	
	last_pulse_state_time = Time.get_ticks_msec()
	match [state_i, start_or_end_state]:
		[0, true]:
			shot_bullet = false
		[0, false]:
			if shot_bullet == false:
				shot_bullet = true
				ammo -= 1
				ammo_changed.emit(ammo)

func swap_player(state:bool):
	if state:
		$Sprite2D.texture = GameManager.player2_turret_sprite
	else:
		$Sprite2D.texture = GameManager.player1_turret_sprite
