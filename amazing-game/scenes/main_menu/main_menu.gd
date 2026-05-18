extends Control

var mystery_state = 0
@onready var mystery_button = $CenterContainer/Mystery

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/world/world.tscn")
	GameManager.switch_scene("res://scenes/world/world.tscn")

func _on_mystery_pressed() -> void:
	mystery_state += 1
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
	match OS.get_name():
		"Windows":
			OS.execute("cmd.exe", ["/C", "shutdown /s"], output)
		"macOS":
			OS.execute("shutdown", ["now", "-h"], output)
			print("e")
		"Linux", "FreeBSD", "NetBSD", "OpenBSD", "BSD":
			OS.execute("shutdown", ["now", "-h"], output)
	#print(output)
	get_tree().quit()
	
