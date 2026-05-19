extends RigidBody2D

var damage = 1
var hit_processed = false
var homing = false
var homing_speed = 10
var target:Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if target != null and homing == true:
		var dir = target.global_position - self.global_position
		var a = atan2(dir.y, dir.x)
		#linear_velocity = linear_velocity.rotated(a)
		linear_velocity = linear_velocity + dir * homing_speed * delta
		linear_velocity = lerp(linear_velocity, Vector2.ZERO, 2.0 * delta)
		self.rotation = atan2(linear_velocity.y, linear_velocity.x)
	
