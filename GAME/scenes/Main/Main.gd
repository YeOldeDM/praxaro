extends Node2D



onready var fader = get_node("Fader")
var current_scene

func StartGame():
	change_current_scene( GAME.WORLD_SCENE )

func StartTitle():
	change_current_scene( GAME.TITLE_SCENE )


func LoadGame():
	pass

func QuitGame():
	fader.fade_out()
	yield( fader, "fade_finished" )
	get_tree().quit()



func change_current_scene( scene_path ):
	get_tree().set_pause(true)
	fader.fade_out()
	yield( fader, "fade_finished" )
	var scene = load( scene_path ).instance()
	if current_scene:
		current_scene.queue_free()
	add_child( scene )
	current_scene = scene
	if "main" in scene:
		scene.main = self
	fader.fade_in()
	get_tree().set_pause(false)

func _ready():
	StartTitle()


func _notification( what ):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		QuitGame()