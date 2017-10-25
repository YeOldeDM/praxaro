extends PanelContainer

var pause_pressed = false


func toggle_pause():
	get_tree().set_pause( !get_tree().is_paused() )
	set_hidden( !get_tree().is_paused() )





func _ready():
	set_process_input(true)

func _input(event):
	var PAUSE = event.is_action_pressed("START")
	
	if PAUSE and !pause_pressed:
		toggle_pause()
	pause_pressed = PAUSE





func _on_RESUME_pressed():
	toggle_pause()


func _on_TOMENU_pressed():
	get_node("/root/Main").StartTitle()


func _on_QUIT_pressed():
	get_node("/root/Main").QuitGame()
