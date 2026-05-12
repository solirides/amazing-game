extends CanvasLayer

signal upgrades_finished
signal upgrade_selected(player_id: int, type: Cards.CardType)

@export var card_scene: PackedScene
@export var card_spacing: float = 100.0

var p1_has_played: bool = false
var p2_has_played: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	
	$SpawnPoint1.global_position = Vector2(screen_size.x / 4.0, screen_size.y / 2.0)
	$SpawnPoint2.global_position = Vector2(screen_size.x * 3.0 / 4.0, screen_size.y / 2.0)
	
	var starting_cards = [Cards.CardType.DAMAGE, Cards.CardType.HEALTH, Cards.CardType.SPEED]
	spawn_hand(1, $SpawnPoint1.global_position, starting_cards)
	spawn_hand(2, $SpawnPoint2.global_position, starting_cards)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_hand(player_id: int, center_pos: Vector2, card_types: Array) -> void:
	var hand_size = card_types.size()
	
	for i in range(hand_size):
		var card = card_scene.instantiate()
		
		var offset_x = (i - (hand_size - 1) / 2.0) * card_spacing
		card.position = center_pos + Vector2(offset_x, 0)
		
		card.player_owner = player_id
		card.card_type = card_types[i]
		
		card.card_played.connect(_on_card_played)
		
		add_child(card)

func _on_card_played(clicked_card: Cards, player_id: int, type: Cards.CardType) -> void:
	if (player_id == 1):
		p1_has_played = true
	else:
		p2_has_played = true
	
	for child in get_children():
		if child is Cards and child.player_owner == player_id and child != clicked_card:
			child.discard()
	
	upgrade_selected.emit(player_id, type)
	
	if (p1_has_played == true and p2_has_played == true):
		end_selection_phase()

func end_selection_phase() -> void:
	await get_tree().create_timer(2.0).timeout
	
	upgrades_finished.emit()
	
	queue_free()
