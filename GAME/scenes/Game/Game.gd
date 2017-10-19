extends Node2D

###
# Game: 
#   -Handles high-level main game functions( change levels, spawn player, etc )
#   -Handles player stats: HP/MP, XP, GP, etc

export(String, FILE, "*.tscn") var player_scene_path

# Reference to the player node. Defined when player spawns
var player

# Reference to the current level scene. Defined when we set_level
var level

func set_level( level_scene, spawn_point ):
	var lvl = load(level_scene)

	if self.level:
		self.level.queue_free()
	lvl = lvl.instance()
	add_child(lvl)
	self.level = lvl
	spawn_player()
	self.level.add_child( self.player )
	self.player.set_pos( self.level.get_node( spawn_point ).get_pos() )
	self.player.init( self.level )

func spawn_player():
	var p = load( player_scene_path )

	p = p.instance()
	self.player = p


func _ready():
	set_level( "res://scenes/levels/Test/TestLevel1.tscn", "START" )
	get_node("Fader").fade_in()
