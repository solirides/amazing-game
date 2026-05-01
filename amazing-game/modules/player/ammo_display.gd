extends Node2D


@export var bullet:Node
@export var player:Node

var bullets = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.ammo_changed.connect(_on_player_ammo_updated)
	create_bullets(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_bullets(count:int):
	bullet.visible = false
	var offset = 30
	var total_offset = offset*(count - 1)/2.0
	
	for i in range(0,count):
		var a = bullet.duplicate()
		a.position.x = i*offset - total_offset
		a.visible = true
		add_child(a)
		bullets.append(a)
	

func update_bullets(remaining_bullets:int):
	for i in range(0,remaining_bullets):
		bullets[i].modulate = Color(1.0, 1.0, 1.0, 1.0)
	for i in range(remaining_bullets,bullets.size()):
		bullets[i].modulate = Color(0.46, 0.46, 0.46, 0.753)

func _on_player_ammo_updated(ammo:int):
	update_bullets(ammo)
	
