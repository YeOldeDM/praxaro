extends Node2D

###
# Game: 
#   -Handles high-level main game functions( change levels, spawn player, etc )
#   -Handles player stats: HP/MP, XP, GP, etc


onready var HUD = get_node("HUD/Frame")
onready var DebugOutput = HUD.get_node("DebugOutput")


export(String, FILE, "*.tscn") var player_scene_path
export(String, FILE, "*.tscn") var DEFAULT_STARTING_LEVEL
# Reference to the player node. Defined when player spawns
var player

# Reference to the current level scene. Defined when we set_level
var level

var debug_mode = {
	"DevMode":		false,
	"GodMode":		false,
	"GhostMode":	false,
	}

var main


func set_level( level_scene=DEFAULT_STARTING_LEVEL, spawn_point=null ):
	if self.level:
		# Delete old level
		self.level.queue_free()


	# Load new level
	var lvl = load(level_scene)
	lvl = lvl.instance()
	add_child(lvl)
	self.level = lvl
	lvl.game = self
	
	# Spawn a new Hero
	spawn_player()
	self.level.add_child( self.player )
	if !spawn_point:
		spawn_point = self.level.DEFAULT_WARP_POINT
	self.player.set_pos( self.level.get_node( spawn_point ).get_pos() )
	self.player.init( self.level )

	
	

func spawn_player():
	var p = load( player_scene_path )
	p = p.instance()
	self.player = p

func announce( message ):
	DebugOutput.set_text( message )
	DebugOutput.get_node("Timer").start()

func _ready():
	for key in debug_mode:
		debug_mode[key] = DATA.get_pref( "modes", key )
	set_process_input(true)
	set_level()
	

func _input( event ):
	# Poll for DEBUG COMMANDS
	# F1: DevMode
	# F2: GodMode
	# F3: GhostMode
	if event.type == InputEvent.KEY:
		if event.pressed and !event.is_echo():
			if event.scancode == KEY_F1:
				debug_mode.DevMode = !debug_mode.DevMode
				announce( "DevMode " + ["OFF", "ON"][ int(debug_mode.DevMode) ] )
				DATA.set_pref( "modes", "DevMode", debug_mode.DevMode )
			elif event.scancode == KEY_F2:
				if debug_mode.DevMode:
					debug_mode.GodMode = !debug_mode.GodMode
					announce( "GodMode " + ["OFF", "ON"][ int(debug_mode.GodMode) ] )
					DATA.set_pref( "modes", "GodMode", debug_mode.GodMode )
				else:
					announce( "DevMode OFF" )
			elif event.scancode == KEY_F3:
				if debug_mode.DevMode:
					debug_mode.GhostMode = !debug_mode.GhostMode
					announce( "GhostMode " + ["OFF", "ON"][ int(debug_mode.GhostMode) ] )
					DATA.set_pref( "modes", "GhostMode", debug_mode.GhostMode )
				else:
					announce( "DevMode OFF" )


