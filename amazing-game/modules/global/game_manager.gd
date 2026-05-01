extends Node

# reference to world node
var world:Node
var turret:Node
var wall:Node
@export var player1_color:Color = Color(0.0, 0.7, 1.0, 1.0)
@export var player2_color:Color = Color(1.0, 0.633, 0.0, 1.0)

@export var player1_turret_sprite:Texture2D
@export var player2_turret_sprite:Texture2D

# false:original controls
# true:controls have been swapped
var swap_state = false

signal players_swapped(state:bool)

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused

func swap_players(state:bool, force:bool=false):
	if state != swap_state or force:
		swap_state = state
		players_swapped.emit(state)
