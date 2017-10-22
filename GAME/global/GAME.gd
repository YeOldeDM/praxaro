extends Node

const VERSION = {
		"MAJOR":	0,
		"MINOR":	0,
		"BABY":		3
		}

const TITLE_SCENE = "res://scenes/Title/Title.tscn"
const WORLD_SCENE = "res://scenes/World/World.tscn"


func get_version_as_string():
	return "v%s.%s.%s" % [VERSION.MAJOR, VERSION.MINOR, VERSION.BABY] 