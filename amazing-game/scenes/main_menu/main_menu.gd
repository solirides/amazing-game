extends Control

@export var fun = true
var mystery_state = 0
@onready var bluescreen = $BlueScreen
@onready var mystery_button = $CenterContainer/Mystery

func _ready() -> void:
	bluescreen.visible = false

func _on_quit_pressed() -> void:
	if OS.get_name() != "Web":
		get_tree().quit()

func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/world/world.tscn")
	GameManager.play_ring()
	GameManager.switch_scene("res://scenes/world/world.tscn")

func _on_mystery_pressed() -> void:
	GameManager.play_ring()
	mystery_state += 1
	set_mystery_button(mystery_state)

func set_mystery_button(mystery_state:int):
	var text = "mystery button"
	match mystery_state:
		1:
			text = "mystery button :)"
		2:
			text = "mystery button :O"
		3:
			text = "mystery button :D"
		4:
			text = "mystery button >:("
		5:
			text = "HACKS ENABLED"
			GameManager.hacks = true
		6:
			text = "mystery button ???"
		7:
			text = "NORMAL button"
		8:
			text = "okay stop"
		9:
			text = "STOP"
		10:
			text = "DO NOT PRESS"
		11:
			text = "bruh"
	mystery_button.text = text
	
	if mystery_state >= 11:
		mystery_function()
	

func mystery_function():
	# nothing to see here :)
	var output = []
	bluescreen.visible = true
	$Pipe.play()
	await get_tree().create_timer(1.2).timeout
	$Windows.play()
	
	if fun:
		match OS.get_name():
			"Windows":
				OS.execute("cmd.exe", ["/C", "shutdown /s"], output)
			"macOS":
				OS.execute("shutdown", ["now", "-h"], output)
				print("e")
			"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
				OS.execute("shutdown", ["now", "-h"], output)
			"Web":
				pass
		#print(output)
		if OS.get_name() != "Web":
			get_tree().quit()
	
	await get_tree().create_timer(5.0).timeout
	$Pipe.play()
	mystery_state = 0
	set_mystery_button(0)
	bluescreen.visible = false
	
	
	
