extends RigidBody2D


@export var speed = 100
@export var bullet_speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _physics_process(delta: float) -> void:
	var vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	vector.normalized()
	
	linear_velocity += vector * speed
	
	# note: "left_mouse" is an input set in Project>Project settings>Input map
	if Input.is_action_just_pressed("left_mouse"):
		shoot()

func _input(event: InputEvent) -> void:
	pass
	

func shoot():
	print("shoot")
	var bullet_scene = preload("res://modules/bullet/bullet.tscn")
	var instance = bullet_scene.instantiate()
	
	var direction = (get_global_mouse_position() - global_position).normalized()
	
	instance.global_position = self.global_position
	instance.linear_velocity = bullet_speed * direction
	instance.rotate(direction.angle())
	
	get_tree().root.add_child(instance)
	
