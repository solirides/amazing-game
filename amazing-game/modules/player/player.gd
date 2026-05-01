class_name Player
extends RigidBody2D


@export var base_speed:float = 12
@export var base_health:int = 100
@export var respawn_time:float = 4.0

@onready var health = base_health
@onready var speed = base_speed
var theta = 0
var can_move = true
var alive_state = true
var can_shoot = false

#var max_damage_in_tick = 0

signal alive_state_changed(state:bool)

func _on_body_entered(body: Node) -> void:
	print("collision")
	if body.is_in_group("bullet"):
		if body.hit_processed:
			return
		# prevent double hit
		body.hit_processed = true
		
		damage(body.damage)
		body.queue_free()

func damage(amount:int):
	if alive_state == false:
		return
	health -= amount
	if health <= 0:
		print("player dead")
		die()

var modulate_tween:Tween

func die():
	alive_state_changed.emit(false)
	alive_state = false
	can_move = false
	
	var timer = get_tree().create_timer(respawn_time, false, true).timeout.connect(respawn)
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

#func _physics_process(delta: float) -> void:
	#if max_damage_in_tick > 0:
		#damage(max_damage_in_tick)
	#max_damage_in_tick = 0
