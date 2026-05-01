extends Player


@export var outer_radius:float = 300
@export var inner_radius:float = 280
@export var arc_angle:float = 0.7
@export var critical_damage_multiplier:float = 2

func _ready() -> void:
	GameManager.wall = self
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
	if can_move:
		if Input.is_action_pressed("wall_ccw"):
			theta -= speed / inner_radius
		if Input.is_action_pressed("wall_cw"):
			theta += speed / inner_radius
	
	self.rotation = theta
	#self.global_position = Vector2(1,0).rotated(theta)

func create_critical_spot(angle:float):
	var rot = randf_range(0, arc_angle - angle)
	$CriticalSpot/Polygon2D.rotation = rot
	
	var shape = create_polygon(0.2*arc_angle, 10, outer_radius+2, inner_radius-2)
	$CriticalSpot/Polygon2D.polygon = shape
	$CriticalSpot/CollisionPolygon2D.polygon = shape
	

func remove_critical_spot():
	$CriticalSpot/Polygon2D.polygon = []
	$CriticalSpot/CollisionPolygon2D.polygon = []

# set priority of critical spot rigidbody to something lower than the wall rigidbody
# so that the critical spot processes first

func _on_body_entered(body: Node) -> void:
	#print("collision")
	if body.is_in_group("bullet"):
		if body.hit_processed:
			return
		# prevent double hit from regular collision
		body.hit_processed = true
		
		print("critical hit")
		damage(body.damage * critical_damage_multiplier)
		body.queue_free()
		
		remove_critical_spot()
		get_tree().create_timer(2.0).timeout.connect(func(): create_critical_spot(0.2))
