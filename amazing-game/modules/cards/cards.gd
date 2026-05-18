class_name Cards


# NOTE: collision shape has a low priority for recieving mouse inputs
# any control nodes in the scene will consume mouse inputs instead
# set mouse filter to pass

extends Area2D

signal card_played(clicked_card: Cards, player_id: int, type: CardType)

enum CardType {DAMAGE, SPEED, HEALTH}
const card_to_string = {
	CardType.DAMAGE : "bullet_damage",
	CardType.SPEED : "speed",
	CardType.HEALTH : "shield" # this is not regular health
}

@export var damage_texture: Texture2D
@export var speed_texture: Texture2D
@export var health_texture: Texture2D

@export var player_owner: int

@export var card_type: CardType

var drop_distance = 800.0

var on_screen_position: Vector2

var off_screen_position: Vector2

var is_selectable = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match card_type:
		CardType.DAMAGE:
			$Sprite2D.texture = damage_texture
		CardType.SPEED:
			$Sprite2D.texture = speed_texture
		CardType.HEALTH:
			$Sprite2D.texture = health_texture
	
	on_screen_position = position
	
	if (player_owner == 2):
		position.y -= drop_distance
	else:
		position.y += drop_distance
	
	off_screen_position = position
	
	var tween = create_tween()
	tween.tween_property(self, "position", on_screen_position, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	is_selectable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (is_selectable == false):
		return
	
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		select_card()
		is_selectable = false

func select_card() -> void:
	card_played.emit(self, player_owner, card_type)
	
	var tween = create_tween()
	tween.tween_property(self, "position", off_screen_position, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	queue_free()

func discard() -> void:
	is_selectable = false
	
	var tween = create_tween()
	tween.tween_property(self, "position", off_screen_position, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	queue_free()
