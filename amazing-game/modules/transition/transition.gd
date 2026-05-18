extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.modulate = Color(1,1,1,0)
	#fade_out()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var tween
func fade_out(time:float):
	$ColorRect.modulate = Color(1,1,1,0)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,1), time)

func fade_in(time:float):
	$ColorRect.modulate = Color(1,1,1,1)
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(1,1,1,0), time)
	
	await tween.finished
	self.queue_free()
