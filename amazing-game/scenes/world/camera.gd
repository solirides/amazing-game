extends Camera2D

@export var target:Node
@export var speed = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if target != null:
		global_position = lerp(global_position, target.global_position, delta * speed)

var shake_tween:Tween
func shake(amplitude:float=10, frequency:float=3, duration:float=1):
	
	if shake_tween:
		shake_tween.kill()
	shake_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for i in range(floor(duration * frequency)):
		var vec = Vector2(1,0).rotated(randf_range(0,2*PI))
		shake_tween.tween_property(self, "offset", vec * amplitude, 1.0/frequency)
	shake_tween.tween_property(self, "offset", Vector2(0,0), 1.0/frequency)
	#self.offset = vec * amplitude
	
