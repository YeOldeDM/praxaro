extends Control


var main













func _ready():
	get_node("Actions/START").grab_focus()
	
	# Show version number
	var V = GAME.VERSION
	get_node("Version").set_text( GAME.get_version_as_string() )









func _on_START_pressed():
	print("GPO")
	main.StartGame()


func _on_CONTINUE_pressed():
	main.LoadGame()


func _on_OPTIONS_pressed():
	pass # replace with function body


func _on_QUIT_pressed():
	main.QuitGame()

