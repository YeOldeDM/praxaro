extends Node


signal saved_data()


###	DATA SINGLETON ###

#	Handle save game data and user preferences




###	CFG FILE PATHS	###
const PREFS_PATH = "user://prefs.cfg"
const HERO_PRESETS_PATH = "user://hero_presets.cfg"

###	CFG FILE TEMPLATES
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

var HERO_PRESETS_TEMPLATE = {
		"standard":
			{
			},
		# VERSION DATA: CAN'T TOUCH THIS!
		"version":
			{ 
			"version":	GAME.VERSION,
			},
		}

# Local config objects
var _prefs = ConfigFile.new()
var _hero_presets = ConfigFile.new()







# Set/Get user preferences
func set_pref( cat, key, value ):
	_prefs.set_value( cat, key, value )

func get_pref( cat, key ):
	return _prefs.get_value( cat, key )



###	HERO PARAM PRESETS	###
func save_preset( name, data ):
	for key in data:
		_hero_presets.set_value( name, key, data[key] )

func get_preset( name ):
	if !_hero_presets.has_section( name ):
		return ERR_DOES_NOT_EXIST
	
	var dict = {}
	for key in _hero_presets.get_section_keys( name ):
		dict[key] = _hero_presets.get_value( name, key )
	return dict



# Save/Load cfg files
func save_file( cfg, to_path ):
	var saved = cfg.save( to_path )
	if saved != OK:
		OS.alert( "User prefs not saved: ERROR %s" % saved )
	else:
		print( "User prefs saved to %s" % to_path )
	return saved

func load_file( cfg, from_path ):
	var loaded = cfg.load( from_path )
	if loaded != OK:
		OS.alert( "User prefs not loaded: ERROR %s" % loaded )
	else:
		print( "User prefs loaded from %s" % from_path )
	return loaded






# Create a fresh prefs file from a template
func _make_file( _cfg, TEMPLATE, save_path ):
	for CAT in TEMPLATE:
		for KEY in TEMPLATE[ CAT ]:
			_cfg.set_value( CAT, KEY, TEMPLATE[ CAT ][ KEY ] )
	save_file( _cfg, save_path )


# Called when loaded prefs ver does not match current version
# Adds cats/keys not included in saved prefs, and applies default values to those
func _update_file( _cfg, TEMPLATE ):
	# Go through each category of the template..
	for CAT in TEMPLATE:
		if not CAT in _cfg:
			# If the category isn't in the file, add all template keys to the new section
			for KEY in TEMPLATE[ CAT ]:
				_cfg.set_value( CAT, KEY, TEMPLATE[ CAT ][ KEY ] )
		else:
			for KEY in TEMPLATE[ CAT ]:
				# If a new key exists in an old category, add that as well
				if not KEY in _cfg.get_section_keys( CAT ):
					_cfg.set_value( CAT, KEY, TEMPLATE[ CAT ][ KEY ] )








func _ready():
	var file = File.new()
	# Check for prefs file. If it doesn't exist, create a new one
	if file.file_exists( PREFS_PATH ):
		load_file( _prefs, PREFS_PATH )
	else:
		_make_file( _prefs, PREFS_TEMPLATE, PREFS_PATH )
	# Check for version difference. Update prefs if needed
	if _prefs.get_value("version", "version").hash() != PREFS_TEMPLATE.version.version.hash():
		_update_file( _prefs, PREFS_TEMPLATE )
	file.close()
	# Check for hero presets file. If it doesn't exist, create a new one
	if file.file_exists( HERO_PRESETS_PATH ):
		load_file( _hero_presets, HERO_PRESETS_PATH )
	else:
		_make_file( _hero_presets, HERO_PRESETS_TEMPLATE, HERO_PRESETS_PATH )
	if _hero_presets.get_value( "version", "version" ).hash() != HERO_PRESETS_TEMPLATE.version.version.hash():
		_update_file( _hero_presets, HERO_PRESETS_TEMPLATE )
	file.close()



func _notification( what ):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_file( _prefs, PREFS_PATH )
		save_file( _hero_presets, HERO_PRESETS_PATH )
		emit_signal( "saved_data" )