extends Control





func StartGame():
	get_node("Fader").fade_out()
	yield( get_node("Fader"), "fade_finished" )
	get_tree().change_scene_to( preload("res://scenes/Game/Game.tscn") )

func LoadGame():
	pass

func QuitGame():
	get_node("Fader").fade_out()
	yield( get_node("Fader"), "fade_finished" )
	get_tree().quit()










func _ready():
	get_node("Fader").fade_in()
	get_node("Actions/START").grab_focus()
	
	# Show version number
	var V = GAME.VERSION
	get_node("Version").set_text( "v%s.%s.%s" % [V.MAJOR, V.MINOR, V.BABY] )









func _on_START_pressed():
	StartGame()


func _on_CONTINUE_pressed():
	LoadGame()


func _on_OPTIONS_pressed():
	pass # replace with function body


func _on_QUIT_pressed():
	QuitGame()

