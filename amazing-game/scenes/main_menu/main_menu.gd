extends Control

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
	

func _on_mystery_pressed() -> void:
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
	
