extends RigidBody2D


@export var speed:float = 12
@export var radius:float = 300
@export var inner_radius:float = 280

@export var base_health:int = 100
var health = 0
var theta = 0

func _ready() -> void:
	# set collision shape
	var polygon = create_polygon()
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon
	
	health = base_health
	

func create_polygon():
	# make an arc shape
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
		damage(body.damage)
		body.queue_free()

func damage(amount:int):
	health -= amount
	if health <= 0:
		print("wall dead")
		queue_free()
