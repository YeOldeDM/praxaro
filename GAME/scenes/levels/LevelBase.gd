extends Node2D

var hide_colmap = true setget _set_hide_colmap
var hide_boundry = true setget _set_hide_boundry

func get_boundry_rect():
	return get_node("BOUNDRY").get_rect()

func _ready():
	self.hide_colmap = self.hide_colmap
	self.hide_boundry = self.hide_boundry


func _set_hide_colmap( hidden ):
	hide_colmap = hidden
	get_node("COLMAP").set_hidden( hidden )

func _set_hide_boundry( hidden ):
	hide_boundry = hidden
	get_node("BOUNDRY").set_hidden( hidden )