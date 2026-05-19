extends Control

signal upgrades_finished
signal upgrade_selected(player_id: int, type: Cards.CardType)

@export var card_scene: PackedScene
@export var card_spacing: float = 100.0

var p1_has_played: bool = false
var p2_has_played: bool = false

var max_time: float = 20.0

var p1_cards: Array = []
var p2_cards: Array = []

var spin_tween: Tween
var pulse_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#await get_tree().create_timer(0.5).timeout
	
	var BgLeftPos = $DividingLine/BgLeft.position.x
	var BgRightPos = $DividingLine/BgRight.position.x
	var LabelP1Pos = $LabelP1.position.x
	var LabelP2Pos = $LabelP2.position.x
	
	$DividingLine.scale.y = 0.0
	$DividingLine/CenterBox.scale = Vector2.ZERO
	$DividingLine/TimerLabel.scale = Vector2.ZERO
	
	$DividingLine/BgLeft.position.x = -8000
	$DividingLine/BgRight.position.x = 4000
	
	$LabelP1.position.x = -2000
	$LabelP2.position.x = 1000
	
	var screen_size = get_viewport().get_visible_rect().size
	
	$SpawnPoint1.global_position = Vector2(screen_size.x / 4.0, screen_size.y / 2.0) - screen_size / 2.0
	$SpawnPoint2.global_position = Vector2(screen_size.x * 3.0 / 4.0, screen_size.y / 2.0) - screen_size / 2.0
	
	## this is opposite of the current state since players will be swapped after card selection
	#if GameManager.swap_state == true:
		#$P1Role/Sprite2D.texture = GameManager.player1_turret_sprite
		#$P2Role/Sprite2D.texture = GameManager.player2_wall_sprite
		#
	#else:
		#$P1Role/Sprite2D.texture = GameManager.player1_wall_sprite
		#$P2Role/Sprite2D.texture = GameManager.player2_turret_sprite
	
	$LabelP1/P1Role.text = "damage taken: \n" + str(GameManager.player1.damage_taken)
	$LabelP1/P1Role.text += "\ndeaths: \n" + str(GameManager.player1.death_count)
	$LabelP2/P2Role.text = "damage taken: \n" + str(GameManager.player2.damage_taken)
	$LabelP2/P2Role.text += "\ndeaths: \n" + str(GameManager.player2.death_count)
	
	# terrible code organization
	var winner = -1
	if GameManager.player1.death_count < GameManager.player2.death_count:
		winner = 1
	elif GameManager.player1.death_count > GameManager.player2.death_count:
		winner = 2
	else:
		if GameManager.player1.damage_taken < GameManager.player2.damage_taken:
			winner = 1
		elif GameManager.player1.damage_taken > GameManager.player2.damage_taken:
			winner = 2
		else:
			# tie?
			winner = -1
	
	print("game stats")
	print(GameManager.player1.death_count)
	print(GameManager.player2.death_count)
	print(GameManager.player1.damage_taken)
	print(GameManager.player2.damage_taken)
	
	var text = "???"
	match winner:
		1:
			text = "Player 1!"
		2:
			text = "Player 2!"
		_:
			text = "Tie!?"
	$DividingLine/Winner.text = "WINNER:\n" + text
	
	
	var intro_tween = create_tween()
	intro_tween.tween_property($DividingLine, "scale:y", 1.0, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	intro_tween.set_parallel(true)
	intro_tween.tween_property($DividingLine/BgLeft, "position:x", BgLeftPos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	intro_tween.tween_property($DividingLine/BgRight, "position:x", BgRightPos, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	intro_tween.tween_property($LabelP1, "position:x", LabelP1Pos, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	intro_tween.tween_property($LabelP2, "position:x", LabelP2Pos, 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	intro_tween.set_parallel(false)
	
	intro_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	intro_tween.tween_property($DividingLine/TimerLabel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# await intro_tween.finished
	
	var starting_cards = [Cards.CardType.DAMAGE, Cards.CardType.HEALTH, Cards.CardType.SPEED]
	#spawn_hand(1, $SpawnPoint1.global_position, starting_cards)
	#spawn_hand(2, $SpawnPoint2.global_position, starting_cards)
	
	$SelectTimer.wait_time = max_time
	
	await get_tree().create_timer(2.0).timeout
	
	$SelectTimer.start()
	
	spin_tween = create_tween().set_loops()
	spin_tween.tween_property($DividingLine/CenterBox, "rotation_degrees", 45, 0.3).as_relative()
	spin_tween.tween_interval(0.7)
	
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(1.2, 1.2), 0.3).set_trans(Tween.TRANS_SINE)
	pulse_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(1.0, 1.0), 0.7).set_trans(Tween.TRANS_SINE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not $SelectTimer.is_stopped() == true):
		var seconds_left = ceil($SelectTimer.time_left)
		$DividingLine/TimerLabel.text = str(int(seconds_left))

#func spawn_hand(player_id: int, center_pos: Vector2, card_types: Array) -> void:
	#var hand_size = card_types.size()
	#
	#for i in range(hand_size):
		#var card = card_scene.instantiate()
		#
		#var offset_x = (i - (hand_size - 1) / 2.0) * card_spacing
		#card.position = center_pos + Vector2(offset_x, 0)
		#
		#card.player_owner = player_id
		#card.card_type = card_types[i]
		#
		#card.card_played.connect(_on_card_played)
		#
		#if (player_id == 1):
			#p1_cards.append(card)
		#elif (player_id == 2):
			#p2_cards.append(card)
		#
		#add_child(card)

#func _on_card_played(clicked_card: Cards, player_id: int, type: Cards.CardType) -> void:
	#if (player_id == 1):
		#p1_has_played = true
	#else:
		#p2_has_played = true
	#
	#for child in get_children():
		#if child is Cards and child.player_owner == player_id and child != clicked_card:
			#child.discard()
	#
	#upgrade_selected.emit(player_id, type)
	#
	#if (p1_has_played == true and p2_has_played == true):
		#$SelectTimer.stop()
		#end_selection_phase()
#
#func end_selection_phase() -> void:
	#spin_tween.kill()
	#pulse_tween.kill()
	#
	#var exit_tween = create_tween()
	#
	#exit_tween.tween_property($DividingLine/TimerLabel, "scale", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	#exit_tween.tween_property($DividingLine/CenterBox, "scale", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	#
	#exit_tween.set_parallel(true)
	#exit_tween.tween_property($DividingLine/BgLeft, "position:x", -8000, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#exit_tween.tween_property($DividingLine/BgRight, "position:x", 4000, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#exit_tween.tween_property($LabelP1, "position:x", -2000, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#exit_tween.tween_property($LabelP2, "position:x", 1000, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#
	#exit_tween.tween_property($DividingLine, "scale:y", 0.0, 0.5).set_delay(0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#exit_tween.set_parallel(false)
	#
	#await exit_tween.finished
	#
	#upgrades_finished.emit()
	#
	#queue_free()

func _on_select_timer_timeout() -> void:
	$DividingLine/TimerLabel.text = "TIME!"
	
	GameManager.switch_scene("res://scenes/main_menu/main_menu.tscn")
	#await get_tree().create_timer(0.5).timeout
	#
	#if (p1_has_played == false):
		#var p1_random_value = randi_range(0, 2)
		#p1_cards[p1_random_value].select_card()
	#if (p2_has_played == false):
		#var p2_random_value = randi_range(0, 2)
		#p2_cards[p2_random_value].select_card()
