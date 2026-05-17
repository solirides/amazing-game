extends Node

# reference to world node
var world:Node
var turret:Node
var wall:Node
var player1:Node
var player2:Node

@export var player1_color:Color = Color(0.0, 0.7, 1.0, 1.0)
@export var player2_color:Color = Color(1.0, 0.633, 0.0, 1.0)

@export var player1_turret_sprite:Texture2D
@export var player1_wall_sprite:Texture2D
@export var player2_turret_sprite:Texture2D
@export var player2_wall_sprite:Texture2D

# false:original controls
# true:controls have been swapped
var swap_state = false

signal players_swapped(state:bool)

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	save_inputs()

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused

func swap_players(state:bool, force:bool=false):
	if state != swap_state or force:
		swap_state = state
		swap_player_controls(state)
		swap_stats()
		var temp = player1
		var player1 = player2
		var player2 = temp
		players_swapped.emit(state)

func swap_stats():
	var stats = ["health", "shield", "bullet_damage", "speed", "bullet_speed"]
	var more_stats = []
	for stat in stats:
		more_stats.append("base_" + stat)
	stats.append_array(more_stats)
	for stat in stats:
		var temp = player1.get(stat)
		player1.set(stat, player2.get(stat))
		player2.set(stat, temp)

var actions_to_swap = [
		["turret_cw", "wall_cw"],
		["turret_ccw", "wall_ccw"],
		["turret_attack", "wall_attack"]
	]
var saved_actions_p1 = []
var saved_actions_p2 = []

func swap_player_controls(state:bool):
	print("swapping players")
	
	var actions_for_p1 = []
	var actions_for_p2 = []
	if state:
		actions_for_p1 = saved_actions_p2
		actions_for_p2 = saved_actions_p1
	else:
		actions_for_p1 = saved_actions_p1
		actions_for_p2 = saved_actions_p2
	
	for i in actions_to_swap.size():
		
		InputMap.action_erase_events(actions_to_swap[i][0])
		InputMap.action_erase_events(actions_to_swap[i][1])
		
		for event in actions_for_p1[i]:
			InputMap.action_add_event(actions_to_swap[i][0], event)
		
		for event in actions_for_p2[i]:
			InputMap.action_add_event(actions_to_swap[i][1], event)

func save_inputs():
	for i in actions_to_swap.size():
		var events1 = InputMap.action_get_events(actions_to_swap[i][0])
		var events2 = InputMap.action_get_events(actions_to_swap[i][1])
		
		saved_actions_p1.append(events1)
		saved_actions_p2.append(events2)
