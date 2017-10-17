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
	if lvl != OK:
		return
	
	if self.level:
		self.level.queue_free()
	lvl = lvl.instance()
	add_child(lvl)
	self.level = lvl
	

func spawn_player():
	var p = load( player_scene_path )
	if p != OK:
		return
	p = p.instance()
	self.player = p
	return p

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
