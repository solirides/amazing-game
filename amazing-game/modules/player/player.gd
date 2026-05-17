class_name Player
extends RigidBody2D

@export var base_bullet_speed = 1000
@export var base_bullet_damage:int = 20
@export var base_shield:int = 0
@export var base_speed:float = 6.0
@export var base_accel:float = 20
@export var base_decel:float = 3
@export var base_health:int = 100
@export var respawn_time:float = 4.0
@export var base_ammo:int = 3

@onready var bullet_speed = base_bullet_speed
@onready var health = base_health
@onready var accel = base_accel
@onready var decel = base_decel
@onready var speed = base_speed
@onready var ammo = base_ammo
@onready var bullet_damage = base_bullet_damage
var shield:int = 0

var theta = 0
var can_move = true
var alive_state = true
var can_shoot = false

var upgrades = {
	"shield":0,
	"speed":0,
	"damage":0
}

var upgrade_multipliers = {
	"shield":30,
	"speed":0.15,
	"damage":0.20
}

#var max_damage_in_tick = 0

signal alive_state_changed(state:bool)
signal ammo_changed(ammo:int)

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
	shield = max(0, shield - amount)
	var real_damage = max(0, amount - shield)
	
	health -= real_damage
	if health <= 0:
		print("player dead")
		die()

var modulate_tween:Tween

func die():
	if alive_state == false:
		return
	alive_state_changed.emit(false)
	alive_state = false
	can_move = false
	
	queue_respawn(respawn_time)

func queue_respawn(time:float):
	var timer = get_tree().create_timer(respawn_time, false, true).timeout.connect(respawn)
	flash_animation(time)

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
	
	ammo = base_ammo
	ammo_changed.emit(ammo)
	
	if modulate_tween:
		modulate_tween.kill()
	modulate = Color(1,1,1,1)

func calculate_upgrades():
	pass

func add_upgrade(stat:String):
	if stat not in upgrades.keys():
		upgrades[stat] = 0
	upgrades[stat] += 1
	
	var upgrade_amount = 0.10
	if stat in upgrade_multipliers.keys():
		upgrade_amount = upgrade_multipliers[stat]
	var value = get("base_" + stat) * (1.0 + upgrades[stat] * upgrade_amount)
	if stat == "shield":
		value = get("base_" + stat) + upgrade_amount
	
	set(stat, value)
	print(stat + " " + str(get(stat)))
	

#func _physics_process(delta: float) -> void:
	#if max_damage_in_tick > 0:
		#damage(max_damage_in_tick)
	#max_damage_in_tick = 0
