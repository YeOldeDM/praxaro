extends Node

###	DATA SINGLETON ###

#	Handle save game data and user preferences

const PREFS_PATH = "user://prefs.cfg"

# User preferences template.
# Only include new sections/keys on version change!
var PREFS_TEMPLATE = {
		"modes":
			{
			"DevMode":		false,
			"GodMode":		false,
			"GhostMode":	false,
			},

		# VERSION DATA: CAN'T TOUCH THIS!
		"version":
			{ 
			"version":	GAME.VERSION,
			},
		}




var _prefs = ConfigFile.new()


func set_pref( cat, key, value ):
	_prefs.set_value( cat, key, value )

func get_pref( cat, key ):
	return _prefs.get_value( cat, key )

func _ready():
	var file = File.new()
	# Check for prefs file. If it doesn't exist, create a new one
	if file.file_exists( PREFS_PATH ):
		load_prefs( PREFS_PATH )
	else:
		_make_prefs()
	# Check for version difference. Update prefs if needed
	if _prefs.get_value("version", "version").hash() != PREFS_TEMPLATE.version.version.hash():
		_update_prefs()
	
	file.close()



# Save current prefs to user dir
func save_prefs( to_path=PREFS_PATH ):
	var saved = _prefs.save( to_path )
	if saved != OK:
		OS.alert( "User prefs not saved: ERROR %s" % saved )
	else:
		print( "User prefs saved to %s" % to_path )


# Load the prefs file from user dir
func load_prefs( from_path=PREFS_PATH ):
	var loaded = _prefs.load( from_path )
	if loaded != OK:
		OS.alert( "User prefs not loaded: ERROR %s" % loaded )
	else:
		print( "User prefs loaded from %s" % from_path )



# Create a fresh prefs file from a template
func _make_prefs():
	for CAT in PREFS_TEMPLATE:
		for KEY in PREFS_TEMPLATE[ CAT ]:
			_prefs.set_value( CAT, KEY, PREFS_TEMPLATE[ CAT ][ KEY ] )
	save_prefs()


# Called when loaded prefs ver does not match current version
# Adds cats/keys not included in saved prefs, and applies default values to those
func _update_prefs():
	for CAT in PREFS_TEMPLATE:
		if not CAT in _prefs:
			for KEY in PREFS_TEMPLATE[ CAT ]:
				_prefs.set_value( CAT, KEY, PREFS_TEMPLATE[ CAT ][ KEY ] )
		else:
			for KEY in PREFS_TEMPLATE[ CAT ]:
				if not KEY in _prefs.get_section_keys( CAT ):
					_prefs.set_value( CAT, KEY, PREFS_TEMPLATE[ CAT ][ KEY ] )
	_prefs.set_value( "version", "version", PREFS_TEMPLATE.version.version )
	OS.alert( "Updated prefs file for version %s!" % GAME.get_version_as_string() )