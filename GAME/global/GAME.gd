extends Node


###	GAME singleton
# Store global game data


### CURRENT VERSION
# Increment this on the first commit of a
# new version branch. All other code relating to
# true game version will refer to this:
const VERSION = {
		"MAJOR":	0,
		"MINOR":	0,
		"BABY":		6
		}

# Main Scene file paths
const TITLE_SCENE = "res://scenes/Title/Title.tscn"
const WORLD_SCENE = "res://scenes/World/World.tscn"

# Return the version no. as a string: "1.2.3"
func get_version_as_string():
	return "v%s.%s.%s" % [VERSION.MAJOR, VERSION.MINOR, VERSION.BABY] 