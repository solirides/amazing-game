extends Node

# reference to world node
var world:Node
var turret:Node
var wall:Node
@export var turret_color:Color = Color(0.0, 0.7, 1.0, 1.0)
@export var wall_color:Color = Color(1.0, 0.633, 0.0, 1.0)

# false:original controls
# true:controls have been swapped
var swap_state = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
