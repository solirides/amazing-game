extends Control


@onready var anim_player = $AnimationPlayer
@onready var round_label = $Round

func _ready() -> void:
	GameManager.players_swapped.connect(_on_swap_players)

func _on_swap_players(state:bool):
	display_round_text()

func display_round_text():
	var text = "Round " + str(GameManager.world.round_num)
	round_label.text = text
	anim_player.play("round")
	
