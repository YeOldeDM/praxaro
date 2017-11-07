extends Position2D

var entity_path = "res://scenes/mobs/Snail/Snail.tscn"

func spawn( to ):
	print("A")
	var mob = load( entity_path ).instance()
	to.add_child( mob )
	mob.set_pos( get_pos() )
	if mob.has_method("start"):
		mob.start()

func _ready():
	get_node("Sprite").queue_free()
