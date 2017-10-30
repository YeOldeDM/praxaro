extends Node2D


###	MAIN SCENE
# Root of all other game scenes
# 
# Holds the highest-most game methods/members


# Screen Fader node
onready var fader = get_node("Fader")

# Reference to current "main" scene instance
var current_scene


# MASTER START MAIN GAME
func StartGame():
	change_current_scene( GAME.WORLD_SCENE )


# MASTER GO TO TITLE
func StartTitle():
	change_current_scene( GAME.TITLE_SCENE )



# MASTER QUIT GAME
func QuitGame():
	DATA.save_all()
	fader.fade_out()
	yield( fader, "fade_finished" )
	get_tree().quit()


# Change between "main" scenes
# These should be filepaths declared as
# constants of GAME!
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


### 	!!ROOT GAME INIT!!	###
func _ready():
	var rect = get_viewport().get_rect()
	print(rect)
	# Bootstrap the Title scene
	StartTitle()
	

# Called when the game is quit outside the engine
# (ie. not via `get_tree().quit()`)
func _notification( what ):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		QuitGame()