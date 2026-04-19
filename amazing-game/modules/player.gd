extends RigidBody2D


var speed = 40

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
	
	
