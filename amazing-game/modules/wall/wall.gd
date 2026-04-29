extends RigidBody2D


@export var base_speed:float = 12
@export var outer_radius:float = 300
@export var inner_radius:float = 280

@export var base_health:int = 100
@export var respawn_time:float = 4.0

@onready var health = base_health
@onready var speed = base_speed
var theta = 0
var can_move = true
var alive_state = true


signal alive_state_changed(state:bool)

func _ready() -> void:
	GameManager.wall = self
	# set collision shape
	var polygon = create_polygon()
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon
	

func create_polygon():
	# make an arc shape
	var points = []
	var res = 10
	var angle = 0.7
	for i in range(res):
		points.append(Vector2(1,0).rotated(angle / float(res) * i) * outer_radius)
	for i in range(res):
		points.append(Vector2(1,0).rotated(angle / float(res) * (res - i - 1)) * inner_radius)
	return PackedVector2Array(points)


func _physics_process(delta: float) -> void:
	
	if can_move:
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
	if alive_state == false:
		return
	health -= amount
	if health <= 0:
		print("wall dead")
		die()

var modulate_tween:Tween

func die():
	alive_state_changed.emit(false)
	alive_state = false
	can_move = false
	
	var timer = get_tree().create_timer(respawn_time, false, true).timeout.connect(respawn)
	GameManager.swap_players(!GameManager.swap_state)
	flash_animation(respawn_time)

func flash_animation(duration:float):
	# flashing animation
	if modulate_tween:
		modulate_tween.kill()
	var modulate_tween = create_tween()
	for i in range(ceil((duration - 0.6) / 0.6)):
		modulate_tween.tween_property(self, "modulate", Color(1,1,1,0.2), 0.3)
		modulate_tween.tween_property(self, "modulate", Color(1,1,1,0.6), 0.3)
	for i in range(3):
		modulate_tween.tween_property(self, "modulate", Color(1,1,1,0.4), 0.1)
		modulate_tween.tween_property(self, "modulate", Color(1,1,1,0.8), 0.1)
	modulate_tween.tween_property(self, "modulate", Color(1,1,1,1), 0)

func respawn():
	alive_state_changed.emit(true)
	alive_state = true
	can_move = true
	
	health = base_health
	
	if modulate_tween:
		modulate_tween.kill()
	modulate = Color(1,1,1,1)
