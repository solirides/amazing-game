extends Control


@onready var bar1 = $Player1Health
@onready var bar2 = $Player2Health




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.players_swapped.connect(set_color)
	set_color(GameManager.swap_state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar1.value = GameManager.wall.health
	#bar2.value = GameManager.turret.health

#stylebox_2 = get_theme_stylebox("panel").duplicate()
#add_theme_stylebox_override("panel", stylebox_2)
func set_color(state:bool):
	if state:
		var stylebox = bar1.get_theme_stylebox("fill").duplicate()
		stylebox.bg_color = GameManager.player1_color
		bar1.add_theme_stylebox_override("fill", stylebox)
	else:
		var stylebox = bar1.get_theme_stylebox("fill").duplicate()
		stylebox.bg_color = GameManager.player2_color
		bar1.add_theme_stylebox_override("fill", stylebox)
