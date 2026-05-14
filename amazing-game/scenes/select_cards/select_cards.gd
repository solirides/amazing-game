extends CanvasLayer

signal upgrades_finished
signal upgrade_selected(player_id: int, type: Cards.CardType)

@export var card_scene: PackedScene
@export var card_spacing: float = 100.0

var p1_has_played: bool = false
var p2_has_played: bool = false

var max_time: float = 10.0

var p1_cards: Array = []
var p2_cards: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	
	$SpawnPoint1.global_position = Vector2(screen_size.x / 4.0, screen_size.y / 2.0)
	$SpawnPoint2.global_position = Vector2(screen_size.x * 3.0 / 4.0, screen_size.y / 2.0)
	
	var starting_cards = [Cards.CardType.DAMAGE, Cards.CardType.HEALTH, Cards.CardType.SPEED]
	spawn_hand(1, $SpawnPoint1.global_position, starting_cards)
	spawn_hand(2, $SpawnPoint2.global_position, starting_cards)
	
	$SelectTimer.wait_time = max_time
	
	await get_tree().create_timer(2.0).timeout
	
	$SelectTimer.start()
	
	# var pulse_tween = create_tween().set_loops()
	# pulse_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(1.2, 1.2), 0.5).set_trans(Tween.TRANS_SINE)
	# pulse_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not $SelectTimer.is_stopped() == true):
		var seconds_left = ceil($SelectTimer.time_left)
		$DividingLine/CenterBox/TimerLabel.text = str(int(seconds_left))

func spawn_hand(player_id: int, center_pos: Vector2, card_types: Array) -> void:
	var hand_size = card_types.size()
	
	for i in range(hand_size):
		var card = card_scene.instantiate()
		
		var offset_x = (i - (hand_size - 1) / 2.0) * card_spacing
		card.position = center_pos + Vector2(offset_x, 0)
		
		card.player_owner = player_id
		card.card_type = card_types[i]
		
		card.card_played.connect(_on_card_played)
		
		if (player_id == 1):
			p1_cards.append(card)
		elif (player_id == 2):
			p2_cards.append(card)
		
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
		$SelectTimer.stop()
		end_selection_phase()

func end_selection_phase() -> void:
	await get_tree().create_timer(1.5).timeout
	
	upgrades_finished.emit()
	
	queue_free()

func _on_select_timer_timeout() -> void:
	$DividingLine/CenterBox/TimerLabel.text = "TIME!"
	
	if (p1_has_played == false):
		var p1_random_value = randi_range(0, 2)
		p1_cards[p1_random_value].select_card()
	if (p2_has_played == false):
		var p2_random_value = randi_range(0, 2)
		p2_cards[p2_random_value].select_card()
