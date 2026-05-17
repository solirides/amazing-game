extends Player


@export var outer_radius:float = 300
@export var inner_radius:float = 280
@export var arc_angle:float = 0.7
@export var critical_damage_multiplier:float = 2

func _ready() -> void:
	GameManager.wall = self
	GameManager.player2 = self
	GameManager.players_swapped.connect(swap_player)
	# set collision shape
	var polygon = create_polygon(arc_angle)
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon
	
	create_critical_spot(0.2)

func create_polygon(angle:float = 0.7, resolution:float=10, outer_radius:float=outer_radius, inner_radius:float=inner_radius):
	# make an arc shape
	var points = []
	#var res = 10
	#var angle = 0.7
	for i in range(resolution):
		points.append(Vector2(1,0).rotated(angle / float(resolution) * i) * outer_radius)
	for i in range(resolution):
		points.append(Vector2(1,0).rotated(angle / float(resolution) * (resolution - i - 1)) * inner_radius)
	return PackedVector2Array(points)

func _physics_process(delta: float) -> void:
	
	#apply_central_force(Vector2(10,0))
	
	if can_move:
		#var magnitude = clamp((1 - abs(angular_velocity/(speed/inner_radius))), 0, 1)
		#magnitude = pow(magnitude, 2.0)
		#var sign = sign(angular_velocity)
		#if Input.is_action_pressed("wall_ccw"):
			#angular_velocity -= accel * magnitude * delta
		#if Input.is_action_pressed("wall_cw"):
			#angular_velocity += accel * magnitude * delta
		#angular_velocity = lerp(angular_velocity, 0.0, delta * decel)
		#angular_velocity = clamp(angular_velocity, -speed/inner_radius, speed/inner_radius)
		
		if Input.is_action_pressed("wall_ccw"):
			theta -= speed * delta / 4.0
		if Input.is_action_pressed("wall_cw"):
			theta += speed * delta / 4.0
	
		self.rotation = theta
		#self.global_position = Vector2(1,0).rotated(theta)
	

func create_critical_spot(angle:float):
	var rot = randf_range(0, arc_angle - angle)
	$CriticalSpot/Polygon2D.rotation = rot
	$CriticalSpot/CollisionPolygon2D.rotation = rot
	
	var shape = create_polygon(0.2*arc_angle, 10, outer_radius+10, inner_radius-10)
	$CriticalSpot/Polygon2D.polygon = shape
	$CriticalSpot/CollisionPolygon2D.polygon = shape
	

func remove_critical_spot():
	$CriticalSpot/Polygon2D.polygon = []
	$CriticalSpot/CollisionPolygon2D.polygon = []

func _on_body_entered(body: Node) -> void:
	print("collision")
	var critical = false
	if body.is_in_group("bullet"):
		if body.hit_processed:
			return
		# prevent double hit
		body.hit_processed = true
		
		if body in $CriticalSpot.get_overlapping_bodies():
			print("critical hit")
			damage(body.damage * critical_damage_multiplier)
			remove_critical_spot()
			get_tree().create_timer(2.0).timeout.connect(func(): create_critical_spot(0.2))
		else:
			print("regular hit")
			damage(body.damage)
		
		
		body.queue_free()
		

#func _on_critical_spot_body_entered(body: Node) -> void:
	#print("critical collision")
	#if body.is_in_group("bullet"):
		#if body.hit_processed:
			#return
		## prevent double hit from regular collision
		#body.hit_processed = true
		#
		#print("critical hit")
		#damage(body.damage * critical_damage_multiplier)
		#body.queue_free()
		#
		#remove_critical_spot()
		#get_tree().create_timer(2.0).timeout.connect(func(): create_critical_spot(0.2))

func swap_player(state:bool):
	if state:
		get_node("Polygon2D").modulate = GameManager.player1_color
	else:
		get_node("Polygon2D").modulate = GameManager.player2_color
