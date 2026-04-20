extends RigidBody2D

var theta = 0
@export var speed:float = 16
@export var radius:float = 300
@export var inner_radius:float = 280

func _ready() -> void:
	var polygon = create_polygon()
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon
	
	

func create_polygon():
	var points = []
	var res = 10
	var angle = 0.7
	for i in range(res):
		points.append(Vector2(1,0).rotated(angle / float(res) * i) * radius)
	for i in range(res):
		points.append(Vector2(1,0).rotated(angle / float(res) * (res - i - 1)) * inner_radius)
	return PackedVector2Array(points)


func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("wall_ccw"):
		theta -= speed / inner_radius
	if Input.is_action_pressed("wall_cw"):
		theta += speed / inner_radius
	
	self.rotation = theta
	#self.global_position = Vector2(1,0).rotated(theta)


func _on_body_entered(body: Node) -> void:
	print("collision")
	if body.is_in_group("bullet"):
		body.queue_free()
